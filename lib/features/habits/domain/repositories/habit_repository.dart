import 'package:dartz/dartz.dart';
import '../entities/habit.dart';
import '../entities/habit_schedule.dart';
import '../entities/habit_occurrence.dart';
import '../entities/habit_check_in.dart';
import '../failures/habit_failure.dart';

abstract interface class HabitRepository {
  String get accountId;
  Future<Either<HabitFailure, Habit>> createHabit({
    required String name,
    required HabitSchedule schedule,
    String description = '',
    HabitCategory? category,
    int? targetMinutes,
  });
  Stream<List<Habit>> watchHabits();
  Stream<TodayProjection> watchToday();
  void refreshToday();
  Future<Either<HabitFailure, CompleteOccurrenceResult>> completeOccurrence({
    required String habitId,
    required String scheduledLocalDate,
  });
  Future<Either<HabitFailure, Unit>> deliverPendingHabitCreates();
  Future<void> close();
}
