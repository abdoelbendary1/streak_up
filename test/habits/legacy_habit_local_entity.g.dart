// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legacy_habit_local_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLegacyHabitLocalEntityCollection on Isar {
  IsarCollection<LegacyHabitLocalEntity> get legacyHabitLocalEntitys =>
      this.collection();
}

const LegacyHabitLocalEntitySchema = CollectionSchema(
  name: r'HabitLocalEntity',
  id: 3182216507762887817,
  properties: {
    r'accountId': PropertySchema(
      id: 0,
      name: r'accountId',
      type: IsarType.string,
    ),
    r'category': PropertySchema(
      id: 1,
      name: r'category',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 3,
      name: r'description',
      type: IsarType.string,
    ),
    r'entityId': PropertySchema(
      id: 4,
      name: r'entityId',
      type: IsarType.string,
    ),
    r'frequency': PropertySchema(
      id: 5,
      name: r'frequency',
      type: IsarType.string,
    ),
    r'name': PropertySchema(id: 6, name: r'name', type: IsarType.string),
    r'rejection': PropertySchema(
      id: 7,
      name: r'rejection',
      type: IsarType.string,
    ),
    r'serverRevision': PropertySchema(
      id: 8,
      name: r'serverRevision',
      type: IsarType.long,
    ),
    r'syncStatus': PropertySchema(
      id: 9,
      name: r'syncStatus',
      type: IsarType.string,
    ),
    r'targetMinutes': PropertySchema(
      id: 10,
      name: r'targetMinutes',
      type: IsarType.long,
    ),
    r'timezone': PropertySchema(
      id: 11,
      name: r'timezone',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 12,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'weekdays': PropertySchema(
      id: 13,
      name: r'weekdays',
      type: IsarType.longList,
    ),
  },

  estimateSize: _legacyHabitLocalEntityEstimateSize,
  serialize: _legacyHabitLocalEntitySerialize,
  deserialize: _legacyHabitLocalEntityDeserialize,
  deserializeProp: _legacyHabitLocalEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'entityId': IndexSchema(
      id: 745355021660786263,
      name: r'entityId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'entityId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _legacyHabitLocalEntityGetId,
  getLinks: _legacyHabitLocalEntityGetLinks,
  attach: _legacyHabitLocalEntityAttach,
  version: '3.3.2',
);

int _legacyHabitLocalEntityEstimateSize(
  LegacyHabitLocalEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accountId.length * 3;
  {
    final value = object.category;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.entityId.length * 3;
  bytesCount += 3 + object.frequency.length * 3;
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.rejection;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.syncStatus.length * 3;
  bytesCount += 3 + object.timezone.length * 3;
  bytesCount += 3 + object.weekdays.length * 8;
  return bytesCount;
}

void _legacyHabitLocalEntitySerialize(
  LegacyHabitLocalEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accountId);
  writer.writeString(offsets[1], object.category);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.description);
  writer.writeString(offsets[4], object.entityId);
  writer.writeString(offsets[5], object.frequency);
  writer.writeString(offsets[6], object.name);
  writer.writeString(offsets[7], object.rejection);
  writer.writeLong(offsets[8], object.serverRevision);
  writer.writeString(offsets[9], object.syncStatus);
  writer.writeLong(offsets[10], object.targetMinutes);
  writer.writeString(offsets[11], object.timezone);
  writer.writeDateTime(offsets[12], object.updatedAt);
  writer.writeLongList(offsets[13], object.weekdays);
}

LegacyHabitLocalEntity _legacyHabitLocalEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LegacyHabitLocalEntity();
  object.accountId = reader.readString(offsets[0]);
  object.category = reader.readStringOrNull(offsets[1]);
  object.createdAt = reader.readDateTimeOrNull(offsets[2]);
  object.description = reader.readString(offsets[3]);
  object.entityId = reader.readString(offsets[4]);
  object.frequency = reader.readString(offsets[5]);
  object.id = id;
  object.name = reader.readString(offsets[6]);
  object.rejection = reader.readStringOrNull(offsets[7]);
  object.serverRevision = reader.readLongOrNull(offsets[8]);
  object.syncStatus = reader.readString(offsets[9]);
  object.targetMinutes = reader.readLongOrNull(offsets[10]);
  object.timezone = reader.readString(offsets[11]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[12]);
  object.weekdays = reader.readLongList(offsets[13]) ?? [];
  return object;
}

P _legacyHabitLocalEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 13:
      return (reader.readLongList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _legacyHabitLocalEntityGetId(LegacyHabitLocalEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _legacyHabitLocalEntityGetLinks(
  LegacyHabitLocalEntity object,
) {
  return [];
}

void _legacyHabitLocalEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  LegacyHabitLocalEntity object,
) {
  object.id = id;
}

extension LegacyHabitLocalEntityByIndex
    on IsarCollection<LegacyHabitLocalEntity> {
  Future<LegacyHabitLocalEntity?> getByEntityId(String entityId) {
    return getByIndex(r'entityId', [entityId]);
  }

  LegacyHabitLocalEntity? getByEntityIdSync(String entityId) {
    return getByIndexSync(r'entityId', [entityId]);
  }

  Future<bool> deleteByEntityId(String entityId) {
    return deleteByIndex(r'entityId', [entityId]);
  }

  bool deleteByEntityIdSync(String entityId) {
    return deleteByIndexSync(r'entityId', [entityId]);
  }

  Future<List<LegacyHabitLocalEntity?>> getAllByEntityId(
    List<String> entityIdValues,
  ) {
    final values = entityIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'entityId', values);
  }

  List<LegacyHabitLocalEntity?> getAllByEntityIdSync(
    List<String> entityIdValues,
  ) {
    final values = entityIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'entityId', values);
  }

  Future<int> deleteAllByEntityId(List<String> entityIdValues) {
    final values = entityIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'entityId', values);
  }

  int deleteAllByEntityIdSync(List<String> entityIdValues) {
    final values = entityIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'entityId', values);
  }

  Future<Id> putByEntityId(LegacyHabitLocalEntity object) {
    return putByIndex(r'entityId', object);
  }

  Id putByEntityIdSync(LegacyHabitLocalEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'entityId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByEntityId(List<LegacyHabitLocalEntity> objects) {
    return putAllByIndex(r'entityId', objects);
  }

  List<Id> putAllByEntityIdSync(
    List<LegacyHabitLocalEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'entityId', objects, saveLinks: saveLinks);
  }
}

extension LegacyHabitLocalEntityQueryWhereSort
    on QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QWhere> {
  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LegacyHabitLocalEntityQueryWhere
    on
        QueryBuilder<
          LegacyHabitLocalEntity,
          LegacyHabitLocalEntity,
          QWhereClause
        > {
  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterWhereClause
  >
  entityIdEqualTo(String entityId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'entityId', value: [entityId]),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterWhereClause
  >
  entityIdNotEqualTo(String entityId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entityId',
                lower: [],
                upper: [entityId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entityId',
                lower: [entityId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entityId',
                lower: [entityId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entityId',
                lower: [],
                upper: [entityId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension LegacyHabitLocalEntityQueryFilter
    on
        QueryBuilder<
          LegacyHabitLocalEntity,
          LegacyHabitLocalEntity,
          QFilterCondition
        > {
  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  categoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'category'),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  categoryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'category'),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  categoryEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  categoryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  categoryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  categoryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'category',
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  categoryStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  categoryEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'category',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'category', value: ''),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'category', value: ''),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'createdAt'),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'createdAt'),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  createdAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  createdAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  createdAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  descriptionEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'description',
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  descriptionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  descriptionEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'description',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  frequencyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'frequency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  frequencyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'frequency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  frequencyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'frequency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  frequencyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'frequency',
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  frequencyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'frequency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  frequencyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'frequency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  frequencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'frequency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  frequencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'frequency',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  frequencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'frequency', value: ''),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  frequencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'frequency', value: ''),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  rejectionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'rejection'),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  rejectionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'rejection'),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  rejectionEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'rejection',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  rejectionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'rejection',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  rejectionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'rejection',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  rejectionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'rejection',
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  rejectionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'rejection',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  rejectionEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'rejection',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  rejectionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'rejection',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  rejectionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'rejection',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  rejectionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'rejection', value: ''),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  rejectionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'rejection', value: ''),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  serverRevisionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'serverRevision'),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  serverRevisionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'serverRevision'),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  serverRevisionEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'serverRevision', value: value),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  serverRevisionGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'serverRevision',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  serverRevisionLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'serverRevision',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  serverRevisionBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'serverRevision',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  syncStatusEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'syncStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  syncStatusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'syncStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  syncStatusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'syncStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  syncStatusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'syncStatus',
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  syncStatusStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'syncStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  syncStatusEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'syncStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  syncStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'syncStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  syncStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'syncStatus',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  syncStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'syncStatus', value: ''),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  syncStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'syncStatus', value: ''),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  targetMinutesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'targetMinutes'),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  targetMinutesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'targetMinutes'),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  targetMinutesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'targetMinutes', value: value),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  targetMinutesGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'targetMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  targetMinutesLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'targetMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  targetMinutesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'targetMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  timezoneEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'timezone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  timezoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'timezone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  timezoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'timezone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  timezoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'timezone',
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
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  timezoneStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'timezone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  timezoneEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'timezone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  timezoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'timezone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  timezoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'timezone',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  timezoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'timezone', value: ''),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  timezoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'timezone', value: ''),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  updatedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  updatedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  updatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  weekdaysElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'weekdays', value: value),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  weekdaysElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'weekdays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  weekdaysElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'weekdays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  weekdaysElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'weekdays',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  weekdaysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'weekdays', length, true, length, true);
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  weekdaysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'weekdays', 0, true, 0, true);
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  weekdaysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'weekdays', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  weekdaysLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'weekdays', 0, true, length, include);
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  weekdaysLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'weekdays', length, include, 999999, true);
    });
  }

  QueryBuilder<
    LegacyHabitLocalEntity,
    LegacyHabitLocalEntity,
    QAfterFilterCondition
  >
  weekdaysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekdays',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension LegacyHabitLocalEntityQueryObject
    on
        QueryBuilder<
          LegacyHabitLocalEntity,
          LegacyHabitLocalEntity,
          QFilterCondition
        > {}

extension LegacyHabitLocalEntityQueryLinks
    on
        QueryBuilder<
          LegacyHabitLocalEntity,
          LegacyHabitLocalEntity,
          QFilterCondition
        > {}

extension LegacyHabitLocalEntityQuerySortBy
    on QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QSortBy> {
  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortByAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortByEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortByEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortByFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortByFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortByRejection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rejection', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortByRejectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rejection', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortByServerRevision() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverRevision', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortByServerRevisionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverRevision', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortByTargetMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetMinutes', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortByTargetMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetMinutes', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortByTimezone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timezone', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortByTimezoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timezone', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LegacyHabitLocalEntityQuerySortThenBy
    on
        QueryBuilder<
          LegacyHabitLocalEntity,
          LegacyHabitLocalEntity,
          QSortThenBy
        > {
  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByRejection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rejection', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByRejectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rejection', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByServerRevision() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverRevision', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByServerRevisionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverRevision', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByTargetMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetMinutes', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByTargetMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetMinutes', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByTimezone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timezone', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByTimezoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timezone', Sort.desc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LegacyHabitLocalEntityQueryWhereDistinct
    on QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QDistinct> {
  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QDistinct>
  distinctByAccountId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QDistinct>
  distinctByCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QDistinct>
  distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QDistinct>
  distinctByEntityId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entityId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QDistinct>
  distinctByFrequency({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'frequency', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QDistinct>
  distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QDistinct>
  distinctByRejection({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rejection', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QDistinct>
  distinctByServerRevision() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverRevision');
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QDistinct>
  distinctBySyncStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QDistinct>
  distinctByTargetMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetMinutes');
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QDistinct>
  distinctByTimezone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timezone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, LegacyHabitLocalEntity, QDistinct>
  distinctByWeekdays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekdays');
    });
  }
}

extension LegacyHabitLocalEntityQueryProperty
    on
        QueryBuilder<
          LegacyHabitLocalEntity,
          LegacyHabitLocalEntity,
          QQueryProperty
        > {
  QueryBuilder<LegacyHabitLocalEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, String, QQueryOperations>
  accountIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountId');
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, String?, QQueryOperations>
  categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, DateTime?, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, String, QQueryOperations>
  descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, String, QQueryOperations>
  entityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entityId');
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, String, QQueryOperations>
  frequencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'frequency');
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, String, QQueryOperations>
  nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, String?, QQueryOperations>
  rejectionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rejection');
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, int?, QQueryOperations>
  serverRevisionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverRevision');
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, String, QQueryOperations>
  syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, int?, QQueryOperations>
  targetMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetMinutes');
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, String, QQueryOperations>
  timezoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timezone');
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, DateTime?, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<LegacyHabitLocalEntity, List<int>, QQueryOperations>
  weekdaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekdays');
    });
  }
}
