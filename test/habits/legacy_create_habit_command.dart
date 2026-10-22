import 'package:isar_community/isar.dart';
part 'legacy_create_habit_command.g.dart';

// The exact pre-delivery collection shape, only for the native upgrade test.
@collection
@Name('CreateHabitCommandLocalEntity')
class LegacyCreateHabitCommand {
  Id id = Isar.autoIncrement;
  @Index(unique: true)
  late String commandId;
  late String entityId;
  late String accountId;
  String type = 'createHabit';
  int version = 1;
  late String payloadJson;
}
