import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/app/bootstrap/app_logger.dart';
import 'package:streak_up/app/routing/feature_route_hosts.dart';
import 'package:streak_up/app/routing/shell_destination.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/core/presentation/status/status_models.dart';
import 'package:streak_up/features/shell/presentation/shell_cubit.dart';
import 'package:streak_up/main.dart';

void main() {
  group('US1 — Navigation & Shell Structure (T012–T024, SL01-FR-001–004, AS-01–03)', () {
    late RedactedAppLogger logger;
    late ShellCubit shellCubit;
    late ShellStatusCubit statusCubit;
    late FeedbackCoordinator feedbackCoordinator;
    late FeatureRouteHosts injectedHosts;

    setUp(() {
      logger = RedactedAppLogger();
      shellCubit = ShellCubit();
      statusCubit = ShellStatusCubit();
      feedbackCoordinator = FeedbackCoordinator(logger);
      injectedHosts = FeatureRouteHosts.custom(
        todayBuilder: (_) => const Text(
          'INJECTED_TODAY_HOST',
          key: ValueKey<String>('injected_today'),
        ),
        habitsBuilder: (_) => const Text(
          'INJECTED_HABITS_HOST',
          key: ValueKey<String>('injected_habits'),
        ),
        challengesBuilder: (_) => const Text(
          'INJECTED_CHALLENGES_HOST',
          key: ValueKey<String>('injected_challenges'),
        ),
        friendsBuilder: (_) => const Text(
          'INJECTED_FRIENDS_HOST',
          key: ValueKey<String>('injected_friends'),
        ),
        inboxBuilder: (_) => const Text(
          'INJECTED_INBOX_HOST',
          key: ValueKey<String>('injected_inbox'),
        ),
        profileBuilder: (_) => const Text(
          'INJECTED_PROFILE_HOST',
          key: ValueKey<String>('injected_profile'),
        ),
        syncRecoveryBuilder: (_) => const Text(
          'INJECTED_SYNC_RECOVERY_HOST',
          key: ValueKey<String>('injected_sync_recovery'),
        ),
      );
    });

    tearDown(() async {
      await shellCubit.close();
      await statusCubit.close();
      await feedbackCoordinator.close();
    });

    testWidgets(
      'Exposes exactly four labeled primary destinations, identifies selected state, and opens injected hosts (AS-01, SL01-FR-001–002)',
      (tester) async {
        final semanticsHandle = tester.ensureSemantics();
        try {
          await tester.pumpWidget(
            StreakUpShellApp(
              shellCubit: shellCubit,
              statusCubit: statusCubit,
              feedbackCoordinator: feedbackCoordinator,
              routeHosts: injectedHosts,
              simulatedDeviceLocale: const Locale('en'),
            ),
          );
          await tester.pumpAndSettle();

          // Exactly four bottom destinations exist.
          expect(ShellDestination.values.length, 4);
          expect(find.byKey(const ValueKey<String>('shell_bottom_nav_today')), findsOneWidget);
          expect(find.byKey(const ValueKey<String>('shell_bottom_nav_habits')), findsOneWidget);
          expect(find.byKey(const ValueKey<String>('shell_bottom_nav_challenges')), findsOneWidget);
          expect(find.byKey(const ValueKey<String>('shell_bottom_nav_friends')), findsOneWidget);

          // Today is selected initially and shows injected Today host.
          expect(find.text('INJECTED_TODAY_HOST'), findsOneWidget);
          expect(shellCubit.state.selectedDestination, ShellDestination.today);
          expect(
            tester.getSemantics(find.byKey(const ValueKey<String>('shell_bottom_nav_today'))),
            matchesSemantics(
              isButton: true,
              hasSelectedState: true,
              isSelected: true,
              hasTapAction: true,
              label: 'Today, selected tab',
            ),
          );

          // Select Habits -> opens Habits host and updates selected semantics.
          await tester.tap(find.byKey(const ValueKey<String>('shell_bottom_nav_habits')));
          await tester.pumpAndSettle();
          expect(find.text('INJECTED_HABITS_HOST'), findsOneWidget);
          expect(shellCubit.state.selectedDestination, ShellDestination.habits);
          expect(
            tester.getSemantics(find.byKey(const ValueKey<String>('shell_bottom_nav_habits'))),
            matchesSemantics(
              isButton: true,
              hasSelectedState: true,
              isSelected: true,
              hasTapAction: true,
              label: 'Habits, selected tab',
            ),
          );

          // Select Challenges -> opens Challenges host.
          await tester.tap(find.byKey(const ValueKey<String>('shell_bottom_nav_challenges')));
          await tester.pumpAndSettle();
          expect(find.text('INJECTED_CHALLENGES_HOST'), findsOneWidget);
          expect(shellCubit.state.selectedDestination, ShellDestination.challenges);

          // Select Friends -> opens Friends host.
          await tester.tap(find.byKey(const ValueKey<String>('shell_bottom_nav_friends')));
          await tester.pumpAndSettle();
          expect(find.text('INJECTED_FRIENDS_HOST'), findsOneWidget);
          expect(shellCubit.state.selectedDestination, ShellDestination.friends);
        } finally {
          semanticsHandle.dispose();
        }
      },
    );

    testWidgets(
      'Opens global Inbox and Profile actions from any branch and returns to the active branch (AS-02, AS-03, SL01-FR-003)',
      (tester) async {
        await tester.pumpWidget(
          StreakUpShellApp(
            shellCubit: shellCubit,
            statusCubit: statusCubit,
            feedbackCoordinator: feedbackCoordinator,
            routeHosts: injectedHosts,
            simulatedDeviceLocale: const Locale('en'),
          ),
        );
        await tester.pumpAndSettle();

        // Switch to Challenges branch first.
        await tester.tap(find.byKey(const ValueKey<String>('shell_bottom_nav_challenges')));
        await tester.pumpAndSettle();
        expect(find.text('INJECTED_CHALLENGES_HOST'), findsOneWidget);
        expect(shellCubit.state.selectedDestination, ShellDestination.challenges);

        // Open global Inbox action -> opens Inbox outside the bottom bar.
        await tester.tap(find.byKey(const ValueKey<String>('shell_top_action_inbox')));
        await tester.pumpAndSettle();
        expect(find.text('INJECTED_INBOX_HOST'), findsOneWidget);

        // Return from Inbox -> restores Challenges branch.
        await tester.tap(find.byKey(const ValueKey<String>('global_route_back_button')));
        await tester.pumpAndSettle();
        expect(find.text('INJECTED_CHALLENGES_HOST'), findsOneWidget);
        expect(shellCubit.state.selectedDestination, ShellDestination.challenges);

        // Open global Profile action -> opens Profile and returns to Challenges branch.
        await tester.tap(find.byKey(const ValueKey<String>('shell_top_action_profile')));
        await tester.pumpAndSettle();
        expect(find.text('INJECTED_PROFILE_HOST'), findsOneWidget);

        await tester.tap(find.byKey(const ValueKey<String>('global_route_back_button')));
        await tester.pumpAndSettle();
        expect(find.text('INJECTED_CHALLENGES_HOST'), findsOneWidget);
        expect(shellCubit.state.selectedDestination, ShellDestination.challenges);
      },
    );

    testWidgets(
      'Exposes contextual Sync & Recovery Review entry only when attention is needed and returns to active branch (T024, SL01-FR-004)',
      (tester) async {
        await tester.pumpWidget(
          StreakUpShellApp(
            shellCubit: shellCubit,
            statusCubit: statusCubit,
            feedbackCoordinator: feedbackCoordinator,
            routeHosts: injectedHosts,
            simulatedDeviceLocale: const Locale('en'),
          ),
        );
        await tester.pumpAndSettle();

        // When Online with no pending/failed work, Review action is absent.
        expect(
          find.byKey(const ValueKey<String>('shell_status_review_action')),
          findsNothing,
        );

        // Switch to Habits and report a sync failure.
        await tester.tap(find.byKey(const ValueKey<String>('shell_bottom_nav_habits')));
        await tester.pumpAndSettle();

        statusCubit.setNetworkState(
          NetworkState.syncFailed,
          failedCount: 1,
        );
        await tester.pumpAndSettle();

        // Review button is now discoverable and opens Sync & Recovery host.
        final reviewButton = find.byKey(
          const ValueKey<String>('shell_status_review_action'),
        );
        expect(reviewButton, findsOneWidget);
        await tester.tap(reviewButton);
        await tester.pumpAndSettle();
        expect(find.text('INJECTED_SYNC_RECOVERY_HOST'), findsOneWidget);

        // Back returns to Habits branch while failure remains discoverable.
        await tester.tap(find.byKey(const ValueKey<String>('global_route_back_button')));
        await tester.pumpAndSettle();
        expect(find.text('INJECTED_HABITS_HOST'), findsOneWidget);
        expect(shellCubit.state.selectedDestination, ShellDestination.habits);
        expect(reviewButton, findsOneWidget);
      },
    );
  });
}
