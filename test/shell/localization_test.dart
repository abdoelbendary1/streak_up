import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:streak_up/app/bootstrap/app_logger.dart';
import 'package:streak_up/app/routing/feature_route_hosts.dart';
import 'package:streak_up/core/localization/active_locale_resolver.dart';
import 'package:streak_up/core/localization/locale_formatter.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/core/presentation/status/status_models.dart';
import 'package:streak_up/features/shell/presentation/shell_cubit.dart';
import 'package:streak_up/main.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
    await initializeDateFormatting('ar');
  });

  group('US2 — English, Arabic, Locale Fallback & Formatting (T025–T030, SL01-FR-005–008, AS-04–07)', () {
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
      'ActiveLocaleResolver maps device en -> en, device ar -> ar, unsupported -> en, and honors explicit override without persistence (AS-04, AS-05)',
      () {
        expect(
          ActiveLocaleResolver.resolve(deviceLocale: const Locale('en', 'US')),
          const Locale('en'),
        );
        expect(
          ActiveLocaleResolver.resolve(deviceLocale: const Locale('ar', 'EG')),
          const Locale('ar'),
        );
        expect(
          ActiveLocaleResolver.resolve(deviceLocale: const Locale('fr', 'FR')),
          const Locale('en'),
        );
        expect(
          ActiveLocaleResolver.resolve(deviceLocale: const Locale('es')),
          const Locale('en'),
        );
        expect(
          ActiveLocaleResolver.resolve(
            deviceLocale: const Locale('en'),
            explicitOverride: const Locale('ar'),
          ),
          const Locale('ar'),
        );
      },
    );

    test(
      'LocaleFormatter formats dates/times by locale, enforces 0–9 numerals in both languages, and isolates mixed-script text (AS-07, SL01-FR-008)',
      () {
        final sampleDate = DateTime.utc(2026, 9, 20, 9, 41);

        final enCount = LocaleFormatter.formatCount(1284, const Locale('en'));
        final arCount = LocaleFormatter.formatCount(1284, const Locale('ar'));
        expect(enCount, contains('1'));
        expect(arCount, contains('1'));
        expect(arCount, isNot(contains('١')));

        final enDate = LocaleFormatter.formatDate(sampleDate, const Locale('en'));
        final arDate = LocaleFormatter.formatDate(sampleDate, const Locale('ar'));
        expect(enDate, isNot(equals(arDate)));
        expect(arDate, contains('20'));
        expect(arDate, isNot(contains('٢٠')));

        final mixed = LocaleFormatter.isolateMixedScript('قراءة Book لمدة ١٥ دقيقة');
        expect(mixed, contains('15'));
        expect(mixed, isNot(contains('١٥')));
        expect(mixed.startsWith('\u2068'), isTrue);
        expect(mixed.endsWith('\u2069'), isTrue);
      },
    );

    testWidgets(
      'Renders English shell when device locale is unsupported (fr_FR) and switches dynamically when explicit Arabic override is supplied (AS-04, AS-05)',
      (tester) async {
        statusCubit.setNetworkState(
          NetworkState.syncFailed,
          failedCount: 2,
        );

        await tester.pumpWidget(
          StreakUpShellApp(
            shellCubit: shellCubit,
            statusCubit: statusCubit,
            feedbackCoordinator: feedbackCoordinator,
            routeHosts: const FeatureRouteHosts(),
            simulatedDeviceLocale: const Locale('fr', 'FR'),
          ),
        );
        await tester.pumpAndSettle();

        // Unsupported fr_FR falls back to English.
        expect(find.text('Today'), findsOneWidget);
        expect(find.text('Habits'), findsOneWidget);
        expect(find.text('Challenges'), findsOneWidget);
        expect(find.text('Friends'), findsOneWidget);
        expect(find.text('Sync issue'), findsOneWidget);
        expect(find.text('Review'), findsOneWidget);

        // Supply explicit Arabic override (as future Profile will provide).
        shellCubit.setLocaleOverride(const Locale('ar'));
        await tester.pumpAndSettle();

        expect(find.text('اليوم'), findsOneWidget);
        expect(find.text('العادات'), findsOneWidget);
        expect(find.text('التحديات'), findsOneWidget);
        expect(find.text('الأصدقاء'), findsOneWidget);
        expect(find.text('مشكلة في المزامنة'), findsOneWidget);
        expect(find.text('مراجعة'), findsOneWidget);
        // Numeral 2 uses approved 0–9 glyph in Arabic banner description.
        expect(find.textContaining('2'), findsWidgets);
      },
    );

    testWidgets(
      'Responsive matrix: compact (<360), standard (390), large phone (430), and wide (>=600) viewports with large text scale (1.6x) in English and Arabic do not overflow or clip actions (T029, T030, AS-15)',
      (tester) async {
        final viewports = <Size>[
          const Size(320, 640), // Compact phone (<360)
          const Size(390, 844), // Reference-like standard phone
          const Size(430, 932), // Large phone
          const Size(768, 600), // Wide / tablet-like (>=600) & short height
        ];

        statusCubit.setNetworkState(
          NetworkState.syncFailed,
          failedCount: 1,
        );

        for (final locale in <Locale>[const Locale('en'), const Locale('ar')]) {
          shellCubit.setLocaleOverride(locale);
          for (final size in viewports) {
            await tester.binding.setSurfaceSize(size);
            await tester.pumpWidget(
              MediaQuery(
                data: MediaQueryData(
                  size: size,
                  textScaler: const TextScaler.linear(1.6),
                  padding: const EdgeInsets.only(top: 24, bottom: 16),
                ),
                child: StreakUpShellApp(
                  shellCubit: shellCubit,
                  statusCubit: statusCubit,
                  feedbackCoordinator: feedbackCoordinator,
                  routeHosts: const FeatureRouteHosts(),
                ),
              ),
            );
            await tester.pumpAndSettle();

            // Verify zero layout overflow exceptions and all 4 tabs + Inbox/Profile + Review exist.
            expect(tester.takeException(), isNull);
            expect(find.byKey(const ValueKey<String>('shell_top_action_inbox')), findsOneWidget);
            expect(find.byKey(const ValueKey<String>('shell_top_action_profile')), findsOneWidget);
            expect(find.byKey(const ValueKey<String>('shell_bottom_nav_today')), findsOneWidget);
            expect(find.byKey(const ValueKey<String>('shell_bottom_nav_habits')), findsOneWidget);
            expect(find.byKey(const ValueKey<String>('shell_bottom_nav_challenges')), findsOneWidget);
            expect(find.byKey(const ValueKey<String>('shell_bottom_nav_friends')), findsOneWidget);
            expect(find.byKey(const ValueKey<String>('shell_status_review_action')), findsOneWidget);
          }
        }
        await tester.binding.setSurfaceSize(null);
      },
    );
  });
}
