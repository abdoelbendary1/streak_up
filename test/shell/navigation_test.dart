import '../support/test_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:streak_up/app/routing/app_routes.dart';
import 'package:streak_up/core/logging/app_logger.dart';
import 'package:streak_up/features/shell/presentation/models/shell_destination.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/core/presentation/connectivity/connectivity_cubit.dart';
import 'package:streak_up/features/shell/presentation/cubit/shell_cubit.dart';
import 'package:streak_up/features/shell/presentation/widgets/shell_bottom_navigation.dart';

void main() {
  group('US1 — Navigation & Shell Structure (T012–T024, SL01-FR-001–004, AS-01–03)', () {
    late GoRouter router;
    late AppLogger logger;
    late ShellCubit shellCubit;
    late ConnectivityCubit connectivityCubit;
    late FeedbackCoordinator feedbackCoordinator;

    setUp(() {
      router = createTestRouter();
      logger = AppLogger();
      shellCubit = ShellCubit();
      connectivityCubit = ConnectivityCubit();
      feedbackCoordinator = FeedbackCoordinator(logger);
    });

    tearDown(() async {
      router.dispose();
      await shellCubit.close();
      await connectivityCubit.close();
      await feedbackCoordinator.close();
    });

    testWidgets(
      'Exposes exactly four labeled primary destinations, identifies selected state, and opens placeholder screens (AS-01, SL01-FR-001–002)',
      (tester) async {
        final semanticsHandle = tester.ensureSemantics();
        try {
          await tester.pumpWidget(
            TestApp(
              router: router,
              shellCubit: shellCubit,
              connectivityCubit: connectivityCubit,
              feedbackCoordinator: feedbackCoordinator,

              simulatedDeviceLocale: const Locale('en'),
            ),
          );
          await tester.pumpAndSettle();

          // Exactly four bottom destinations exist.
          expect(ShellDestination.values.length, 4);
          expect(
            find.byKey(const ValueKey<String>('shell_bottom_nav_today')),
            findsOneWidget,
          );
          expect(
            find.byKey(const ValueKey<String>('shell_bottom_nav_habits')),
            findsOneWidget,
          );
          expect(
            find.byKey(const ValueKey<String>('shell_bottom_nav_challenges')),
            findsOneWidget,
          );
          expect(
            find.byKey(const ValueKey<String>('shell_bottom_nav_friends')),
            findsOneWidget,
          );

          // Today is selected initially and shows Today placeholder.
          expect(
            find.byKey(const ValueKey('shell_host_today')),
            findsOneWidget,
          );
          expect(router.routerDelegate.currentConfiguration.uri.path, '/today');
          expect(
            tester.getSemantics(
              find.byKey(const ValueKey<String>('shell_bottom_nav_today')),
            ),
            matchesSemantics(
              isButton: true,
              hasSelectedState: true,
              isSelected: true,
              hasTapAction: true,
              label: 'Today, selected tab',
            ),
          );

          // Select Habits -> opens Habits host and updates selected semantics.
          await tester.tap(
            find.byKey(const ValueKey<String>('shell_bottom_nav_habits')),
          );
          await tester.pumpAndSettle();
          expect(
            find.byKey(const ValueKey('shell_host_habits')),
            findsOneWidget,
          );
          expect(
            router.routerDelegate.currentConfiguration.uri.path,
            '/habits',
          );
          expect(
            tester.getSemantics(
              find.byKey(const ValueKey<String>('shell_bottom_nav_habits')),
            ),
            matchesSemantics(
              isButton: true,
              hasSelectedState: true,
              isSelected: true,
              hasTapAction: true,
              label: 'Habits, selected tab',
            ),
          );

          // Select Challenges -> opens Challenges host.
          await tester.tap(
            find.byKey(const ValueKey<String>('shell_bottom_nav_challenges')),
          );
          await tester.pumpAndSettle();
          expect(
            find.byKey(const ValueKey('shell_host_challenges')),
            findsOneWidget,
          );
          expect(
            router.routerDelegate.currentConfiguration.uri.path,
            '/challenges',
          );

          // Select Friends -> opens Friends host.
          await tester.tap(
            find.byKey(const ValueKey<String>('shell_bottom_nav_friends')),
          );
          await tester.pumpAndSettle();
          expect(
            find.byKey(const ValueKey('shell_host_friends')),
            findsOneWidget,
          );
          expect(
            router.routerDelegate.currentConfiguration.uri.path,
            '/friends',
          );
        } finally {
          semanticsHandle.dispose();
        }
      },
    );

    testWidgets(
      'Opens global Inbox and Profile actions from any branch and returns to the active branch (AS-02, AS-03, SL01-FR-003)',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            router: router,
            shellCubit: shellCubit,
            connectivityCubit: connectivityCubit,
            feedbackCoordinator: feedbackCoordinator,

            simulatedDeviceLocale: const Locale('en'),
          ),
        );
        await tester.pumpAndSettle();

        // Switch to Challenges branch first.
        await tester.tap(
          find.byKey(const ValueKey<String>('shell_bottom_nav_challenges')),
        );
        await tester.pumpAndSettle();
        expect(
          find.byKey(const ValueKey('shell_host_challenges')),
          findsOneWidget,
        );
        expect(
          router.routerDelegate.currentConfiguration.uri.path,
          '/challenges',
        );

        // Open global Inbox action -> opens Inbox outside the bottom bar.
        await tester.tap(
          find.byKey(const ValueKey<String>('shell_top_action_inbox')),
        );
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('global_host_inbox')), findsOneWidget);

        // Return from Inbox -> restores Challenges branch.
        await tester.tap(
          find.byKey(const ValueKey<String>('global_route_back_button')),
        );
        await tester.pumpAndSettle();
        expect(
          find.byKey(const ValueKey('shell_host_challenges')),
          findsOneWidget,
        );
        expect(
          router.routerDelegate.currentConfiguration.uri.path,
          '/challenges',
        );

        // Open global Profile action -> opens Profile and returns to Challenges branch.
        await tester.tap(
          find.byKey(const ValueKey<String>('shell_top_action_profile')),
        );
        await tester.pumpAndSettle();
        expect(
          find.byKey(const ValueKey('global_host_profile')),
          findsOneWidget,
        );

        await tester.tap(
          find.byKey(const ValueKey<String>('global_route_back_button')),
        );
        await tester.pumpAndSettle();
        expect(
          find.byKey(const ValueKey('shell_host_challenges')),
          findsOneWidget,
        );
        expect(
          router.routerDelegate.currentConfiguration.uri.path,
          '/challenges',
        );
      },
    );

    testWidgets(
      'direct typed navigation owns selection across locale changes and global return',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            router: router,
            shellCubit: shellCubit,
            connectivityCubit: connectivityCubit,
            feedbackCoordinator: feedbackCoordinator,
          ),
        );
        await tester.pumpAndSettle();
        const FriendsRouteData().go(
          router.routerDelegate.navigatorKey.currentContext!,
        );
        await tester.pumpAndSettle();
        shellCubit.setLocaleOverride(const Locale('ar'));
        await tester.pumpAndSettle();
        expect(router.routerDelegate.currentConfiguration.uri.path, '/friends');
        expect(
          find.byKey(const ValueKey('shell_host_friends')),
          findsOneWidget,
        );
        expect(
          Directionality.of(
            tester.element(find.byKey(const ValueKey('shell_host_friends'))),
          ),
          TextDirection.rtl,
        );
        expect(
          tester
              .widget<ShellBottomNavigation>(find.byType(ShellBottomNavigation))
              .selectedIndex,
          ShellDestination.friends.index,
        );
        await tester.tap(
          find.byKey(const ValueKey<String>('shell_top_action_inbox')),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const ValueKey<String>('global_route_back_button')),
        );
        await tester.pumpAndSettle();
        expect(router.routerDelegate.currentConfiguration.uri.path, '/friends');
        expect(
          find.byKey(const ValueKey('shell_host_friends')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'compact enlarged English navigation keeps each label on one readable line',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(320, 640));
        tester.platformDispatcher.textScaleFactorTestValue = 1.3;
        addTearDown(() async {
          tester.platformDispatcher.clearTextScaleFactorTestValue();
          await tester.binding.setSurfaceSize(null);
        });
        await tester.pumpWidget(
          TestApp(
            router: router,
            shellCubit: shellCubit,
            connectivityCubit: connectivityCubit,
            feedbackCoordinator: feedbackCoordinator,

            simulatedDeviceLocale: const Locale('en'),
          ),
        );
        await tester.pumpAndSettle();
        for (final label in ['Today', 'Habits', 'Challenges', 'Friends']) {
          final paragraph = tester.renderObject<RenderParagraph>(
            find.text(label),
          );
          expect(
            paragraph.getBoxesForSelection(
              TextSelection(baseOffset: 0, extentOffset: label.length),
            ),
            hasLength(1),
            reason: '$label must not leave an orphan character on another line',
          );
        }
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'standalone global routes return to Today when there is no prior page',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            router: router,
            shellCubit: shellCubit,
            connectivityCubit: connectivityCubit,
            feedbackCoordinator: feedbackCoordinator,
          ),
        );
        await tester.pumpAndSettle();
        final context = router.routerDelegate.navigatorKey.currentContext!;
        for (final open in <void Function(BuildContext)>[
          (context) => const InboxRouteData().go(context),
          (context) => const ProfileRouteData().go(context),
        ]) {
          open(context);
          await tester.pumpAndSettle();
          expect(router.canPop(), isFalse);
          await tester.tap(
            find.byKey(const ValueKey<String>('global_route_back_button')),
          );
          await tester.pumpAndSettle();
          expect(router.routerDelegate.currentConfiguration.uri.path, '/today');
          expect(
            find.byKey(const ValueKey('shell_host_today')),
            findsOneWidget,
          );
        }
      },
    );

    testWidgets(
      'a feature can open Sync & Recovery and return to its active branch',
      (tester) async {
        await tester.pumpWidget(
          TestApp(
            router: router,
            shellCubit: shellCubit,
            connectivityCubit: connectivityCubit,
            feedbackCoordinator: feedbackCoordinator,
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.byKey(const ValueKey('shell_status_review_action')),
          findsNothing,
        );
        await tester.tap(find.byKey(const ValueKey('shell_bottom_nav_habits')));
        await tester.pumpAndSettle();
        const SyncRecoveryRouteData().push<void>(
          router.routerDelegate.navigatorKey.currentContext!,
        );
        await tester.pumpAndSettle();
        expect(
          find.byKey(const ValueKey('global_host_sync_recovery')),
          findsOneWidget,
        );
        await tester.tap(
          find.byKey(const ValueKey('global_route_back_button')),
        );
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('shell_host_habits')), findsOneWidget);
        expect(router.routerDelegate.currentConfiguration.uri.path, '/habits');
      },
    );
  });
}
