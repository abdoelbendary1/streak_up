import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/app/bootstrap/app_logger.dart';
import 'package:streak_up/app/routing/feature_route_hosts.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/core/presentation/status/status_models.dart';
import 'package:streak_up/features/shell/presentation/shell_cubit.dart';
import 'package:streak_up/main.dart';

void main() {
  group('US4 — Accessibility, Touch Targets, Safe Areas, Keyboard Insets & Reduced Motion (T043, SL01-FR-015, AS-15)', () {
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
      'Primary navigation, global Inbox/Profile actions, and Review button meet >= 48x48 logical-pixel touch target minimum',
      (tester) async {
        statusCubit.setNetworkState(
          NetworkState.syncFailed,
          failedCount: 1,
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

        final controlKeys = <Key>[
          const ValueKey<String>('shell_top_action_inbox'),
          const ValueKey<String>('shell_top_action_profile'),
          const ValueKey<String>('shell_bottom_nav_today'),
          const ValueKey<String>('shell_bottom_nav_habits'),
          const ValueKey<String>('shell_bottom_nav_challenges'),
          const ValueKey<String>('shell_bottom_nav_friends'),
          const ValueKey<String>('shell_status_review_action'),
        ];

        for (final key in controlKeys) {
          final size = tester.getSize(find.byKey(key));
          expect(
            size.width,
            greaterThanOrEqualTo(AppSpacing.minTouchTarget),
            reason: 'Control $key width (${size.width}) must be >= 48px',
          );
          expect(
            size.height,
            greaterThanOrEqualTo(AppSpacing.minTouchTarget),
            reason: 'Control $key height (${size.height}) must be >= 48px',
          );
        }
      },
    );

    testWidgets(
      'Preserves state information when reduced motion (disableAnimations) is active and remains scrollable under keyboard viewInsets and short height',
      (tester) async {
        statusCubit.setNetworkState(NetworkState.reconnecting);

        await tester.binding.setSurfaceSize(const Size(360, 420));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(
              size: Size(360, 420),
              disableAnimations: true,
              accessibleNavigation: true,
              padding: EdgeInsets.only(top: 32, bottom: 20),
              viewInsets: EdgeInsets.only(bottom: 180),
            ),
            child: StreakUpShellApp(
              shellCubit: shellCubit,
              statusCubit: statusCubit,
              feedbackCoordinator: feedbackCoordinator,
              routeHosts: const FeatureRouteHosts(),
              simulatedDeviceLocale: const Locale('en'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // No layout overflow even with 420px short height + 180px keyboard inset + safe-area padding.
        expect(tester.takeException(), isNull);
        expect(find.text('Reconnecting'), findsOneWidget);
        expect(find.byIcon(Icons.wifi_find_rounded), findsOneWidget);
      },
    );
  });
}
