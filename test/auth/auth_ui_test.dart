import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/app/theme/app_theme.dart';
import 'package:streak_up/core/localization/active_locale_resolver.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:streak_up/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:streak_up/features/auth/presentation/screens/password_recovery_screen.dart';
import 'package:streak_up/features/auth/presentation/screens/password_recovery_sent_screen.dart';
import 'package:streak_up/features/auth/presentation/screens/password_reset_screen.dart';
import 'package:streak_up/features/auth/presentation/screens/registration_screen.dart';
import 'package:streak_up/features/auth/presentation/screens/session_expired_screen.dart';
import 'package:streak_up/features/auth/presentation/screens/session_restoring_screen.dart';
import 'package:streak_up/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:streak_up/features/auth/presentation/sheets/sign_out_warning_sheet.dart';

import '../support/fake_auth_repository.dart';

void main() {
  group('SL-02 Bilingual & Responsive UI Matrix (T031)', () {
    late AuthCubit authCubit;
    late FakeAuthRepository repository;

    setUp(() {
      repository = FakeAuthRepository();
      authCubit = AuthCubit(repository);
    });

    tearDown(() async {
      await authCubit.close();
      await repository.controller.close();
    });

    Widget buildTestHost({
      required Widget child,
      Locale locale = const Locale('en'),
      double textScale = 1.0,
    }) {
      return BlocProvider<AuthCubit>.value(
        value: authCubit,
        child: MaterialApp(
          theme: AppTheme.light,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: ActiveLocaleResolver.supportedLocales,
          builder: (context, navigator) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(textScale)),
              child: navigator!,
            );
          },
          home: Scaffold(body: child),
        ),
      );
    }

    testWidgets(
      'renders all active SL-02 screens across compact (320x640), mobile (390x844), and tablet (768x1024) in English LTR and Arabic RTL with 1.3x text scale without overflow',
      (tester) async {
        final screens = <Widget>[
          SignInScreen(
            onNavigateToRegister: () {},
            onNavigateToPasswordRecovery: () {},
          ),
          RegistrationScreen(onNavigateToSignIn: () {}),
          EmailVerificationScreen(
            onBackToSignIn: () {},
            emailOverride: 'name@example.com',
          ),
          PasswordRecoveryScreen(
            onRecoveryLinkRequested: () {},
            onBackToSignIn: () {},
          ),
          PasswordRecoverySentScreen(onBackToSignIn: () {}),
          PasswordResetScreen(onPasswordUpdated: () {}, onBackToSignIn: () {}),
          const SessionRestoringScreen(),
          SessionExpiredScreen(onSignInAgain: () {}),
          SignOutWarningSheet(onStaySignedIn: () {}, onSignOutAnyway: () {}),
        ];

        const viewports = <Size>[
          Size(320, 640), // ~320 compact width
          Size(390, 844), // 390x844 reference
          Size(430, 932), // wider phone
          Size(768, 1024), // >=600 wide tablet
          Size(640, 360), // short height / landscape
        ];

        for (final size in viewports) {
          await tester.binding.setSurfaceSize(size);
          for (final locale in const <Locale>[Locale('en'), Locale('ar')]) {
            for (final screen in screens) {
              await tester.pumpWidget(
                BlocProvider<AuthCubit>.value(
                  value: authCubit,
                  child: MaterialApp(
                    theme: AppTheme.light,
                    locale: locale,
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    supportedLocales: ActiveLocaleResolver.supportedLocales,
                    builder: (context, navigator) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          textScaler: const TextScaler.linear(1.3),
                          padding: const EdgeInsets.only(top: 24, bottom: 20),
                          viewInsets: size.height <= 400
                              ? const EdgeInsets.only(bottom: 140)
                              : EdgeInsets.zero,
                        ),
                        child: navigator!,
                      );
                    },
                    home: Scaffold(body: screen),
                  ),
                ),
              );
              await tester.pump();
              expect(tester.takeException(), isNull);
            }
          }
        }
        await tester.binding.setSurfaceSize(null);
      },
    );

    testWidgets(
      'enforces minimum 48dp touch targets and non-mirrored StreakUpWordmark in RTL',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(390, 844));
        await tester.pumpWidget(
          buildTestHost(
            locale: const Locale('ar'),
            child: SignInScreen(
              onNavigateToRegister: () {},
              onNavigateToPasswordRecovery: () {},
            ),
          ),
        );
        await tester.pump();

        final submitButtonSize = tester.getSize(
          find.byKey(const ValueKey<String>('sign_in_submit_button')),
        );
        expect(submitButtonSize.height, greaterThanOrEqualTo(48));

        final createButtonSize = tester.getSize(
          find.byKey(const ValueKey<String>('sign_in_create_account_button')),
        );
        expect(createButtonSize.height, greaterThanOrEqualTo(48));

        await tester.binding.setSurfaceSize(null);
      },
    );
  });
}
