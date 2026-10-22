import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/core/network/interceptors/supabase_auth_interceptor.dart';
import 'package:streak_up/features/habits/data/local/habit_local_store.dart';
import 'package:streak_up/features/habits/data/repositories/habit_repository_impl.dart';
import 'package:streak_up/features/habits/domain/entities/habit.dart';
import 'package:streak_up/features/habits/domain/entities/habit_schedule.dart';
import 'isar_test_storage.dart';

void main() {
  final url = Platform.environment['HABIT_REMOTE_TEST_URL'];
  test(
    'real HTTP Edge/PostgreSQL receipt replay reconciles real Isar after lost ack',
    () async {
      await initializeHabitTestStorage();
      final directory = await Directory.systemTemp.createTemp(
        'streakup_remote_',
      );
      const account = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
      final store = await HabitLocalStore.open(
        directory: directory.path,
        accountId: account,
      );
      final local = HabitRepositoryImpl(store, isAccountAvailable: () => true);
      await local.createHabit(
        name: 'Native remote integration',
        schedule: HabitSchedule(
          frequency: HabitFrequency.daily,
          timezone: 'Africa/Cairo',
        ),
      );
      final original = (await store.readPendingCommands()).single;
      final dio = Dio(
        BaseOptions(baseUrl: url!.replaceFirst('create-habit-v1', '')),
      );
      var loseAcknowledgement = true;
      final bodies = <dynamic>[];
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            options.headers['Authorization'] = 'Bearer isolated-test-token';
            bodies.add(options.data);
            handler.next(options);
          },
          onResponse: (response, handler) {
            if (loseAcknowledgement) {
              handler.reject(
                DioException(
                  requestOptions: response.requestOptions,
                  type: DioExceptionType.receiveTimeout,
                ),
              );
            } else {
              handler.next(response);
            }
          },
        ),
      );
      final repository = HabitRepositoryImpl(
        store,
        isAccountAvailable: () => true,
        remote: dio,
        readCredentials: () => SupabaseRequestCredentials(
          userId: account,
          token: 'isolated-test-token',
          expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
        ),
      );
      try {
        expect(
          (await repository.deliverPendingHabitCreates()).isLeft(),
          isTrue,
        );
        expect(
          (await store.readPendingCommands()).single.commandId,
          original.commandId,
        );
        expect(
          (await repository.watchHabits().first).single.syncStatus,
          HabitSyncStatus.pending,
        );
        loseAcknowledgement = false;
        expect(
          (await repository.deliverPendingHabitCreates()).isRight(),
          isTrue,
        );
        expect(bodies.first, bodies.last);
        final habit = (await repository.watchHabits().first).single;
        expect(habit.id, original.entityId);
        expect(habit.accountId, account);
        expect(habit.syncStatus, HabitSyncStatus.synced);
        expect(habit.serverRevision, 1);
        expect(await store.readPendingCommands(), isEmpty);
      } finally {
        await repository.close();
        dio.close(force: true);
        await directory.delete(recursive: true);
      }
    },
    skip: url == null
        ? 'Requires isolated Edge/PostgreSQL HTTP fixture'
        : false,
  );
}
