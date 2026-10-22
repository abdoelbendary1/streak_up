import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/app/routing/app_router.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';

import '../support/fake_auth_repository.dart';

void main() {
  test('redirects use only established authoritative auth states', () {
    for (final status in AuthStatus.values) {
      final state = AuthState(
        status: status,
        session: status == AuthStatus.authenticated ? accountA : null,
      );
      final target = AppRouter.resolveAuthRedirect(state, '/profile');
      expect(target, status == AuthStatus.authenticated ? null : isNotNull);
    }
    expect(
      AppRouter.resolveAuthRedirect(
        const AuthState(status: AuthStatus.verificationRequired),
        '/today',
      ),
      '/verify-email',
    );
    expect(
      AppRouter.resolveAuthRedirect(
        const AuthState(status: AuthStatus.recoveryRequired),
        '/today',
      ),
      '/password-recovery/reset',
    );
    expect(
      AppRouter.resolveAuthRedirect(
        const AuthState(status: AuthStatus.reauthenticationRequired),
        '/today',
      ),
      '/session-expired',
    );
  });

  test('saved destinations exclude credentials and external origins', () async {
    final backend = FakeAuthRepository();
    final cubit = AuthCubit(backend);
    for (final path in [
      'https://example.test/profile',
      '/profile?code=private',
      '/profile#private',
      '//example.test/profile',
    ]) {
      final router = AppRouter(cubit, initialLocation: path);
      router.dispose();
    }
    await cubit.close();
  });

  test(
    'in-flight signingOut or restoring blocks content with neutral restoring UI',
    () {
      expect(
        AppRouter.resolveAuthRedirect(
          const AuthState(status: AuthStatus.signingOut, session: accountA),
          '/today',
        ),
        '/restoring',
      );
      expect(
        AppRouter.resolveAuthRedirect(
          const AuthState(status: AuthStatus.restoring),
          '/today',
        ),
        '/restoring',
      );
    },
  );
}
