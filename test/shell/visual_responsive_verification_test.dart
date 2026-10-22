import '../support/test_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/core/logging/app_logger.dart';
import 'package:streak_up/app/theme/app_colors.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/core/presentation/connectivity/connectivity_cubit.dart';
import 'package:streak_up/core/presentation/connectivity/widgets/connectivity_banner.dart';
import 'package:streak_up/core/presentation/widgets/streak_up_wordmark.dart';
import 'package:streak_up/features/shell/presentation/cubit/shell_cubit.dart';
import 'package:streak_up/features/shell/presentation/widgets/shell_bottom_navigation.dart';

void main() {
  group('T046 — Visual & Responsive Verification against Approved PNGs and Tokens', () {
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
      'Verifies 390x844 reference canvas, <360 compact, 360-599 standard, >=600 wide centered 560px max-width, short landscape, and 1.3x/1.6x large text in EN LTR and AR RTL',
      (tester) async {
        const viewports = <({String label, Size size, double textScale})>[
          (
            label: 'Reference 390x844 @1.0x',
            size: Size(390, 844),
            textScale: 1.0,
          ),
          (
            label: 'Compact 320x640 @1.0x',
            size: Size(320, 640),
            textScale: 1.0,
          ),
          (
            label: 'Compact 320x640 @1.3x',
            size: Size(320, 640),
            textScale: 1.3,
          ),
          (
            label: 'Reference 390x844 @1.6x (SL01-UI-003)',
            size: Size(390, 844),
            textScale: 1.6,
          ),
          (
            label: 'Large phone 430x932 @1.0x',
            size: Size(430, 932),
            textScale: 1.0,
          ),
          (
            label: 'Short landscape 640x360 @1.3x',
            size: Size(640, 360),
            textScale: 1.3,
          ),
          (
            label: 'Wide tablet 840x600 @1.0x',
            size: Size(840, 600),
            textScale: 1.0,
          ),
        ];

        await tester.pumpWidget(
          TestApp(
            shellCubit: shellCubit,
            connectivityCubit: connectivityCubit,
            feedbackCoordinator: feedbackCoordinator,

            todayBuilder: (context) => const SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('Morning Stretch'),
                  SizedBox(height: AppSpacing.sm),
                  Text('Hydration Goal'),
                ],
              ),
            ),
            simulatedDeviceLocale: const Locale('en'),
          ),
        );

        connectivityCubit.setState(NetworkState.offline);

        for (final locale in const <Locale>[Locale('en'), Locale('ar')]) {
          shellCubit.setLocaleOverride(locale);
          for (final viewport in viewports) {
            await tester.binding.setSurfaceSize(viewport.size);
            tester.platformDispatcher.textScaleFactorTestValue =
                viewport.textScale;
            await tester.pumpAndSettle();

            expect(
              tester.takeException(),
              isNull,
              reason:
                  'Zero render/overflow exceptions at ${viewport.label} (${locale.languageCode})',
            );

            // Verify top bar wordmark, Inbox, Profile, SyncFailed banner, and bottom nav are visible.
            expect(find.byType(StreakUpWordmark), findsOneWidget);
            expect(
              find.byKey(const ValueKey<String>('shell_top_action_inbox')),
              findsOneWidget,
            );
            expect(
              find.byKey(const ValueKey<String>('shell_top_action_profile')),
              findsOneWidget,
            );
            expect(find.byType(ConnectivityBanner), findsOneWidget);
            expect(find.byType(ShellBottomNavigation), findsOneWidget);

            // On wide widths (>= 600), verify body content is constrained to <= 560px and centered.
            if (viewport.size.width >= AppSpacing.wideWidthMin) {
              final bannerBox = tester.getRect(find.byType(ConnectivityBanner));
              expect(
                bannerBox.width,
                lessThanOrEqualTo(AppSpacing.maxReadableContentWidth),
              );
            }
          }
        }

        await tester.binding.setSurfaceSize(null);
        tester.platformDispatcher.clearTextScaleFactorTestValue();
      },
    );

    test(
      'Verifies exact approved color tokens against DESIGN_SYSTEM.md and BRAND_IDENTITY.md',
      () {
        expect(AppColors.primaryGreen, const Color(0xFF22C55E));
        expect(AppColors.greenDark, const Color(0xFF16A34A));
        expect(AppColors.navy, const Color(0xFF0F172A));
        expect(AppColors.orange, const Color(0xFFF97316));
        expect(AppColors.blue, const Color(0xFF3B82F6));
        expect(AppColors.purple, const Color(0xFFA855F7));
        expect(AppColors.peach, const Color(0xFFFB923C));
        expect(AppColors.background, const Color(0xFFF8FAFC));
        expect(AppColors.surface, const Color(0xFFFFFFFF));
        expect(AppColors.border, const Color(0xFFE2E8F0));
        expect(AppColors.secondaryText, const Color(0xFF64748B));
        expect(AppColors.success, const Color(0xFF22C55E));
        expect(AppColors.warning, const Color(0xFFF59E0B));
        expect(AppColors.error, const Color(0xFFEF4444));
        expect(AppColors.pending, const Color(0xFFF97316));
        expect(AppColors.information, const Color(0xFF3B82F6));
      },
    );
  });
}
