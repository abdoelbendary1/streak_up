import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/app/bootstrap/app_logger.dart';
import 'package:streak_up/app/bootstrap/injection.dart';
import 'package:streak_up/app/bootstrap/redacted_bloc_observer.dart';
import 'package:streak_up/app/routing/app_router.dart';
import 'package:streak_up/app/routing/feature_route_hosts.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/core/presentation/status/status_models.dart';
import 'package:streak_up/features/shell/presentation/shell_cubit.dart';

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
  group('T004 & T005 — AppLogger, RedactedBlocObserver, and DI bootstrap', () {
    test(
      'RedactedBlocObserver logs only allowlisted type/lifecycle metadata and excludes private habit, email, token, and friend strings (AS-17, SL01-FR-017)',
      () async {
        final logger = RedactedAppLogger();
        final previousObserver = Bloc.observer;
        Bloc.observer = RedactedBlocObserver(logger);
        addTearDown(() {
          Bloc.observer = previousObserver;
        });

        final cubit = _SensitiveSampleCubit();
        cubit.updatePrivateHabit('Confidential Medication Habit');
        cubit.triggerSensitiveError();
        await cubit.close();

        expect(logger.entries, isNotEmpty);

        final serializedLogs = logger.entries
            .map((e) => e.toString())
            .join('\n');

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

    test('RedactedAppLogger evicts oldest entries at its buffer limit', () {
      final logger = RedactedAppLogger();

      for (var index = 0; index < 501; index++) {
        logger.info('event-$index');
      }

      expect(logger.entries, hasLength(500));
      expect(logger.entries.first.event, 'event-1');
      expect(logger.entries.last.event, 'event-500');
    });

    test(
      'RedactedAppLogger drops non-allowlisted keys and redacts emails/tokens in event text',
      () {
        final logger = RedactedAppLogger();
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

        final entry = logger.entries.single;
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
      'configureDependencies registers and resolves shell presentation dependencies via injectable',
      () async {
        final locator = await configureDependencies(initializeSupabase: false);

        expect(locator<AppLogger>(), isA<RedactedAppLogger>());
        expect(locator<RedactedBlocObserver>(), isA<RedactedBlocObserver>());
        expect(locator<ShellCubit>(), isA<ShellCubit>());
        expect(locator<ShellStatusCubit>(), isA<ShellStatusCubit>());
        expect(locator<FeedbackCoordinator>(), isA<FeedbackCoordinator>());
        expect(locator<FeatureRouteHosts>(), isA<FeatureRouteHosts>());
        expect(locator<AppRouter>(), isA<AppRouter>());
      },
    );
  });
}
