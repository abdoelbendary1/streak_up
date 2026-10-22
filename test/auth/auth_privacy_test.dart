import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/core/logging/app_bloc_observer.dart';
import 'package:streak_up/core/logging/app_logger.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';

import '../support/fake_auth_repository.dart';

void main() {
  group('SL-02 Auth Privacy & Telemetry Redaction (T032)', () {
    test(
      'AppLogger and AppBlocObserver never emit emails, passwords, recovery links, verification tokens, access tokens, or refresh tokens',
      () async {
        final entries = <LogEntry>[];
        final logger = AppLogger(sink: entries.add);
        final observer = AppBlocObserver(logger);

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

        final authCubit = AuthCubit(FakeAuthRepository());

        observer.onCreate(authCubit);
        await authCubit.signIn(
          email: sensitiveEmail,
          password: sensitivePassword,
        );
        observer.onChange(
          authCubit,
          Change<AuthState>(
            currentState: const AuthState.restoring(),
            nextState: authCubit.state,
          ),
        );

        expect(authCubit.state.toString(), isNot(contains(sensitiveEmail)));
        expect(authCubit.state.toString(), isNot(contains(sensitivePassword)));

        for (final entry in entries) {
          final serialized = entry.toString();
          expect(serialized, isNot(contains(sensitiveEmail)));
          expect(serialized, isNot(contains(sensitivePassword)));
          expect(serialized, isNot(contains(sensitiveAccessToken)));
          expect(serialized, isNot(contains(sensitiveRefreshToken)));
          expect(serialized, isNot(contains('verif_hash_999')));
        }

        await authCubit.close();
      },
    );
  });
}
