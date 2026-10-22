// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: experimental_member_use

part of 'habit_local_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHabitLocalEntityCollection on Isar {
  IsarCollection<HabitLocalEntity> get habitLocalEntitys => this.collection();
}

const HabitLocalEntitySchema = CollectionSchema(
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
    r'coverageStartLocalDate': PropertySchema(
      id: 2,
      name: r'coverageStartLocalDate',
      type: IsarType.string,
    ),
    r'coverageStartObservedAtUtc': PropertySchema(
      id: 3,
      name: r'coverageStartObservedAtUtc',
      type: IsarType.dateTime,
    ),
    r'coverageStartSource': PropertySchema(
      id: 4,
      name: r'coverageStartSource',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 5,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 6,
      name: r'description',
      type: IsarType.string,
    ),
    r'entityId': PropertySchema(
      id: 7,
      name: r'entityId',
      type: IsarType.string,
    ),
    r'frequency': PropertySchema(
      id: 8,
      name: r'frequency',
      type: IsarType.string,
    ),
    r'name': PropertySchema(id: 9, name: r'name', type: IsarType.string),
    r'rejection': PropertySchema(
      id: 10,
      name: r'rejection',
      type: IsarType.string,
    ),
    r'serverRevision': PropertySchema(
      id: 11,
      name: r'serverRevision',
      type: IsarType.long,
    ),
    r'syncStatus': PropertySchema(
      id: 12,
      name: r'syncStatus',
      type: IsarType.string,
    ),
    r'targetMinutes': PropertySchema(
      id: 13,
      name: r'targetMinutes',
      type: IsarType.long,
    ),
    r'timezone': PropertySchema(
      id: 14,
      name: r'timezone',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 15,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'weekdays': PropertySchema(
      id: 16,
      name: r'weekdays',
      type: IsarType.longList,
    ),
  },

  estimateSize: _habitLocalEntityEstimateSize,
  serialize: _habitLocalEntitySerialize,
  deserialize: _habitLocalEntityDeserialize,
  deserializeProp: _habitLocalEntityDeserializeProp,
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

  getId: _habitLocalEntityGetId,
  getLinks: _habitLocalEntityGetLinks,
  attach: _habitLocalEntityAttach,
  version: '3.3.2',
);

int _habitLocalEntityEstimateSize(
  HabitLocalEntity object,
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
  {
    final value = object.coverageStartLocalDate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.coverageStartSource;
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

void _habitLocalEntitySerialize(
  HabitLocalEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accountId);
  writer.writeString(offsets[1], object.category);
  writer.writeString(offsets[2], object.coverageStartLocalDate);
  writer.writeDateTime(offsets[3], object.coverageStartObservedAtUtc);
  writer.writeString(offsets[4], object.coverageStartSource);
  writer.writeDateTime(offsets[5], object.createdAt);
  writer.writeString(offsets[6], object.description);
  writer.writeString(offsets[7], object.entityId);
  writer.writeString(offsets[8], object.frequency);
  writer.writeString(offsets[9], object.name);
  writer.writeString(offsets[10], object.rejection);
  writer.writeLong(offsets[11], object.serverRevision);
  writer.writeString(offsets[12], object.syncStatus);
  writer.writeLong(offsets[13], object.targetMinutes);
  writer.writeString(offsets[14], object.timezone);
  writer.writeDateTime(offsets[15], object.updatedAt);
  writer.writeLongList(offsets[16], object.weekdays);
}

HabitLocalEntity _habitLocalEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HabitLocalEntity();
  object.accountId = reader.readString(offsets[0]);
  object.category = reader.readStringOrNull(offsets[1]);
  object.coverageStartLocalDate = reader.readStringOrNull(offsets[2]);
  object.coverageStartObservedAtUtc = reader.readDateTimeOrNull(offsets[3]);
  object.coverageStartSource = reader.readStringOrNull(offsets[4]);
  object.createdAt = reader.readDateTimeOrNull(offsets[5]);
  object.description = reader.readString(offsets[6]);
  object.entityId = reader.readString(offsets[7]);
  object.frequency = reader.readString(offsets[8]);
  object.id = id;
  object.name = reader.readString(offsets[9]);
  object.rejection = reader.readStringOrNull(offsets[10]);
  object.serverRevision = reader.readLongOrNull(offsets[11]);
  object.syncStatus = reader.readString(offsets[12]);
  object.targetMinutes = reader.readLongOrNull(offsets[13]);
  object.timezone = reader.readString(offsets[14]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[15]);
  object.weekdays = reader.readLongList(offsets[16]) ?? [];
  return object;
}

P _habitLocalEntityDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readLongOrNull(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 16:
      return (reader.readLongList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _habitLocalEntityGetId(HabitLocalEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _habitLocalEntityGetLinks(HabitLocalEntity object) {
  return [];
}

void _habitLocalEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  HabitLocalEntity object,
) {
  object.id = id;
}

extension HabitLocalEntityByIndex on IsarCollection<HabitLocalEntity> {
  Future<HabitLocalEntity?> getByEntityId(String entityId) {
    return getByIndex(r'entityId', [entityId]);
  }

  HabitLocalEntity? getByEntityIdSync(String entityId) {
    return getByIndexSync(r'entityId', [entityId]);
  }

  Future<bool> deleteByEntityId(String entityId) {
    return deleteByIndex(r'entityId', [entityId]);
  }

  bool deleteByEntityIdSync(String entityId) {
    return deleteByIndexSync(r'entityId', [entityId]);
  }

  Future<List<HabitLocalEntity?>> getAllByEntityId(
    List<String> entityIdValues,
  ) {
    final values = entityIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'entityId', values);
  }

  List<HabitLocalEntity?> getAllByEntityIdSync(List<String> entityIdValues) {
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

  Future<Id> putByEntityId(HabitLocalEntity object) {
    return putByIndex(r'entityId', object);
  }

  Id putByEntityIdSync(HabitLocalEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'entityId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByEntityId(List<HabitLocalEntity> objects) {
    return putAllByIndex(r'entityId', objects);
  }

  List<Id> putAllByEntityIdSync(
    List<HabitLocalEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'entityId', objects, saveLinks: saveLinks);
  }
}

extension HabitLocalEntityQueryWhereSort
    on QueryBuilder<HabitLocalEntity, HabitLocalEntity, QWhere> {
  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HabitLocalEntityQueryWhere
    on QueryBuilder<HabitLocalEntity, HabitLocalEntity, QWhereClause> {
  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterWhereClause>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterWhereClause>
  entityIdEqualTo(String entityId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'entityId', value: [entityId]),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterWhereClause>
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

extension HabitLocalEntityQueryFilter
    on QueryBuilder<HabitLocalEntity, HabitLocalEntity, QFilterCondition> {
  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  accountIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accountId', value: ''),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  accountIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'accountId', value: ''),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  categoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'category'),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  categoryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'category'),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'category', value: ''),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'category', value: ''),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartLocalDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'coverageStartLocalDate'),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartLocalDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'coverageStartLocalDate'),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartLocalDateEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'coverageStartLocalDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartLocalDateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'coverageStartLocalDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartLocalDateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'coverageStartLocalDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartLocalDateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'coverageStartLocalDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartLocalDateStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'coverageStartLocalDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartLocalDateEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'coverageStartLocalDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartLocalDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'coverageStartLocalDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartLocalDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'coverageStartLocalDate',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartLocalDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'coverageStartLocalDate', value: ''),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartLocalDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'coverageStartLocalDate',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartObservedAtUtcIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'coverageStartObservedAtUtc'),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartObservedAtUtcIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'coverageStartObservedAtUtc',
        ),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartObservedAtUtcEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'coverageStartObservedAtUtc',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartObservedAtUtcGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'coverageStartObservedAtUtc',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartObservedAtUtcLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'coverageStartObservedAtUtc',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartObservedAtUtcBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'coverageStartObservedAtUtc',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartSourceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'coverageStartSource'),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartSourceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'coverageStartSource'),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartSourceEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'coverageStartSource',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartSourceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'coverageStartSource',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartSourceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'coverageStartSource',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartSourceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'coverageStartSource',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartSourceStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'coverageStartSource',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartSourceEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'coverageStartSource',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartSourceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'coverageStartSource',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartSourceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'coverageStartSource',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartSourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'coverageStartSource', value: ''),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  coverageStartSourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'coverageStartSource',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'createdAt'),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'createdAt'),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  entityIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'entityId', value: ''),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  entityIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'entityId', value: ''),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  frequencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'frequency', value: ''),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  frequencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'frequency', value: ''),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  rejectionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'rejection'),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  rejectionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'rejection'),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  rejectionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'rejection', value: ''),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  rejectionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'rejection', value: ''),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  serverRevisionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'serverRevision'),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  serverRevisionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'serverRevision'),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  serverRevisionEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'serverRevision', value: value),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  syncStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'syncStatus', value: ''),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  syncStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'syncStatus', value: ''),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  targetMinutesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'targetMinutes'),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  targetMinutesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'targetMinutes'),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  targetMinutesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'targetMinutes', value: value),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  timezoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'timezone', value: ''),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  timezoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'timezone', value: ''),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  weekdaysElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'weekdays', value: value),
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  weekdaysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'weekdays', length, true, length, true);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  weekdaysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'weekdays', 0, true, 0, true);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  weekdaysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'weekdays', 0, false, 999999, true);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  weekdaysLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'weekdays', 0, true, length, include);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
  weekdaysLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'weekdays', length, include, 999999, true);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterFilterCondition>
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

extension HabitLocalEntityQueryObject
    on QueryBuilder<HabitLocalEntity, HabitLocalEntity, QFilterCondition> {}

extension HabitLocalEntityQueryLinks
    on QueryBuilder<HabitLocalEntity, HabitLocalEntity, QFilterCondition> {}

extension HabitLocalEntityQuerySortBy
    on QueryBuilder<HabitLocalEntity, HabitLocalEntity, QSortBy> {
  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByCoverageStartLocalDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverageStartLocalDate', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByCoverageStartLocalDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverageStartLocalDate', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByCoverageStartObservedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverageStartObservedAtUtc', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByCoverageStartObservedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverageStartObservedAtUtc', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByCoverageStartSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverageStartSource', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByCoverageStartSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverageStartSource', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByRejection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rejection', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByRejectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rejection', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByServerRevision() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverRevision', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByServerRevisionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverRevision', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByTargetMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetMinutes', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByTargetMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetMinutes', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByTimezone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timezone', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByTimezoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timezone', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension HabitLocalEntityQuerySortThenBy
    on QueryBuilder<HabitLocalEntity, HabitLocalEntity, QSortThenBy> {
  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByCoverageStartLocalDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverageStartLocalDate', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByCoverageStartLocalDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverageStartLocalDate', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByCoverageStartObservedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverageStartObservedAtUtc', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByCoverageStartObservedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverageStartObservedAtUtc', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByCoverageStartSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverageStartSource', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByCoverageStartSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverageStartSource', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByRejection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rejection', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByRejectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rejection', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByServerRevision() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverRevision', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByServerRevisionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverRevision', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByTargetMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetMinutes', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByTargetMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetMinutes', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByTimezone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timezone', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByTimezoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timezone', Sort.desc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension HabitLocalEntityQueryWhereDistinct
    on QueryBuilder<HabitLocalEntity, HabitLocalEntity, QDistinct> {
  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QDistinct>
  distinctByAccountId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QDistinct>
  distinctByCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QDistinct>
  distinctByCoverageStartLocalDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'coverageStartLocalDate',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QDistinct>
  distinctByCoverageStartObservedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coverageStartObservedAtUtc');
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QDistinct>
  distinctByCoverageStartSource({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'coverageStartSource',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QDistinct>
  distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QDistinct>
  distinctByEntityId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entityId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QDistinct>
  distinctByFrequency({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'frequency', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QDistinct>
  distinctByRejection({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rejection', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QDistinct>
  distinctByServerRevision() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverRevision');
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QDistinct>
  distinctBySyncStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QDistinct>
  distinctByTargetMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetMinutes');
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QDistinct>
  distinctByTimezone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timezone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<HabitLocalEntity, HabitLocalEntity, QDistinct>
  distinctByWeekdays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekdays');
    });
  }
}

extension HabitLocalEntityQueryProperty
    on QueryBuilder<HabitLocalEntity, HabitLocalEntity, QQueryProperty> {
  QueryBuilder<HabitLocalEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HabitLocalEntity, String, QQueryOperations> accountIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountId');
    });
  }

  QueryBuilder<HabitLocalEntity, String?, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<HabitLocalEntity, String?, QQueryOperations>
  coverageStartLocalDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coverageStartLocalDate');
    });
  }

  QueryBuilder<HabitLocalEntity, DateTime?, QQueryOperations>
  coverageStartObservedAtUtcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coverageStartObservedAtUtc');
    });
  }

  QueryBuilder<HabitLocalEntity, String?, QQueryOperations>
  coverageStartSourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coverageStartSource');
    });
  }

  QueryBuilder<HabitLocalEntity, DateTime?, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<HabitLocalEntity, String, QQueryOperations>
  descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<HabitLocalEntity, String, QQueryOperations> entityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entityId');
    });
  }

  QueryBuilder<HabitLocalEntity, String, QQueryOperations> frequencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'frequency');
    });
  }

  QueryBuilder<HabitLocalEntity, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<HabitLocalEntity, String?, QQueryOperations>
  rejectionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rejection');
    });
  }

  QueryBuilder<HabitLocalEntity, int?, QQueryOperations>
  serverRevisionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverRevision');
    });
  }

  QueryBuilder<HabitLocalEntity, String, QQueryOperations>
  syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }

  QueryBuilder<HabitLocalEntity, int?, QQueryOperations>
  targetMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetMinutes');
    });
  }

  QueryBuilder<HabitLocalEntity, String, QQueryOperations> timezoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timezone');
    });
  }

  QueryBuilder<HabitLocalEntity, DateTime?, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<HabitLocalEntity, List<int>, QQueryOperations>
  weekdaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekdays');
    });
  }
}
