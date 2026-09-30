import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Finite application/network reachability projection (`T032`, `SL01-FR-009`).
enum NetworkState { online, offline, reconnecting, syncing, syncFailed }

/// Distinct cause for connectivity or synchronization issues (`T032`, `SL01-FR-010`).
///
/// Auth/session problems are kept separate from transport offline so the UI
/// directs the user toward account recovery rather than mislabeling as Offline.
enum ConnectivityIssueCause {
  none,
  transportOffline,
  backendUnreachable,
  authSessionActionRequired,
}

/// Finite synchronization state for an individual user action (`T032`, `SL01-FR-011`).
///
/// `pending` means saved locally without remote acknowledgment.
/// `synced` requires confirmed server acknowledgment and local reconciliation.
/// `failed` means remote synchronization failed and requires attention/recovery.
enum ActionSyncStatus { pending, synced, failed }

/// Controlled presentation model for an individual action's local and remote state
/// (`T032`, `T033`, `AS-09`–`10`).
@immutable
class ActionStatusProjection {
  const ActionStatusProjection({
    required this.actionKey,
    required this.actionLabel,
    required this.isCompletedLocally,
    required this.remoteSyncStatus,
    this.savedWhileOffline = false,
  });

  /// Safe opaque identifier for the action (never contains private habit text in global logs).
  final String actionKey;

  /// Localized, privacy-safe label supplied by the owning feature.
  final String actionLabel;

  /// Whether the action was accepted and persisted locally on this device.
  final bool isCompletedLocally;

  /// Separate remote synchronization status (`Pending`, `Synced`, or `Failed`).
  /// Local completion (`isCompletedLocally == true`) never implies `ActionSyncStatus.synced`.
  final ActionSyncStatus remoteSyncStatus;

  /// Whether the local save occurred while offline (`Saved offline` badge variant).
  final bool savedWhileOffline;

  /// True only when the supplied remote status explicitly confirms server reconciliation.
  bool get isRemotelyAcknowledged =>
      remoteSyncStatus == ActionSyncStatus.synced;

  /// True when this action requires user recovery/review.
  bool get requiresRecovery => remoteSyncStatus == ActionSyncStatus.failed;

  ActionStatusProjection copyWith({
    String? actionKey,
    String? actionLabel,
    bool? isCompletedLocally,
    ActionSyncStatus? remoteSyncStatus,
    bool? savedWhileOffline,
  }) {
    return ActionStatusProjection(
      actionKey: actionKey ?? this.actionKey,
      actionLabel: actionLabel ?? this.actionLabel,
      isCompletedLocally: isCompletedLocally ?? this.isCompletedLocally,
      remoteSyncStatus: remoteSyncStatus ?? this.remoteSyncStatus,
      savedWhileOffline: savedWhileOffline ?? this.savedWhileOffline,
    );
  }
}

/// Controlled shell status projection consumed by the SL-01 shell (`T032`–`T037`).
@immutable
class ShellStatusState {
  const ShellStatusState({
    this.networkState = NetworkState.online,
    this.issueCause = ConnectivityIssueCause.none,
    this.pendingCount = 0,
    this.failedCount = 0,
    this.compactSyncBanner = false,
    this.actions = const <String, ActionStatusProjection>{},
  });

  /// Factory enforcing that a device network-interface boolean alone CANNOT
  /// establish [NetworkState.online] without confirmed backend reachability (`AS-08`, `SL01-FR-009`).
  factory ShellStatusState.fromReachabilitySignals({
    required bool hasNetworkInterface,
    required bool isBackendReachable,
    bool isRestoringReachability = false,
    bool isSyncRunning = false,
    bool hasAuthSessionIssue = false,
    int pendingCount = 0,
    int failedCount = 0,
    bool compactSyncBanner = false,
    Map<String, ActionStatusProjection> actions =
        const <String, ActionStatusProjection>{},
  }) {
    if (hasAuthSessionIssue) {
      return ShellStatusState(
        networkState: NetworkState.syncFailed,
        issueCause: ConnectivityIssueCause.authSessionActionRequired,
        pendingCount: pendingCount,
        failedCount: failedCount > 0 ? failedCount : 1,
        compactSyncBanner: compactSyncBanner,
        actions: actions,
      );
    }
    if (failedCount > 0) {
      return ShellStatusState(
        networkState: NetworkState.syncFailed,
        issueCause: isBackendReachable
            ? ConnectivityIssueCause.none
            : ConnectivityIssueCause.backendUnreachable,
        pendingCount: pendingCount,
        failedCount: failedCount,
        compactSyncBanner: compactSyncBanner,
        actions: actions,
      );
    }
    if (!hasNetworkInterface) {
      return ShellStatusState(
        networkState: NetworkState.offline,
        issueCause: ConnectivityIssueCause.transportOffline,
        pendingCount: pendingCount,
        failedCount: 0,
        compactSyncBanner: compactSyncBanner,
        actions: actions,
      );
    }
    // Device Wi-Fi/cellular availability alone cannot establish Online because captive portals or backend outages still block sync.
    if (!isBackendReachable) {
      return ShellStatusState(
        networkState: isRestoringReachability
            ? NetworkState.reconnecting
            : NetworkState.offline,
        issueCause: ConnectivityIssueCause.backendUnreachable,
        pendingCount: pendingCount,
        failedCount: 0,
        compactSyncBanner: compactSyncBanner,
        actions: actions,
      );
    }
    if (isRestoringReachability) {
      return ShellStatusState(
        networkState: NetworkState.reconnecting,
        issueCause: ConnectivityIssueCause.none,
        pendingCount: pendingCount,
        failedCount: 0,
        compactSyncBanner: compactSyncBanner,
        actions: actions,
      );
    }
    if (isSyncRunning) {
      return ShellStatusState(
        networkState: NetworkState.syncing,
        issueCause: ConnectivityIssueCause.none,
        pendingCount: pendingCount,
        failedCount: 0,
        compactSyncBanner: compactSyncBanner,
        actions: actions,
      );
    }
    return ShellStatusState(
      networkState: NetworkState.online,
      issueCause: ConnectivityIssueCause.none,
      pendingCount: pendingCount,
      failedCount: 0,
      compactSyncBanner: compactSyncBanner,
      actions: actions,
    );
  }

  final NetworkState networkState;
  final ConnectivityIssueCause issueCause;
  final int pendingCount;
  final int failedCount;
  final bool compactSyncBanner;
  final Map<String, ActionStatusProjection> actions;

  bool get isAuthActionRequired =>
      issueCause == ConnectivityIssueCause.authSessionActionRequired;

  /// Whether the contextual Sync & Recovery attention entry (`Review`) must be exposed
  /// (`SL01-FR-004`, `SL01-FR-012`, `AS-10`, `AS-14`).
  bool get shouldExposeSyncRecoveryEntry =>
      networkState == NetworkState.syncFailed ||
      failedCount > 0 ||
      isAuthActionRequired ||
      actions.values.any((a) => a.requiresRecovery);

  ShellStatusState copyWith({
    NetworkState? networkState,
    ConnectivityIssueCause? issueCause,
    int? pendingCount,
    int? failedCount,
    bool? compactSyncBanner,
    Map<String, ActionStatusProjection>? actions,
  }) {
    return ShellStatusState(
      networkState: networkState ?? this.networkState,
      issueCause: issueCause ?? this.issueCause,
      pendingCount: pendingCount ?? this.pendingCount,
      failedCount: failedCount ?? this.failedCount,
      compactSyncBanner: compactSyncBanner ?? this.compactSyncBanner,
      actions: actions ?? this.actions,
    );
  }
}

/// Injectable Cubit holding controlled connection and action sync states for SL-01 (`T032`).
///
/// Notice that setting [NetworkState.syncing] or [NetworkState.reconnecting] never
/// mutates any [ActionStatusProjection.remoteSyncStatus] from `pending` to `synced`.
@lazySingleton
class ShellStatusCubit extends Cubit<ShellStatusState> {
  ShellStatusCubit() : super(const ShellStatusState());

  void updateStatus(ShellStatusState newState) {
    emit(newState);
  }

  void setNetworkState(
    NetworkState networkState, {
    ConnectivityIssueCause issueCause = ConnectivityIssueCause.none,
    int? pendingCount,
    int? failedCount,
    bool? compactSyncBanner,
  }) {
    // Updating network state NEVER automatically converts pending actions to synced.
    emit(
      state.copyWith(
        networkState: networkState,
        issueCause: issueCause,
        pendingCount: pendingCount,
        failedCount: failedCount,
        compactSyncBanner: compactSyncBanner,
      ),
    );
  }

  void upsertActionStatus(ActionStatusProjection projection) {
    final nextActions = Map<String, ActionStatusProjection>.from(state.actions)
      ..[projection.actionKey] = projection;
    final pendingCount = nextActions.values
        .where((a) => a.remoteSyncStatus == ActionSyncStatus.pending)
        .length;
    final failedCount = nextActions.values
        .where((a) => a.remoteSyncStatus == ActionSyncStatus.failed)
        .length;
    emit(
      state.copyWith(
        actions: Map<String, ActionStatusProjection>.unmodifiable(nextActions),
        pendingCount: pendingCount,
        failedCount: failedCount,
      ),
    );
  }

  /// Clears all account-bound status and pending/failed projections when the
  /// active account scope is torn down (`T017`, `SL02-FR-008`–`011`).
  void resetForAccountTransition() {
    emit(
      state.copyWith(
        pendingCount: 0,
        failedCount: 0,
        compactSyncBanner: false,
        actions: const <String, ActionStatusProjection>{},
      ),
    );
  }
}
