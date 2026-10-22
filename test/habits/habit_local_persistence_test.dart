import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:isar_community/isar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/features/habits/data/local/habit_local_store.dart';
import 'package:streak_up/features/habits/data/local/habit_local_entity.dart';
import 'package:streak_up/features/habits/data/local/create_habit_command_local_entity.dart';
import 'package:streak_up/features/habits/data/repositories/habit_repository_impl.dart';
import 'package:streak_up/features/habits/domain/entities/habit.dart';
import 'package:streak_up/features/habits/domain/entities/habit_schedule.dart';
import 'package:streak_up/features/habits/domain/failures/habit_failure.dart';
import 'package:streak_up/features/habits/domain/use_cases/habit_use_cases.dart';
import 'package:streak_up/features/habits/presentation/cubit/habit_list_cubit.dart';
import 'isar_test_storage.dart';
import 'legacy_create_habit_command.dart';

void main() {
  setUpAll(initializeHabitTestStorage);
  late Directory directory;
  late HabitLocalStore store;
  late HabitRepositoryImpl repository;
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('streakup_habit_');
    store = await HabitLocalStore.open(
      directory: directory.path,
      accountId: 'A',
    );
    repository = HabitRepositoryImpl(store, isAccountAvailable: () => true);
  });
  tearDown(() async {
    await repository.close();
    await directory.delete(recursive: true);
  });
  HabitSchedule schedule() => HabitSchedule(
    frequency: HabitFrequency.selectedWeekdays,
    timezone: 'Africa/Cairo',
    weekdays: [1, 3, 5],
  );

  test(
    'atomic create persists Habit and immutable command, watcher emits Pending',
    () async {
      final observed = repository.watchHabits().firstWhere(
        (rows) => rows.isNotEmpty,
      );
      final result = await repository.createHabit(
        name: ' Read ',
        description: 'Twenty minutes',
        schedule: schedule(),
        category: HabitCategory.reading,
        targetMinutes: 20,
      );
      final habit = result.fold(
        (failure) => throw StateError('$failure'),
        (habit) => habit,
      );
      expect(habit.syncStatus, HabitSyncStatus.pending);
      expect((await observed).single.id, habit.id);
      final command = (await store.readPendingCommands()).single;
      expect(command.entityId, habit.id);
      expect(command.commandId, isNot(habit.id));
      expect(command.accountId, 'A');
      expect(command.version, 1);
      expect(jsonDecode(command.payloadJson), {
        'name': 'Read',
        'description': 'Twenty minutes',
        'category': 'reading',
        'targetMinutes': 20,
        'visibility': 'private',
        'schedule': {
          'frequency': 'selectedWeekdays',
          'weekdays': [1, 3, 5],
          'timezone': 'Africa/Cairo',
        },
      });
    },
  );

  test(
    'failure after first insert rolls back new Habit and new command',
    () async {
      final first = HabitLocalEntity()
        ..entityId = 'first'
        ..accountId = 'A'
        ..name = 'First'
        ..description = ''
        ..frequency = 'daily'
        ..weekdays = []
        ..timezone = 'Africa/Cairo';
      final command = CreateHabitCommandLocalEntity()
        ..commandId = 'duplicate'
        ..entityId = 'first'
        ..accountId = 'A'
        ..payloadJson = '{}';
      await store.create(first, command);
      final second = HabitLocalEntity()
        ..entityId = 'second'
        ..accountId = 'A'
        ..name = 'Second'
        ..description = ''
        ..frequency = 'daily'
        ..weekdays = []
        ..timezone = 'Africa/Cairo';
      final invalid = CreateHabitCommandLocalEntity()
        ..commandId = 'duplicate'
        ..entityId = 'second'
        ..accountId = 'A'
        ..payloadJson = '{"second":true}';
      second
        ..coverageStartLocalDate = '2026-10-06'
        ..coverageStartObservedAtUtc = DateTime.utc(2026, 10, 6, 12)
        ..coverageStartSource = 'localCreation';
      await expectLater(store.create(second, invalid), throwsA(anything));
      expect((await repository.watchHabits().first).map((h) => h.id), [
        'first',
      ]);
      expect((await store.readPendingCommands()).map((c) => c.entityId), [
        'first',
      ]);
    },
  );

  test(
    'close/reopen preserves Habit, same commandId and complete payload',
    () async {
      await repository.createHabit(name: 'Read', schedule: schedule());
      final before = (await store.readPendingCommands()).single;
      await repository.close();
      store = await HabitLocalStore.open(
        directory: directory.path,
        accountId: 'A',
      );
      repository = HabitRepositoryImpl(store, isAccountAvailable: () => true);
      final habits = await repository.watchHabits().first;
      final after = (await store.readPendingCommands()).single;
      expect(habits.single.id, before.entityId);
      expect(habits.single.syncStatus, HabitSyncStatus.pending);
      expect(habits.single.schedule.timezone, 'Africa/Cairo');
      expect(after.commandId, before.commandId);
      expect(after.payloadJson, before.payloadJson);
    },
  );

  test(
    'B cannot observe A Habit or intent; returning A restores original work',
    () async {
      await repository.createHabit(
        name: 'A private Habit',
        schedule: schedule(),
      );
      final aCommand = (await store.readPendingCommands()).single.commandId;
      await repository.close();
      final bStore = await HabitLocalStore.open(
        directory: directory.path,
        accountId: 'B',
      );
      final bRepository = HabitRepositoryImpl(
        bStore,
        isAccountAvailable: () => true,
      );
      expect(await bRepository.watchHabits().first, isEmpty);
      expect(await bStore.readPendingCommands(), isEmpty);
      await bRepository.createHabit(name: 'B Habit', schedule: schedule());
      await bRepository.close();
      store = await HabitLocalStore.open(
        directory: directory.path,
        accountId: 'A',
      );
      repository = HabitRepositoryImpl(store, isAccountAvailable: () => true);
      expect(
        (await repository.watchHabits().first).single.name,
        'A private Habit',
      );
      expect((await store.readPendingCommands()).single.commandId, aCommand);
    },
  );

  test('local watcher updates the list Cubit after commit', () async {
    final list = HabitListCubit(WatchHabitsUseCase(repository));
    try {
      final observed = list.stream.firstWhere(
        (state) => state.habits.isNotEmpty,
      );
      await repository.createHabit(
        name: 'Observed Habit',
        schedule: schedule(),
      );
      final state = await observed.timeout(const Duration(seconds: 10));
      expect(state.habits.single.name, 'Observed Habit');
      expect(state.habits.single.syncStatus, HabitSyncStatus.pending);
      expect(state.isLoading, isFalse);
    } finally {
      await list.close();
    }
  });
  test('unavailable account accepts neither projection nor intent', () async {
    final unavailable = HabitRepositoryImpl(
      store,
      isAccountAvailable: () => false,
    );
    final result = await unavailable.createHabit(
      name: 'Read',
      schedule: schedule(),
    );
    expect(result.fold((f) => f, (_) => null), HabitFailure.accountUnavailable);
    expect(await repository.watchHabits().first, isEmpty);
    expect(await store.readPendingCommands(), isEmpty);
  });

  test(
    'repository defensively rejects invalid input without local writes',
    () async {
      for (final input in [
        repository.createHabit(name: ' ', schedule: schedule()),
        repository.createHabit(
          name: 'Read',
          schedule: HabitSchedule(
            frequency: HabitFrequency.selectedWeekdays,
            timezone: 'Africa/Cairo',
          ),
        ),
        repository.createHabit(
          name: 'Read',
          schedule: HabitSchedule(
            frequency: HabitFrequency.daily,
            timezone: 'Invalid/Timezone',
          ),
        ),
      ]) {
        expect((await input).isLeft(), isTrue);
      }
      expect(await store.readPendingCommands(), isEmpty);
    },
  );

  test(
    'pre-delivery schema upgrade retains unresolved command IDs and payload',
    () async {
      await repository.close();
      final legacy = await Isar.open(
        [HabitLocalEntitySchema, LegacyCreateHabitCommandSchema],
        directory: '${directory.path}/habits/QQ',
        name: 'habits_QQ',
        relaxedDurability: false,
        inspector: false,
      );
      final command = LegacyCreateHabitCommand()
        ..accountId = 'A'
        ..commandId = 'legacy-command'
        ..entityId = 'legacy-habit'
        ..payloadJson = '{"name":"Legacy"}';
      await legacy.writeTxn(
        () => legacy.legacyCreateHabitCommands.put(command),
      );
      await legacy.close();
      store = await HabitLocalStore.open(
        directory: directory.path,
        accountId: 'A',
      );
      repository = HabitRepositoryImpl(store, isAccountAvailable: () => true);
      final reopened = (await store.readPendingCommands()).single;
      expect(reopened.commandId, 'legacy-command');
      expect(reopened.payloadJson, '{"name":"Legacy"}');
      expect(reopened.outcome, isNull);
    },
  );
}
