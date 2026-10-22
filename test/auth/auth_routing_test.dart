import '../support/test_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/core/logging/app_logger.dart';
import 'package:streak_up/app/routing/app_router.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/core/presentation/connectivity/connectivity_cubit.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:streak_up/features/shell/presentation/cubit/shell_cubit.dart';
import '../support/fake_auth_repository.dart';

void main() {
  for (final warning in [false, true]) {
    testWidgets(
      warning
          ? 'profile offers sign-out only and preserves warning cancel and confirmation'
          : 'restoring blocks shell and sign-in restores the sanitized initial destination',
      (tester) async {
        final backend = FakeAuthRepository();
        final cubit = AuthCubit(backend);
        final shell = ShellCubit();
        final status = ConnectivityCubit();
        final feedback = FeedbackCoordinator(AppLogger());
        final appRouter = AppRouter(
          cubit,
          initialLocation: warning ? '/profile' : '/challenges',
        );
        addTearDown(() async {
          appRouter.dispose();
          await cubit.close();
          await backend.controller.close();
          await shell.close();
          await status.close();
          await feedback.close();
        });
        await tester.pumpWidget(
          TestApp(
            shellCubit: shell,
            connectivityCubit: status,
            feedbackCoordinator: feedback,
            authCubit: cubit,
            router: appRouter.router,
          ),
        );
        await tester.pump();
        expect(
          appRouter.router.routerDelegate.currentConfiguration.uri.path,
          '/restoring',
        );
        expect(
          find.byKey(const ValueKey<String>('shell_host_challenges')),
          findsNothing,
        );
        await tester.runAsync(cubit.restore);
        await tester.pumpAndSettle();
        expect(
          appRouter.router.routerDelegate.currentConfiguration.uri.path,
          '/sign-in',
        );
        await tester.runAsync(
          () =>
              cubit.signIn(email: accountA.email, password: 'fixture-password'),
        );
        await tester.pumpAndSettle();
        expect(
          appRouter.router.routerDelegate.currentConfiguration.uri.path,
          warning ? '/profile' : '/challenges',
        );
        if (warning) {
          expect(
            find.byKey(const ValueKey<String>('profile_switch_account_button')),
            findsNothing,
          );
          await tester.tap(
            find.byKey(const ValueKey<String>('profile_sign_out_button')),
          );
          await tester.pumpAndSettle();
          expect(cubit.state.canAccessProtected, isTrue);
          await tester.tap(
            find.byKey(const ValueKey<String>('sign_out_warning_stay_button')),
          );
          await tester.pumpAndSettle();
          expect(cubit.state.canAccessProtected, isTrue);
          await tester.tap(
            find.byKey(const ValueKey<String>('profile_sign_out_button')),
          );
          await tester.pumpAndSettle();
          await tester.runAsync(
            () => tester.tap(
              find.byKey(
                const ValueKey<String>('sign_out_warning_confirm_button'),
              ),
            ),
          );
          await tester.runAsync(() => Future<void>.delayed(Duration.zero));
          await tester.pumpAndSettle();
          expect(cubit.state.canAccessProtected, isFalse);
          expect(
            appRouter.router.routerDelegate.currentConfiguration.uri.path,
            '/sign-in',
          );
        }
      },
    );
  }
  test(
    'redirect matrix blocks unverified and invalidated sessions and unvalidated recovery',
    () {
      expect(
        AppRouter.resolveAuthRedirect(
          const AuthState(status: AuthStatus.verificationRequired),
          '/today',
        ),
        '/verify-email',
      );
      expect(
        AppRouter.resolveAuthRedirect(
          const AuthState(status: AuthStatus.reauthenticationRequired),
          '/today',
        ),
        '/session-expired',
      );
      expect(
        AppRouter.resolveAuthRedirect(
          const AuthState(status: AuthStatus.signedOut),
          '/password-recovery/reset',
        ),
        '/password-recovery',
      );
    },
  );
}
