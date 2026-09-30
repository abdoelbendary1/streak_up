import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:streak_up/app/bootstrap/app_logger.dart';
import 'package:streak_up/core/presentation/status/status_models.dart';
import 'package:streak_up/features/auth/domain/auth_gateway.dart';
import 'package:streak_up/features/auth/domain/auth_models.dart';
import 'package:streak_up/features/auth/domain/pending_work_presence.dart';

/// Type of voluntary account boundary exit awaiting user confirmation (`T018`, `SL02-FR-008`–`009`).
enum PendingExitKind { signOut, switchAccount }

/// Prompt state when voluntary sign-out or account switch detects `pending` or `unknown` local work (`T018`).
@immutable
class PendingAccountExitPrompt {
  const PendingAccountExitPrompt({
    required this.kind,
    required this.presence,
    required this.accountId,
    this.nextEmail,
  });

  final PendingExitKind kind;
  final PendingWorkPresence presence;
  final AccountId accountId;
  final String? nextEmail;
}

/// Snapshot emitted by [AuthSessionCoordinator] (`T014`–`T018`).
@immutable
class AuthCoordinatorSnapshot {
  const AuthCoordinatorSnapshot({
    this.accountState = const AuthAccountState.restoring(),
    this.connectionCondition = AuthConnectionCondition.normal,
    this.transitionEpoch = 0,
    this.savedProtectedLocation,
    this.activeExitPrompt,
    this.lastRecoveryReceipt,
    this.lastCallbackFailure,
    this.discardedStaleCallbackCount = 0,
  });

  final AuthAccountState accountState;
  final AuthConnectionCondition connectionCondition;
  final int transitionEpoch;
  final String? savedProtectedLocation;
  final PendingAccountExitPrompt? activeExitPrompt;
  final PasswordRecoveryRequestReceipt? lastRecoveryReceipt;
  final AuthFailure? lastCallbackFailure;
  final int discardedStaleCallbackCount;

  AccountId? get activeAccountId => accountState.activeAccountId;

  AuthCoordinatorSnapshot copyWith({
    AuthAccountState? accountState,
    AuthConnectionCondition? connectionCondition,
    int? transitionEpoch,
    String? savedProtectedLocation,
    bool clearSavedProtectedLocation = false,
    PendingAccountExitPrompt? activeExitPrompt,
    bool clearActiveExitPrompt = false,
    PasswordRecoveryRequestReceipt? lastRecoveryReceipt,
    bool clearLastRecoveryReceipt = false,
    AuthFailure? lastCallbackFailure,
    bool clearLastCallbackFailure = false,
    int? discardedStaleCallbackCount,
  }) {
    return AuthCoordinatorSnapshot(
      accountState: accountState ?? this.accountState,
      connectionCondition: connectionCondition ?? this.connectionCondition,
      transitionEpoch: transitionEpoch ?? this.transitionEpoch,
      savedProtectedLocation: clearSavedProtectedLocation
          ? null
          : (savedProtectedLocation ?? this.savedProtectedLocation),
      activeExitPrompt: clearActiveExitPrompt
          ? null
          : (activeExitPrompt ?? this.activeExitPrompt),
      lastRecoveryReceipt: clearLastRecoveryReceipt
          ? null
          : (lastRecoveryReceipt ?? this.lastRecoveryReceipt),
      lastCallbackFailure: clearLastCallbackFailure
          ? null
          : (lastCallbackFailure ?? this.lastCallbackFailure),
      discardedStaleCallbackCount:
          discardedStaleCallbackCount ?? this.discardedStaleCallbackCount,
    );
  }
}

/// Application coordinator owning account session state, monotonic transition epochs,
/// serialized account switches, and stale-callback isolation (`T014`–`T018`, `SL02-FR-006`–`011`).
@lazySingleton
class AuthSessionCoordinator extends ChangeNotifier {
  AuthSessionCoordinator(
    this._gateway,
    this._pendingWorkProvider,
    this._scopeLifecycle,
    this._statusCubit,
    this._logger,
  ) {
    _gatewaySubscription = _gateway.signals.listen(_onGatewaySignal);
  }

  final AuthGateway _gateway;
  final PendingWorkPresenceProvider _pendingWorkProvider;
  final AccountScopeLifecycle _scopeLifecycle;
  final ShellStatusCubit _statusCubit;
  final AppLogger _logger;

  AuthCoordinatorSnapshot _snapshot = const AuthCoordinatorSnapshot();
  AuthCoordinatorSnapshot get snapshot => _snapshot;

  final StreamController<AuthCoordinatorSnapshot> _streamController =
      StreamController<AuthCoordinatorSnapshot>.broadcast();
  Stream<AuthCoordinatorSnapshot> get stream => _streamController.stream;

  StreamSubscription<AuthGatewaySignal>? _gatewaySubscription;

  /// Single-flight tail future ensuring account transitions never interleave (`T015`).
  Future<void>? _transitionTail;
  // Kept outside emitted snapshots and cleared whenever the prompt ends.
  String? _pendingSwitchPassword;

  static const Set<String> _allowedSavedRoutePrefixes = <String>{
    '/today',
    '/habits',
    '/challenges',
    '/friends',
    '/inbox',
    '/profile',
    '/sync-recovery',
  };

  /// Restores the initial session at startup while keeping the app in `restoring`
  /// until verification completes (`T014`, `SL02-FR-006`).
  Future<AuthCoordinatorSnapshot> restoreInitialSession() {
    return _enqueueTransition(() async {
      final (restoredState, condition) = await _gateway.restoreInitialSession();
      await _applyAccountStateTransition(
        nextState: restoredState,
        connectionCondition: condition,
        clearSavedDestination: false,
      );
      return _snapshot;
    });
  }

  /// Records a single sanitized internal protected route when an unauthenticated or
  /// expired session intercepts navigation (`T023`, `SL02-FR-012`).
  void recordIntendedProtectedDestination(String? candidateLocation) {
    final sanitized = sanitizeProtectedRoute(candidateLocation);
    if (sanitized == null || _snapshot.savedProtectedLocation == sanitized) {
      return;
    }
    // Mutate snapshot without calling notifyListeners() so GoRouter redirect evaluation does not re-trigger itself.
    _snapshot = _snapshot.copyWith(savedProtectedLocation: sanitized);
    if (!_streamController.isClosed) {
      _streamController.add(_snapshot);
    }
  }

  /// Consumes the saved protected destination after successful authentication for the same account (`T023`).
  String consumePostAuthenticationDestination() {
    final saved = _snapshot.savedProtectedLocation;
    if (saved != null) {
      _snapshot = _snapshot.copyWith(clearSavedProtectedLocation: true);
      if (!_streamController.isClosed) {
        _streamController.add(_snapshot);
      }
      return saved;
    }
    return '/today';
  }

  /// Sanitizes a candidate route path so only internal protected shell/global routes
  /// can be restored; external URLs and auth routes are rejected (`T023`).
  static String? sanitizeProtectedRoute(String? rawLocation) {
    if (rawLocation == null || rawLocation.trim().isEmpty) {
      return null;
    }
    final uri = Uri.tryParse(rawLocation.trim());
    if (uri == null || uri.hasScheme || uri.hasAuthority) {
      return null;
    }
    final path = uri.path;
    if (!path.startsWith('/') || path.startsWith('//')) {
      return null;
    }
    final isAllowed = _allowedSavedRoutePrefixes.any(
      (prefix) => path == prefix || path.startsWith('$prefix/'),
    );
    return isAllowed ? path : null;
  }

  /// Evaluates whether an async callback belongs to the currently active account
  /// and transition epoch (`T016`, `SL02-FR-010`).
  bool isCurrentScope({
    required int capturedEpoch,
    required AccountId? capturedAccountId,
  }) {
    if (capturedEpoch != _snapshot.transitionEpoch) {
      return false;
    }
    if (capturedAccountId != _snapshot.activeAccountId) {
      return false;
    }
    return true;
  }

  /// Executes [apply] only if [capturedEpoch] and [capturedAccountId] still match
  /// the active account session; otherwise discards the stale result (`T016`).
  Future<bool> runIfScopeActive({
    required int capturedEpoch,
    required AccountId? capturedAccountId,
    required FutureOr<void> Function() apply,
  }) async {
    if (!isCurrentScope(
      capturedEpoch: capturedEpoch,
      capturedAccountId: capturedAccountId,
    )) {
      final nextCount = _snapshot.discardedStaleCallbackCount + 1;
      _logger.info(
        'auth.stale_callback.discarded',
        metadata: <String, Object?>{'count': nextCount},
      );
      _emit(_snapshot.copyWith(discardedStaleCallbackCount: nextCount));
      return false;
    }
    await apply();
    return true;
  }

  Future<AuthOutcome<AuthAccountState>> register({
    required String email,
    required String password,
  }) {
    return _enqueueTransition(() async {
      final outcome = await _gateway.registerWithEmailPassword(
        email: email,
        password: password,
      );
      if (outcome is AuthSuccess<AuthAccountState>) {
        await _applyAccountStateTransition(
          nextState: outcome.value,
          connectionCondition: AuthConnectionCondition.normal,
          clearSavedDestination: false,
        );
      }
      return outcome;
    });
  }

  Future<AuthOutcome<AuthAccountState>> signIn({
    required String email,
    required String password,
    bool forceSwitchAfterWarning = false,
  }) {
    return _enqueueTransition(() async {
      cancelPendingExitPrompt();
      final currentAccountId = _snapshot.activeAccountId;
      // If an authenticated session is already active, treat signing into another
      // account as an account switch and inspect PendingWorkPresence first (`T018`, `SL02-FR-009`).
      if (currentAccountId != null && !forceSwitchAfterWarning) {
        final presence = await _pendingWorkProvider.checkPendingWork(
          currentAccountId,
        );
        if (presence.requiresRetentionWarning) {
          _pendingSwitchPassword = password;
          _emit(
            _snapshot.copyWith(
              activeExitPrompt: PendingAccountExitPrompt(
                kind: PendingExitKind.switchAccount,
                presence: presence,
                accountId: currentAccountId,
                nextEmail: email,
              ),
            ),
          );
          return AuthOutcome.success(_snapshot.accountState);
        }
      }

      final outcome = await _gateway.signInWithEmailPassword(
        email: email,
        password: password,
      );
      if (outcome is AuthSuccess<AuthAccountState>) {
        final nextAccountId = outcome.value.activeAccountId;
        final isDifferentAccount =
            currentAccountId != null &&
            nextAccountId != null &&
            currentAccountId != nextAccountId;
        final isDifferentFromReauthAccount = switch (_snapshot.accountState) {
          AuthReauthenticationRequiredState(:final previousAccountId) =>
            previousAccountId != null &&
                nextAccountId != null &&
                previousAccountId != nextAccountId,
          _ => false,
        };
        await _applyAccountStateTransition(
          nextState: outcome.value,
          connectionCondition: AuthConnectionCondition.normal,
          clearSavedDestination:
              isDifferentAccount || isDifferentFromReauthAccount,
        );
      }
      return outcome;
    });
  }

  Future<AuthOutcome<AuthAccountState>> checkEmailVerification({
    String? email,
  }) {
    final resolvedEmail =
        email ??
        switch (_snapshot.accountState) {
          AuthVerificationRequiredState(:final email) => email,
          _ => '',
        };
    return _enqueueTransition(() async {
      final outcome = await _gateway.checkEmailVerificationStatus(
        email: resolvedEmail,
      );
      if (outcome is AuthSuccess<AuthAccountState>) {
        await _applyAccountStateTransition(
          nextState: outcome.value,
          connectionCondition: AuthConnectionCondition.normal,
          clearSavedDestination: false,
        );
      }
      return outcome;
    });
  }

  Future<AuthOutcome<void>> resendVerificationEmail({String? email}) {
    final resolvedEmail =
        email ??
        switch (_snapshot.accountState) {
          AuthVerificationRequiredState(:final email) => email,
          _ => '',
        };
    return _gateway.resendVerificationEmail(email: resolvedEmail);
  }

  Future<AuthOutcome<PasswordRecoveryRequestReceipt>> requestPasswordRecovery({
    required String email,
  }) async {
    final outcome = await _gateway.requestPasswordRecovery(email: email);
    if (outcome is AuthSuccess<PasswordRecoveryRequestReceipt>) {
      _emit(_snapshot.copyWith(lastRecoveryReceipt: outcome.value));
    }
    return outcome;
  }

  Future<AuthOutcome<AuthAccountState>> handleAuthCallbackUri(Uri uri) {
    return _enqueueTransition(() async {
      final outcome = await _gateway.ingestAuthCallbackUri(uri);
      switch (outcome) {
        case AuthSuccess<AuthAccountState>(:final value):
          await _applyAccountStateTransition(
            nextState: value,
            connectionCondition: AuthConnectionCondition.normal,
            clearSavedDestination: false,
          );
        case AuthFailureOutcome<AuthAccountState>(:final failure):
          _emit(_snapshot.copyWith(lastCallbackFailure: failure));
      }
      return outcome;
    });
  }

  Future<AuthOutcome<AuthAccountState>> submitRecoveredPassword({
    required String newPassword,
  }) {
    return _enqueueTransition(() async {
      final outcome = await _gateway.submitNewPassword(
        newPassword: newPassword,
      );
      if (outcome is AuthSuccess<AuthAccountState>) {
        await _applyAccountStateTransition(
          nextState: outcome.value,
          connectionCondition: AuthConnectionCondition.normal,
          clearSavedDestination: false,
        );
      }
      return outcome;
    });
  }

  /// Requests voluntary sign-out (`T018`, `SL02-FR-008`).
  ///
  /// When [PendingWorkPresence] is `pending` or `unknown`, surfaces a retention
  /// warning prompt before tearing down the account session unless [forceAfterWarning] is true.
  Future<bool> requestSignOut({bool forceAfterWarning = false}) {
    return _enqueueTransition(() async {
      cancelPendingExitPrompt();
      final currentAccountId = _snapshot.activeAccountId;
      if (currentAccountId != null && !forceAfterWarning) {
        final presence = await _pendingWorkProvider.checkPendingWork(
          currentAccountId,
        );
        if (presence.requiresRetentionWarning) {
          _pendingSwitchPassword = null;
          _emit(
            _snapshot.copyWith(
              activeExitPrompt: PendingAccountExitPrompt(
                kind: PendingExitKind.signOut,
                presence: presence,
                accountId: currentAccountId,
              ),
            ),
          );
          return false;
        }
      }

      await _gateway.signOut();
      await _applyAccountStateTransition(
        nextState: const AuthAccountState.signedOut(),
        connectionCondition: AuthConnectionCondition.normal,
        clearSavedDestination: true,
      );
      return true;
    });
  }

  /// Requests switching from the active account to another account (`T018`, `SL02-FR-009`).
  Future<bool> requestAccountSwitch({
    bool forceAfterWarning = false,
    String? nextEmail,
    String? nextPassword,
  }) {
    return _enqueueTransition(() async {
      cancelPendingExitPrompt();
      final currentAccountId = _snapshot.activeAccountId;
      if (currentAccountId != null && !forceAfterWarning) {
        final presence = await _pendingWorkProvider.checkPendingWork(
          currentAccountId,
        );
        if (presence.requiresRetentionWarning) {
          _pendingSwitchPassword = nextPassword;
          _emit(
            _snapshot.copyWith(
              activeExitPrompt: PendingAccountExitPrompt(
                kind: PendingExitKind.switchAccount,
                presence: presence,
                accountId: currentAccountId,
                nextEmail: nextEmail,
              ),
            ),
          );
          return false;
        }
      }

      if (nextEmail != null && nextPassword != null) {
        await _gateway.signOut();
        final signInOutcome = await _gateway.signInWithEmailPassword(
          email: nextEmail,
          password: nextPassword,
        );
        if (signInOutcome is AuthSuccess<AuthAccountState>) {
          await _applyAccountStateTransition(
            nextState: signInOutcome.value,
            connectionCondition: AuthConnectionCondition.normal,
            clearSavedDestination: true,
          );
          return true;
        }
      }

      await _gateway.signOut();
      await _applyAccountStateTransition(
        nextState: const AuthAccountState.signedOut(),
        connectionCondition: AuthConnectionCondition.normal,
        clearSavedDestination: true,
      );
      return true;
    });
  }

  /// Cancels a pending sign-out or switch warning (`Stay Signed In` / `Stay on This Account`).
  void cancelPendingExitPrompt() {
    _pendingSwitchPassword = null;
    if (_snapshot.activeExitPrompt != null) {
      _emit(_snapshot.copyWith(clearActiveExitPrompt: true));
    }
  }

  /// Confirms a pending sign-out or switch warning (`Sign Out Anyway` / `Switch Anyway`).
  Future<void> confirmPendingExitPrompt() async {
    final prompt = _snapshot.activeExitPrompt;
    if (prompt == null) {
      return;
    }
    final nextPassword = _pendingSwitchPassword;
    _pendingSwitchPassword = null;
    _emit(_snapshot.copyWith(clearActiveExitPrompt: true));
    switch (prompt.kind) {
      case PendingExitKind.signOut:
        await requestSignOut(forceAfterWarning: true);
      case PendingExitKind.switchAccount:
        await requestAccountSwitch(
          forceAfterWarning: true,
          nextEmail: prompt.nextEmail,
          nextPassword: nextPassword,
        );
    }
  }

  /// Transitions the active session into `reauthenticationRequired` when remote
  /// token invalidation is confirmed (`T014`, `SL02-FR-007`).
  Future<void> handleConfirmedSessionInvalidation({
    AccountId? previousAccountId,
    String? emailHint,
  }) {
    return _enqueueTransition(() async {
      await _applyAccountStateTransition(
        nextState: AuthAccountState.reauthenticationRequired(
          previousAccountId: previousAccountId ?? _snapshot.activeAccountId,
          emailHint: emailHint,
        ),
        connectionCondition: AuthConnectionCondition.normal,
        clearSavedDestination: false,
      );
    });
  }

  void _onGatewaySignal(AuthGatewaySignal signal) {
    switch (signal) {
      case AuthGatewayStateChangedSignal(
        :final accountState,
        :final connectionCondition,
      ):
        _enqueueTransition(() async {
          await _applyAccountStateTransition(
            nextState: accountState,
            connectionCondition: connectionCondition,
            clearSavedDestination: false,
          );
        });
      case AuthGatewayPasswordRecoveryReadySignal(:final email):
        _enqueueTransition(() async {
          final current = _snapshot.accountState;
          final next = switch (current) {
            AuthAuthenticatedState(:final session) =>
              AuthAccountState.authenticated(
                session: session,
                hasValidatedPasswordResetContext: true,
              ),
            _ => AuthAccountState.signedOut(
              hasValidatedPasswordResetContext: true,
              recoveryEmail: email,
            ),
          };
          await _applyAccountStateTransition(
            nextState: next,
            connectionCondition: _snapshot.connectionCondition,
            clearSavedDestination: false,
          );
        });
    }
  }

  Future<void> _applyAccountStateTransition({
    required AuthAccountState nextState,
    required AuthConnectionCondition connectionCondition,
    required bool clearSavedDestination,
  }) async {
    _pendingSwitchPassword = null;
    final previousAccountId = _snapshot.activeAccountId;
    final nextAccountId = nextState.activeAccountId;
    final accountBoundaryChanged = previousAccountId != nextAccountId;
    final statusChanged = _snapshot.accountState.status != nextState.status;

    final nextEpoch = (accountBoundaryChanged || statusChanged)
        ? _snapshot.transitionEpoch + 1
        : _snapshot.transitionEpoch;

    // Tear down previous account scope before activating any new scope or signed-out state (`T017`).
    if (accountBoundaryChanged ||
        nextState is AuthSignedOutState ||
        nextState is AuthReauthenticationRequiredState) {
      await _scopeLifecycle.deactivateAccountScope(
        previousAccountId: previousAccountId,
        transitionEpoch: nextEpoch,
      );
    }

    if (nextAccountId != null) {
      await _scopeLifecycle.activateAccountScope(
        accountId: nextAccountId,
        transitionEpoch: nextEpoch,
      );
    }

    // Reflect connection/session status in the shared SL-01 shell status model without
    // conflating offline connectivity with session invalidation (`SL02-FR-006`–`007`).
    if (nextState is AuthReauthenticationRequiredState) {
      _statusCubit.setNetworkState(
        NetworkState.syncFailed,
        issueCause: ConnectivityIssueCause.authSessionActionRequired,
      );
    } else if (connectionCondition ==
        AuthConnectionCondition.offlineOrBackendUnreachable) {
      _statusCubit.setNetworkState(
        NetworkState.offline,
        issueCause: ConnectivityIssueCause.transportOffline,
      );
    }

    _logger.info(
      'auth.session.transition',
      metadata: <String, Object?>{
        'nextStateType': nextState.status.name,
        'count': nextEpoch,
      },
    );

    _emit(
      _snapshot.copyWith(
        accountState: nextState,
        connectionCondition: connectionCondition,
        transitionEpoch: nextEpoch,
        clearSavedProtectedLocation: clearSavedDestination,
        clearActiveExitPrompt: true,
        clearLastCallbackFailure: true,
      ),
    );
  }

  Future<T> _enqueueTransition<T>(Future<T> Function() operation) {
    final completer = Completer<T>();
    final previous = _transitionTail;
    Future<void> runOperation() async {
      try {
        final result = await operation();
        completer.complete(result);
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    }

    _transitionTail = previous == null
        ? Future<void>.microtask(runOperation)
        : previous.then((_) => runOperation());
    return completer.future;
  }

  void _emit(AuthCoordinatorSnapshot next) {
    _snapshot = next;
    if (!_streamController.isClosed) {
      _streamController.add(next);
    }
    notifyListeners();
  }

  @override
  @disposeMethod
  void dispose() {
    _pendingSwitchPassword = null;
    _gatewaySubscription?.cancel();
    _streamController.close();
    super.dispose();
  }
}
