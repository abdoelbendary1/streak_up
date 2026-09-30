import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/app/bootstrap/app_logger.dart';
import 'package:streak_up/app/bootstrap/redacted_bloc_observer.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/core/presentation/status/status_models.dart';
import 'package:streak_up/features/auth/application/auth_session_coordinator.dart';
import 'package:streak_up/features/auth/domain/auth_models.dart';
import 'package:streak_up/features/auth/domain/pending_work_presence.dart';
import 'package:streak_up/features/auth/presentation/auth_cubit.dart';
import 'package:streak_up/features/shell/presentation/shell_cubit.dart';

import 'auth_session_coordinator_test.dart';

void main() {
  group('SL-02 Auth Privacy & Telemetry Redaction (T032)', () {
    test(
      'AppLogger and RedactedBlocObserver never emit emails, passwords, recovery links, verification tokens, access tokens, or refresh tokens',
      () async {
        final logger = RedactedAppLogger();
        final observer = RedactedBlocObserver(logger);

        const sensitiveEmail = 'private.user@streakup.io';
        const sensitivePassword = 'MySuperSecretPassword!99';
        const sensitiveAccessToken =
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.sig';
        const sensitiveRefreshToken = 'refresh_token_secret_val_987654';
        const sensitiveRecoveryLink =
            'io.streakup.app://auth-callback?type=recovery&token_hash=verif_hash_999&access_token=$sensitiveAccessToken&refresh_token=$sensitiveRefreshToken';

        logger.info(
          'auth.event for $sensitiveEmail with link $sensitiveRecoveryLink and password=$sensitivePassword',
          metadata: <String, Object?>{
            'email': sensitiveEmail,
            'password': sensitivePassword,
            'accessToken': sensitiveAccessToken,
            'refreshToken': sensitiveRefreshToken,
            'recoveryLink': sensitiveRecoveryLink,
            'destination': 'url=$sensitiveRecoveryLink',
            'blocType': 'AuthCubit',
          },
        );

        final gateway = FakeAuthGateway();
        final pendingProvider = ConfigurablePendingWorkPresenceProvider();
        final shellCubit = ShellCubit();
        final statusCubit = ShellStatusCubit();
        final feedback = FeedbackCoordinator(logger);
        final lifecycle = ShellAccountScopeLifecycle(
          shellCubit,
          statusCubit,
          feedback,
        );
        final coordinator = AuthSessionCoordinator(
          gateway,
          pendingProvider,
          lifecycle,
          statusCubit,
          logger,
        );
        final authCubit = AuthCubit(coordinator);

        observer.onCreate(authCubit);
        await authCubit.signIn(
          email: sensitiveEmail,
          password: sensitivePassword,
        );
        observer.onChange(
          authCubit,
          // ignore: invalid_use_of_protected_member
          Change<AuthState>(
            currentState: const AuthState(),
            nextState: authCubit.state,
          ),
        );

        expect(AccountId('acc-123').toString(), isNot(contains('acc-123')));
        expect(authCubit.state.toString(), isNot(contains(sensitiveEmail)));

        for (final entry in logger.entries) {
          final serialized = entry.toString();
          expect(serialized, isNot(contains(sensitiveEmail)));
          expect(serialized, isNot(contains(sensitivePassword)));
          expect(serialized, isNot(contains(sensitiveAccessToken)));
          expect(serialized, isNot(contains(sensitiveRefreshToken)));
          expect(serialized, isNot(contains('verif_hash_999')));
        }

        await authCubit.close();
        coordinator.dispose();
      },
    );
  });
}
