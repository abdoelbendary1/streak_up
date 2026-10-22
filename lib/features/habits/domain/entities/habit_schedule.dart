import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

enum HabitFrequency { daily, selectedWeekdays }

class HabitSchedule {
  HabitSchedule({
    required this.frequency,
    required this.timezone,
    Iterable<int> weekdays = const [],
  }) : weekdays = List.unmodifiable(weekdays);
  final HabitFrequency frequency;
  final String timezone;
  // ISO weekdays: Monday = 1, Sunday = 7. No occurrence/deadline semantics.
  final List<int> weekdays;
  static bool _zonesLoaded = false;

  bool get isValid {
    if (!_zonesLoaded) {
      tz_data.initializeTimeZones();
      _zonesLoaded = true;
    }
    if (!tz.timeZoneDatabase.locations.containsKey(timezone)) return false;
    return frequency == HabitFrequency.daily
        ? weekdays.isEmpty
        : weekdays.isNotEmpty &&
              weekdays.toSet().length == weekdays.length &&
              weekdays.every((day) => day >= 1 && day <= 7);
  }
}
