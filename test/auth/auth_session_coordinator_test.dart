import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/app/bootstrap/app_logger.dart';
import 'package:streak_up/app/routing/shell_destination.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/core/presentation/feedback/feedback_models.dart';
import 'package:streak_up/core/presentation/status/status_models.dart';
import 'package:streak_up/features/auth/application/auth_session_coordinator.dart';
import 'package:streak_up/features/auth/domain/auth_gateway.dart';
import 'package:streak_up/features/auth/domain/auth_models.dart';
import 'package:streak_up/features/auth/domain/pending_work_presence.dart';
import 'package:streak_up/features/shell/presentation/shell_cubit.dart';

class FakeAuthGateway implements AuthGateway {
  final StreamController<AuthGatewaySignal> signalController =
      StreamController<AuthGatewaySignal>.broadcast();

  AuthAccountState restoreState = const AuthAccountState.signedOut();
  AuthOutcome<AuthAccountState> callbackOutcome = const AuthOutcome.success(
    AuthAccountState.signedOut(),
  );
  AuthConnectionCondition restoreCondition = AuthConnectionCondition.normal;

  Map<String, AuthOutcome<AuthAccountState>> signInResponses =
      <String, AuthOutcome<AuthAccountState>>{};

  int signOutCount = 0;

  @override
  Stream<AuthGatewaySignal> get signals => signalController.stream;

  @override
  Future<(AuthAccountState, AuthConnectionCondition)>
  restoreInitialSession() async => (restoreState, restoreCondition);

  @override
  Future<AuthOutcome<AuthAccountState>> registerWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return AuthOutcome.success(
      AuthAccountState.verificationRequired(email: email),
    );
  }

  @override
  Future<AuthOutcome<AuthAccountState>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final mapped = signInResponses[email];
    if (mapped != null) return mapped;
    return AuthOutcome.success(
      AuthAccountState.authenticated(
        session: VerifiedAccountSession(
          accountId: AccountId('acc-$email'),
          email: email,
          verifiedAt: DateTime.utc(2026, 9, 29),
          evidenceSource: SessionEvidenceSource.remoteSessionVerified,
        ),
      ),
    );
  }

  @override
  Future<AuthOutcome<AuthAccountState>> checkEmailVerificationStatus({
    required String email,
  }) async {
    return AuthOutcome.success(
      AuthAccountState.authenticated(
        session: VerifiedAccountSession(
          accountId: AccountId('acc-$email'),
          email: email,
          verifiedAt: DateTime.utc(2026, 9, 29),
          evidenceSource: SessionEvidenceSource.remoteSessionVerified,
        ),
      ),
    );
  }

  @override
  Future<AuthOutcome<void>> resendVerificationEmail({
    required String email,
  }) async => const AuthOutcome.success(null);

  @override
  Future<AuthOutcome<PasswordRecoveryRequestReceipt>> requestPasswordRecovery({
    required String email,
  }) async => AuthOutcome.success(
    PasswordRecoveryRequestReceipt(submittedEmail: email),
  );

  @override
  Future<AuthOutcome<AuthAccountState>> ingestAuthCallbackUri(
    Uri callbackUri,
  ) async => callbackOutcome;

  @override
  Future<AuthOutcome<AuthAccountState>> submitNewPassword({
    required String newPassword,
  }) async => const AuthOutcome.success(AuthAccountState.signedOut());

  @override
  Future<AuthOutcome<void>> signOut() async {
    signOutCount++;
    return const AuthOutcome.success(null);
  }

  @override
  Future<void> dispose() async {
    await signalController.close();
  }
}

class ConfigurablePendingWorkPresenceProvider
    implements PendingWorkPresenceProvider {
  PendingWorkPresence presence = PendingWorkPresence.unknown;

  @override
  Future<PendingWorkPresence> checkPendingWork(AccountId accountId) async =>
      presence;
}

void main() {
  group('AuthSessionCoordinator Account Isolation & Epochs (T020)', () {
    late FakeAuthGateway gateway;
    late ConfigurablePendingWorkPresenceProvider pendingProvider;
    late ShellCubit shellCubit;
    late ShellStatusCubit statusCubit;
    late FeedbackCoordinator feedbackCoordinator;
    late ShellAccountScopeLifecycle scopeLifecycle;
    late AuthSessionCoordinator coordinator;

    setUp(() {
      final logger = RedactedAppLogger();
      gateway = FakeAuthGateway();
      pendingProvider = ConfigurablePendingWorkPresenceProvider();
      shellCubit = ShellCubit();
      statusCubit = ShellStatusCubit();
      feedbackCoordinator = FeedbackCoordinator(logger);
      scopeLifecycle = ShellAccountScopeLifecycle(
        shellCubit,
        statusCubit,
        feedbackCoordinator,
      );
      coordinator = AuthSessionCoordinator(
        gateway,
        pendingProvider,
        scopeLifecycle,
        statusCubit,
        logger,
      );
    });

    tearDown(() {
      coordinator.dispose();
    });

    test(
      'Account A -> Sign Out -> Account B -> Account A resets shell, status, feedback, and saved routes while incrementing monotonic epochs',
      () async {
        pendingProvider.presence = PendingWorkPresence.none;

        // 1. Sign in as Account A
        await coordinator.signIn(email: 'a@example.com', password: 'password1');
        final epochA1 = coordinator.snapshot.transitionEpoch;
        expect(
          coordinator.snapshot.activeAccountId,
          AccountId('acc-a@example.com'),
        );
        expect(scopeLifecycle.activeAccountId, AccountId('acc-a@example.com'));

        // Mutate Account A shell, status, feedback, and saved route state
        shellCubit.syncDestinationFromRoute(ShellDestination.challenges);
        shellCubit.setLocaleOverride(const Locale('ar'));
        statusCubit.upsertActionStatus(
          const ActionStatusProjection(
            actionKey: 'act-1',
            actionLabel: 'Action 1',
            isCompletedLocally: true,
            remoteSyncStatus: ActionSyncStatus.pending,
          ),
        );
        feedbackCoordinator.publish(
          const FeedbackDescriptor(
            id: 'banner-a',
            kind: FeedbackKind.warning,
            lifetime: FeedbackLifetime.persistent,
            messageKey: FeedbackMessageKey.localSavePending,
          ),
        );
        coordinator.recordIntendedProtectedDestination('/challenges');
        expect(coordinator.snapshot.savedProtectedLocation, '/challenges');

        // 2. Voluntary sign out from Account A
        final signedOut = await coordinator.requestSignOut();
        expect(signedOut, isTrue);
        expect(coordinator.snapshot.accountState, isA<AuthSignedOutState>());
        expect(coordinator.snapshot.transitionEpoch, greaterThan(epochA1));
        expect(coordinator.snapshot.savedProtectedLocation, isNull);
        expect(shellCubit.state.selectedDestination, ShellDestination.today);
        expect(shellCubit.state.explicitLocaleOverride, isNull);
        expect(statusCubit.state.actions, isEmpty);
        expect(feedbackCoordinator.state.persistentBanners, isEmpty);

        // 3. Sign in as Account B
        await coordinator.signIn(email: 'b@example.com', password: 'password2');
        final epochB = coordinator.snapshot.transitionEpoch;
        expect(
          coordinator.snapshot.activeAccountId,
          AccountId('acc-b@example.com'),
        );
        expect(scopeLifecycle.activeAccountId, AccountId('acc-b@example.com'));
        expect(epochB, greaterThan(epochA1 + 1));

        // 4. Switch back to Account A
        await coordinator.requestAccountSwitch(
          forceAfterWarning: true,
          nextEmail: 'a@example.com',
          nextPassword: 'password1',
        );
        expect(
          coordinator.snapshot.activeAccountId,
          AccountId('acc-a@example.com'),
        );
        expect(coordinator.snapshot.transitionEpoch, greaterThan(epochB));
      },
    );

    test(
      'stale async callbacks from prior transitionEpoch or mismatched AccountId are discarded without mutating state',
      () async {
        pendingProvider.presence = PendingWorkPresence.none;
        await coordinator.signIn(email: 'a@example.com', password: 'password1');
        final capturedEpochA = coordinator.snapshot.transitionEpoch;
        final capturedAccountA = coordinator.snapshot.activeAccountId;

        // Switch to Account B
        await coordinator.requestAccountSwitch(
          forceAfterWarning: true,
          nextEmail: 'b@example.com',
          nextPassword: 'password2',
        );

        var sideEffectExecuted = false;
        final applied = await coordinator.runIfScopeActive(
          capturedEpoch: capturedEpochA,
          capturedAccountId: capturedAccountA,
          apply: () {
            sideEffectExecuted = true;
          },
        );

        expect(applied, isFalse);
        expect(sideEffectExecuted, isFalse);
        expect(coordinator.snapshot.discardedStaleCallbackCount, 1);
      },
    );

    test(
      'voluntary sign-out and account switch trigger retention warning when PendingWorkPresence is pending or unknown, and bypass when none',
      () async {
        await coordinator.signIn(email: 'a@example.com', password: 'password1');

        // Case 1: unknown (SL-02 runtime default) -> requires warning
        pendingProvider.presence = PendingWorkPresence.unknown;
        final didSignOutImmediately = await coordinator.requestSignOut();
        expect(didSignOutImmediately, isFalse);
        expect(
          coordinator.snapshot.activeExitPrompt?.kind,
          PendingExitKind.signOut,
        );

        // Cancel warning -> stays signed in as Account A
        coordinator.cancelPendingExitPrompt();
        expect(coordinator.snapshot.activeExitPrompt, isNull);
        expect(
          coordinator.snapshot.activeAccountId,
          AccountId('acc-a@example.com'),
        );

        // Case 2: pending -> requires warning for account switch
        pendingProvider.presence = PendingWorkPresence.pending;
        final didSwitchImmediately = await coordinator.requestAccountSwitch(
          nextEmail: 'b@example.com',
          nextPassword: 'password2',
        );
        expect(didSwitchImmediately, isFalse);
        expect(
          coordinator.snapshot.activeExitPrompt?.kind,
          PendingExitKind.switchAccount,
        );

        // Confirm warning -> completes switch to Account B
        await coordinator.confirmPendingExitPrompt();
        expect(
          coordinator.snapshot.activeAccountId,
          AccountId('acc-b@example.com'),
        );
      },
    );
  });
}
