import '../support/test_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/core/logging/app_logger.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/core/presentation/connectivity/connectivity_cubit.dart';
import 'package:streak_up/features/shell/presentation/cubit/shell_cubit.dart';

void main() {
  group(
    'US4 — Accessibility, Touch Targets, Safe Areas, Keyboard Insets & Reduced Motion (T043, SL01-FR-015, AS-15)',
    () {
      late AppLogger logger;
      late ShellCubit shellCubit;
      late ConnectivityCubit connectivityCubit;
      late FeedbackCoordinator feedbackCoordinator;

      setUp(() {
        logger = AppLogger();
        shellCubit = ShellCubit();
        connectivityCubit = ConnectivityCubit();
        feedbackCoordinator = FeedbackCoordinator(logger);
      });

      tearDown(() async {
        await shellCubit.close();
        await connectivityCubit.close();
        await feedbackCoordinator.close();
      });

      testWidgets(
        'Primary navigation, global Inbox/Profile actions, meet >= 48x48 logical-pixel touch target minimum',
        (tester) async {
          connectivityCubit.setNetworkState(NetworkState.offline);

          await tester.pumpWidget(
            TestApp(
              shellCubit: shellCubit,
              connectivityCubit: connectivityCubit,
              feedbackCoordinator: feedbackCoordinator,

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
          connectivityCubit.setNetworkState(NetworkState.reconnecting);

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
              child: TestApp(
                shellCubit: shellCubit,
                connectivityCubit: connectivityCubit,
                feedbackCoordinator: feedbackCoordinator,

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
    },
  );
}
