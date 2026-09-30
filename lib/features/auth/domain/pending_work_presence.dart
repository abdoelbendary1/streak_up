import 'package:injectable/injectable.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/core/presentation/status/status_models.dart';
import 'package:streak_up/features/auth/domain/auth_models.dart';
import 'package:streak_up/features/shell/presentation/shell_cubit.dart';

/// Narrow presence indicator for unsynced local work (`T007`, `SL02-FR-008`, `SL02-FR-009`).
///
/// Kept intentionally free of Isar/outbox schema details until SL-03.
enum PendingWorkPresence {
  pending,
  none,
  unknown;

  /// Both confirmed `pending` work and `unknown` inspection state conservatively
  /// require presenting the retention warning before voluntary sign-out or switch (`T007`, `T018`).
  bool get requiresRetentionWarning =>
      this == PendingWorkPresence.pending ||
      this == PendingWorkPresence.unknown;
}

/// Narrow contract for inspecting whether an account has unsynced local changes (`T007`).
abstract interface class PendingWorkPresenceProvider {
  Future<PendingWorkPresence> checkPendingWork(AccountId accountId);
}

/// Default SL-02 runtime provider returning [PendingWorkPresence.unknown] until SL-03
/// introduces the local outbox (`T007`).
@LazySingleton(as: PendingWorkPresenceProvider)
class DefaultPendingWorkPresenceProvider
    implements PendingWorkPresenceProvider {
  const DefaultPendingWorkPresenceProvider();

  @override
  Future<PendingWorkPresence> checkPendingWork(AccountId accountId) async {
    return PendingWorkPresence.unknown;
  }
}

/// Lifecycle hook executed during serialized account transitions (`T007`, `T017`, `SL02-FR-008`–`011`).
abstract interface class AccountScopeLifecycle {
  AccountId? get activeAccountId;
  int get activeTransitionEpoch;

  /// Tears down and resets all account-bound presentation/application state for
  /// [previousAccountId] before any new account or signed-out route renders.
  Future<void> deactivateAccountScope({
    AccountId? previousAccountId,
    required int transitionEpoch,
  });

  /// Binds the newly verified [accountId] at [transitionEpoch] after prior scope cleanup completes.
  Future<void> activateAccountScope({
    required AccountId accountId,
    required int transitionEpoch,
  });
}

/// Default SL-02 account scope lifecycle implementation (`T017`).
///
/// Resets [ShellCubit], [ShellStatusCubit], and [FeedbackCoordinator] before
/// activating a new account so Account A state never bleeds into Account B.
@LazySingleton(as: AccountScopeLifecycle)
class ShellAccountScopeLifecycle implements AccountScopeLifecycle {
  ShellAccountScopeLifecycle(
    this._shellCubit,
    this._statusCubit,
    this._feedbackCoordinator,
  );

  final ShellCubit _shellCubit;
  final ShellStatusCubit _statusCubit;
  final FeedbackCoordinator _feedbackCoordinator;

  AccountId? _activeAccountId;
  int _activeTransitionEpoch = 0;

  @override
  AccountId? get activeAccountId => _activeAccountId;

  @override
  int get activeTransitionEpoch => _activeTransitionEpoch;

  @override
  Future<void> deactivateAccountScope({
    AccountId? previousAccountId,
    required int transitionEpoch,
  }) async {
    _activeTransitionEpoch = transitionEpoch;
    _activeAccountId = null;
    _shellCubit.resetForAccountTransition();
    _statusCubit.resetForAccountTransition();
    _feedbackCoordinator.resetForAccountTransition();
  }

  @override
  Future<void> activateAccountScope({
    required AccountId accountId,
    required int transitionEpoch,
  }) async {
    _activeTransitionEpoch = transitionEpoch;
    _activeAccountId = accountId;
  }
}
