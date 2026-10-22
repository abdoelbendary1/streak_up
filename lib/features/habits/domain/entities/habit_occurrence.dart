import 'habit.dart';
import 'habit_check_in.dart';

enum HabitOccurrenceState { pending, completed, missed }

class HabitOccurrence {
  const HabitOccurrence({
    required this.habit,
    required this.scheduledLocalDate,
    required this.state,
    this.checkIn,
  });
  final Habit habit;
  final String scheduledLocalDate;
  final HabitOccurrenceState state;
  final HabitCheckIn? checkIn;
  String get key => occurrenceKey(habit.id, scheduledLocalDate);
}

class TodayProjection {
  TodayProjection({
    required this.habitCount,
    required Iterable<HabitOccurrence> due,
    required Iterable<HabitOccurrence> yesterday,
    required this.nextBoundaryUtc,
    Iterable<HabitOccurrence> pendingEarlier = const [],
  }) : due = List.unmodifiable(due),
       yesterday = List.unmodifiable(yesterday),
       pendingEarlier = List.unmodifiable(pendingEarlier);
  final int habitCount;
  final List<HabitOccurrence> due;
  final List<HabitOccurrence> yesterday;
  final DateTime? nextBoundaryUtc;
  // Older unresolved actions stay discoverable without becoming due/history.
  final List<HabitOccurrence> pendingEarlier;
  int get completedCount =>
      due.where((row) => row.state == HabitOccurrenceState.completed).length;
}
