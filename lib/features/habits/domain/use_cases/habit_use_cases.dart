import 'package:dartz/dartz.dart';
import '../entities/habit.dart';
import '../entities/habit_schedule.dart';
import '../entities/habit_occurrence.dart';
import '../entities/habit_check_in.dart';
import '../failures/habit_failure.dart';
import '../repositories/habit_repository.dart';

class CreateHabitUseCase {
  const CreateHabitUseCase(this._repository);
  final HabitRepository _repository;
  Future<Either<HabitFailure, Habit>> call({
    required String name,
    required HabitSchedule schedule,
    String description = '',
    HabitCategory? category,
    int? targetMinutes,
  }) => _repository.createHabit(
    name: name,
    schedule: schedule,
    description: description,
    category: category,
    targetMinutes: targetMinutes,
  );
}

class WatchHabitsUseCase {
  const WatchHabitsUseCase(this._repository);
  final HabitRepository _repository;
  Stream<List<Habit>> call() => _repository.watchHabits();
}

class DeliverPendingHabitCreatesUseCase {
  const DeliverPendingHabitCreatesUseCase(this._repository);
  final HabitRepository _repository;
  Future<Either<HabitFailure, Unit>> call() =>
      _repository.deliverPendingHabitCreates();
}

class WatchTodayUseCase {
  const WatchTodayUseCase(this._repository);
  final HabitRepository _repository;
  Stream<TodayProjection> call() => _repository.watchToday();
}

class RefreshTodayUseCase {
  const RefreshTodayUseCase(this._repository);
  final HabitRepository _repository;
  void call() => _repository.refreshToday();
}

class CompleteOccurrenceUseCase {
  const CompleteOccurrenceUseCase(this._repository);
  final HabitRepository _repository;
  Future<Either<HabitFailure, CompleteOccurrenceResult>> call({
    required String habitId,
    required String scheduledLocalDate,
  }) => _repository.completeOccurrence(
    habitId: habitId,
    scheduledLocalDate: scheduledLocalDate,
  );
}
