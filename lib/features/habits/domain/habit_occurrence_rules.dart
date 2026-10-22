import 'package:timezone/timezone.dart' as tz;
import 'entities/habit.dart';
import 'entities/habit_occurrence.dart';
import 'entities/habit_schedule.dart';
import 'entities/habit_check_in.dart';

String habitLocalDate(HabitSchedule schedule, DateTime instantUtc) {
  if (!schedule.isValid) throw StateError('Invalid Habit schedule');
  return civilDate(
    tz.TZDateTime.from(instantUtc.toUtc(), tz.getLocation(schedule.timezone)),
  );
}

String civilDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

void verifyCoverage(
  HabitSchedule schedule,
  String? start,
  DateTime? observed,
  HabitStartSource? source,
) {
  if (start == null ||
      observed == null ||
      source == null ||
      habitLocalDate(schedule, observed) != start) {
    throw StateError('Missing or inconsistent Habit coverage');
  }
}

bool isScheduledOn(HabitSchedule schedule, String start, DateTime date) =>
    civilDate(date).compareTo(start) >= 0 &&
    (schedule.frequency == HabitFrequency.daily ||
        schedule.weekdays.contains(date.weekday));

TodayProjection projectToday(
  Iterable<Habit> habits,
  DateTime nowUtc, {
  Iterable<HabitCheckIn> checkIns = const [],
}) {
  final due = <HabitOccurrence>[];
  final yesterday = <HabitOccurrence>[];
  DateTime? nextBoundary;
  final rows = habits.toList();
  final completions = {for (final checkIn in checkIns) checkIn.key: checkIn};
  for (final fact in completions.values) {
    verifyCoverage(
      fact.schedule,
      fact.coverageStartLocalDate,
      fact.coverageStartObservedAtUtc,
      fact.coverageStartSource,
    );
    if (fact.observedLocalDate != fact.scheduledLocalDate ||
        habitLocalDate(fact.schedule, fact.admittedAtUtc) !=
            fact.scheduledLocalDate ||
        !isScheduledOn(
          fact.schedule,
          fact.coverageStartLocalDate,
          DateTime.parse(fact.scheduledLocalDate),
        ) ||
        !rows.any(
          (habit) =>
              habit.id == fact.habitId && habit.accountId == fact.accountId,
        )) {
      throw StateError('Inconsistent completion evidence');
    }
  }
  final pendingEarlier = <HabitOccurrence>[];
  // Match the existing Habits list's local-store order; no completion reordering.
  for (final habit in rows) {
    if (!habit.schedule.isValid) throw StateError('Invalid Habit schedule');
    final start = habit.coverageStartLocalDate;
    final observed = habit.coverageStartObservedAtUtc;
    verifyCoverage(habit.schedule, start, observed, habit.coverageStartSource);
    final location = tz.getLocation(habit.schedule.timezone);
    final localNow = tz.TZDateTime.from(nowUtc.toUtc(), location);
    final next = tz.TZDateTime(
      location,
      localNow.year,
      localNow.month,
      localNow.day + 1,
    ).toUtc();
    if (nextBoundary == null || next.isBefore(nextBoundary)) {
      nextBoundary = next;
    }
    if (habit.syncStatus == HabitSyncStatus.failed) continue;
    final today = DateTime.utc(localNow.year, localNow.month, localNow.day);
    final previous = DateTime.utc(
      localNow.year,
      localNow.month,
      localNow.day - 1,
    );
    bool scheduled(DateTime date) =>
        isScheduledOn(habit.schedule, start!, date);
    HabitCheckIn? completionFor(DateTime date) {
      final fact = completions[occurrenceKey(habit.id, civilDate(date))];
      if (fact == null) return null;
      if (fact.accountId != habit.accountId ||
          fact.observedLocalDate != fact.scheduledLocalDate ||
          habitLocalDate(fact.schedule, fact.admittedAtUtc) !=
              fact.scheduledLocalDate) {
        throw StateError('Inconsistent completion evidence');
      }
      return fact;
    }

    if (scheduled(today)) {
      final completion = completionFor(today);
      due.add(
        HabitOccurrence(
          habit: habit,
          scheduledLocalDate: civilDate(today),
          state: completion == null
              ? HabitOccurrenceState.pending
              : HabitOccurrenceState.completed,
          checkIn: completion,
        ),
      );
    }
    if (scheduled(previous) && completionFor(previous) == null) {
      yesterday.add(
        HabitOccurrence(
          habit: habit,
          scheduledLocalDate: civilDate(previous),
          state: HabitOccurrenceState.missed,
        ),
      );
    }
    for (final fact in completions.values) {
      if (fact.habitId == habit.id &&
          fact.scheduledLocalDate.compareTo(civilDate(today)) < 0) {
        pendingEarlier.add(
          HabitOccurrence(
            habit: habit,
            scheduledLocalDate: fact.scheduledLocalDate,
            state: HabitOccurrenceState.completed,
            checkIn: fact,
          ),
        );
      }
    }
  }
  return TodayProjection(
    habitCount: rows.length,
    due: due,
    yesterday: yesterday,
    nextBoundaryUtc: nextBoundary,
    pendingEarlier: pendingEarlier,
  );
}
