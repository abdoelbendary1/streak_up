import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:streak_up/app/bootstrap/injection.dart';
import 'package:streak_up/core/logging/app_bloc_observer.dart';
import 'package:streak_up/core/logging/app_logger.dart';
import 'package:streak_up/core/presentation/connectivity/connectivity_cubit.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/core/presentation/feedback/feedback_models.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:streak_up/features/auth/data/storage/secure_auth_storage.dart';
import 'package:streak_up/features/shell/presentation/cubit/shell_cubit.dart';

import '../support/fake_auth_repository.dart';

class _SensitiveSampleState {
  const _SensitiveSampleState({
    required this.privateHabitTitle,
    required this.email,
    required this.bearerToken,
    required this.friendName,
  });

  final String privateHabitTitle;
  final String email;
  final String bearerToken;
  final String friendName;

  @override
  String toString() {
    return 'SensitiveSampleState(habit: $privateHabitTitle, email: $email, token: $bearerToken, friend: $friendName)';
  }
}

class _SensitiveSampleCubit extends Cubit<_SensitiveSampleState> {
  _SensitiveSampleCubit()
    : super(
        const _SensitiveSampleState(
          privateHabitTitle: 'Secret Therapy Journaling',
          email: 'private.user@example.com',
          bearerToken: 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.secret',
          friendName: 'PrivateFriendHandle',
        ),
      );

  void updatePrivateHabit(String nextTitle) {
    emit(
      _SensitiveSampleState(
        privateHabitTitle: nextTitle,
        email: state.email,
        bearerToken: state.bearerToken,
        friendName: state.friendName,
      ),
    );
  }

  void triggerSensitiveError() {
    addError(
      StateError(
        'Failed for private.user@example.com on Secret Therapy Journaling with Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.secret',
      ),
    );
  }
}

void main() {
  group('T004 & T005 — AppLogger, AppBlocObserver, and DI bootstrap', () {
    test(
      'AppBlocObserver logs only allowlisted type/lifecycle metadata and excludes private habit, email, token, and friend strings (AS-17, SL01-FR-017)',
      () async {
        final entries = <LogEntry>[];
        final logger = AppLogger(sink: entries.add);
        final previousObserver = Bloc.observer;
        Bloc.observer = AppBlocObserver(logger);
        addTearDown(() {
          Bloc.observer = previousObserver;
        });

        final cubit = _SensitiveSampleCubit();
        cubit.updatePrivateHabit('Confidential Medication Habit');
        cubit.triggerSensitiveError();
        await cubit.close();

        expect(entries, isNotEmpty);

        final serializedLogs = entries.map((e) => e.toString()).join('\n');

        // Sensitive strings must NEVER appear in logged output.
        expect(serializedLogs, isNot(contains('Secret Therapy Journaling')));
        expect(
          serializedLogs,
          isNot(contains('Confidential Medication Habit')),
        );
        expect(serializedLogs, isNot(contains('private.user@example.com')));
        expect(
          serializedLogs,
          isNot(contains('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9')),
        );
        expect(serializedLogs, isNot(contains('PrivateFriendHandle')));

        // Type names and lifecycle metadata ARE recorded.
        expect(serializedLogs, contains('_SensitiveSampleCubit'));
        expect(serializedLogs, contains('_SensitiveSampleState'));
      },
    );

    test(
      'AppLogger drops non-allowlisted keys and redacts emails/tokens in event text',
      () {
        final entries = <LogEntry>[];
        final logger = AppLogger(sink: entries.add);
        logger.info(
          'sync attempt for user@example.com with Bearer eyJhbGciOiJIUzI1Ni.payload',
          metadata: <String, Object?>{
            'privateHabit': 'Evening Prayer',
            'friendEmail': 'friend@example.com',
            'rawPayload': '{"secret": 123}',
            'count': 2,
            'networkState': 'offline',
          },
        );

        final entry = entries.single;
        expect(entry.metadata.containsKey('privateHabit'), isFalse);
        expect(entry.metadata.containsKey('friendEmail'), isFalse);
        expect(entry.metadata.containsKey('rawPayload'), isFalse);
        expect(entry.metadata['count'], 2);
        expect(entry.metadata['networkState'], 'offline');
        expect(entry.event, isNot(contains('user@example.com')));
        expect(entry.event, contains('[REDACTED_EMAIL]'));
        expect(entry.event, contains('[REDACTED_TOKEN]'));
      },
    );

    test(
      'configureDependencies registers and resolves core and presentation dependencies via generated Injectable',
      () async {
        final locator = GetIt.asNewInstance();
        await configureDependencies(instance: locator);

        addTearDown(locator.reset);
        expect(locator<AppLogger>(), isA<AppLogger>());
        expect(locator<AppBlocObserver>(), isA<AppBlocObserver>());
        expect(locator<ShellCubit>(), isA<ShellCubit>());
        expect(locator<ConnectivityCubit>(), isA<ConnectivityCubit>());
        expect(locator<FeedbackCoordinator>(), isA<FeedbackCoordinator>());
        expect(locator<SecureAuthStorage>(), isA<SecureAuthStorage>());
      },
    );
  });

  test(
    'composition keeps session lazy and resets account UI before rebind',
    () async {
      final repository = FakeAuthRepository()..currentSession = accountA;
      final shell = ShellCubit();
      final feedback = FeedbackCoordinator(AppLogger());
      final authCubit = AuthCubit(repository);
      addTearDown(() async {
        await authCubit.close();
        await repository.controller.close();
        await shell.close();
        await feedback.close();
      });
      expect(repository.controller.hasListener, isTrue);
      await authCubit.signIn(
        email: 'fixture@example.test',
        password: 'fixture',
      );
      shell.setLocaleOverride(const Locale('ar'));
      feedback.publish(
        const FeedbackDescriptor(
          id: 'old-account',
          kind: FeedbackKind.warning,
          message: 'Safe notice',
        ),
      );
      shell.resetForAccountTransition();
      feedback.resetForAccountTransition();
      await authCubit.signOut();
      expect(shell.state.explicitLocaleOverride, isNull);
      expect(feedback.state.activeTransient, isNull);
    },
  );
}
