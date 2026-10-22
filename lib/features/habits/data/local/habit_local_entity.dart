import 'package:isar_community/isar.dart';
part 'habit_local_entity.g.dart';

@collection
class HabitLocalEntity {
  Id id = Isar.autoIncrement;
  @Index(unique: true)
  late String entityId;
  late String accountId;
  late String name;
  late String description;
  String? category;
  int? targetMinutes;
  late String frequency;
  late List<int> weekdays;
  late String timezone;
  String syncStatus = 'pending';
  int? serverRevision;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? rejection;
  String? coverageStartLocalDate;
  DateTime? coverageStartObservedAtUtc;
  String? coverageStartSource;
}
