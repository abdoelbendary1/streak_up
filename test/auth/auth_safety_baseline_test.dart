import '../support/test_app.dart';
import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/core/logging/app_logger.dart';
import 'package:streak_up/app/routing/app_router.dart';
import 'package:streak_up/core/presentation/connectivity/connectivity_cubit.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:streak_up/features/auth/domain/models/auth_models.dart';
import 'package:streak_up/features/shell/presentation/cubit/shell_cubit.dart';
import '../support/fake_auth_repository.dart';

void main() {
  late FakeAuthRepository backend;
  late AuthCubit cubit;
  late ShellCubit shell;
  late ConnectivityCubit status;
  late FeedbackCoordinator feedback;

  setUp(() {
    backend = FakeAuthRepository();
    shell = ShellCubit();
    status = ConnectivityCubit();
    feedback = FeedbackCoordinator(AppLogger());
    cubit = AuthCubit(backend);
  });

  tearDown(() async {
    await cubit.close();
    await backend.controller.close();
    await shell.close();
    await status.close();
    await feedback.close();
  });

  Future<void> signInA() async {
    await cubit.signIn(email: accountA.email, password: 'fixture-password');
  }

  for (final failure in [null, AuthFailure.network]) {
    testWidgets(
      'reauthentication exit follows session routing when failure is $failure',
      (tester) async {
        await tester.runAsync(() async {
          await signInA();
          backend.restoreResult = const Left(AuthFailure.invalidSession);
          await cubit.restore();
        });
        backend.signOutFailure = failure;
        final router = AppRouter(cubit, initialLocation: '/session-expired');
        addTearDown(router.dispose);
        await tester.pumpWidget(
          TestApp(
            shellCubit: shell,
            connectivityCubit: status,
            feedbackCoordinator: feedback,
            authCubit: cubit,
            router: router.router,
          ),
        );
        await tester.pumpAndSettle();
        await tester.runAsync(() async {
          await tester.tap(
            find.byKey(const ValueKey('session_expired_sign_in_button')),
          );
          await Future<void>.delayed(Duration.zero);
        });
        await tester.pumpAndSettle();
        expect(
          router.router.routerDelegate.currentConfiguration.uri.path,
          '/sign-in',
        );
        expect(cubit.state.canAccessProtected, isFalse);
      },
    );
  }

  test(
    'delayed SDK token refresh from A cannot replace B after sign-out and sign-in',
    () async {
      await cubit.restore();
      await signInA();
      expect(await cubit.signOut(), isTrue);
      expect(cubit.state.status, AuthStatus.signedOut);
      backend.signInResult = const Right(accountB);
      await cubit.signIn(email: accountB.email, password: 'fixture-password');
      expect(cubit.state.account?.id, accountB.id);
      backend.event(AuthEventKind.refreshed, session: accountA);
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.account?.id, accountB.id);
    },
  );

  for (final operation in ['registration', 'sign-in', 'callback']) {
    test(
      'verified user without a valid access token cannot authenticate via $operation',
      () async {
        const userOnly = AuthSessionEvidence(
          id: 'user-only',
          email: 'fixture@example.test',
          emailVerified: true,
          accessTokenValid: false,
        );
        switch (operation) {
          case 'registration':
            backend.registration = const Right(
              RegistrationResult(session: userOnly),
            );
            await cubit.register(
              email: userOnly.email,
              password: 'fixture-password',
              confirmPassword: 'fixture-password',
            );
          case 'sign-in':
            backend.signInResult = const Right(userOnly);
            await cubit.signIn(
              email: userOnly.email,
              password: 'fixture-password',
            );
          default:
            backend.event(AuthEventKind.signedIn, session: userOnly);
            await Future<void>.delayed(Duration.zero);
        }
        expect(cubit.state.canAccessProtected, isFalse);
        expect(cubit.state.account, isNull);
      },
    );
  }

  test(
    'remote sign-out failure after local removal stays signed out on restore',
    () async {
      await signInA();
      backend.clearOnFailure = true;
      backend.signOutFailure = AuthFailure.network;
      await cubit.signOut();
      expect(cubit.state.canAccessProtected, isFalse);
      backend.restoreResult = const Right(null);
      await cubit.restore();
      expect(cubit.state.status, AuthStatus.signedOut);
    },
  );

  test(
    'unresolved sign-out cannot silently restore retained session evidence',
    () async {
      await signInA();
      backend.signOutFailure = AuthFailure.storage;
      await cubit.signOut();
      expect(cubit.state.canAccessProtected, isFalse);
      backend.restoreResult = const Left(AuthFailure.storage);
      await cubit.restore();
      expect(cubit.state.canAccessProtected, isFalse);
      expect(cubit.state.account, isNull);
    },
  );

  testWidgets('protected account UI is hidden while sign-out is in progress', (
    tester,
  ) async {
    await tester.runAsync(signInA);
    final appRouter = AppRouter(cubit, initialLocation: '/today');
    addTearDown(appRouter.dispose);
    await tester.pumpWidget(
      TestApp(
        shellCubit: shell,
        connectivityCubit: status,
        feedbackCoordinator: feedback,
        authCubit: cubit,
        router: appRouter.router,
      ),
    );
    await tester.pumpAndSettle();
    final protectedContent = find.byKey(
      const ValueKey<String>('shell_host_today'),
    );
    expect(protectedContent, findsOneWidget);

    backend.signInGate = Completer<void>();
    late Future<bool> exit;
    await tester.runAsync(() async {
      exit = cubit.signOut();
    });
    await tester.pump();
    expect(
      cubit.state.canAccessProtected,
      isFalse,
      reason: 'Protected access must be blocked immediately on signOut.',
    );
    expect(protectedContent, findsNothing);

    await tester.runAsync(() async {
      await exit;
    });
    await tester.pumpAndSettle();

    expect(protectedContent, findsNothing);
    expect(
      appRouter.router.routerDelegate.currentConfiguration.uri.path,
      '/sign-in',
    );
  });

  testWidgets(
    'sign-out clears prior-account navigation before another account signs in',
    (tester) async {
      await tester.runAsync(signInA);
      final appRouter = AppRouter(cubit, initialLocation: '/challenges');
      addTearDown(appRouter.dispose);
      await tester.pumpWidget(
        TestApp(
          shellCubit: shell,
          connectivityCubit: status,
          feedbackCoordinator: feedback,
          authCubit: cubit,
          router: appRouter.router,
        ),
      );
      await tester.pumpAndSettle();
      appRouter.router.push('/profile');
      await tester.pumpAndSettle();
      expect(appRouter.router.canPop(), isTrue);
      await tester.runAsync(() => cubit.signOut());
      await tester.pumpAndSettle();
      backend.signInResult = const Right(accountB);
      await tester.runAsync(
        () => cubit.signIn(email: accountB.email, password: 'fixture-password'),
      );
      await tester.pumpAndSettle();
      expect(
        appRouter.router.routerDelegate.currentConfiguration.uri.path,
        '/today',
      );
      expect(appRouter.router.canPop(), isFalse);
      expect(
        find.byKey(const ValueKey<String>('shell_host_challenges')),
        findsNothing,
      );
    },
  );
}
