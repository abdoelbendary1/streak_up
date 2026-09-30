import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/app/bootstrap/app_logger.dart';
import 'package:streak_up/app/routing/feature_route_hosts.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/core/presentation/status/status_models.dart';
import 'package:streak_up/core/presentation/status/widgets/action_sync_status_badge.dart';
import 'package:streak_up/features/shell/presentation/shell_cubit.dart';
import 'package:streak_up/main.dart';

void main() {
  group(
    'US3 — Connection & Action Synchronization Status (T031–T038, SL01-FR-009–012, AS-08–11)',
    () {
      late RedactedAppLogger logger;
      late ShellCubit shellCubit;
      late ShellStatusCubit statusCubit;
      late FeedbackCoordinator feedbackCoordinator;

      setUp(() {
        logger = RedactedAppLogger();
        shellCubit = ShellCubit();
        statusCubit = ShellStatusCubit();
        feedbackCoordinator = FeedbackCoordinator(logger);
      });

      tearDown(() async {
        await shellCubit.close();
        await statusCubit.close();
        await feedbackCoordinator.close();
      });

      test(
        'Device network interface boolean alone never produces NetworkState.online when backend reachability is unconfirmed (AS-08, SL01-FR-009)',
        () {
          final unreachableWithWifi = ShellStatusState.fromReachabilitySignals(
            hasNetworkInterface: true,
            isBackendReachable: false,
          );
          expect(unreachableWithWifi.networkState, isNot(NetworkState.online));
          expect(unreachableWithWifi.networkState, NetworkState.offline);

          final restoringWithWifi = ShellStatusState.fromReachabilitySignals(
            hasNetworkInterface: true,
            isBackendReachable: false,
            isRestoringReachability: true,
          );
          expect(restoringWithWifi.networkState, NetworkState.reconnecting);

          final confirmedOnline = ShellStatusState.fromReachabilitySignals(
            hasNetworkInterface: true,
            isBackendReachable: true,
          );
          expect(confirmedOnline.networkState, NetworkState.online);
        },
      );

      test(
        'Clearing an action failure preserves the underlying network state',
        () {
          statusCubit.setNetworkState(
            NetworkState.offline,
            issueCause: ConnectivityIssueCause.transportOffline,
          );
          statusCubit.upsertActionStatus(
            const ActionStatusProjection(
              actionKey: 'action_1',
              actionLabel: 'Morning stretch',
              isCompletedLocally: true,
              remoteSyncStatus: ActionSyncStatus.failed,
            ),
          );

          expect(statusCubit.state.networkState, NetworkState.offline);
          expect(statusCubit.state.failedCount, 1);

          statusCubit.upsertActionStatus(
            const ActionStatusProjection(
              actionKey: 'action_1',
              actionLabel: 'Morning stretch',
              isCompletedLocally: true,
              remoteSyncStatus: ActionSyncStatus.synced,
            ),
          );

          expect(statusCubit.state.networkState, NetworkState.offline);
          expect(statusCubit.state.failedCount, 0);
        },
      );

      test(
        'Account transition reset clears action state without asserting Online',
        () {
          statusCubit.setNetworkState(
            NetworkState.offline,
            issueCause: ConnectivityIssueCause.transportOffline,
            pendingCount: 1,
            failedCount: 1,
          );
          statusCubit.upsertActionStatus(
            const ActionStatusProjection(
              actionKey: 'action_1',
              actionLabel: 'Morning stretch',
              isCompletedLocally: true,
              remoteSyncStatus: ActionSyncStatus.failed,
            ),
          );

          statusCubit.resetForAccountTransition();

          expect(statusCubit.state.networkState, NetworkState.offline);
          expect(
            statusCubit.state.issueCause,
            ConnectivityIssueCause.transportOffline,
          );
          expect(statusCubit.state.pendingCount, 0);
          expect(statusCubit.state.failedCount, 0);
          expect(statusCubit.state.actions, isEmpty);
        },
      );

      test(
        'Auth/session action-required is distinguished from transport Offline (AS-11, SL01-FR-010)',
        () {
          final authIssue = ShellStatusState.fromReachabilitySignals(
            hasNetworkInterface: true,
            isBackendReachable: true,
            hasAuthSessionIssue: true,
          );
          expect(authIssue.isAuthActionRequired, isTrue);
          expect(
            authIssue.issueCause,
            ConnectivityIssueCause.authSessionActionRequired,
          );
          expect(authIssue.shouldExposeSyncRecoveryEntry, isTrue);
        },
      );

      testWidgets(
        'Renders distinct icon + localized text explanations for Offline, Reconnecting, Syncing, SyncFailed, and Auth Action Required (AS-08, AS-11, SL01-FR-009–010)',
        (tester) async {
          await tester.pumpWidget(
            StreakUpShellApp(
              shellCubit: shellCubit,
              statusCubit: statusCubit,
              feedbackCoordinator: feedbackCoordinator,
              routeHosts: const FeatureRouteHosts(),
              simulatedDeviceLocale: const Locale('en'),
            ),
          );
          await tester.pumpAndSettle();

          // 1. Offline
          statusCubit.setNetworkState(NetworkState.offline);
          await tester.pumpAndSettle();
          expect(
            find.byKey(const ValueKey<String>('shell_status_banner_offline')),
            findsOneWidget,
          );
          expect(find.text("You're offline"), findsOneWidget);
          expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);

          // 2. Reconnecting
          statusCubit.setNetworkState(NetworkState.reconnecting);
          await tester.pumpAndSettle();
          expect(
            find.byKey(
              const ValueKey<String>('shell_status_banner_reconnecting'),
            ),
            findsOneWidget,
          );
          expect(find.text('Reconnecting'), findsOneWidget);

          // 3. Syncing
          statusCubit.setNetworkState(NetworkState.syncing);
          await tester.pumpAndSettle();
          expect(
            find.byKey(const ValueKey<String>('shell_status_banner_syncing')),
            findsOneWidget,
          );
          expect(find.text('Syncing'), findsOneWidget);

          // 4. SyncFailed (standard & compact variants)
          statusCubit.setNetworkState(
            NetworkState.syncFailed,
            failedCount: 1,
            compactSyncBanner: false,
          );
          await tester.pumpAndSettle();
          expect(
            find.byKey(
              const ValueKey<String>('shell_status_banner_sync_failed'),
            ),
            findsOneWidget,
          );
          expect(find.text('Sync issue'), findsOneWidget);
          expect(find.text('Review'), findsOneWidget);

          statusCubit.setNetworkState(
            NetworkState.syncFailed,
            failedCount: 1,
            compactSyncBanner: true,
          );
          await tester.pumpAndSettle();
          expect(find.text("1 change couldn't sync"), findsOneWidget);
          expect(
            find.text(
              'Review the affected activity to resolve this sync issue.',
            ),
            findsOneWidget,
          );

          // 5. Auth/session issue (not mislabeled as Offline)
          statusCubit.setNetworkState(
            NetworkState.syncFailed,
            issueCause: ConnectivityIssueCause.authSessionActionRequired,
          );
          await tester.pumpAndSettle();
          expect(
            find.byKey(
              const ValueKey<String>('shell_status_banner_auth_required'),
            ),
            findsOneWidget,
          );
          expect(find.text('Account attention required'), findsOneWidget);
          expect(find.text("You're offline"), findsNothing);
        },
      );

      testWidgets(
        'Separates local completion from remote Pending/Synced/Failed status; Syncing never converts Pending to Synced (AS-09, AS-10, SL01-FR-011–012)',
        (tester) async {
          // Add an offline-saved locally completed action that is Pending remote acknowledgment.
          statusCubit.upsertActionStatus(
            const ActionStatusProjection(
              actionKey: 'action_1',
              actionLabel: 'Morning stretch',
              isCompletedLocally: true,
              remoteSyncStatus: ActionSyncStatus.pending,
              savedWhileOffline: true,
            ),
          );

          await tester.pumpWidget(
            StreakUpShellApp(
              shellCubit: shellCubit,
              statusCubit: statusCubit,
              feedbackCoordinator: feedbackCoordinator,
              routeHosts: const FeatureRouteHosts(),
              simulatedDeviceLocale: const Locale('en'),
            ),
          );
          await tester.pumpAndSettle();

          // Both local completion ("Completed locally") and "Saved offline" appear separately; never "Synced".
          expect(find.text('Completed locally'), findsOneWidget);
          expect(find.text('Saved offline'), findsOneWidget);
          expect(find.text('Morning stretch'), findsOneWidget);
          expect(find.text('action_1'), findsNothing);
          expect(find.text('Synced'), findsNothing);

          // Transition shell to Syncing -> action MUST remain Pending, NOT Synced.
          statusCubit.setNetworkState(NetworkState.syncing);
          await tester.pumpAndSettle();
          expect(
            statusCubit.state.actions['action_1']!.remoteSyncStatus,
            ActionSyncStatus.pending,
          );
          expect(find.text('Synced'), findsNothing);

          // Transition action to Failed while another is Pending -> both statuses remain distinct and Review is visible.
          statusCubit.setNetworkState(NetworkState.online);
          statusCubit.upsertActionStatus(
            const ActionStatusProjection(
              actionKey: 'action_1',
              actionLabel: 'Morning stretch',
              isCompletedLocally: true,
              remoteSyncStatus: ActionSyncStatus.failed,
            ),
          );
          statusCubit.upsertActionStatus(
            const ActionStatusProjection(
              actionKey: 'action_2',
              actionLabel: 'Read a book',
              isCompletedLocally: true,
              remoteSyncStatus: ActionSyncStatus.pending,
            ),
          );
          await tester.pumpAndSettle();

          expect(statusCubit.state.networkState, NetworkState.online);
          expect(find.text('Sync failed'), findsOneWidget);
          expect(find.text('Pending sync'), findsOneWidget);
          expect(
            find.byKey(const ValueKey<String>('action_failed_review_button')),
            findsOneWidget,
          );

          // Only when owning feature reconciles remote acknowledgment does it show Synced.
          statusCubit.upsertActionStatus(
            const ActionStatusProjection(
              actionKey: 'action_2',
              actionLabel: 'Read a book',
              isCompletedLocally: true,
              remoteSyncStatus: ActionSyncStatus.synced,
            ),
          );
          await tester.pumpAndSettle();
          expect(find.text('Synced'), findsOneWidget);

          // Verify non-color-only distinction: each ActionSyncStatusBadge has both an Icon and Text.
          expect(
            find.descendant(
              of: find.byType(ActionSyncStatusBadge),
              matching: find.byType(Icon),
            ),
            findsWidgets,
          );
          expect(
            find.descendant(
              of: find.byType(ActionSyncStatusBadge),
              matching: find.byType(Text),
            ),
            findsWidgets,
          );
        },
      );
    },
  );
}
