import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/app/bootstrap/app_logger.dart';
import 'package:streak_up/app/routing/app_router.dart';
import 'package:streak_up/app/routing/feature_route_hosts.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/core/presentation/status/status_models.dart';
import 'package:streak_up/features/auth/application/auth_session_coordinator.dart';
import 'package:streak_up/features/auth/domain/auth_models.dart';
import 'package:streak_up/features/auth/domain/pending_work_presence.dart';
import 'package:streak_up/features/auth/presentation/auth_cubit.dart';
import 'package:streak_up/features/shell/presentation/shell_cubit.dart';
import 'package:streak_up/main.dart';

import 'auth_session_coordinator_test.dart';

void main() {
  group('Auth Protected Routing & Deep-Link Guards (T025)', () {
    late FakeAuthGateway gateway;
    late ConfigurablePendingWorkPresenceProvider pendingProvider;
    late ShellCubit shellCubit;
    late ShellStatusCubit statusCubit;
    late FeedbackCoordinator feedbackCoordinator;
    late AuthSessionCoordinator coordinator;
    late AuthCubit authCubit;

    setUp(() {
      final logger = RedactedAppLogger();
      gateway = FakeAuthGateway();
      pendingProvider = ConfigurablePendingWorkPresenceProvider()
        ..presence = PendingWorkPresence.none;
      shellCubit = ShellCubit();
      statusCubit = ShellStatusCubit();
      feedbackCoordinator = FeedbackCoordinator(logger);
      final lifecycle = ShellAccountScopeLifecycle(
        shellCubit,
        statusCubit,
        feedbackCoordinator,
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

    testWidgets(
      'starts at /restoring without flashing shell, redirects signedOut to /sign-in, and restores saved protected destination after verified authentication',
      (tester) async {
        final router = AppRouter.createRouter(
          initialLocation: '/challenges',
          authCoordinator: coordinator,
        );

        await tester.pumpWidget(
          StreakUpShellApp(
            shellCubit: shellCubit,
            statusCubit: statusCubit,
            feedbackCoordinator: feedbackCoordinator,
            routeHosts: const FeatureRouteHosts(),
            authCubit: authCubit,
            router: router,
          ),
        );
        await tester.pump();

        // While restoring, /challenges must redirect to /restoring and record /challenges
        expect(
          router.routerDelegate.currentConfiguration.uri.path,
          '/restoring',
        );
        expect(coordinator.snapshot.savedProtectedLocation, '/challenges');
        expect(
          find.byKey(const ValueKey<String>('shell_host_challenges')),
          findsNothing,
        );

        // Complete restoration as signedOut -> redirects to /sign-in
        await authCubit.restoreInitialSession();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));
        expect(router.routerDelegate.currentConfiguration.uri.path, '/sign-in');

        // Sign in with verified account -> restores saved destination /challenges
        await authCubit.signIn(
          email: 'user@example.com',
          password: 'password123',
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));
        expect(
          router.routerDelegate.currentConfiguration.uri.path,
          '/challenges',
        );
        expect(
          find.byKey(const ValueKey<String>('shell_host_challenges')),
          findsOneWidget,
        );
      },
    );

    test(
      'redirect matrix blocks unverified accounts on /verify-email, invalidated sessions on /session-expired, and unvalidated /password-recovery/reset on /password-recovery',
      () async {
        // 1. Direct entry to /password-recovery/reset without recovery context redirects to /password-recovery
        await coordinator.restoreInitialSession();
        expect(
          AppRouter.resolveAuthRedirect(
            coordinator: coordinator,
            location: '/password-recovery/reset',
          ),
          '/password-recovery',
        );

        // 2. Unverified registration locks all protected routes to /verify-email
        await coordinator.register(
          email: 'pending@example.com',
          password: 'password123',
        );
        for (final protectedPath in <String>[
          '/today',
          '/habits',
          '/challenges',
          '/friends',
          '/inbox',
          '/profile',
          '/sync-recovery',
        ]) {
          expect(
            AppRouter.resolveAuthRedirect(
              coordinator: coordinator,
              location: protectedPath,
            ),
            '/verify-email',
          );
        }

        // 3. Confirmed session invalidation routes protected destinations to /session-expired
        await coordinator.handleConfirmedSessionInvalidation(
          previousAccountId: AccountId('acc-pending'),
        );
        expect(
          AppRouter.resolveAuthRedirect(
            coordinator: coordinator,
            location: '/today',
          ),
          '/session-expired',
        );

        // 4. OS callback URI (io.streakup.app://auth-callback) strips tokens from GoRouter path
        final callbackUri = Uri.parse(
          'io.streakup.app://auth-callback?type=recovery&token_hash=secret_hash_987',
        );
        final redirectedPath = AppRouter.resolveAuthRedirect(
          coordinator: coordinator,
          location: '/auth-callback',
          fullUri: callbackUri,
        );
        expect(redirectedPath, '/password-recovery');
        expect(redirectedPath, isNot(contains('secret_hash_987')));

        gateway.callbackOutcome = const AuthOutcome.success(
          AuthAccountState.signedOut(
            hasValidatedPasswordResetContext: true,
            recoveryEmail: 'user@example.com',
          ),
        );
        await coordinator.handleAuthCallbackUri(callbackUri);
        expect(
          AppRouter.resolveAuthRedirect(
            coordinator: coordinator,
            location: '/sign-in',
          ),
          isNull,
        );
        expect(
          AppRouter.resolveAuthRedirect(
            coordinator: coordinator,
            location: '/today',
          ),
          '/password-recovery/reset',
        );
      },
    );
  });
}
