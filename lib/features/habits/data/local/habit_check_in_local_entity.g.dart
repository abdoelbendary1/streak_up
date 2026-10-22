// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: experimental_member_use

part of 'habit_check_in_local_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHabitCheckInLocalEntityCollection on Isar {
  IsarCollection<HabitCheckInLocalEntity> get habitCheckInLocalEntitys =>
      this.collection();
}

const HabitCheckInLocalEntitySchema = CollectionSchema(
  name: r'HabitCheckInLocalEntity',
  id: 236454474176446919,
  properties: {
    r'accountId': PropertySchema(
      id: 0,
      name: r'accountId',
      type: IsarType.string,
    ),
    r'admittedAtUtc': PropertySchema(
      id: 1,
      name: r'admittedAtUtc',
      type: IsarType.dateTime,
    ),
    r'commandId': PropertySchema(
      id: 2,
      name: r'commandId',
      type: IsarType.string,
    ),
    r'coverageStartLocalDate': PropertySchema(
      id: 3,
      name: r'coverageStartLocalDate',
      type: IsarType.string,
    ),
    r'coverageStartObservedAtUtc': PropertySchema(
      id: 4,
      name: r'coverageStartObservedAtUtc',
      type: IsarType.dateTime,
    ),
    r'coverageStartSource': PropertySchema(
      id: 5,
      name: r'coverageStartSource',
      type: IsarType.string,
    ),
    r'frequency': PropertySchema(
      id: 6,
      name: r'frequency',
      type: IsarType.string,
    ),
    r'habitId': PropertySchema(id: 7, name: r'habitId', type: IsarType.string),
    r'observedLocalDate': PropertySchema(
      id: 8,
      name: r'observedLocalDate',
      type: IsarType.string,
    ),
    r'occurrenceKey': PropertySchema(
      id: 9,
      name: r'occurrenceKey',
      type: IsarType.string,
    ),
    r'scheduledLocalDate': PropertySchema(
      id: 10,
      name: r'scheduledLocalDate',
      type: IsarType.string,
    ),
    r'syncStatus': PropertySchema(
      id: 11,
      name: r'syncStatus',
      type: IsarType.string,
    ),
    r'timezone': PropertySchema(
      id: 12,
      name: r'timezone',
      type: IsarType.string,
    ),
    r'weekdays': PropertySchema(
      id: 13,
      name: r'weekdays',
      type: IsarType.longList,
    ),
  },

  estimateSize: _habitCheckInLocalEntityEstimateSize,
  serialize: _habitCheckInLocalEntitySerialize,
  deserialize: _habitCheckInLocalEntityDeserialize,
  deserializeProp: _habitCheckInLocalEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'occurrenceKey': IndexSchema(
      id: 1905454298359628696,
      name: r'occurrenceKey',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'occurrenceKey',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _habitCheckInLocalEntityGetId,
  getLinks: _habitCheckInLocalEntityGetLinks,
  attach: _habitCheckInLocalEntityAttach,
  version: '3.3.2',
);

int _habitCheckInLocalEntityEstimateSize(
  HabitCheckInLocalEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accountId.length * 3;
  bytesCount += 3 + object.commandId.length * 3;
  bytesCount += 3 + object.coverageStartLocalDate.length * 3;
  bytesCount += 3 + object.coverageStartSource.length * 3;
  bytesCount += 3 + object.frequency.length * 3;
  bytesCount += 3 + object.habitId.length * 3;
  bytesCount += 3 + object.observedLocalDate.length * 3;
  bytesCount += 3 + object.occurrenceKey.length * 3;
  bytesCount += 3 + object.scheduledLocalDate.length * 3;
  bytesCount += 3 + object.syncStatus.length * 3;
  bytesCount += 3 + object.timezone.length * 3;
  bytesCount += 3 + object.weekdays.length * 8;
  return bytesCount;
}

void _habitCheckInLocalEntitySerialize(
  HabitCheckInLocalEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accountId);
  writer.writeDateTime(offsets[1], object.admittedAtUtc);
  writer.writeString(offsets[2], object.commandId);
  writer.writeString(offsets[3], object.coverageStartLocalDate);
  writer.writeDateTime(offsets[4], object.coverageStartObservedAtUtc);
  writer.writeString(offsets[5], object.coverageStartSource);
  writer.writeString(offsets[6], object.frequency);
  writer.writeString(offsets[7], object.habitId);
  writer.writeString(offsets[8], object.observedLocalDate);
  writer.writeString(offsets[9], object.occurrenceKey);
  writer.writeString(offsets[10], object.scheduledLocalDate);
  writer.writeString(offsets[11], object.syncStatus);
  writer.writeString(offsets[12], object.timezone);
  writer.writeLongList(offsets[13], object.weekdays);
}

HabitCheckInLocalEntity _habitCheckInLocalEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HabitCheckInLocalEntity();
  object.accountId = reader.readString(offsets[0]);
  object.admittedAtUtc = reader.readDateTime(offsets[1]);
  object.commandId = reader.readString(offsets[2]);
  object.coverageStartLocalDate = reader.readString(offsets[3]);
  object.coverageStartObservedAtUtc = reader.readDateTime(offsets[4]);
  object.coverageStartSource = reader.readString(offsets[5]);
  object.frequency = reader.readString(offsets[6]);
  object.habitId = reader.readString(offsets[7]);
  object.id = id;
  object.observedLocalDate = reader.readString(offsets[8]);
  object.occurrenceKey = reader.readString(offsets[9]);
  object.scheduledLocalDate = reader.readString(offsets[10]);
  object.syncStatus = reader.readString(offsets[11]);
  object.timezone = reader.readString(offsets[12]);
  object.weekdays = reader.readLongList(offsets[13]) ?? [];
  return object;
}

P _habitCheckInLocalEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readLongList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _habitCheckInLocalEntityGetId(HabitCheckInLocalEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _habitCheckInLocalEntityGetLinks(
  HabitCheckInLocalEntity object,
) {
  return [];
}

void _habitCheckInLocalEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  HabitCheckInLocalEntity object,
) {
  object.id = id;
}

extension HabitCheckInLocalEntityByIndex
    on IsarCollection<HabitCheckInLocalEntity> {
  Future<HabitCheckInLocalEntity?> getByOccurrenceKey(String occurrenceKey) {
    return getByIndex(r'occurrenceKey', [occurrenceKey]);
  }

  HabitCheckInLocalEntity? getByOccurrenceKeySync(String occurrenceKey) {
    return getByIndexSync(r'occurrenceKey', [occurrenceKey]);
  }

  Future<bool> deleteByOccurrenceKey(String occurrenceKey) {
    return deleteByIndex(r'occurrenceKey', [occurrenceKey]);
  }

  bool deleteByOccurrenceKeySync(String occurrenceKey) {
    return deleteByIndexSync(r'occurrenceKey', [occurrenceKey]);
  }

  Future<List<HabitCheckInLocalEntity?>> getAllByOccurrenceKey(
    List<String> occurrenceKeyValues,
  ) {
    final values = occurrenceKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'occurrenceKey', values);
  }

  List<HabitCheckInLocalEntity?> getAllByOccurrenceKeySync(
    List<String> occurrenceKeyValues,
  ) {
    final values = occurrenceKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'occurrenceKey', values);
  }

  Future<int> deleteAllByOccurrenceKey(List<String> occurrenceKeyValues) {
    final values = occurrenceKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'occurrenceKey', values);
  }

  int deleteAllByOccurrenceKeySync(List<String> occurrenceKeyValues) {
    final values = occurrenceKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'occurrenceKey', values);
  }

  Future<Id> putByOccurrenceKey(HabitCheckInLocalEntity object) {
    return putByIndex(r'occurrenceKey', object);
  }

  Id putByOccurrenceKeySync(
    HabitCheckInLocalEntity object, {
    bool saveLinks = true,
  }) {
    return putByIndexSync(r'occurrenceKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByOccurrenceKey(
    List<HabitCheckInLocalEntity> objects,
  ) {
    return putAllByIndex(r'occurrenceKey', objects);
  }

  List<Id> putAllByOccurrenceKeySync(
    List<HabitCheckInLocalEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'occurrenceKey', objects, saveLinks: saveLinks);
  }
}

extension HabitCheckInLocalEntityQueryWhereSort
    on QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QWhere> {
  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HabitCheckInLocalEntityQueryWhere
    on
        QueryBuilder<
          HabitCheckInLocalEntity,
          HabitCheckInLocalEntity,
          QWhereClause
        > {
  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterWhereClause
  >
  occurrenceKeyEqualTo(String occurrenceKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'occurrenceKey',
          value: [occurrenceKey],
        ),
      );
    });
  }

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterWhereClause
  >
  occurrenceKeyNotEqualTo(String occurrenceKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'occurrenceKey',
                lower: [],
                upper: [occurrenceKey],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'occurrenceKey',
                lower: [occurrenceKey],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'occurrenceKey',
                lower: [occurrenceKey],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'occurrenceKey',
                lower: [],
                upper: [occurrenceKey],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension HabitCheckInLocalEntityQueryFilter
    on
        QueryBuilder<
          HabitCheckInLocalEntity,
          HabitCheckInLocalEntity,
          QFilterCondition
        > {
  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  admittedAtUtcEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'admittedAtUtc', value: value),
      );
    });
  }

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  admittedAtUtcGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'admittedAtUtc',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  admittedAtUtcLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'admittedAtUtc',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  admittedAtUtcBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'admittedAtUtc',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  coverageStartLocalDateEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  coverageStartLocalDateGreaterThan(
    String value, {
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

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  coverageStartLocalDateLessThan(
    String value, {
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

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  coverageStartLocalDateBetween(
    String lower,
    String upper, {
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

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  coverageStartLocalDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'coverageStartLocalDate', value: ''),
      );
    });
  }

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  coverageStartObservedAtUtcEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'coverageStartObservedAtUtc',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  coverageStartObservedAtUtcGreaterThan(
    DateTime value, {
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

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  coverageStartObservedAtUtcLessThan(DateTime value, {bool include = false}) {
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

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  coverageStartObservedAtUtcBetween(
    DateTime lower,
    DateTime upper, {
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

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  coverageStartSourceEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  coverageStartSourceGreaterThan(
    String value, {
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

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  coverageStartSourceLessThan(
    String value, {
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

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  coverageStartSourceBetween(
    String lower,
    String upper, {
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

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  coverageStartSourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'coverageStartSource', value: ''),
      );
    });
  }

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  observedLocalDateEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'observedLocalDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  observedLocalDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'observedLocalDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  observedLocalDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'observedLocalDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  observedLocalDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'observedLocalDate',
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  observedLocalDateStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'observedLocalDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  observedLocalDateEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'observedLocalDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  observedLocalDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'observedLocalDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  observedLocalDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'observedLocalDate',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  observedLocalDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'observedLocalDate', value: ''),
      );
    });
  }

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  observedLocalDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'observedLocalDate', value: ''),
      );
    });
  }

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  weekdaysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'weekdays', length, true, length, true);
    });
  }

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  weekdaysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'weekdays', 0, true, 0, true);
    });
  }

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  weekdaysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'weekdays', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  weekdaysLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'weekdays', 0, true, length, include);
    });
  }

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
    QAfterFilterCondition
  >
  weekdaysLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'weekdays', length, include, 999999, true);
    });
  }

  QueryBuilder<
    HabitCheckInLocalEntity,
    HabitCheckInLocalEntity,
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

extension HabitCheckInLocalEntityQueryObject
    on
        QueryBuilder<
          HabitCheckInLocalEntity,
          HabitCheckInLocalEntity,
          QFilterCondition
        > {}

extension HabitCheckInLocalEntityQueryLinks
    on
        QueryBuilder<
          HabitCheckInLocalEntity,
          HabitCheckInLocalEntity,
          QFilterCondition
        > {}

extension HabitCheckInLocalEntityQuerySortBy
    on QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QSortBy> {
  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortByAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortByAdmittedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'admittedAtUtc', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortByAdmittedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'admittedAtUtc', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortByCommandId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commandId', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortByCommandIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commandId', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortByCoverageStartLocalDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverageStartLocalDate', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortByCoverageStartLocalDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverageStartLocalDate', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortByCoverageStartObservedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverageStartObservedAtUtc', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortByCoverageStartObservedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverageStartObservedAtUtc', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortByCoverageStartSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverageStartSource', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortByCoverageStartSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverageStartSource', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortByFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortByFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortByHabitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortByHabitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortByObservedLocalDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observedLocalDate', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortByObservedLocalDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observedLocalDate', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortByOccurrenceKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurrenceKey', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortByOccurrenceKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurrenceKey', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortByScheduledLocalDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledLocalDate', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortByScheduledLocalDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledLocalDate', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortByTimezone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timezone', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  sortByTimezoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timezone', Sort.desc);
    });
  }
}

extension HabitCheckInLocalEntityQuerySortThenBy
    on
        QueryBuilder<
          HabitCheckInLocalEntity,
          HabitCheckInLocalEntity,
          QSortThenBy
        > {
  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByAdmittedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'admittedAtUtc', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByAdmittedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'admittedAtUtc', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByCommandId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commandId', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByCommandIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commandId', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByCoverageStartLocalDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverageStartLocalDate', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByCoverageStartLocalDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverageStartLocalDate', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByCoverageStartObservedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverageStartObservedAtUtc', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByCoverageStartObservedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverageStartObservedAtUtc', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByCoverageStartSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverageStartSource', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByCoverageStartSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverageStartSource', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByHabitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByHabitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByObservedLocalDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observedLocalDate', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByObservedLocalDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observedLocalDate', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByOccurrenceKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurrenceKey', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByOccurrenceKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurrenceKey', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByScheduledLocalDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledLocalDate', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByScheduledLocalDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledLocalDate', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByTimezone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timezone', Sort.asc);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QAfterSortBy>
  thenByTimezoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timezone', Sort.desc);
    });
  }
}

extension HabitCheckInLocalEntityQueryWhereDistinct
    on
        QueryBuilder<
          HabitCheckInLocalEntity,
          HabitCheckInLocalEntity,
          QDistinct
        > {
  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QDistinct>
  distinctByAccountId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QDistinct>
  distinctByAdmittedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'admittedAtUtc');
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QDistinct>
  distinctByCommandId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'commandId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QDistinct>
  distinctByCoverageStartLocalDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'coverageStartLocalDate',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QDistinct>
  distinctByCoverageStartObservedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coverageStartObservedAtUtc');
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QDistinct>
  distinctByCoverageStartSource({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'coverageStartSource',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QDistinct>
  distinctByFrequency({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'frequency', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QDistinct>
  distinctByHabitId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'habitId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QDistinct>
  distinctByObservedLocalDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'observedLocalDate',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QDistinct>
  distinctByOccurrenceKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'occurrenceKey',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QDistinct>
  distinctByScheduledLocalDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'scheduledLocalDate',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QDistinct>
  distinctBySyncStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QDistinct>
  distinctByTimezone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timezone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, HabitCheckInLocalEntity, QDistinct>
  distinctByWeekdays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekdays');
    });
  }
}

extension HabitCheckInLocalEntityQueryProperty
    on
        QueryBuilder<
          HabitCheckInLocalEntity,
          HabitCheckInLocalEntity,
          QQueryProperty
        > {
  QueryBuilder<HabitCheckInLocalEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, String, QQueryOperations>
  accountIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountId');
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, DateTime, QQueryOperations>
  admittedAtUtcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'admittedAtUtc');
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, String, QQueryOperations>
  commandIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'commandId');
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, String, QQueryOperations>
  coverageStartLocalDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coverageStartLocalDate');
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, DateTime, QQueryOperations>
  coverageStartObservedAtUtcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coverageStartObservedAtUtc');
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, String, QQueryOperations>
  coverageStartSourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coverageStartSource');
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, String, QQueryOperations>
  frequencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'frequency');
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, String, QQueryOperations>
  habitIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'habitId');
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, String, QQueryOperations>
  observedLocalDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'observedLocalDate');
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, String, QQueryOperations>
  occurrenceKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'occurrenceKey');
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, String, QQueryOperations>
  scheduledLocalDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledLocalDate');
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, String, QQueryOperations>
  syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, String, QQueryOperations>
  timezoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timezone');
    });
  }

  QueryBuilder<HabitCheckInLocalEntity, List<int>, QQueryOperations>
  weekdaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekdays');
    });
  }
}
