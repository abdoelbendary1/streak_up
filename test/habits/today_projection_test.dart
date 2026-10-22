import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/features/habits/domain/entities/habit.dart';
import 'package:streak_up/features/habits/domain/entities/habit_schedule.dart';
import 'package:streak_up/features/habits/domain/habit_occurrence_rules.dart';

Habit fixture({
  String zone = 'Africa/Cairo',
  String start = '2026-10-01',
  List<int>? days,
  HabitStartSource source = HabitStartSource.localCreation,
}) {
  final schedule = HabitSchedule(
    frequency: days == null
        ? HabitFrequency.daily
        : HabitFrequency.selectedWeekdays,
    timezone: zone,
    weekdays: days ?? [],
  );
  // Use a real origin in this zone to keep evidence consistent.
  final origin = DateTime.parse('${start}T12:00:00Z');
  return Habit(
    id: 'ABC',
    accountId: 'A',
    name: 'Read',
    schedule: schedule,
    coverageStartLocalDate: habitLocalDate(schedule, origin),
    coverageStartObservedAtUtc: origin,
    coverageStartSource: source,
  );
}

void main() {
  test('Daily projects one current row and bounded scheduled yesterday', () {
    final result = projectToday([fixture()], DateTime.utc(2026, 10, 6, 12));
    expect(result.due.single.key, 'abc/2026-10-06');
    expect(result.yesterday.single.scheduledLocalDate, '2026-10-05');
    expect(result.habitCount, 1);
  });
  test('ISO weekday filtering distinguishes no habits and nothing due', () {
    final now = DateTime.utc(2026, 10, 6, 12); // Tuesday.
    expect(projectToday([], now).habitCount, 0);
    final result = projectToday([
      fixture(days: [1, 3]),
    ], now);
    expect(result.due, isEmpty);
    expect(result.habitCount, 1);
    expect(result.yesterday.single.scheduledLocalDate, '2026-10-05');
    expect(
      projectToday([
        fixture(days: [1, 3]),
      ], DateTime.utc(2026, 10, 7, 12)).due,
      hasLength(1),
    );
  });
  test('retained timezone controls date even when UTC/device date differs', () {
    final result = projectToday([
      fixture(zone: 'America/New_York'),
    ], DateTime.utc(2026, 10, 6, 1));
    expect(result.due.single.scheduledLocalDate, '2026-10-05');
    expect(result.nextBoundaryUtc, DateTime.utc(2026, 10, 6, 4));
    final cairo = projectToday([fixture()], DateTime.utc(2026, 10, 6, 1));
    expect(cairo.due.single.scheduledLocalDate, '2026-10-06');
    expect(result.due.single.habit.schedule.timezone, 'America/New_York');
  });
  test('dates before start/legacy prospective coverage are unknown', () {
    for (final source in HabitStartSource.values) {
      final habit = fixture(start: '2026-10-06', source: source);
      final before = projectToday([habit], DateTime.utc(2026, 10, 5, 12));
      expect(before.due, isEmpty);
      expect(before.yesterday, isEmpty);
      final startDay = projectToday([habit], DateTime.utc(2026, 10, 6, 12));
      expect(startDay.due, hasLength(1));
      expect(startDay.yesterday, isEmpty);
    }
  });
  test('DST next civil boundary spans 23 and 25 hours, not fixed 24', () {
    final spring = projectToday([
      fixture(zone: 'America/New_York', start: '2026-03-01'),
    ], DateTime.utc(2026, 3, 8, 5));
    expect(
      spring.nextBoundaryUtc!.difference(DateTime.utc(2026, 3, 8, 5)),
      const Duration(hours: 23),
    );
    final autumn = projectToday([
      fixture(zone: 'America/New_York', start: '2026-10-01'),
    ], DateTime.utc(2026, 11, 1, 4));
    expect(
      autumn.nextBoundaryUtc!.difference(DateTime.utc(2026, 11, 1, 4)),
      const Duration(hours: 25),
    );
  });
  test('missing coverage is a load failure, not empty Today', () {
    expect(
      () => projectToday([
        Habit(
          id: 'x',
          accountId: 'A',
          name: 'Broken',
          schedule: fixture().schedule,
        ),
      ], DateTime.utc(2026, 10, 6)),
      throwsStateError,
    );
  });
}
