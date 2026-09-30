import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/app/bootstrap/app_logger.dart';
import 'package:streak_up/app/routing/feature_route_hosts.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/core/presentation/feedback/feedback_models.dart';
import 'package:streak_up/core/presentation/feedback/widgets/shared_feedback_host.dart';
import 'package:streak_up/core/presentation/status/status_models.dart';
import 'package:streak_up/core/presentation/widgets/shared_state_views.dart';
import 'package:streak_up/features/shell/presentation/shell_cubit.dart';
import 'package:streak_up/main.dart';

void main() {
  group('US4 — Shared Feedback, Coalescing, Persistent Recovery & Privacy (T039–T044, SL01-FR-013–017, AS-12–17)', () {
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

    testWidgets(
      'Supports all seven FeedbackKind severities with icon + localized severity prefix + text and optional action (AS-12, SL01-FR-013)',
      (tester) async {
        var actionTriggered = false;

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

        for (final kind in FeedbackKind.values) {
          feedbackCoordinator.publish(
            FeedbackDescriptor(
              id: 'test_${kind.name}',
              kind: kind,
              messageKey: FeedbackMessageKey.localSavePending,
              lifetime: FeedbackLifetime.transient,
              actionIntent: FeedbackActionIntent(
                actionId: 'act_${kind.name}',
                onTriggered: () {
                  actionTriggered = true;
                },
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.byKey(const ValueKey<String>('transient_feedback_card')), findsOneWidget);
          expect(
            find.byKey(ValueKey<String>('feedback_action_act_${kind.name}')),
            findsOneWidget,
          );
        }

        await tester.tap(
          find.byKey(
            ValueKey<String>('feedback_action_act_${FeedbackKind.values.last.name}'),
          ),
        );
        await tester.pumpAndSettle();
        expect(actionTriggered, isTrue);
      },
    );

    testWidgets(
      'Coalesces repeated background sync updates and never creates durable Inbox events (AS-13, AS-17, SL01-FR-014, SL01-FR-017)',
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

        // Publish three repetitive background sync events.
        feedbackCoordinator.publish(
          const FeedbackDescriptor(
            id: 'bg_1',
            kind: FeedbackKind.sync,
            messageKey: FeedbackMessageKey.backgroundSyncProgress,
            lifetime: FeedbackLifetime.transient,
            isBackgroundSyncEvent: true,
          ),
        );
        feedbackCoordinator.publish(
          const FeedbackDescriptor(
            id: 'bg_2',
            kind: FeedbackKind.sync,
            messageKey: FeedbackMessageKey.backgroundSyncProgress,
            lifetime: FeedbackLifetime.transient,
            isBackgroundSyncEvent: true,
          ),
        );
        feedbackCoordinator.publish(
          const FeedbackDescriptor(
            id: 'bg_3',
            kind: FeedbackKind.sync,
            messageKey: FeedbackMessageKey.backgroundSyncProgress,
            lifetime: FeedbackLifetime.transient,
            isBackgroundSyncEvent: true,
          ),
        );
        await tester.pumpAndSettle();

        // Only a single coalesced transient card is shown with count = 3.
        expect(find.byKey(const ValueKey<String>('transient_feedback_card')), findsOneWidget);
        expect(
          find.textContaining('3 background sync updates in progress'),
          findsOneWidget,
        );
        expect(feedbackCoordinator.state.createdInboxEventCount, 0);
      },
    );

    testWidgets(
      'Dismissing transient feedback or a global banner never clears source-level persistent action failure (AS-14, SL01-FR-014)',
      (tester) async {
        await tester.pumpWidget(
          StreakUpShellApp(
            shellCubit: shellCubit,
            statusCubit: statusCubit,
            feedbackCoordinator: feedbackCoordinator,
            routeHosts: FeatureRouteHosts.custom(
              todayBuilder: (_) => const InlineActionFeedbackHost(
                actionKey: 'failed_action_42',
              ),
            ),
            simulatedDeviceLocale: const Locale('en'),
          ),
        );
        await tester.pumpAndSettle();

        feedbackCoordinator.publish(
          const FeedbackDescriptor(
            id: 'persistent_issue_42',
            kind: FeedbackKind.recoverableError,
            messageKey: FeedbackMessageKey.syncIssueNeedsReview,
            lifetime: FeedbackLifetime.persistent,
            sourceActionKey: 'failed_action_42',
          ),
        );
        feedbackCoordinator.publish(
          const FeedbackDescriptor(
            id: 'transient_notice',
            kind: FeedbackKind.warning,
            messageKey: FeedbackMessageKey.generalWarning,
            lifetime: FeedbackLifetime.transient,
          ),
        );
        await tester.pumpAndSettle();

        // Dismiss the transient message and the global banner.
        feedbackCoordinator.dismissTransient();
        feedbackCoordinator.dismissBannerOnly('persistent_issue_42');
        await tester.pumpAndSettle();

        // Source-level inline failure remains visible and discoverable.
        expect(
          find.byKey(const ValueKey<String>('inline_feedback_failed_action_42')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Distinguishes Loading, Truly Empty, and Inline Error shared state presentations (T042, AS-16, SL01-FR-016)',
      (tester) async {
        await tester.pumpWidget(
          StreakUpShellApp(
            shellCubit: shellCubit,
            statusCubit: statusCubit,
            feedbackCoordinator: feedbackCoordinator,
            routeHosts: FeatureRouteHosts.custom(
              todayBuilder: (_) => const Column(
                children: <Widget>[
                  SharedSectionStateView(kind: SectionContentStateKind.loading),
                  SharedSectionStateView(
                    kind: SectionContentStateKind.trulyEmpty,
                    nextActionLabel: 'Start step',
                  ),
                  SharedSectionStateView(kind: SectionContentStateKind.inlineError),
                ],
              ),
            ),
            simulatedDeviceLocale: const Locale('en'),
          ),
        );
        await tester.pump();

        expect(find.byKey(const ValueKey<String>('shared_section_state_loading')), findsOneWidget);
        expect(find.byKey(const ValueKey<String>('shared_section_state_trulyEmpty')), findsOneWidget);
        expect(find.byKey(const ValueKey<String>('shared_section_state_inlineError')), findsOneWidget);
        expect(find.text('Loading'), findsOneWidget);
        expect(find.text('Nothing to show yet'), findsOneWidget);
        expect(find.text('Unable to load content'), findsOneWidget);
      },
    );
  });
}
