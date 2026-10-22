import 'package:isar_community/isar.dart';
part 'create_check_in_command_local_entity.g.dart';

@collection
class CreateCheckInCommandLocalEntity {
  Id id = Isar.autoIncrement;
  @Index(unique: true)
  late String commandId;
  late String accountId;
  late String habitId;
  late String scheduledLocalDate;
  late String occurrenceKey;
  String type = 'createCheckIn';
  int version = 1;
  // Frozen at the successful local transaction; future replay uses these bytes.
  late String payloadJson;
  String? outcome;
  String? responseJson;
}
