import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/features/habits/domain/entities/habit.dart';
import 'package:streak_up/features/habits/domain/entities/habit_check_in.dart';
import 'package:streak_up/features/habits/domain/entities/habit_occurrence.dart';
import 'package:streak_up/features/habits/domain/entities/habit_schedule.dart';
import 'package:streak_up/features/habits/domain/failures/habit_failure.dart';
import 'package:streak_up/features/habits/domain/repositories/habit_repository.dart';
import 'package:streak_up/features/habits/domain/use_cases/habit_use_cases.dart';
import 'package:streak_up/features/habits/presentation/cubit/create_habit_cubit.dart';

class _LocalRepository implements HabitRepository {
  @override
  Future<Either<HabitFailure, CompleteOccurrenceResult>> completeOccurrence({
    required String habitId,
    required String scheduledLocalDate,
  }) async => const Left(HabitFailure.occurrenceUnavailable);
  @override
  Stream<TodayProjection> watchToday() => const Stream.empty();
  @override
  void refreshToday() {}
  @override
  String get accountId => 'A';
  final completion = Completer<Either<HabitFailure, Habit>>();
  int calls = 0;
  @override
  Future<Either<HabitFailure, Habit>> createHabit({
    required String name,
    required HabitSchedule schedule,
    String description = '',
    HabitCategory? category,
    int? targetMinutes,
  }) {
    calls++;
    return completion.future;
  }

  @override
  Stream<List<Habit>> watchHabits() => const Stream.empty();
  @override
  Future<void> close() async {}
  @override
  Future<Either<HabitFailure, Unit>> deliverPendingHabitCreates() async =>
      const Right(unit);
}

void main() {
  HabitSchedule schedule() =>
      HabitSchedule(frequency: HabitFrequency.daily, timezone: 'Africa/Cairo');
  test(
    'valid local create returns Pending and loading ends only after commit',
    () async {
      final repository = _LocalRepository();
      final cubit = CreateHabitCubit(
        CreateHabitUseCase(repository),
        readTimezone: () async => 'Africa/Cairo',
      );
      final result = cubit.create(
        name: ' Read ',
        frequency: HabitFrequency.daily,
      );
      expect(cubit.state.isSubmitting, isTrue);
      expect(
        await cubit.create(name: 'Read', frequency: HabitFrequency.daily),
        isFalse,
      );
      await Future<void>.delayed(Duration.zero);
      expect(repository.calls, 1);
      repository.completion.complete(
        Right(
          Habit(
            id: 'habit',
            accountId: 'A',
            name: 'Read',
            schedule: schedule(),
          ),
        ),
      );
      expect(await result, isTrue);
      expect(cubit.state.isSubmitting, isFalse);
      expect(cubit.state.habit!.syncStatus, HabitSyncStatus.pending);
      await cubit.close();
    },
  );
  test(
    'invalid name and selected-weekday schedule do not reach repository',
    () async {
      final repository = _LocalRepository();
      final cubit = CreateHabitCubit(
        CreateHabitUseCase(repository),
        readTimezone: () async => 'Africa/Cairo',
      );
      expect(
        await cubit.create(name: ' ', frequency: HabitFrequency.daily),
        isFalse,
      );
      expect(cubit.state.failure, HabitFailure.invalidName);
      for (final days in [
        <int>[],
        [0],
        [8],
        [1, 1],
      ]) {
        expect(
          await cubit.create(
            name: 'Read',
            frequency: HabitFrequency.selectedWeekdays,
            weekdays: days,
          ),
          isFalse,
        );
        expect(cubit.state.failure, HabitFailure.invalidSchedule);
      }
      expect(repository.calls, 0);
      expect(cubit.state.isSubmitting, isFalse);
      await cubit.close();
    },
  );
  test('local storage failure returns false and ends loading', () async {
    final repository = _LocalRepository();
    final cubit = CreateHabitCubit(
      CreateHabitUseCase(repository),
      readTimezone: () async => 'Africa/Cairo',
    );
    final result = cubit.create(name: 'Read', frequency: HabitFrequency.daily);
    repository.completion.complete(const Left(HabitFailure.storage));
    expect(await result, isFalse);
    expect(cubit.state.failure, HabitFailure.storage);
    expect(cubit.state.isSubmitting, isFalse);
    expect(cubit.state.habit, isNull);
    await cubit.close();
  });
}
