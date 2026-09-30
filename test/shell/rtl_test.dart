import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/app/bootstrap/app_logger.dart';
import 'package:streak_up/app/routing/feature_route_hosts.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/core/presentation/status/status_models.dart';
import 'package:streak_up/core/presentation/widgets/streak_up_wordmark.dart';
import 'package:streak_up/features/shell/presentation/shell_cubit.dart';
import 'package:streak_up/main.dart';

void main() {
  group('US2 — RTL Layout, Navigation Order, and Logo Orientation (T025, T027, T030, SL01-FR-007, AS-06)', () {
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
      'Arabic RTL mirrors top global actions and bottom navigation reading order while keeping StreakUpWordmark LTR unmirrored (AS-06, SL01-FR-007)',
      (tester) async {
        // 1. Render in English LTR.
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

        final ltrTodayDx = tester
            .getCenter(find.byKey(const ValueKey<String>('shell_bottom_nav_today')))
            .dx;
        final ltrFriendsDx = tester
            .getCenter(find.byKey(const ValueKey<String>('shell_bottom_nav_friends')))
            .dx;
        final ltrWordmarkDx = tester.getCenter(find.byType(StreakUpWordmark)).dx;
        final ltrProfileDx = tester
            .getCenter(find.byKey(const ValueKey<String>('shell_top_action_profile')))
            .dx;

        // In LTR, Today is on the left and Friends is on the right; Wordmark is left of Profile.
        expect(ltrTodayDx, lessThan(ltrFriendsDx));
        expect(ltrWordmarkDx, lessThan(ltrProfileDx));

        // 2. Switch to Arabic RTL.
        shellCubit.setLocaleOverride(const Locale('ar'));
        await tester.pumpAndSettle();

        expect(Directionality.of(tester.element(find.byKey(const ValueKey<String>('shell_bottom_nav_today')))), TextDirection.rtl);

        final rtlTodayDx = tester
            .getCenter(find.byKey(const ValueKey<String>('shell_bottom_nav_today')))
            .dx;
        final rtlFriendsDx = tester
            .getCenter(find.byKey(const ValueKey<String>('shell_bottom_nav_friends')))
            .dx;
        final rtlWordmarkDx = tester.getCenter(find.byType(StreakUpWordmark)).dx;
        final rtlProfileDx = tester
            .getCenter(find.byKey(const ValueKey<String>('shell_top_action_profile')))
            .dx;

        // In RTL (`SL01-UI-005-today-rtl-ar.png`), Today (اليوم) is on the right and Friends (الأصدقاء) is on the left;
        // Wordmark is on the right (start) and Profile is on the left (end).
        expect(rtlTodayDx, greaterThan(rtlFriendsDx));
        expect(rtlWordmarkDx, greaterThan(rtlProfileDx));

        // StreakUpWordmark image keeps matchTextDirection == false inside an LTR Directionality subtree.
        final wordmarkImage = tester.widget<Image>(
          find.descendant(
            of: find.byType(StreakUpWordmark),
            matching: find.byType(Image),
          ),
        );
        expect(wordmarkImage.matchTextDirection, isFalse);
      },
    );
  });
}
