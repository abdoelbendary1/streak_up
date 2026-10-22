import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:isar_community/isar.dart';
import 'habit_local_entity.dart';
import 'create_habit_command_local_entity.dart';
import '../../domain/entities/habit_schedule.dart';
import '../../domain/habit_occurrence_rules.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_check_in.dart';
import '../../domain/failures/habit_failure.dart';
import 'habit_check_in_local_entity.dart';
import 'create_check_in_command_local_entity.dart';

class HabitLocalSnapshot {
  const HabitLocalSnapshot(this.habits, this.checkIns, this.commands);
  final List<HabitLocalEntity> habits;
  final List<HabitCheckInLocalEntity> checkIns;
  final List<CreateCheckInCommandLocalEntity> commands;
}

class HabitLocalStore {
  HabitLocalStore._(this.accountId, this._isar);
  final String accountId;
  final Isar _isar;
  bool _closed = false;

  static Future<HabitLocalStore> open({
    required String directory,
    required String accountId,
  }) async {
    if (accountId.isEmpty) throw ArgumentError.value(accountId);
    final key = base64Url.encode(utf8.encode(accountId)).replaceAll('=', '');
    final accountDirectory = Directory('$directory/habits/$key');
    await accountDirectory.create(recursive: true);
    final isar = await Isar.open(
      [
        HabitLocalEntitySchema,
        CreateHabitCommandLocalEntitySchema,
        HabitCheckInLocalEntitySchema,
        CreateCheckInCommandLocalEntitySchema,
      ],
      directory: accountDirectory.path,
      name: 'habits_$key',
      relaxedDurability: false,
      inspector: false,
    );
    return HabitLocalStore._(accountId, isar);
  }

  bool get isOpen => !_closed && _isar.isOpen;

  Future<void> create(
    HabitLocalEntity habit,
    CreateHabitCommandLocalEntity command,
  ) async {
    if (!isOpen ||
        habit.accountId != accountId ||
        command.accountId != accountId ||
        habit.entityId != command.entityId ||
        habit.id != Isar.autoIncrement ||
        command.id != Isar.autoIncrement) {
      throw StateError('Unavailable account store or existing record');
    }
    await _isar.writeTxn(() async {
      await _isar.habitLocalEntitys.put(habit);
      await _isar.createHabitCommandLocalEntitys.put(command);
    });
  }

  Stream<List<HabitLocalEntity>> watchHabits() =>
      _isar.habitLocalEntitys.where().watch(fireImmediately: true);

  Stream<void> watchCheckIns() => _isar.habitCheckInLocalEntitys.watchLazy();

  // Only missing legacy coverage is initialized. Commands and server metadata
  // are untouched; this observation never claims an original creation date.
  Future<List<HabitLocalEntity>> readHabitsWithCoverage(
    DateTime observedUtc,
  ) async {
    if (!isOpen) throw StateError('Unavailable account store');
    return _isar.writeTxn(() => _initializeCoverage(observedUtc));
  }

  Future<List<HabitLocalEntity>> _initializeCoverage(
    DateTime observedUtc,
  ) async {
    final rows = await _isar.habitLocalEntitys.where().findAll();
    for (final row in rows) {
      if (row.accountId != accountId) {
        throw StateError('Foreign account Habit');
      }
      if (row.coverageStartLocalDate == null &&
          row.coverageStartObservedAtUtc == null &&
          row.coverageStartSource == null) {
        final schedule = HabitSchedule(
          frequency: HabitFrequency.values.byName(row.frequency),
          timezone: row.timezone,
          weekdays: row.weekdays,
        );
        row
          ..coverageStartLocalDate = habitLocalDate(schedule, observedUtc)
          ..coverageStartObservedAtUtc = observedUtc.toUtc()
          ..coverageStartSource = 'legacyObservation';
        await _isar.habitLocalEntitys.put(row);
      }
    }
    return rows;
  }

  Future<HabitLocalSnapshot> readTodaySnapshot(DateTime observedUtc) async {
    if (!isOpen) throw StateError('Unavailable account store');
    // Initialization and all projection facts are read at one database boundary.
    return _isar.writeTxn(
      () async => HabitLocalSnapshot(
        await _initializeCoverage(observedUtc),
        await _isar.habitCheckInLocalEntitys.where().findAll(),
        await _isar.createCheckInCommandLocalEntitys.where().findAll(),
      ),
    );
  }

  Future<Either<HabitFailure, CompleteOccurrenceResult>> completeOccurrence({
    required String habitId,
    required String scheduledLocalDate,
    required bool Function() isAccountAvailable,
    required DateTime Function() readUtcNow,
    required String Function() createCommandId,
  }) async {
    if (!isOpen) return const Left(HabitFailure.accountUnavailable);
    return _isar.writeTxn(() async {
      final parent = await _isar.habitLocalEntitys.getByEntityId(habitId);
      if (!isAccountAvailable()) {
        return const Left(HabitFailure.accountUnavailable);
      }
      if (parent == null ||
          parent.accountId != accountId ||
          parent.syncStatus == 'failed') {
        return const Left(HabitFailure.occurrenceUnavailable);
      }
      final schedule = HabitSchedule(
        frequency: HabitFrequency.values.byName(parent.frequency),
        timezone: parent.timezone,
        weekdays: parent.weekdays,
      );
      verifyCoverage(
        schedule,
        parent.coverageStartLocalDate,
        parent.coverageStartObservedAtUtc,
        parent.coverageStartSource == null
            ? null
            : HabitStartSource.values.byName(parent.coverageStartSource!),
      );
      // Admission is sampled after queue/transaction delay and parent reread.
      final admittedAtUtc = readUtcNow().toUtc();
      final observedDate = habitLocalDate(schedule, admittedAtUtc);
      if (observedDate != scheduledLocalDate ||
          !isScheduledOn(
            schedule,
            parent.coverageStartLocalDate!,
            DateTime.parse(observedDate),
          )) {
        return const Left(HabitFailure.occurrenceUnavailable);
      }
      final key = occurrenceKey(parent.entityId, observedDate);
      final existing = await _isar.habitCheckInLocalEntitys.getByOccurrenceKey(
        key,
      );
      if (!isAccountAvailable()) {
        return const Left(HabitFailure.accountUnavailable);
      }
      if (existing != null) {
        if (existing.accountId != accountId) {
          throw StateError('Foreign completion');
        }
        return const Right(CompleteOccurrenceResult.alreadyCompleted);
      }
      final commandId = createCommandId();
      final checkIn = HabitCheckInLocalEntity()
        ..occurrenceKey = key
        ..accountId = accountId
        ..habitId = parent.entityId
        ..scheduledLocalDate = observedDate
        ..commandId = commandId
        ..admittedAtUtc = admittedAtUtc
        ..observedLocalDate = observedDate
        ..timezone = schedule.timezone
        ..frequency = schedule.frequency.name
        ..weekdays = schedule.weekdays.toList()
        ..coverageStartLocalDate = parent.coverageStartLocalDate!
        ..coverageStartObservedAtUtc = parent.coverageStartObservedAtUtc!
            .toUtc()
        ..coverageStartSource = parent.coverageStartSource!;
      final command = CreateCheckInCommandLocalEntity()
        ..commandId = commandId
        ..accountId = accountId
        ..habitId = parent.entityId
        ..scheduledLocalDate = observedDate
        ..occurrenceKey = key
        ..payloadJson = jsonEncode({
          'admittedAtUtc': admittedAtUtc.toIso8601String(),
          'observedLocalDate': observedDate,
          'schedule': {
            'frequency': schedule.frequency.name,
            'weekdays': schedule.weekdays,
            'timezone': schedule.timezone,
          },
          'startEvidence': {
            'localDate': parent.coverageStartLocalDate,
            'observedAtUtc': parent.coverageStartObservedAtUtc!
                .toUtc()
                .toIso8601String(),
            'source': parent.coverageStartSource,
          },
        });
      await _isar.habitCheckInLocalEntitys.put(checkIn);
      await _isar.createCheckInCommandLocalEntitys.put(command);
      return const Right(CompleteOccurrenceResult.completed);
    });
  }

  Future<List<CreateHabitCommandLocalEntity>> readPendingCommands() => _isar
      .createHabitCommandLocalEntitys
      .filter()
      .group((query) => query.outcomeIsNull().or().outcomeEqualTo('pending'))
      .findAll();

  Future<void> reconcile(
    CreateHabitCommandLocalEntity sent,
    Map<String, dynamic> response,
  ) async {
    if (!isOpen ||
        sent.accountId != accountId ||
        response['accountId'] != accountId ||
        response['commandId'] != sent.commandId ||
        response['entityId'] != sent.entityId ||
        response['version'] != sent.version ||
        !['accepted', 'rejected'].contains(response['outcome'])) {
      throw StateError('Unavailable account store');
    }
    await _isar.writeTxn(() async {
      final command = await _isar.createHabitCommandLocalEntitys.get(sent.id);
      if (command == null ||
          command.commandId != sent.commandId ||
          command.accountId != accountId ||
          command.payloadJson != sent.payloadJson ||
          command.entityId != sent.entityId ||
          command.version != sent.version) {
        throw StateError('Command changed');
      }
      if (command.outcome != null && command.outcome != 'pending') return;
      final habit = await _isar.habitLocalEntitys.getByEntityId(
        command.entityId,
      );
      if (habit == null || habit.accountId != accountId) {
        throw StateError('Missing owned Habit');
      }
      final accepted = response['outcome'] == 'accepted';
      if (accepted) {
        final canonical = response['habit'] as Map<String, dynamic>;
        final schedule = canonical['schedule'] as Map<String, dynamic>;
        habit
          ..name = canonical['name'] as String
          ..description = canonical['description'] as String
          ..category = canonical['category'] as String?
          ..targetMinutes = canonical['targetMinutes'] as int?
          ..frequency = schedule['frequency'] as String
          ..weekdays = List<int>.from(schedule['weekdays'] as List)
          ..timezone = schedule['timezone'] as String
          ..serverRevision = canonical['revision'] as int
          ..createdAt = DateTime.parse(canonical['createdAt'] as String).toUtc()
          ..updatedAt = DateTime.parse(canonical['updatedAt'] as String).toUtc()
          ..rejection = null
          ..syncStatus = 'synced';
      } else {
        habit
          ..syncStatus = 'failed'
          ..rejection = response['reason'] as String;
      }
      await _isar.habitLocalEntitys.put(habit);
      command
        ..outcome = accepted ? 'accepted' : 'rejected'
        ..responseJson = jsonEncode(response);
      await _isar.createHabitCommandLocalEntitys.put(command);
    });
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    try {
      await _isar.close();
    } catch (_) {
      _closed = false;
      rethrow;
    }
  }
}
