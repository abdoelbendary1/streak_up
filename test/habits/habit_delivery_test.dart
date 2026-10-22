import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/core/network/interceptors/supabase_auth_interceptor.dart';
import 'package:streak_up/features/habits/data/local/habit_local_store.dart';
import 'package:streak_up/features/habits/data/repositories/habit_repository_impl.dart';
import 'package:streak_up/features/habits/domain/entities/habit.dart';
import 'package:streak_up/features/habits/domain/entities/habit_schedule.dart';
import 'package:streak_up/features/habits/domain/failures/habit_failure.dart';
import 'package:streak_up/features/habits/domain/use_cases/habit_use_cases.dart';
import 'package:streak_up/features/habits/presentation/cubit/create_habit_cubit.dart';
import 'isar_test_storage.dart';

class _Adapter implements HttpClientAdapter {
  _Adapter(this.respond);
  final Future<ResponseBody> Function(RequestOptions) respond;
  final requests = <RequestOptions>[];
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? stream,
    Future<void>? cancelFuture,
  ) {
    requests.add(options);
    return respond(options);
  }

  @override
  void close({bool force = false}) {}
}

// Inject a serialization fault after the Habit put but before command put.
// The real Isar transaction must roll back, not an in-memory storage fake.
class _ReconciliationFault extends SyncTransformer {
  bool fail = true;
  @override
  Future<dynamic> transformResponse(
    RequestOptions options,
    ResponseBody body,
  ) async {
    final result = await super.transformResponse(options, body);
    if (fail) (result as Map<String, dynamic>)['fault'] = Object();
    return result;
  }
}

ResponseBody reply(int status, Object body) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);
Map<String, dynamic> accepted(RequestOptions request, {String account = 'A'}) {
  final command = request.data as Map<String, dynamic>;
  final payload = command['payload'] as Map<String, dynamic>;
  return {
    'outcome': 'accepted',
    'commandId': command['commandId'],
    'entityId': command['entityId'],
    'version': 1,
    'accountId': account,
    'habit': {
      ...payload,
      'id': command['entityId'],
      'accountId': account,
      'revision': 1,
      'createdAt': '2026-10-05T09:00:00Z',
      'updatedAt': '2026-10-05T09:00:00Z',
    },
  };
}

void main() {
  setUpAll(initializeHabitTestStorage);
  late Directory directory;
  late HabitLocalStore store;
  late HabitRepositoryImpl repository;
  late Dio dio;
  late SupabaseRequestCredentials? credentials;
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('streakup_delivery_');
    store = await HabitLocalStore.open(
      directory: directory.path,
      accountId: 'A',
    );
    repository = HabitRepositoryImpl(store, isAccountAvailable: () => true);
    await repository.createHabit(
      name: 'Read',
      schedule: HabitSchedule(
        frequency: HabitFrequency.daily,
        timezone: 'Africa/Cairo',
      ),
    );
    dio = Dio(BaseOptions(baseUrl: 'http://localhost/functions/v1/'));
    credentials = SupabaseRequestCredentials(
      userId: 'A',
      token: 'pinned-A',
      expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
    );
    repository = HabitRepositoryImpl(
      store,
      isAccountAvailable: () => true,
      remote: dio,
      readCredentials: () => credentials,
    );
  });
  tearDown(() async {
    await repository.close();
    dio.close(force: true);
    await directory.delete(recursive: true);
  });

  test('real local submit ends before the pending HTTP response', () async {
    final response = Completer<ResponseBody>();
    final started = Completer<void>();
    dio.httpClientAdapter = _Adapter((_) {
      if (!started.isCompleted) started.complete();
      return response.future;
    });
    final cubit = CreateHabitCubit(
      CreateHabitUseCase(repository),
      readTimezone: () async => 'Africa/Cairo',
    );
    try {
      expect(
        await cubit
            .create(
              name: 'Independent local save',
              frequency: HabitFrequency.daily,
            )
            .timeout(const Duration(seconds: 5)),
        isTrue,
      );
      expect(cubit.state.isSubmitting, isFalse);
      expect(cubit.state.habit!.syncStatus, HabitSyncStatus.pending);
      await started.future.timeout(const Duration(seconds: 5));
      expect(response.isCompleted, isFalse);
    } finally {
      response.complete(reply(500, {}));
      await repository.deliverPendingHabitCreates();
      await cubit.close();
    }
  });

  test(
    'immutable stored command is sent; accepted reconciles and watcher emits Synced',
    () async {
      final before = (await store.readPendingCommands()).single;
      final startBefore = (await repository.watchHabits().first).single;
      final adapter = _Adapter(
        (request) async => reply(200, accepted(request)),
      );
      dio.httpClientAdapter = adapter;
      final observed = repository.watchHabits().firstWhere(
        (rows) => rows.single.syncStatus == HabitSyncStatus.synced,
      );
      expect((await repository.deliverPendingHabitCreates()).isRight(), isTrue);
      final request = adapter.requests.single;
      expect(request.uri.path, '/functions/v1/create-habit-v1');
      expect(request.data, {
        'commandId': before.commandId,
        'entityId': before.entityId,
        'version': 1,
        'payload': jsonDecode(before.payloadJson),
      });
      expect(
        request.extra[SupabaseRequestCredentials.requestKey],
        same(credentials),
      );
      final habit = (await observed).single;
      expect(habit.coverageStartLocalDate, startBefore.coverageStartLocalDate);
      expect(
        habit.coverageStartObservedAtUtc,
        startBefore.coverageStartObservedAtUtc,
      );
      expect(habit.coverageStartSource, startBefore.coverageStartSource);
      expect(habit.serverRevision, 1);
      expect(habit.createdAt, DateTime.utc(2026, 10, 5, 9));
      expect(await store.readPendingCommands(), isEmpty);
      await repository.close();
      store = await HabitLocalStore.open(
        directory: directory.path,
        accountId: 'A',
      );
      repository = HabitRepositoryImpl(store, isAccountAvailable: () => true);
      expect(
        (await repository.watchHabits().first).single.syncStatus,
        HabitSyncStatus.synced,
      );
      expect(await store.readPendingCommands(), isEmpty);
    },
  );

  for (final invalid in ['missing', 'wrongAccount', 'expired', 'emptyToken']) {
    test('$invalid authorization sends nothing and preserves intent', () async {
      credentials = invalid == 'missing'
          ? null
          : SupabaseRequestCredentials(
              userId: invalid == 'wrongAccount' ? 'B' : 'A',
              token: invalid == 'emptyToken' ? '' : 'token',
              expiresAt: DateTime.now().toUtc().add(
                Duration(hours: invalid == 'expired' ? -1 : 1),
              ),
            );
      final adapter = _Adapter((_) async => reply(500, {}));
      dio.httpClientAdapter = adapter;
      expect(
        (await repository.deliverPendingHabitCreates()).fold(
          (f) => f,
          (_) => null,
        ),
        HabitFailure.authorization,
      );
      expect(adapter.requests, isEmpty);
      expect((await store.readPendingCommands()).length, 1);
    });
  }
  for (final status in [401, 403, 429, 500, 503]) {
    test('HTTP $status preserves Pending and original command', () async {
      final before = (await store.readPendingCommands()).single.commandId;
      dio.httpClientAdapter = _Adapter((_) async => reply(status, {}));
      expect((await repository.deliverPendingHabitCreates()).isLeft(), isTrue);
      expect((await store.readPendingCommands()).single.commandId, before);
      expect(
        (await repository.watchHabits().first).single.syncStatus,
        HabitSyncStatus.pending,
      );
    });
  }
  test('lost response replays same command ID and reconciles', () async {
    var lost = true;
    final adapter = _Adapter((request) async {
      if (lost)
        throw DioException(
          requestOptions: request,
          type: DioExceptionType.receiveTimeout,
        );
      return reply(200, accepted(request));
    });
    dio.httpClientAdapter = adapter;
    expect((await repository.deliverPendingHabitCreates()).isLeft(), isTrue);
    expect((await store.readPendingCommands()).length, 1);
    lost = false;
    expect((await repository.deliverPendingHabitCreates()).isRight(), isTrue);
    expect(adapter.requests.first.data, adapter.requests.last.data);
    expect(
      (await repository.watchHabits().first).single.syncStatus,
      HabitSyncStatus.synced,
    );
  });
  test('definitive rejection persists Failed and stops replay', () async {
    final adapter = _Adapter(
      (request) async => reply(422, {
        'outcome': 'rejected',
        'commandId': request.data['commandId'],
        'entityId': request.data['entityId'],
        'version': 1,
        'accountId': 'A',
        'reason': 'invalidPayload',
      }),
    );
    dio.httpClientAdapter = adapter;
    await repository.deliverPendingHabitCreates();
    final habit = (await repository.watchHabits().first).single;
    expect(habit.syncStatus, HabitSyncStatus.failed);
    expect(habit.rejection, HabitRejection.invalidPayload);
    expect(await store.readPendingCommands(), isEmpty);
    await repository.deliverPendingHabitCreates();
    expect(adapter.requests.length, 1);
  });
  test(
    'reconciliation failure rolls back Habit and ack; same-ID replay succeeds',
    () async {
      final fault = _ReconciliationFault();
      dio.transformer = fault;
      final adapter = _Adapter(
        (request) async => reply(200, accepted(request)),
      );
      dio.httpClientAdapter = adapter;
      final before = (await store.readPendingCommands()).single;
      expect(
        (await repository.deliverPendingHabitCreates()).fold(
          (f) => f,
          (_) => null,
        ),
        HabitFailure.storage,
      );
      final unchanged = (await repository.watchHabits().first).single;
      expect(unchanged.syncStatus, HabitSyncStatus.pending);
      expect(unchanged.serverRevision, isNull);
      expect(
        (await store.readPendingCommands()).single.commandId,
        before.commandId,
      );
      expect((await store.readPendingCommands()).single.responseJson, isNull);
      fault.fail = false;
      expect((await repository.deliverPendingHabitCreates()).isRight(), isTrue);
      expect(adapter.requests.first.data, adapter.requests.last.data);
      expect(
        (await repository.watchHabits().first).single.syncStatus,
        HabitSyncStatus.synced,
      );
    },
  );
  for (final field in [
    'commandId',
    'entityId',
    'version',
    'accountId',
    'habit',
    'missingCategory',
    'missingTarget',
  ]) {
    test('uncorrelated/malformed $field is never acknowledged', () async {
      dio.httpClientAdapter = _Adapter((request) async {
        final body = accepted(request);
        if (field == 'missingCategory' || field == 'missingTarget') {
          (body['habit'] as Map<String, dynamic>).remove(
            field == 'missingCategory' ? 'category' : 'targetMinutes',
          );
        } else {
          body[field] = 'wrong';
        }
        return reply(200, body);
      });
      expect(
        (await repository.deliverPendingHabitCreates()).fold(
          (f) => f,
          (_) => null,
        ),
        HabitFailure.invalidResponse,
      );
      expect((await store.readPendingCommands()).length, 1);
    });
  }
  test('account leaving during response cannot reconcile', () async {
    var available = true;
    repository = HabitRepositoryImpl(
      store,
      isAccountAvailable: () => available,
      remote: dio,
      readCredentials: () => credentials,
    );
    dio.httpClientAdapter = _Adapter((request) async {
      available = false;
      return reply(200, accepted(request));
    });
    await repository.deliverPendingHabitCreates();
    expect((await store.readPendingCommands()).length, 1);
    expect((await store.watchHabits().first).single.syncStatus, 'pending');
  });
}
