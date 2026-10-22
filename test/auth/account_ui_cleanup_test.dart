import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/core/logging/app_logger.dart';
import 'package:streak_up/core/presentation/connectivity/connectivity_cubit.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/core/presentation/feedback/feedback_models.dart';
import 'package:streak_up/features/auth/domain/models/auth_models.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:streak_up/features/shell/presentation/cubit/shell_cubit.dart';

import '../support/fake_auth_repository.dart';
import '../support/test_app.dart';

const _failure = FeedbackDescriptor(
  id: 'account-failure',
  kind: FeedbackKind.recoverableError,
  message: 'Unable to save',
);

void main() {
  late FakeAuthRepository backend;
  late AuthCubit authCubit;
  late ShellCubit shellCubit;
  late ConnectivityCubit connectivityCubit;
  late FeedbackCoordinator feedbackCoordinator;

  setUp(() {
    backend = FakeAuthRepository();
    shellCubit = ShellCubit();
    connectivityCubit = ConnectivityCubit();
    feedbackCoordinator = FeedbackCoordinator(AppLogger());
    authCubit = AuthCubit(backend);
  });

  tearDown(() async {
    await authCubit.close();
    await backend.controller.close();
    await shellCubit.close();
    await connectivityCubit.close();
    await feedbackCoordinator.close();
  });

  Future<void> pumpHarness(WidgetTester tester) async {
    await tester.pumpWidget(
      TestApp(
        shellCubit: shellCubit,
        connectivityCubit: connectivityCubit,
        feedbackCoordinator: feedbackCoordinator,
        authCubit: authCubit,
      ),
    );
    await tester.pumpAndSettle();
  }

  void populateAccountUi() {
    shellCubit.setLocaleOverride(const Locale('ar'));
    feedbackCoordinator.publish(_failure);
  }

  testWidgets(
    'signing out triggers shell and feedback reset, preserving device-level connectivity',
    (tester) async {
      backend.currentSession = accountA;
      await authCubit.restore();

      await pumpHarness(tester);

      populateAccountUi();
      connectivityCubit.setNetworkState(NetworkState.offline);
      await tester.pump();

      expect(shellCubit.state.explicitLocaleOverride, const Locale('ar'));
      expect(feedbackCoordinator.state.activeTransient, isNotNull);
      expect(connectivityCubit.state, NetworkState.offline);

      await authCubit.signOut();
      await tester.pumpAndSettle();

      expect(shellCubit.state.explicitLocaleOverride, isNull);
      expect(feedbackCoordinator.state.activeTransient, isNull);
      expect(connectivityCubit.state, NetworkState.offline);
    },
  );

  testWidgets(
    'account transition from A to B resets shell locale and feedback',
    (tester) async {
      backend.currentSession = accountA;
      await authCubit.restore();

      await pumpHarness(tester);

      populateAccountUi();
      expect(shellCubit.state.explicitLocaleOverride, const Locale('ar'));
      expect(feedbackCoordinator.state.activeTransient, isNotNull);

      // Sign in as Account B
      backend.signInResult = const Right(accountB);
      await authCubit.signIn(email: accountB.email, password: 'password123');
      await tester.pumpAndSettle();

      expect(shellCubit.state.explicitLocaleOverride, isNull);
      expect(feedbackCoordinator.state.activeTransient, isNull);
      expect(authCubit.state.account?.id, accountB.id);
    },
  );

  testWidgets('same account token refresh does not reset shell or feedback', (
    tester,
  ) async {
    backend.currentSession = accountA;
    await authCubit.restore();

    await pumpHarness(tester);

    populateAccountUi();
    expect(shellCubit.state.explicitLocaleOverride, const Locale('ar'));
    expect(feedbackCoordinator.state.activeTransient, isNotNull);

    // Same account refreshed event
    backend.event(AuthEventKind.refreshed, session: accountA);
    await tester.pump();

    expect(shellCubit.state.explicitLocaleOverride, const Locale('ar'));
    expect(feedbackCoordinator.state.activeTransient, isNotNull);
  });
}
