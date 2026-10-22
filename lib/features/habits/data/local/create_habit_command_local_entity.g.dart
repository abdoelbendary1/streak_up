// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: experimental_member_use

part of 'create_habit_command_local_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCreateHabitCommandLocalEntityCollection on Isar {
  IsarCollection<CreateHabitCommandLocalEntity>
  get createHabitCommandLocalEntitys => this.collection();
}

const CreateHabitCommandLocalEntitySchema = CollectionSchema(
  name: r'CreateHabitCommandLocalEntity',
  id: 3726345915508712271,
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
    r'entityId': PropertySchema(
      id: 2,
      name: r'entityId',
      type: IsarType.string,
    ),
    r'outcome': PropertySchema(id: 3, name: r'outcome', type: IsarType.string),
    r'payloadJson': PropertySchema(
      id: 4,
      name: r'payloadJson',
      type: IsarType.string,
    ),
    r'responseJson': PropertySchema(
      id: 5,
      name: r'responseJson',
      type: IsarType.string,
    ),
    r'type': PropertySchema(id: 6, name: r'type', type: IsarType.string),
    r'version': PropertySchema(id: 7, name: r'version', type: IsarType.long),
  },

  estimateSize: _createHabitCommandLocalEntityEstimateSize,
  serialize: _createHabitCommandLocalEntitySerialize,
  deserialize: _createHabitCommandLocalEntityDeserialize,
  deserializeProp: _createHabitCommandLocalEntityDeserializeProp,
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

  getId: _createHabitCommandLocalEntityGetId,
  getLinks: _createHabitCommandLocalEntityGetLinks,
  attach: _createHabitCommandLocalEntityAttach,
  version: '3.3.2',
);

int _createHabitCommandLocalEntityEstimateSize(
  CreateHabitCommandLocalEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accountId.length * 3;
  bytesCount += 3 + object.commandId.length * 3;
  bytesCount += 3 + object.entityId.length * 3;
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
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _createHabitCommandLocalEntitySerialize(
  CreateHabitCommandLocalEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accountId);
  writer.writeString(offsets[1], object.commandId);
  writer.writeString(offsets[2], object.entityId);
  writer.writeString(offsets[3], object.outcome);
  writer.writeString(offsets[4], object.payloadJson);
  writer.writeString(offsets[5], object.responseJson);
  writer.writeString(offsets[6], object.type);
  writer.writeLong(offsets[7], object.version);
}

CreateHabitCommandLocalEntity _createHabitCommandLocalEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CreateHabitCommandLocalEntity();
  object.accountId = reader.readString(offsets[0]);
  object.commandId = reader.readString(offsets[1]);
  object.entityId = reader.readString(offsets[2]);
  object.id = id;
  object.outcome = reader.readStringOrNull(offsets[3]);
  object.payloadJson = reader.readString(offsets[4]);
  object.responseJson = reader.readStringOrNull(offsets[5]);
  object.type = reader.readString(offsets[6]);
  object.version = reader.readLong(offsets[7]);
  return object;
}

P _createHabitCommandLocalEntityDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _createHabitCommandLocalEntityGetId(CreateHabitCommandLocalEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _createHabitCommandLocalEntityGetLinks(
  CreateHabitCommandLocalEntity object,
) {
  return [];
}

void _createHabitCommandLocalEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  CreateHabitCommandLocalEntity object,
) {
  object.id = id;
}

extension CreateHabitCommandLocalEntityByIndex
    on IsarCollection<CreateHabitCommandLocalEntity> {
  Future<CreateHabitCommandLocalEntity?> getByCommandId(String commandId) {
    return getByIndex(r'commandId', [commandId]);
  }

  CreateHabitCommandLocalEntity? getByCommandIdSync(String commandId) {
    return getByIndexSync(r'commandId', [commandId]);
  }

  Future<bool> deleteByCommandId(String commandId) {
    return deleteByIndex(r'commandId', [commandId]);
  }

  bool deleteByCommandIdSync(String commandId) {
    return deleteByIndexSync(r'commandId', [commandId]);
  }

  Future<List<CreateHabitCommandLocalEntity?>> getAllByCommandId(
    List<String> commandIdValues,
  ) {
    final values = commandIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'commandId', values);
  }

  List<CreateHabitCommandLocalEntity?> getAllByCommandIdSync(
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

  Future<Id> putByCommandId(CreateHabitCommandLocalEntity object) {
    return putByIndex(r'commandId', object);
  }

  Id putByCommandIdSync(
    CreateHabitCommandLocalEntity object, {
    bool saveLinks = true,
  }) {
    return putByIndexSync(r'commandId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCommandId(
    List<CreateHabitCommandLocalEntity> objects,
  ) {
    return putAllByIndex(r'commandId', objects);
  }

  List<Id> putAllByCommandIdSync(
    List<CreateHabitCommandLocalEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'commandId', objects, saveLinks: saveLinks);
  }
}

extension CreateHabitCommandLocalEntityQueryWhereSort
    on
        QueryBuilder<
          CreateHabitCommandLocalEntity,
          CreateHabitCommandLocalEntity,
          QWhere
        > {
  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterWhere
  >
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CreateHabitCommandLocalEntityQueryWhere
    on
        QueryBuilder<
          CreateHabitCommandLocalEntity,
          CreateHabitCommandLocalEntity,
          QWhereClause
        > {
  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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

extension CreateHabitCommandLocalEntityQueryFilter
    on
        QueryBuilder<
          CreateHabitCommandLocalEntity,
          CreateHabitCommandLocalEntity,
          QFilterCondition
        > {
  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterFilterCondition
  >
  entityIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'entityId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterFilterCondition
  >
  entityIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'entityId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterFilterCondition
  >
  entityIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'entityId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterFilterCondition
  >
  entityIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'entityId',
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterFilterCondition
  >
  entityIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'entityId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterFilterCondition
  >
  entityIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'entityId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterFilterCondition
  >
  entityIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'entityId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterFilterCondition
  >
  entityIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'entityId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterFilterCondition
  >
  entityIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'entityId', value: ''),
      );
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterFilterCondition
  >
  entityIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'entityId', value: ''),
      );
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
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

extension CreateHabitCommandLocalEntityQueryObject
    on
        QueryBuilder<
          CreateHabitCommandLocalEntity,
          CreateHabitCommandLocalEntity,
          QFilterCondition
        > {}

extension CreateHabitCommandLocalEntityQueryLinks
    on
        QueryBuilder<
          CreateHabitCommandLocalEntity,
          CreateHabitCommandLocalEntity,
          QFilterCondition
        > {}

extension CreateHabitCommandLocalEntityQuerySortBy
    on
        QueryBuilder<
          CreateHabitCommandLocalEntity,
          CreateHabitCommandLocalEntity,
          QSortBy
        > {
  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  sortByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.asc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  sortByAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.desc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  sortByCommandId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commandId', Sort.asc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  sortByCommandIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commandId', Sort.desc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  sortByEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.asc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  sortByEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.desc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  sortByOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outcome', Sort.asc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  sortByOutcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outcome', Sort.desc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  sortByPayloadJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.asc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  sortByPayloadJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.desc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  sortByResponseJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'responseJson', Sort.asc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  sortByResponseJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'responseJson', Sort.desc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension CreateHabitCommandLocalEntityQuerySortThenBy
    on
        QueryBuilder<
          CreateHabitCommandLocalEntity,
          CreateHabitCommandLocalEntity,
          QSortThenBy
        > {
  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  thenByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.asc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  thenByAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.desc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  thenByCommandId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commandId', Sort.asc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  thenByCommandIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commandId', Sort.desc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  thenByEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.asc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  thenByEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.desc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  thenByOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outcome', Sort.asc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  thenByOutcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outcome', Sort.desc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  thenByPayloadJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.asc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  thenByPayloadJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.desc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  thenByResponseJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'responseJson', Sort.asc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  thenByResponseJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'responseJson', Sort.desc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QAfterSortBy
  >
  thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension CreateHabitCommandLocalEntityQueryWhereDistinct
    on
        QueryBuilder<
          CreateHabitCommandLocalEntity,
          CreateHabitCommandLocalEntity,
          QDistinct
        > {
  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QDistinct
  >
  distinctByAccountId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QDistinct
  >
  distinctByCommandId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'commandId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QDistinct
  >
  distinctByEntityId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entityId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QDistinct
  >
  distinctByOutcome({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'outcome', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QDistinct
  >
  distinctByPayloadJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'payloadJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QDistinct
  >
  distinctByResponseJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'responseJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QDistinct
  >
  distinctByType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    CreateHabitCommandLocalEntity,
    CreateHabitCommandLocalEntity,
    QDistinct
  >
  distinctByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'version');
    });
  }
}

extension CreateHabitCommandLocalEntityQueryProperty
    on
        QueryBuilder<
          CreateHabitCommandLocalEntity,
          CreateHabitCommandLocalEntity,
          QQueryProperty
        > {
  QueryBuilder<CreateHabitCommandLocalEntity, int, QQueryOperations>
  idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CreateHabitCommandLocalEntity, String, QQueryOperations>
  accountIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountId');
    });
  }

  QueryBuilder<CreateHabitCommandLocalEntity, String, QQueryOperations>
  commandIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'commandId');
    });
  }

  QueryBuilder<CreateHabitCommandLocalEntity, String, QQueryOperations>
  entityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entityId');
    });
  }

  QueryBuilder<CreateHabitCommandLocalEntity, String?, QQueryOperations>
  outcomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'outcome');
    });
  }

  QueryBuilder<CreateHabitCommandLocalEntity, String, QQueryOperations>
  payloadJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'payloadJson');
    });
  }

  QueryBuilder<CreateHabitCommandLocalEntity, String?, QQueryOperations>
  responseJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'responseJson');
    });
  }

  QueryBuilder<CreateHabitCommandLocalEntity, String, QQueryOperations>
  typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<CreateHabitCommandLocalEntity, int, QQueryOperations>
  versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'version');
    });
  }
}
