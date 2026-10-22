import 'dart:async';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:streak_up/core/network/interceptors/supabase_auth_interceptor.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_schedule.dart';
import '../../domain/entities/habit_occurrence.dart';
import '../../domain/habit_occurrence_rules.dart';
import '../../domain/failures/habit_failure.dart';
import '../../domain/repositories/habit_repository.dart';
import '../local/habit_local_store.dart';
import '../local/habit_local_entity.dart';
import '../local/create_habit_command_local_entity.dart';
import '../local/habit_check_in_local_entity.dart';
import '../../domain/entities/habit_check_in.dart';

class HabitRepositoryImpl implements HabitRepository {
  HabitRepositoryImpl(
    this._store, {
    required bool Function() isAccountAvailable,
    Dio? remote,
    SupabaseRequestCredentials? Function()? readCredentials,
    DateTime Function()? readUtcNow,
    String Function()? newCheckInCommandId,
  }) : _isAccountAvailable = isAccountAvailable,
       _remote = remote,
       _readCredentials = readCredentials,
       _readUtcNow = readUtcNow ?? (() => DateTime.now().toUtc()),
       _newCheckInCommandId = newCheckInCommandId ?? const Uuid().v4;
  final HabitLocalStore _store;
  final bool Function() _isAccountAvailable;
  final Dio? _remote;
  final SupabaseRequestCredentials? Function()? _readCredentials;
  final DateTime Function() _readUtcNow;
  final String Function() _newCheckInCommandId;
  final _todayRefresh = StreamController<void>.broadcast();
  Future<Either<HabitFailure, Unit>>? _delivery;
  CancelToken? _requestCancellation;
  final _uuid = const Uuid();
  bool _closing = false;
  Future<void> _writes = Future.value();
  @override
  String get accountId => _store.accountId;

  @override
  Future<Either<HabitFailure, Habit>> createHabit({
    required String name,
    required HabitSchedule schedule,
    String description = '',
    HabitCategory? category,
    int? targetMinutes,
  }) async {
    if (_closing || !_store.isOpen || !_isAccountAvailable()) {
      return const Left(HabitFailure.accountUnavailable);
    }
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) {
      return const Left(HabitFailure.invalidName);
    }
    if (!schedule.isValid) {
      return const Left(HabitFailure.invalidSchedule);
    }
    if (targetMinutes != null && targetMinutes <= 0) {
      return const Left(HabitFailure.invalidTarget);
    }
    final entityId = _uuid.v4();
    final commandId = _uuid.v4();
    late Habit habit;
    final local = HabitLocalEntity()
      ..entityId = entityId
      ..accountId = accountId
      ..name = normalizedName
      ..description = description.trim()
      ..category = category?.name
      ..targetMinutes = targetMinutes
      ..frequency = schedule.frequency.name
      ..weekdays = schedule.weekdays.toList()
      ..timezone = schedule.timezone;
    final command = CreateHabitCommandLocalEntity()
      ..commandId = commandId
      ..entityId = entityId
      ..accountId = accountId
      ..payloadJson = jsonEncode({
        'name': normalizedName,
        'description': description.trim(),
        'category': category?.name,
        'targetMinutes': targetMinutes,
        'visibility': 'private',
        'schedule': {
          'frequency': schedule.frequency.name,
          'weekdays': schedule.weekdays,
          'timezone': schedule.timezone,
        },
      });
    // Close waits for admitted transactions; later account changes cannot move
    // a committed action into another store.
    final write = _writes.then((_) async {
      if (_closing || !_isAccountAvailable()) {
        throw StateError('Account unavailable');
      }
      final observedUtc = _readUtcNow().toUtc();
      local
        ..coverageStartLocalDate = habitLocalDate(schedule, observedUtc)
        ..coverageStartObservedAtUtc = observedUtc
        ..coverageStartSource = HabitStartSource.localCreation.name;
      await _store.create(local, command);
      habit = _mapHabit(local);
    });
    _writes = write.then<void>(
      (_) {},
      onError: (Object error, StackTrace stack) {},
    );
    try {
      await write;
      // Delivery is independent of the already committed local result/spinner.
      if (_remote != null) {
        // A creation admitted during an older pass needs its own later snapshot.
        unawaited(() async {
          await _delivery;
          await deliverPendingHabitCreates();
        }());
      }
      return Right(habit);
    } catch (_) {
      return Left(
        _closing || !_isAccountAvailable()
            ? HabitFailure.accountUnavailable
            : HabitFailure.storage,
      );
    }
  }

  @override
  Stream<List<Habit>> watchHabits() => _store.watchHabits().asyncMap(
    (_) async =>
        List<Habit>.unmodifiable((await _readCoveredHabits()).map(_mapHabit)),
  );

  Habit _mapHabit(HabitLocalEntity row) => Habit(
    id: row.entityId,
    accountId: row.accountId,
    name: row.name,
    description: row.description,
    category: row.category == null
        ? null
        : HabitCategory.values.byName(row.category!),
    targetMinutes: row.targetMinutes,
    schedule: HabitSchedule(
      frequency: HabitFrequency.values.byName(row.frequency),
      timezone: row.timezone,
      weekdays: row.weekdays,
    ),
    syncStatus: HabitSyncStatus.values.byName(row.syncStatus),
    serverRevision: row.serverRevision,
    createdAt: row.createdAt?.toUtc(),
    updatedAt: row.updatedAt?.toUtc(),
    rejection: row.rejection == null
        ? null
        : HabitRejection.values.byName(row.rejection!),
    coverageStartLocalDate: row.coverageStartLocalDate,
    coverageStartObservedAtUtc: row.coverageStartObservedAtUtc?.toUtc(),
    coverageStartSource: row.coverageStartSource == null
        ? null
        : HabitStartSource.values.byName(row.coverageStartSource!),
  );

  Future<List<HabitLocalEntity>> _readCoveredHabits() {
    final read = _writes.then((_) {
      if (_closing || !_store.isOpen || !_isAccountAvailable()) {
        throw StateError('Account unavailable');
      }
      return _store.readHabitsWithCoverage(_readUtcNow().toUtc());
    });
    _writes = read.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return read;
  }

  HabitCheckIn _mapCheckIn(HabitCheckInLocalEntity row) => HabitCheckIn(
    accountId: row.accountId,
    habitId: row.habitId,
    scheduledLocalDate: row.scheduledLocalDate,
    commandId: row.commandId,
    admittedAtUtc: row.admittedAtUtc.toUtc(),
    observedLocalDate: row.observedLocalDate,
    schedule: HabitSchedule(
      frequency: HabitFrequency.values.byName(row.frequency),
      timezone: row.timezone,
      weekdays: row.weekdays,
    ),
    coverageStartLocalDate: row.coverageStartLocalDate,
    coverageStartObservedAtUtc: row.coverageStartObservedAtUtc.toUtc(),
    coverageStartSource: HabitStartSource.values.byName(
      row.coverageStartSource,
    ),
    syncStatus: CheckInSyncStatus.values.byName(row.syncStatus),
  );

  Future<TodayProjection> _readToday() {
    final read = _writes.then((_) async {
      if (_closing || !_store.isOpen || !_isAccountAvailable()) {
        throw StateError('Account unavailable');
      }
      final snapshot = await _store.readTodaySnapshot(_readUtcNow().toUtc());
      final commands = {for (final c in snapshot.commands) c.commandId: c};
      for (final fact in snapshot.checkIns) {
        final command = commands[fact.commandId];
        if (fact.accountId != accountId ||
            command == null ||
            command.accountId != accountId ||
            command.habitId != fact.habitId ||
            command.occurrenceKey != fact.occurrenceKey ||
            fact.occurrenceKey !=
                occurrenceKey(fact.habitId, fact.scheduledLocalDate) ||
            command.scheduledLocalDate != fact.scheduledLocalDate ||
            command.version != 1 ||
            command.type != 'createCheckIn' ||
            command.outcome != null) {
          throw StateError('Inconsistent check-in pair');
        }
      }
      return projectToday(
        snapshot.habits.map(_mapHabit),
        _readUtcNow().toUtc(),
        checkIns: snapshot.checkIns.map(_mapCheckIn),
      );
    });
    _writes = read.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return read;
  }

  @override
  Future<Either<HabitFailure, CompleteOccurrenceResult>> completeOccurrence({
    required String habitId,
    required String scheduledLocalDate,
  }) async {
    if (_closing || !_store.isOpen || !_isAccountAvailable()) {
      return const Left(HabitFailure.accountUnavailable);
    }
    final write = _writes.then(
      (_) => _store.completeOccurrence(
        habitId: habitId,
        scheduledLocalDate: scheduledLocalDate,
        isAccountAvailable: () => !_closing && _isAccountAvailable(),
        readUtcNow: _readUtcNow,
        createCommandId: _newCheckInCommandId,
      ),
    );
    _writes = write.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    try {
      return await write;
    } catch (_) {
      return Left(
        _closing || !_isAccountAvailable()
            ? HabitFailure.accountUnavailable
            : HabitFailure.storage,
      );
    } finally {
      // Recompute stale/duplicate actions too; this never starts HTTP delivery.
      refreshToday();
    }
  }

  @override
  Stream<TodayProjection> watchToday() => Stream.multi((controller) {
    var cancelled = false;
    Future<void> pending = Future.value();
    void refresh() {
      pending = pending.then((_) async {
        if (cancelled || _closing) return;
        try {
          final projection = await _readToday();
          if (!cancelled && !_closing && _isAccountAvailable()) {
            controller.add(projection);
          }
        } catch (error, stack) {
          if (!cancelled && !_closing) controller.addError(error, stack);
        }
      });
    }

    final localSubscription = _store.watchHabits().listen(
      (_) => refresh(),
      onError: controller.addError,
    );
    final refreshSubscription = _todayRefresh.stream.listen((_) => refresh());
    final checkInSubscription = _store.watchCheckIns().listen(
      (_) => refresh(),
      onError: controller.addError,
    );
    controller.onCancel = () async {
      cancelled = true;
      await localSubscription.cancel();
      await refreshSubscription.cancel();
      await checkInSubscription.cancel();
    };
  });

  @override
  void refreshToday() {
    if (!_closing) _todayRefresh.add(null);
  }

  @override
  Future<Either<HabitFailure, Unit>> deliverPendingHabitCreates() {
    if (_delivery != null) return _delivery!;
    final pass = _deliver();
    _delivery = pass;
    unawaited(
      pass.whenComplete(() {
        _delivery = null;
      }),
    );
    return pass;
  }

  Future<Either<HabitFailure, Unit>> _deliver() async {
    if (_closing || !_isAccountAvailable()) {
      return const Left(HabitFailure.accountUnavailable);
    }
    final remote = _remote;
    if (remote == null) return const Left(HabitFailure.deliveryUnavailable);
    try {
      // One finite snapshot/pass. No timer, in-flight flag on disk or tight retry.
      final commands = await _store.readPendingCommands();
      for (final command in commands) {
        final credentials = _readCredentials?.call();
        if (_closing ||
            !_isAccountAvailable() ||
            credentials == null ||
            !credentials.isValid ||
            credentials.userId != accountId ||
            command.accountId != accountId) {
          return const Left(HabitFailure.authorization);
        }
        final cancellation = CancelToken();
        _requestCancellation = cancellation;
        Response<dynamic> response;
        try {
          response = await remote.post<dynamic>(
            'create-habit-v1',
            data: {
              'commandId': command.commandId,
              'entityId': command.entityId,
              'version': command.version,
              'payload': jsonDecode(command.payloadJson),
            },
            options: Options(
              extra: {SupabaseRequestCredentials.requestKey: credentials},
              validateStatus: (_) => true,
            ),
            cancelToken: cancellation,
          );
        } on DioException catch (error) {
          return Left(
            error.response?.statusCode == 401 ||
                    error.response?.statusCode == 403
                ? HabitFailure.authorization
                : HabitFailure.deliveryUnavailable,
          );
        } finally {
          _requestCancellation = null;
        }
        if (_closing || !_isAccountAvailable()) {
          return const Left(HabitFailure.accountUnavailable);
        }
        final status = response.statusCode ?? 0;
        if (status == 401 || status == 403) {
          return const Left(HabitFailure.authorization);
        }
        if (status >= 500 || status == 429) {
          return const Left(HabitFailure.deliveryUnavailable);
        }
        final body = response.data;
        if (body is! Map<String, dynamic> || !_correlated(command, body)) {
          return const Left(HabitFailure.invalidResponse);
        }
        if ((status == 200 &&
                body['outcome'] == 'accepted' &&
                _validCanonical(command, body)) ||
            (status == 422 &&
                body['outcome'] == 'rejected' &&
                HabitRejection.values.any(
                  (reason) => reason.name == body['reason'],
                ))) {
          // Store owns the atomic boundary; the watcher alone publishes the result.
          await _store.reconcile(command, body);
        } else {
          return const Left(HabitFailure.invalidResponse);
        }
      }
      return const Right(unit);
    } catch (_) {
      // Failed local reconciliation leaves the original durable intent unresolved.
      return const Left(HabitFailure.storage);
    }
  }

  bool _correlated(
    CreateHabitCommandLocalEntity command,
    Map<String, dynamic> body,
  ) =>
      body['commandId'] == command.commandId &&
      body['entityId'] == command.entityId &&
      body['version'] == command.version &&
      body['accountId'] == accountId;

  bool _validCanonical(
    CreateHabitCommandLocalEntity command,
    Map<String, dynamic> body,
  ) {
    try {
      final habit = body['habit'] as Map<String, dynamic>;
      if (![
        'id',
        'accountId',
        'name',
        'description',
        'category',
        'targetMinutes',
        'schedule',
        'revision',
        'createdAt',
        'updatedAt',
      ].every(habit.containsKey)) {
        return false;
      }
      final schedule = habit['schedule'] as Map<String, dynamic>;
      final canonicalSchedule = HabitSchedule(
        frequency: HabitFrequency.values.byName(
          schedule['frequency'] as String,
        ),
        timezone: schedule['timezone'] as String,
        weekdays: List<int>.from(schedule['weekdays'] as List),
      );
      final category = habit['category'];
      final target = habit['targetMinutes'];
      final createdAt = DateTime.parse(habit['createdAt'] as String);
      final updatedAt = DateTime.parse(habit['updatedAt'] as String);
      return habit['id'] == command.entityId &&
          habit['accountId'] == accountId &&
          (habit['name'] as String).trim().isNotEmpty &&
          habit['description'] is String &&
          canonicalSchedule.isValid &&
          (category == null ||
              HabitCategory.values.any((c) => c.name == category)) &&
          (target == null || target is int && target > 0) &&
          habit['revision'] is int &&
          habit['revision'] == 1 &&
          createdAt.isUtc &&
          updatedAt.isUtc &&
          !updatedAt.isBefore(createdAt);
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> close() async {
    _closing = true;
    _requestCancellation?.cancel();
    await _delivery;
    await _writes;
    await _todayRefresh.close();
    await _store.close();
  }
}
