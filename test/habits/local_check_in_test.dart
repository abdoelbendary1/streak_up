import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';
import 'package:streak_up/features/habits/data/local/habit_local_store.dart';
import 'package:streak_up/features/habits/data/local/habit_local_entity.dart';
import 'package:streak_up/features/habits/data/local/create_habit_command_local_entity.dart';
import 'package:streak_up/features/habits/data/local/habit_check_in_local_entity.dart';
import 'package:streak_up/features/habits/data/local/create_check_in_command_local_entity.dart';
import 'package:streak_up/features/habits/data/repositories/habit_repository_impl.dart';
import 'package:streak_up/features/habits/domain/entities/habit.dart';
import 'package:streak_up/features/habits/domain/entities/habit_check_in.dart';
import 'package:streak_up/features/habits/domain/entities/habit_occurrence.dart';
import 'package:streak_up/features/habits/domain/entities/habit_schedule.dart';
import 'package:streak_up/features/habits/domain/failures/habit_failure.dart';
import 'package:streak_up/features/habits/domain/use_cases/habit_use_cases.dart';
import 'package:streak_up/features/habits/presentation/cubit/today_cubit.dart';
import 'isar_test_storage.dart';

void main() {
  setUpAll(initializeHabitTestStorage);
  late Directory directory;
  late HabitLocalStore store;
  late HabitRepositoryImpl repository;
  var now = DateTime.utc(2026, 10, 6, 12);
  var available = true;
  String? forcedCommandId;
  var crossingBoundary = false;
  Future<void> reopen([String account = 'A']) async {
    store = await HabitLocalStore.open(
      directory: directory.path,
      accountId: account,
    );
    repository = HabitRepositoryImpl(
      store,
      isAccountAvailable: () => available,
      readUtcNow: () {
        final admitted = now;
        if (crossingBoundary) {
          crossingBoundary = false;
          now = now.add(const Duration(days: 1));
        }
        return admitted;
      },
      newCheckInCommandId: () => forcedCommandId ?? const Uuid().v4(),
    );
  }

  setUp(() async {
    now = DateTime.utc(2026, 10, 6, 12);
    available = true;
    forcedCommandId = null;
    crossingBoundary = false;
    directory = await Directory.systemTemp.createTemp('streakup_checkin_');
    await reopen();
  });
  tearDown(() async {
    await repository.close();
    await directory.delete(recursive: true);
  });
  Future<Habit> create({List<int>? days, String zone = 'Africa/Cairo'}) async =>
      (await repository.createHabit(
        name: 'Read',
        schedule: HabitSchedule(
          frequency: days == null
              ? HabitFrequency.daily
              : HabitFrequency.selectedWeekdays,
          weekdays: days ?? [],
          timezone: zone,
        ),
      )).fold((f) => throw StateError('$f'), (h) => h);
  Future<Either<HabitFailure, CompleteOccurrenceResult>> complete(
    Habit h, [
    String date = '2026-10-06',
  ]) => repository.completeOccurrence(habitId: h.id, scheduledLocalDate: date);

  test(
    'offline parent and check-in commit exact evidence; watcher counts once; restart/replay immutable',
    () async {
      final habit = await create();
      expect(habit.syncStatus, HabitSyncStatus.pending);
      final createsBefore = (await store.readPendingCommands()).single;
      final watched = repository.watchToday().firstWhere(
        (p) => p.completedCount == 1,
      );
      expect(
        await complete(habit),
        const Right(CompleteOccurrenceResult.completed),
      );
      final projected = await watched;
      expect(projected.due.single.state, HabitOccurrenceState.completed);
      expect(
        projected.due.single.checkIn!.syncStatus,
        CheckInSyncStatus.pending,
      );
      final snapshot = await store.readTodaySnapshot(now);
      expect(snapshot.checkIns, hasLength(1));
      expect(snapshot.commands, hasLength(1));
      final command = snapshot.commands.single;
      final fact = snapshot.checkIns.single;
      expect(command.commandId, fact.commandId);
      expect(command.commandId, isNot(habit.id));
      expect(command.version, 1);
      expect(command.type, 'createCheckIn');
      expect(command.outcome, isNull);
      expect(fact.admittedAtUtc.toUtc(), now);
      expect(fact.observedLocalDate, '2026-10-06');
      expect(command.occurrenceKey, '${habit.id}/2026-10-06');
      expect(jsonDecode(command.payloadJson), {
        'admittedAtUtc': now.toIso8601String(),
        'observedLocalDate': '2026-10-06',
        'schedule': {
          'frequency': 'daily',
          'weekdays': [],
          'timezone': 'Africa/Cairo',
        },
        'startEvidence': {
          'localDate': habit.coverageStartLocalDate,
          'observedAtUtc': habit.coverageStartObservedAtUtc!.toIso8601String(),
          'source': 'localCreation',
        },
      });
      final bytes = command.payloadJson;
      await repository.close();
      await reopen();
      expect((await repository.watchToday().first).completedCount, 1);
      expect(
        await complete(habit),
        const Right(CompleteOccurrenceResult.alreadyCompleted),
      );
      final reopened = await store.readTodaySnapshot(now);
      expect(reopened.commands.single.commandId, command.commandId);
      expect(reopened.commands.single.payloadJson, bytes);
      expect(
        (await store.readPendingCommands()).single.payloadJson,
        createsBefore.payloadJson,
      );
      expect(reopened.checkIns.single.scheduledLocalDate, '2026-10-06');
    },
  );

  test(
    'concurrent calls and rebuilt Cubit return already completed without another intent',
    () async {
      final habit = await create();
      final results = await Future.wait(
        List.generate(12, (_) => complete(habit)),
      );
      expect(
        results.where(
          (r) => r == const Right(CompleteOccurrenceResult.completed),
        ),
        hasLength(1),
      );
      expect(
        results.where(
          (r) => r == const Right(CompleteOccurrenceResult.alreadyCompleted),
        ),
        hasLength(11),
      );
      final stale = HabitOccurrence(
        habit: habit,
        scheduledLocalDate: '2026-10-06',
        state: HabitOccurrenceState.pending,
      );
      for (var i = 0; i < 2; i++) {
        final cubit = TodayCubit(
          WatchTodayUseCase(repository),
          RefreshTodayUseCase(repository),
          CompleteOccurrenceUseCase(repository),
        );
        await cubit.complete(stale);
        expect(cubit.state.completing, isEmpty);
        expect(cubit.state.actionFailures, isEmpty);
        await cubit.close();
      }
      final snapshot = await store.readTodaySnapshot(now);
      expect(snapshot.commands, hasLength(1));
      expect(snapshot.checkIns, hasLength(1));
    },
  );

  test(
    'native command uniqueness failure after completion put rolls back; Cubit reports local failure; retry succeeds',
    () async {
      final first = await create();
      await complete(first);
      forcedCommandId = (await store.readTodaySnapshot(
        now,
      )).commands.single.commandId;
      final second = await create();
      final cubit = TodayCubit(
        WatchTodayUseCase(repository),
        RefreshTodayUseCase(repository),
        CompleteOccurrenceUseCase(repository),
      );
      final pending = HabitOccurrence(
        habit: second,
        scheduledLocalDate: '2026-10-06',
        state: HabitOccurrenceState.pending,
      );
      await cubit.complete(pending);
      expect(cubit.state.actionFailures[pending.key], HabitFailure.storage);
      expect(cubit.state.completing, isEmpty);
      var snapshot = await store.readTodaySnapshot(now);
      expect(snapshot.checkIns, hasLength(1));
      expect(snapshot.commands, hasLength(1));
      expect(
        (await repository.watchToday().first).due.last.state,
        HabitOccurrenceState.pending,
      );
      forcedCommandId = null;
      await cubit.complete(pending);
      expect(cubit.state.actionFailures, isEmpty);
      snapshot = await store.readTodaySnapshot(now);
      expect(snapshot.checkIns, hasLength(2));
      expect(snapshot.commands, hasLength(2));
      await cubit.close();
    },
  );

  test(
    'selected weekday eligible; unscheduled, future, missing parent and Missed dates reject',
    () async {
      final due = await create(days: [2]);
      final notDue = await create(days: [3]);
      expect(
        await complete(due),
        const Right(CompleteOccurrenceResult.completed),
      );
      expect(
        await complete(notDue),
        const Left(HabitFailure.occurrenceUnavailable),
      );
      expect(
        await complete(due, '2026-10-05'),
        const Left(HabitFailure.occurrenceUnavailable),
      );
      expect(
        await complete(due, '2026-10-07'),
        const Left(HabitFailure.occurrenceUnavailable),
      );
      expect(
        await repository.completeOccurrence(
          habitId: const Uuid().v4(),
          scheduledLocalDate: '2026-10-06',
        ),
        const Left(HabitFailure.occurrenceUnavailable),
      );
      expect((await store.readTodaySnapshot(now)).commands, hasLength(1));
    },
  );

  test('retained zone determines occurrence when UTC date differs', () async {
    now = DateTime.utc(2026, 10, 6, 0, 30);
    final habit = await create(zone: 'America/Los_Angeles');
    expect(
      await complete(habit),
      const Left(HabitFailure.occurrenceUnavailable),
    );
    expect(
      await complete(habit, '2026-10-05'),
      const Right(CompleteOccurrenceResult.completed),
    );
    expect(
      (await store.readTodaySnapshot(now)).checkIns.single.observedLocalDate,
      '2026-10-05',
    );
  });

  test(
    'queue-delayed stale tap cannot backdate; before coverage and rejected parent are excluded',
    () async {
      final habit = await create();
      final stale = complete(habit);
      now = DateTime.utc(2026, 10, 7, 12);
      expect(await stale, const Left(HabitFailure.occurrenceUnavailable));
      now = DateTime.utc(2026, 10, 5, 12);
      expect(
        await complete(habit, '2026-10-05'),
        const Left(HabitFailure.occurrenceUnavailable),
      );
      now = DateTime.utc(2026, 10, 6, 12);
      final isar = Isar.getInstance('habits_QQ')!;
      await isar.writeTxn(() async {
        final row = await isar.habitLocalEntitys.getByEntityId(habit.id);
        row!
          ..syncStatus = 'failed'
          ..rejection = 'invalidPayload';
        await isar.habitLocalEntitys.put(row);
      });
      expect(
        await complete(habit),
        const Left(HabitFailure.occurrenceUnavailable),
      );
      expect((await store.readTodaySnapshot(now)).commands, isEmpty);
    },
  );

  test(
    'database queue delay rechecks admission date after preceding transaction',
    () async {
      final habit = await create();
      final entered = Completer<void>();
      final release = Completer<void>();
      final held = Isar.getInstance('habits_QQ')!.writeTxn(() async {
        entered.complete();
        await release.future;
      });
      await entered.future;
      final requested = complete(habit);
      now = DateTime.utc(2026, 10, 7, 12);
      release.complete();
      await held;
      expect(await requested, const Left(HabitFailure.occurrenceUnavailable));
      expect((await store.readTodaySnapshot(now)).checkIns, isEmpty);
    },
  );

  test(
    'check-in and Today never call HTTP even with configured remote Create delivery',
    () async {
      final habit = await create();
      await repository.close();
      store = await HabitLocalStore.open(
        directory: directory.path,
        accountId: 'A',
      );
      var requests = 0;
      final remote = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              requests++;
              handler.reject(DioException(requestOptions: options));
            },
          ),
        );
      repository = HabitRepositoryImpl(
        store,
        isAccountAvailable: () => true,
        remote: remote,
        readUtcNow: () => now,
      );
      expect(
        await complete(habit),
        const Right(CompleteOccurrenceResult.completed),
      );
      expect((await repository.watchToday().first).completedCount, 1);
      expect(requests, 0);
      expect((await store.readPendingCommands()).length, 1);
      expect(
        (await store.readTodaySnapshot(now)).commands.single.outcome,
        isNull,
      );
    },
  );

  test(
    'on-day admission survives commit across boundary and is Completed/Pending, never Missed',
    () async {
      final habit = await create();
      crossingBoundary = true;
      expect(
        await complete(habit),
        const Right(CompleteOccurrenceResult.completed),
      );
      final projection = await repository.watchToday().first;
      expect(projection.completedCount, 0);
      expect(projection.yesterday, isEmpty);
      expect(projection.pendingEarlier.single.scheduledLocalDate, '2026-10-06');
      expect(
        projection.pendingEarlier.single.checkIn!.syncStatus,
        CheckInSyncStatus.pending,
      );
      now = DateTime.utc(2026, 10, 12, 12);
      expect(
        (await repository.watchToday().first)
            .pendingEarlier
            .single
            .scheduledLocalDate,
        '2026-10-06',
      );
    },
  );

  test(
    'A to B to A retains private check-in and commands; revoked queued admission cannot write',
    () async {
      final habit = await create();
      await complete(habit);
      await repository.close();
      await reopen('B');
      expect((await repository.watchToday().first).habitCount, 0);
      expect(
        await complete(habit),
        const Left(HabitFailure.occurrenceUnavailable),
      );
      expect((await store.readTodaySnapshot(now)).commands, isEmpty);
      await repository.close();
      await reopen();
      expect((await repository.watchToday().first).completedCount, 1);
      final second = await create();
      final queued = complete(second);
      available = false;
      expect(await queued, const Left(HabitFailure.accountUnavailable));
      available = true;
      expect((await store.readTodaySnapshot(now)).commands, hasLength(1));
    },
  );

  test(
    'actual two-collection Milestone 1 schema upgrades without changing Habit/start/V1 receipts',
    () async {
      final habit = await create();
      final original = (await store.readPendingCommands()).single;
      await repository.close();
      final m1 = await Isar.open(
        [HabitLocalEntitySchema, CreateHabitCommandLocalEntitySchema],
        directory: '${directory.path}/habits/QQ',
        name: 'habits_QQ',
        relaxedDurability: false,
        inspector: false,
      );
      final row = (await m1.habitLocalEntitys.where().findAll()).single;
      final id = row.id;
      await m1.writeTxn(() async {
        original
          ..outcome = 'accepted'
          ..responseJson = '{ "original" : true }';
        await m1.createHabitCommandLocalEntitys.put(original);
      });
      await m1.close();
      await reopen();
      final snapshot = await store.readTodaySnapshot(now);
      expect(snapshot.checkIns, isEmpty);
      expect(snapshot.commands, isEmpty);
      expect(snapshot.habits.single.id, id);
      expect(snapshot.habits.single.entityId, habit.id);
      expect(snapshot.habits.single.timezone, 'Africa/Cairo');
      expect(
        snapshot.habits.single.coverageStartLocalDate,
        habit.coverageStartLocalDate,
      );
      expect(snapshot.habits.single.coverageStartSource, 'localCreation');
      expect(
        snapshot.habits.single.coverageStartObservedAtUtc!.toUtc(),
        habit.coverageStartObservedAtUtc,
      );
      final receipt = await Isar.getInstance(
        'habits_QQ',
      )!.createHabitCommandLocalEntitys.getByCommandId(original.commandId);
      expect(receipt!.id, original.id);
      expect(receipt.version, 1);
      expect(receipt.payloadJson, original.payloadJson);
      expect(receipt.outcome, 'accepted');
      expect(receipt.responseJson, '{ "original" : true }');
      expect(
        await complete(habit),
        const Right(CompleteOccurrenceResult.completed),
      );
    },
  );

  test(
    'late V1 parent acknowledgement preserves original completed occurrence and intent',
    () async {
      final habit = await create();
      await complete(habit);
      final intent = (await store.readTodaySnapshot(now)).commands.single;
      final parentCommand = (await store.readPendingCommands()).single;
      now = DateTime.utc(2026, 10, 7, 12);
      await store.reconcile(parentCommand, {
        'accountId': 'A',
        'commandId': parentCommand.commandId,
        'entityId': habit.id,
        'version': 1,
        'outcome': 'accepted',
        'habit': {
          'id': habit.id,
          'accountId': 'A',
          'name': habit.name,
          'description': '',
          'category': null,
          'targetMinutes': null,
          'revision': 1,
          'schedule': {
            'frequency': 'daily',
            'weekdays': [],
            'timezone': 'Africa/Cairo',
          },
          'createdAt': now.toIso8601String(),
          'updatedAt': now.toIso8601String(),
        },
      });
      final projection = await repository.watchToday().first;
      expect(projection.yesterday, isEmpty);
      expect(projection.pendingEarlier.single.scheduledLocalDate, '2026-10-06');
      expect(
        projection.pendingEarlier.single.habit.syncStatus,
        HabitSyncStatus.synced,
      );
      expect(
        projection.pendingEarlier.single.checkIn!.syncStatus,
        CheckInSyncStatus.pending,
      );
      expect(
        (await store.readTodaySnapshot(now)).commands.single.payloadJson,
        intent.payloadJson,
      );
    },
  );

  test(
    'legacy prospective coverage is retained as legacy in immutable completion evidence',
    () async {
      final row = HabitLocalEntity()
        ..entityId = const Uuid().v4()
        ..accountId = 'A'
        ..name = 'Legacy'
        ..description = ''
        ..frequency = 'daily'
        ..weekdays = []
        ..timezone = 'Africa/Cairo'
        ..createdAt = DateTime.utc(2020);
      await store.create(
        row,
        CreateHabitCommandLocalEntity()
          ..commandId = const Uuid().v4()
          ..entityId = row.entityId
          ..accountId = 'A'
          ..payloadJson = '{ "legacy" : true }',
      );
      final legacy = (await repository.watchToday().first).due.single.habit;
      expect(legacy.coverageStartSource, HabitStartSource.legacyObservation);
      expect(
        await complete(legacy),
        const Right(CompleteOccurrenceResult.completed),
      );
      final evidence = (await store.readTodaySnapshot(
        now,
      )).commands.single.payloadJson;
      expect(
        (jsonDecode(evidence) as Map)['startEvidence']['source'],
        'legacyObservation',
      );
      expect(
        (jsonDecode(evidence) as Map)['startEvidence']['localDate'],
        '2026-10-06',
      );
    },
  );
}
