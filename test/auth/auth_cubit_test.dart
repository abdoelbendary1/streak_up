import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/app/bootstrap/app_logger.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/core/presentation/status/status_models.dart';
import 'package:streak_up/features/auth/application/auth_session_coordinator.dart';
import 'package:streak_up/features/auth/domain/auth_models.dart';
import 'package:streak_up/features/auth/domain/pending_work_presence.dart';
import 'package:streak_up/features/auth/presentation/auth_cubit.dart';
import 'package:streak_up/features/shell/presentation/shell_cubit.dart';

import 'auth_session_coordinator_test.dart';

void main() {
  group('AuthCubit Presentation State & Actions (T020)', () {
    late FakeAuthGateway gateway;
    late ConfigurablePendingWorkPresenceProvider pendingProvider;
    late AuthSessionCoordinator coordinator;
    late AuthCubit authCubit;

    setUp(() {
      final logger = RedactedAppLogger();
      gateway = FakeAuthGateway();
      pendingProvider = ConfigurablePendingWorkPresenceProvider();
      final shellCubit = ShellCubit();
      final statusCubit = ShellStatusCubit();
      final feedback = FeedbackCoordinator(logger);
      final lifecycle = ShellAccountScopeLifecycle(
        shellCubit,
        statusCubit,
        feedback,
      );
      coordinator = AuthSessionCoordinator(
        gateway,
        pendingProvider,
        lifecycle,
        statusCubit,
        logger,
      );
      authCubit = AuthCubit(coordinator);
    });

    tearDown(() async {
      await authCubit.close();
      coordinator.dispose();
    });

    test(
      'starts in restoring state and transitions to signedOut on restore',
      () async {
        expect(authCubit.state.status, AuthAccountStatus.restoring);
        await authCubit.restoreInitialSession();
        expect(authCubit.state.status, AuthAccountStatus.signedOut);
      },
    );

    test(
      'validates password mismatch during registration before calling gateway',
      () async {
        final succeeded = await authCubit.register(
          email: 'user@example.com',
          password: 'password123',
          confirmPassword: 'differentPassword',
        );
        expect(succeeded, isFalse);
        expect(
          authCubit.state.activeFailure?.code,
          AuthFailureCode.passwordMismatch,
        );
      },
    );

    test(
      'resendVerificationEmail emits verificationEmailResent info banner',
      () async {
        await authCubit.register(
          email: 'verify@example.com',
          password: 'password123',
          confirmPassword: 'password123',
        );
        expect(authCubit.state.status, AuthAccountStatus.verificationRequired);

        final resent = await authCubit.resendVerificationEmail();
        expect(resent, isTrue);
        expect(
          authCubit.state.infoMessageKey,
          AuthInfoMessageKey.verificationEmailResent,
        );
      },
    );

    test(
      'callback failure is not restored by later snapshots and clears on success',
      () async {
        gateway.callbackOutcome = const AuthOutcome.failure(
          AuthFailure(AuthFailureCode.recoveryLinkExpiredOrInvalid),
        );
        await coordinator.handleAuthCallbackUri(
          Uri.parse('io.streakup.app://auth-callback?type=recovery'),
        );
        expect(
          authCubit.state.activeFailure?.code,
          AuthFailureCode.recoveryLinkExpiredOrInvalid,
        );

        authCubit.clearFeedback();
        await coordinator.requestPasswordRecovery(email: 'user@example.com');
        expect(authCubit.state.activeFailure, isNull);

        gateway.callbackOutcome = const AuthOutcome.success(
          AuthAccountState.signedOut(),
        );
        await coordinator.handleAuthCallbackUri(
          Uri.parse('io.streakup.app://auth-callback?type=recovery'),
        );
        expect(coordinator.snapshot.lastCallbackFailure, isNull);
        expect(authCubit.state.activeFailure, isNull);

        await coordinator.requestPasswordRecovery(email: 'user@example.com');
        expect(authCubit.state.activeFailure, isNull);
      },
    );
  });
}
