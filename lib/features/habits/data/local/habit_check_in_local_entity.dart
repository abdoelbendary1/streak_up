import 'package:isar_community/isar.dart';
part 'habit_check_in_local_entity.g.dart';

@collection
class HabitCheckInLocalEntity {
  Id id = Isar.autoIncrement;
  @Index(unique: true)
  late String occurrenceKey;
  late String accountId;
  late String habitId;
  late String scheduledLocalDate;
  late String commandId;
  late DateTime admittedAtUtc;
  late String observedLocalDate;
  late String timezone;
  late String frequency;
  late List<int> weekdays;
  late String coverageStartLocalDate;
  late DateTime coverageStartObservedAtUtc;
  late String coverageStartSource;
  String syncStatus = 'pending';
}
