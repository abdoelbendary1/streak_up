import 'dart:io';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:streak_up/features/habits/data/local/habit_local_store.dart';
import 'package:streak_up/features/habits/data/local/habit_local_entity.dart';
import 'package:streak_up/features/habits/data/local/create_habit_command_local_entity.dart';
import 'package:streak_up/features/habits/data/repositories/habit_repository_impl.dart';
import 'package:streak_up/features/habits/domain/entities/habit.dart';
import 'package:streak_up/features/habits/domain/entities/habit_schedule.dart';
import 'isar_test_storage.dart';
import 'legacy_habit_local_entity.dart';

void main() {
  setUpAll(initializeHabitTestStorage);
  late Directory directory;
  late HabitLocalStore store;
  late HabitRepositoryImpl repository;
  var now = DateTime.utc(2026, 10, 5, 22);
  HabitSchedule daily() =>
      HabitSchedule(frequency: HabitFrequency.daily, timezone: 'Africa/Cairo');
  setUp(() async {
    now = DateTime.utc(2026, 10, 5, 22);
    directory = await Directory.systemTemp.createTemp('streakup_today_');
    store = await HabitLocalStore.open(
      directory: directory.path,
      accountId: 'A',
    );
    repository = HabitRepositoryImpl(
      store,
      isAccountAvailable: () => true,
      readUtcNow: () => now,
    );
  });
  tearDown(() async {
    await repository.close();
    await directory.delete(recursive: true);
  });

  test(
    'creation samples its start after queued admission, not form submission',
    () async {
      now = DateTime.utc(2026, 10, 5, 20); // Cairo is still Monday.
      final pending = repository.createHabit(name: 'Queued', schedule: daily());
      now = DateTime.utc(2026, 10, 5, 22); // Admitted after local midnight.
      final result = await pending;
      expect(
        result
            .fold((f) => throw StateError('$f'), (h) => h)
            .coverageStartLocalDate,
        '2026-10-06',
      );
    },
  );

  test(
    'new start is atomic local evidence, V1 payload unchanged, survives acknowledgement/restart',
    () async {
      final result = await repository.createHabit(
        name: 'Read',
        schedule: daily(),
      );
      final habit = result.fold((f) => throw StateError('$f'), (h) => h);
      expect(habit.coverageStartLocalDate, '2026-10-06');
      expect(habit.coverageStartObservedAtUtc, now);
      expect(habit.coverageStartSource, HabitStartSource.localCreation);
      final command = (await store.readPendingCommands()).single;
      final bytes = command.payloadJson;
      expect(command.version, 1);
      expect(jsonDecode(bytes), {
        'name': 'Read',
        'description': '',
        'category': null,
        'targetMinutes': null,
        'visibility': 'private',
        'schedule': {
          'frequency': 'daily',
          'weekdays': [],
          'timezone': 'Africa/Cairo',
        },
      });
      await store.reconcile(command, {
        'accountId': 'A',
        'commandId': command.commandId,
        'entityId': habit.id,
        'version': 1,
        'outcome': 'accepted',
        'habit': {
          ...jsonDecode(bytes) as Map<String, dynamic>,
          'id': habit.id,
          'accountId': 'A',
          'revision': 1,
          'createdAt': '2026-10-07T12:00:00Z',
          'updatedAt': '2026-10-07T12:00:00Z',
        },
      });
      await repository.close();
      now = DateTime.utc(2026, 10, 7, 12);
      store = await HabitLocalStore.open(
        directory: directory.path,
        accountId: 'A',
      );
      repository = HabitRepositoryImpl(
        store,
        isAccountAvailable: () => true,
        readUtcNow: () => now,
      );
      final reopened = (await repository.watchHabits().first).single;
      expect(reopened.coverageStartLocalDate, '2026-10-06');
      expect(reopened.coverageStartSource, HabitStartSource.localCreation);
      expect(reopened.syncStatus, HabitSyncStatus.synced);
      expect((await repository.watchToday().first).yesterday, hasLength(1));
    },
  );

  test(
    'actual previous Habit schema preserves IDs, V1 bytes/outcomes and adds one prospective baseline',
    () async {
      await repository.close();
      final legacy = await Isar.open(
        [LegacyHabitLocalEntitySchema, CreateHabitCommandLocalEntitySchema],
        directory: '${directory.path}/habits/QQ',
        name: 'habits_QQ',
        relaxedDurability: false,
        inspector: false,
      );
      const payload =
          '{ "name" : "Legacy", "schedule": {"timezone":"Africa/Cairo"} }';
      await legacy.writeTxn(() async {
        for (var index = 0; index < 2; index++) {
          final row = LegacyHabitLocalEntity()
            ..entityId = 'old-$index'
            ..accountId = 'A'
            ..name = 'Legacy $index'
            ..description = ''
            ..frequency = 'daily'
            ..weekdays = []
            ..timezone = 'Africa/Cairo'
            ..createdAt = DateTime.utc(2020)
            ..syncStatus = (index == 0 ? 'pending' : 'synced');
          await legacy.legacyHabitLocalEntitys.put(row);
          await legacy.createHabitCommandLocalEntitys.put(
            CreateHabitCommandLocalEntity()
              ..commandId = 'command-$index'
              ..entityId = row.entityId
              ..accountId = 'A'
              ..payloadJson = payload
              ..outcome = (index == 0 ? null : 'accepted')
              ..responseJson = (index == 0 ? null : '{"original":true}'),
          );
        }
      });
      final ids = (await legacy.legacyHabitLocalEntitys.where().findAll())
          .map((h) => h.id)
          .toList();
      await legacy.close();
      store = await HabitLocalStore.open(
        directory: directory.path,
        accountId: 'A',
      );
      repository = HabitRepositoryImpl(
        store,
        isAccountAvailable: () => true,
        readUtcNow: () => now,
      );
      final initial = await repository.watchToday().first;
      expect(initial.due, hasLength(2));
      expect(initial.yesterday, isEmpty);
      final rows = await store.watchHabits().first;
      expect(rows.map((h) => h.id), ids);
      expect(
        rows.map((h) => h.coverageStartSource),
        everyElement('legacyObservation'),
      );
      expect(
        rows.map((h) => h.coverageStartLocalDate),
        everyElement('2026-10-06'),
      );
      final pending = (await store.readPendingCommands()).single;
      expect(pending.commandId, 'command-0');
      expect(pending.version, 1);
      expect(pending.payloadJson, payload);
      expect(pending.outcome, isNull);
      final accepted = await Isar.getInstance(
        'habits_QQ',
      )!.createHabitCommandLocalEntitys.getByCommandId('command-1');
      expect(accepted!.payloadJson, payload);
      expect(accepted.outcome, 'accepted');
      expect(accepted.responseJson, '{"original":true}');
      final originalObserved = rows.first.coverageStartObservedAtUtc!.toUtc();
      now = DateTime.utc(2026, 10, 7, 12);
      await repository.close();
      store = await HabitLocalStore.open(
        directory: directory.path,
        accountId: 'A',
      );
      repository = HabitRepositoryImpl(
        store,
        isAccountAvailable: () => true,
        readUtcNow: () => now,
      );
      expect((await repository.watchToday().first).yesterday, hasLength(2));
      final after = (await store.watchHabits().first).first;
      expect(after.coverageStartObservedAtUtc!.toUtc(), originalObserved);
      expect(after.timezone, 'Africa/Cairo');
      expect(after.frequency, 'daily');
      final bStore = await HabitLocalStore.open(
        directory: directory.path,
        accountId: 'B',
      );
      final b = HabitRepositoryImpl(
        bStore,
        isAccountAvailable: () => true,
        readUtcNow: () => now,
      );
      expect((await b.watchToday().first).habitCount, 0);
      await b.close();
    },
  );

  test(
    'Today watcher updates after creation and explicit calendar refresh offline',
    () async {
      final snapshots = <dynamic>[];
      final subscription = repository.watchToday().listen(snapshots.add);
      await repository.watchToday().first;
      final created = repository.watchToday().firstWhere(
        (p) => p.due.isNotEmpty,
      );
      await repository.createHabit(name: 'Observed', schedule: daily());
      expect((await created).due.single.habit.name, 'Observed');
      now = DateTime.utc(2026, 10, 7, 12);
      final advanced = repository.watchToday().firstWhere(
        (p) => p.yesterday.isNotEmpty,
      );
      repository.refreshToday();
      expect(
        (await advanced).yesterday.single.scheduledLocalDate,
        '2026-10-06',
      );
      await subscription.cancel();
      expect(snapshots, isNotEmpty);
    },
  );

  test(
    'failed legacy observation rolls back coverage and surfaces load error',
    () async {
      for (var i = 0; i < 2; i++) {
        final habit = HabitLocalEntity()
          ..entityId = 'legacy-$i'
          ..accountId = 'A'
          ..name = 'Legacy $i'
          ..description = ''
          ..frequency = 'daily'
          ..weekdays = []
          ..timezone = i == 0 ? 'Africa/Cairo' : 'Invalid/Zone';
        final command = CreateHabitCommandLocalEntity()
          ..commandId = 'legacy-command-$i'
          ..entityId = habit.entityId
          ..accountId = 'A'
          ..payloadJson = '{"retained":$i}';
        await store.create(habit, command);
      }
      await expectLater(repository.watchToday().first, throwsStateError);
      final rows = await store.watchHabits().first;
      expect(
        rows.map((row) => row.coverageStartLocalDate),
        everyElement(isNull),
      );
      expect(
        rows.map((row) => row.coverageStartObservedAtUtc),
        everyElement(isNull),
      );
      expect((await store.readPendingCommands()).length, 2);
    },
  );
}
