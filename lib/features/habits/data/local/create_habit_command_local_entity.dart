import 'package:isar_community/isar.dart';
part 'create_habit_command_local_entity.g.dart';

@collection
class CreateHabitCommandLocalEntity {
  Id id = Isar.autoIncrement;
  @Index(unique: true)
  late String commandId;
  late String entityId;
  late String accountId;
  String type = 'createHabit';
  int version = 1;
  // Frozen request input, independent of later projection/form edits.
  late String payloadJson;
  // Null is unresolved, including intents written before delivery existed.
  String? outcome;
  String? responseJson;
}
