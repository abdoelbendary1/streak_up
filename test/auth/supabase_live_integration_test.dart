import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/app/bootstrap/app_logger.dart';
import 'package:streak_up/app/bootstrap/supabase_environment.dart';
import 'package:streak_up/features/auth/data/supabase_auth_gateway.dart';
import 'package:streak_up/features/auth/domain/auth_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

SupabaseEnvironmentConfig? _resolveLiveEnvironmentConfig() {
  const definedUrl = String.fromEnvironment('SUPABASE_URL');
  const definedKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  if (definedUrl.isNotEmpty && definedKey.isNotEmpty) {
    return SupabaseEnvironmentConfig.fromDartDefines(
      urlOverride: definedUrl,
      anonKeyOverride: definedKey,
    );
  }
  final envFile = File('.env.dev.json');
  if (envFile.existsSync()) {
    final decoded =
        jsonDecode(envFile.readAsStringSync()) as Map<String, dynamic>;
    final url = (decoded['SUPABASE_URL'] as String?) ?? '';
    final key = (decoded['SUPABASE_ANON_KEY'] as String?) ?? '';
    if (url.isNotEmpty && key.isNotEmpty) {
      return SupabaseEnvironmentConfig.fromDartDefines(
        envOverride: (decoded['STREAKUP_ENV'] as String?) ?? 'dev',
        urlOverride: url,
        anonKeyOverride: key,
      );
    }
  }
  return null;
}

void main() {
  group('T033 — Live Supabase Auth Integration Verification', () {
    late HttpOverrides? previousHttpOverrides;

    setUpAll(() {
      previousHttpOverrides = HttpOverrides.current;
      HttpOverrides.global = null;
    });

    tearDownAll(() {
      HttpOverrides.global = previousHttpOverrides;
    });

    test(
      'validates environment-driven Supabase URL and anon key, restores initial session, and verifies live Auth endpoint responses',
      () async {
        final envConfig = _resolveLiveEnvironmentConfig();
        if (envConfig == null) {
          markTestSkipped(
            'No live Supabase environment configuration (.env.dev.json or --dart-define) present.',
          );
          return;
        }

        expect(() => envConfig.validate(), returnsNormally);

        final client = SupabaseClient(
          envConfig.supabaseUrl,
          envConfig.publishableAnonKey,
          authOptions: const AuthClientOptions(
            authFlowType: AuthFlowType.implicit,
          ),
        );
        final driver = GoTrueSupabaseAuthClientDriver(client.auth);
        final gateway = SupabaseAuthGateway(
          driver,
          envConfig,
          RedactedAppLogger(),
        );

        try {
          final (initialState, condition) =
              await gateway.restoreInitialSession();
          expect(initialState, isA<AuthSignedOutState>());
          expect(condition, AuthConnectionCondition.normal);

          final invalidSignIn = await gateway.signInWithEmailPassword(
            email: 'sl02.nonexistent.probe@streakup.app',
            password: 'InvalidPassword!123',
          );
          expect(invalidSignIn, isA<AuthFailureOutcome<AuthAccountState>>());
          final failure =
              (invalidSignIn as AuthFailureOutcome<AuthAccountState>).failure;
          expect(failure.isTransportFailure, isFalse);

          final recoveryOutcome = await gateway.requestPasswordRecovery(
            email: 'sl02.nonexistent.probe@streakup.app',
          );
          if (recoveryOutcome
              is AuthFailureOutcome<PasswordRecoveryRequestReceipt>) {
            expect(recoveryOutcome.failure.code, AuthFailureCode.rateLimited);
          } else {
            expect(
              recoveryOutcome,
              isA<AuthSuccess<PasswordRecoveryRequestReceipt>>(),
            );
          }
        } finally {
          await gateway.dispose();
          await client.dispose();
        }
      },
    );
  });
}
