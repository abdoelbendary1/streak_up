import 'habit.dart';
import 'habit_schedule.dart';

enum CheckInSyncStatus { pending }

enum CompleteOccurrenceResult { completed, alreadyCompleted }

class HabitCheckIn {
  const HabitCheckIn({
    required this.accountId,
    required this.habitId,
    required this.scheduledLocalDate,
    required this.commandId,
    required this.admittedAtUtc,
    required this.observedLocalDate,
    required this.schedule,
    required this.coverageStartLocalDate,
    required this.coverageStartObservedAtUtc,
    required this.coverageStartSource,
    this.syncStatus = CheckInSyncStatus.pending,
  });
  final String accountId;
  final String habitId;
  final String scheduledLocalDate;
  final String commandId;
  final DateTime admittedAtUtc;
  final String observedLocalDate;
  final HabitSchedule schedule;
  final String coverageStartLocalDate;
  final DateTime coverageStartObservedAtUtc;
  final HabitStartSource coverageStartSource;
  final CheckInSyncStatus syncStatus;
  String get key => occurrenceKey(habitId, scheduledLocalDate);
}

String occurrenceKey(String habitId, String date) =>
    '${habitId.toLowerCase()}/$date';
