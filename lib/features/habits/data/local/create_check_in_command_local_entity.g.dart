// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: experimental_member_use

part of 'create_check_in_command_local_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCreateCheckInCommandLocalEntityCollection on Isar {
  IsarCollection<CreateCheckInCommandLocalEntity>
  get createCheckInCommandLocalEntitys => this.collection();
}

const CreateCheckInCommandLocalEntitySchema = CollectionSchema(
  name: r'CreateCheckInCommandLocalEntity',
  id: 9166021088625148843,
  properties: {
    r'accountId': PropertySchema(
      id: 0,
      name: r'accountId',
      type: IsarType.string,
    ),
    r'commandId': PropertySchema(
      id: 1,
      name: r'commandId',
      type: IsarType.string,
    ),
    r'habitId': PropertySchema(id: 2, name: r'habitId', type: IsarType.string),
    r'occurrenceKey': PropertySchema(
      id: 3,
      name: r'occurrenceKey',
      type: IsarType.string,
    ),
    r'outcome': PropertySchema(id: 4, name: r'outcome', type: IsarType.string),
    r'payloadJson': PropertySchema(
      id: 5,
      name: r'payloadJson',
      type: IsarType.string,
    ),
    r'responseJson': PropertySchema(
      id: 6,
      name: r'responseJson',
      type: IsarType.string,
    ),
    r'scheduledLocalDate': PropertySchema(
      id: 7,
      name: r'scheduledLocalDate',
      type: IsarType.string,
    ),
    r'type': PropertySchema(id: 8, name: r'type', type: IsarType.string),
    r'version': PropertySchema(id: 9, name: r'version', type: IsarType.long),
  },

  estimateSize: _createCheckInCommandLocalEntityEstimateSize,
  serialize: _createCheckInCommandLocalEntitySerialize,
  deserialize: _createCheckInCommandLocalEntityDeserialize,
  deserializeProp: _createCheckInCommandLocalEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'commandId': IndexSchema(
      id: -4064098501468219660,
      name: r'commandId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'commandId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _createCheckInCommandLocalEntityGetId,
  getLinks: _createCheckInCommandLocalEntityGetLinks,
  attach: _createCheckInCommandLocalEntityAttach,
  version: '3.3.2',
);

int _createCheckInCommandLocalEntityEstimateSize(
  CreateCheckInCommandLocalEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accountId.length * 3;
  bytesCount += 3 + object.commandId.length * 3;
  bytesCount += 3 + object.habitId.length * 3;
  bytesCount += 3 + object.occurrenceKey.length * 3;
  {
    final value = object.outcome;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.payloadJson.length * 3;
  {
    final value = object.responseJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.scheduledLocalDate.length * 3;
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _createCheckInCommandLocalEntitySerialize(
  CreateCheckInCommandLocalEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accountId);
  writer.writeString(offsets[1], object.commandId);
  writer.writeString(offsets[2], object.habitId);
  writer.writeString(offsets[3], object.occurrenceKey);
  writer.writeString(offsets[4], object.outcome);
  writer.writeString(offsets[5], object.payloadJson);
  writer.writeString(offsets[6], object.responseJson);
  writer.writeString(offsets[7], object.scheduledLocalDate);
  writer.writeString(offsets[8], object.type);
  writer.writeLong(offsets[9], object.version);
}

CreateCheckInCommandLocalEntity _createCheckInCommandLocalEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CreateCheckInCommandLocalEntity();
  object.accountId = reader.readString(offsets[0]);
  object.commandId = reader.readString(offsets[1]);
  object.habitId = reader.readString(offsets[2]);
  object.id = id;
  object.occurrenceKey = reader.readString(offsets[3]);
  object.outcome = reader.readStringOrNull(offsets[4]);
  object.payloadJson = reader.readString(offsets[5]);
  object.responseJson = reader.readStringOrNull(offsets[6]);
  object.scheduledLocalDate = reader.readString(offsets[7]);
  object.type = reader.readString(offsets[8]);
  object.version = reader.readLong(offsets[9]);
  return object;
}

P _createCheckInCommandLocalEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _createCheckInCommandLocalEntityGetId(
  CreateCheckInCommandLocalEntity object,
) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _createCheckInCommandLocalEntityGetLinks(
  CreateCheckInCommandLocalEntity object,
) {
  return [];
}

void _createCheckInCommandLocalEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  CreateCheckInCommandLocalEntity object,
) {
  object.id = id;
}

extension CreateCheckInCommandLocalEntityByIndex
    on IsarCollection<CreateCheckInCommandLocalEntity> {
  Future<CreateCheckInCommandLocalEntity?> getByCommandId(String commandId) {
    return getByIndex(r'commandId', [commandId]);
  }

  CreateCheckInCommandLocalEntity? getByCommandIdSync(String commandId) {
    return getByIndexSync(r'commandId', [commandId]);
  }

  Future<bool> deleteByCommandId(String commandId) {
    return deleteByIndex(r'commandId', [commandId]);
  }

  bool deleteByCommandIdSync(String commandId) {
    return deleteByIndexSync(r'commandId', [commandId]);
  }

  Future<List<CreateCheckInCommandLocalEntity?>> getAllByCommandId(
    List<String> commandIdValues,
  ) {
    final values = commandIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'commandId', values);
  }

  List<CreateCheckInCommandLocalEntity?> getAllByCommandIdSync(
    List<String> commandIdValues,
  ) {
    final values = commandIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'commandId', values);
  }

  Future<int> deleteAllByCommandId(List<String> commandIdValues) {
    final values = commandIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'commandId', values);
  }

  int deleteAllByCommandIdSync(List<String> commandIdValues) {
    final values = commandIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'commandId', values);
  }

  Future<Id> putByCommandId(CreateCheckInCommandLocalEntity object) {
    return putByIndex(r'commandId', object);
  }

  Id putByCommandIdSync(
    CreateCheckInCommandLocalEntity object, {
    bool saveLinks = true,
  }) {
    return putByIndexSync(r'commandId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCommandId(
    List<CreateCheckInCommandLocalEntity> objects,
  ) {
    return putAllByIndex(r'commandId', objects);
  }

  List<Id> putAllByCommandIdSync(
    List<CreateCheckInCommandLocalEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'commandId', objects, saveLinks: saveLinks);
  }
}

extension CreateCheckInCommandLocalEntityQueryWhereSort
    on
        QueryBuilder<
          CreateCheckInCommandLocalEntity,
          CreateCheckInCommandLocalEntity,
          QWhere
        > {
  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterWhere
  >
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CreateCheckInCommandLocalEntityQueryWhere
    on
        QueryBuilder<
          CreateCheckInCommandLocalEntity,
          CreateCheckInCommandLocalEntity,
          QWhereClause
        > {
  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterWhereClause
  >
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterWhereClause
  >
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterWhereClause
  >
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterWhereClause
  >
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterWhereClause
  >
  commandIdEqualTo(String commandId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'commandId', value: [commandId]),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterWhereClause
  >
  commandIdNotEqualTo(String commandId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'commandId',
                lower: [],
                upper: [commandId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'commandId',
                lower: [commandId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'commandId',
                lower: [commandId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'commandId',
                lower: [],
                upper: [commandId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension CreateCheckInCommandLocalEntityQueryFilter
    on
        QueryBuilder<
          CreateCheckInCommandLocalEntity,
          CreateCheckInCommandLocalEntity,
          QFilterCondition
        > {
  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  accountIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'accountId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  accountIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'accountId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  accountIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'accountId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  accountIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'accountId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  accountIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'accountId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  accountIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'accountId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  accountIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'accountId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  accountIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'accountId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  accountIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accountId', value: ''),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  accountIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'accountId', value: ''),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  commandIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'commandId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  commandIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'commandId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  commandIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'commandId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  commandIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'commandId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  commandIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'commandId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  commandIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'commandId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  commandIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'commandId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  commandIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'commandId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  commandIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'commandId', value: ''),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  commandIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'commandId', value: ''),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  habitIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'habitId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  habitIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'habitId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  habitIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'habitId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  habitIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'habitId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  habitIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'habitId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  habitIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'habitId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  habitIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'habitId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  habitIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'habitId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  habitIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'habitId', value: ''),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  habitIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'habitId', value: ''),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  occurrenceKeyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'occurrenceKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  occurrenceKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'occurrenceKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  occurrenceKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'occurrenceKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  occurrenceKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'occurrenceKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  occurrenceKeyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'occurrenceKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  occurrenceKeyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'occurrenceKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  occurrenceKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'occurrenceKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  occurrenceKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'occurrenceKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  occurrenceKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'occurrenceKey', value: ''),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  occurrenceKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'occurrenceKey', value: ''),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  outcomeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'outcome'),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  outcomeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'outcome'),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  outcomeEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'outcome',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  outcomeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'outcome',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  outcomeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'outcome',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  outcomeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'outcome',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  outcomeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'outcome',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  outcomeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'outcome',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  outcomeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'outcome',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  outcomeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'outcome',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  outcomeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'outcome', value: ''),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  outcomeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'outcome', value: ''),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  payloadJsonEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'payloadJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  payloadJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'payloadJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  payloadJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'payloadJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  payloadJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'payloadJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  payloadJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'payloadJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  payloadJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'payloadJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  payloadJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'payloadJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  payloadJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'payloadJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  payloadJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'payloadJson', value: ''),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  payloadJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'payloadJson', value: ''),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  responseJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'responseJson'),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  responseJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'responseJson'),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  responseJsonEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'responseJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  responseJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'responseJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  responseJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'responseJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  responseJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'responseJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  responseJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'responseJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  responseJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'responseJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  responseJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'responseJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  responseJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'responseJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  responseJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'responseJson', value: ''),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  responseJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'responseJson', value: ''),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  scheduledLocalDateEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'scheduledLocalDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  scheduledLocalDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'scheduledLocalDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  scheduledLocalDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'scheduledLocalDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  scheduledLocalDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'scheduledLocalDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  scheduledLocalDateStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'scheduledLocalDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  scheduledLocalDateEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'scheduledLocalDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  scheduledLocalDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'scheduledLocalDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  scheduledLocalDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'scheduledLocalDate',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  scheduledLocalDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'scheduledLocalDate', value: ''),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  scheduledLocalDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'scheduledLocalDate', value: ''),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  typeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'type',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  typeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  typeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'type',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: ''),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'type', value: ''),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  versionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'version', value: value),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  versionGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'version',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  versionLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'version',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterFilterCondition
  >
  versionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'version',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension CreateCheckInCommandLocalEntityQueryObject
    on
        QueryBuilder<
          CreateCheckInCommandLocalEntity,
          CreateCheckInCommandLocalEntity,
          QFilterCondition
        > {}

extension CreateCheckInCommandLocalEntityQueryLinks
    on
        QueryBuilder<
          CreateCheckInCommandLocalEntity,
          CreateCheckInCommandLocalEntity,
          QFilterCondition
        > {}

extension CreateCheckInCommandLocalEntityQuerySortBy
    on
        QueryBuilder<
          CreateCheckInCommandLocalEntity,
          CreateCheckInCommandLocalEntity,
          QSortBy
        > {
  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  sortByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.asc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  sortByAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.desc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  sortByCommandId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commandId', Sort.asc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  sortByCommandIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commandId', Sort.desc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  sortByHabitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.asc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  sortByHabitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.desc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  sortByOccurrenceKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurrenceKey', Sort.asc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  sortByOccurrenceKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurrenceKey', Sort.desc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  sortByOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outcome', Sort.asc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  sortByOutcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outcome', Sort.desc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  sortByPayloadJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.asc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  sortByPayloadJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.desc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  sortByResponseJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'responseJson', Sort.asc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  sortByResponseJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'responseJson', Sort.desc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  sortByScheduledLocalDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledLocalDate', Sort.asc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  sortByScheduledLocalDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledLocalDate', Sort.desc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension CreateCheckInCommandLocalEntityQuerySortThenBy
    on
        QueryBuilder<
          CreateCheckInCommandLocalEntity,
          CreateCheckInCommandLocalEntity,
          QSortThenBy
        > {
  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  thenByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.asc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  thenByAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.desc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  thenByCommandId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commandId', Sort.asc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  thenByCommandIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commandId', Sort.desc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  thenByHabitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.asc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  thenByHabitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.desc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  thenByOccurrenceKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurrenceKey', Sort.asc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  thenByOccurrenceKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurrenceKey', Sort.desc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  thenByOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outcome', Sort.asc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  thenByOutcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outcome', Sort.desc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  thenByPayloadJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.asc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  thenByPayloadJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.desc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  thenByResponseJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'responseJson', Sort.asc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  thenByResponseJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'responseJson', Sort.desc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  thenByScheduledLocalDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledLocalDate', Sort.asc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  thenByScheduledLocalDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledLocalDate', Sort.desc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QAfterSortBy
  >
  thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension CreateCheckInCommandLocalEntityQueryWhereDistinct
    on
        QueryBuilder<
          CreateCheckInCommandLocalEntity,
          CreateCheckInCommandLocalEntity,
          QDistinct
        > {
  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QDistinct
  >
  distinctByAccountId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QDistinct
  >
  distinctByCommandId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'commandId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QDistinct
  >
  distinctByHabitId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'habitId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QDistinct
  >
  distinctByOccurrenceKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'occurrenceKey',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QDistinct
  >
  distinctByOutcome({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'outcome', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QDistinct
  >
  distinctByPayloadJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'payloadJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QDistinct
  >
  distinctByResponseJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'responseJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QDistinct
  >
  distinctByScheduledLocalDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'scheduledLocalDate',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QDistinct
  >
  distinctByType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    CreateCheckInCommandLocalEntity,
    CreateCheckInCommandLocalEntity,
    QDistinct
  >
  distinctByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'version');
    });
  }
}

extension CreateCheckInCommandLocalEntityQueryProperty
    on
        QueryBuilder<
          CreateCheckInCommandLocalEntity,
          CreateCheckInCommandLocalEntity,
          QQueryProperty
        > {
  QueryBuilder<CreateCheckInCommandLocalEntity, int, QQueryOperations>
  idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CreateCheckInCommandLocalEntity, String, QQueryOperations>
  accountIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountId');
    });
  }

  QueryBuilder<CreateCheckInCommandLocalEntity, String, QQueryOperations>
  commandIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'commandId');
    });
  }

  QueryBuilder<CreateCheckInCommandLocalEntity, String, QQueryOperations>
  habitIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'habitId');
    });
  }

  QueryBuilder<CreateCheckInCommandLocalEntity, String, QQueryOperations>
  occurrenceKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'occurrenceKey');
    });
  }

  QueryBuilder<CreateCheckInCommandLocalEntity, String?, QQueryOperations>
  outcomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'outcome');
    });
  }

  QueryBuilder<CreateCheckInCommandLocalEntity, String, QQueryOperations>
  payloadJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'payloadJson');
    });
  }

  QueryBuilder<CreateCheckInCommandLocalEntity, String?, QQueryOperations>
  responseJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'responseJson');
    });
  }

  QueryBuilder<CreateCheckInCommandLocalEntity, String, QQueryOperations>
  scheduledLocalDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledLocalDate');
    });
  }

  QueryBuilder<CreateCheckInCommandLocalEntity, String, QQueryOperations>
  typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<CreateCheckInCommandLocalEntity, int, QQueryOperations>
  versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'version');
    });
  }
}
