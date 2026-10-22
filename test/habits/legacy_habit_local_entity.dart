import 'package:isar_community/isar.dart';
part 'legacy_habit_local_entity.g.dart';

// Previous production schema, deliberately without SL-05 coverage fields.
@collection
@Name('HabitLocalEntity')
class LegacyHabitLocalEntity {
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
}
