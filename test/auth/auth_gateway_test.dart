import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/app/bootstrap/app_logger.dart';
import 'package:streak_up/app/bootstrap/supabase_environment.dart';
import 'package:streak_up/features/auth/data/supabase_auth_gateway.dart';
import 'package:streak_up/features/auth/domain/auth_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FakeSupabaseAuthClientDriver implements SupabaseAuthClientDriver {
  final StreamController<RawProviderAuthEvent> controller =
      StreamController<RawProviderAuthEvent>.broadcast();

  RawProviderSessionSnapshot? cachedSession;
  RawProviderSessionSnapshot? signUpResult;
  RawProviderSessionSnapshot? signInResult;
  RawProviderSessionSnapshot? refreshResult;
  (RawProviderSessionSnapshot?, bool)? callbackResult;
  RawProviderSessionSnapshot? updatePasswordResult;

  Object? signUpError;
  Object? signInError;
  Object? refreshError;
  Object? resetPasswordError;
  Object? callbackError;

  int resendCallCount = 0;
  int resetPasswordCallCount = 0;
  int signOutCallCount = 0;

  @override
  Stream<RawProviderAuthEvent> get onAuthStateChange => controller.stream;

  @override
  RawProviderSessionSnapshot? get currentSession => cachedSession;

  @override
  Future<RawProviderSessionSnapshot?> signUp({
    required String email,
    required String password,
    required String emailRedirectTo,
  }) async {
    if (signUpError != null) throw signUpError!;
    return signUpResult;
  }

  @override
  Future<RawProviderSessionSnapshot?> signInWithPassword({
    required String email,
    required String password,
  }) async {
    if (signInError != null) throw signInError!;
    return signInResult;
  }

  @override
  Future<RawProviderSessionSnapshot?> refreshOrFetchUser() async {
    if (refreshError != null) throw refreshError!;
    return refreshResult;
  }

  @override
  Future<void> resendSignupVerification({
    required String email,
    required String emailRedirectTo,
  }) async {
    resendCallCount++;
  }

  @override
  Future<void> resetPasswordForEmail({
    required String email,
    required String redirectTo,
  }) async {
    resetPasswordCallCount++;
    if (resetPasswordError != null) throw resetPasswordError!;
  }

  @override
  Future<(RawProviderSessionSnapshot?, bool)> getSessionFromUrl(
    Uri callbackUri,
  ) async {
    if (callbackError != null) throw callbackError!;
    return callbackResult ?? (null, false);
  }

  @override
  Future<RawProviderSessionSnapshot?> updatePassword(String newPassword) async {
    return updatePasswordResult;
  }

  @override
  Future<void> signOut() async {
    signOutCallCount++;
    cachedSession = null;
  }
}

void main() {
  group('SupabaseEnvironmentConfig & SupabaseAuthGateway (T013)', () {
    late FakeSupabaseAuthClientDriver driver;
    late SupabaseEnvironmentConfig config;
    late SupabaseAuthGateway gateway;

    setUp(() {
      driver = FakeSupabaseAuthClientDriver();
      config = const SupabaseEnvironmentConfig(
        environment: SupabaseEnvironment.dev,
        supabaseUrl: 'https://dev-project.supabase.co',
        publishableAnonKey: 'sb_publishable_dev_anon_key',
      );
      gateway = SupabaseAuthGateway(driver, config, RedactedAppLogger());
    });

    tearDown(() async {
      await gateway.dispose();
    });

    test('rejects service-role secrets in client configuration', () {
      const badConfig = SupabaseEnvironmentConfig(
        environment: SupabaseEnvironment.prod,
        supabaseUrl: 'https://prod-project.supabase.co',
        publishableAnonKey: 'sb_secret_service_role_private_key',
      );
      expect(() => badConfig.validate(), throwsStateError);
    });

    test('allows placeholder keys and HTTP URLs only in dev', () {
      const devConfig = SupabaseEnvironmentConfig(
        environment: SupabaseEnvironment.dev,
        supabaseUrl: 'http://localhost:54321',
        publishableAnonKey: 'sb_publishable_dev_anon_key_placeholder',
      );
      expect(devConfig.validate, returnsNormally);

      const stagingPlaceholderKey = SupabaseEnvironmentConfig(
        environment: SupabaseEnvironment.staging,
        supabaseUrl: 'https://staging-project.supabase.co',
        publishableAnonKey: 'sb_publishable_staging_anon_key_placeholder',
      );
      expect(stagingPlaceholderKey.validate, throwsStateError);

      const productionHttpUrl = SupabaseEnvironmentConfig(
        environment: SupabaseEnvironment.prod,
        supabaseUrl: 'http://prod-project.supabase.co',
        publishableAnonKey: 'sb_publishable_real_key',
      );
      expect(productionHttpUrl.validate, throwsStateError);
    });

    test(
      'registration with unconfirmed email enters verificationRequired',
      () async {
        driver.signUpResult = const RawProviderSessionSnapshot(
          userId: 'acc-101',
          email: 'newuser@example.com',
          emailConfirmedAt: null,
        );

        final outcome = await gateway.registerWithEmailPassword(
          email: 'newuser@example.com',
          password: 'password123',
        );

        expect(outcome, isA<AuthSuccess<AuthAccountState>>());
        final state = (outcome as AuthSuccess<AuthAccountState>).value;
        expect(state, isA<AuthVerificationRequiredState>());
        expect(
          (state as AuthVerificationRequiredState).email,
          'newuser@example.com',
        );
      },
    );

    test('sign-in with verified email enters authenticated state', () async {
      final verifiedTime = DateTime.utc(2026, 9, 29, 12);
      driver.signInResult = RawProviderSessionSnapshot(
        userId: 'acc-202',
        email: 'verified@example.com',
        emailConfirmedAt: verifiedTime,
      );

      final outcome = await gateway.signInWithEmailPassword(
        email: 'verified@example.com',
        password: 'password123',
      );

      expect(outcome, isA<AuthSuccess<AuthAccountState>>());
      final state = (outcome as AuthSuccess<AuthAccountState>).value;
      expect(state, isA<AuthAuthenticatedState>());
      expect(state.activeAccountId, AccountId('acc-202'));
    });

    test(
      'password recovery request is non-enumerating even when provider reports user missing',
      () async {
        driver.resetPasswordError = const AuthException(
          'User not found',
          statusCode: '404',
        );

        final outcome = await gateway.requestPasswordRecovery(
          email: 'unknown@example.com',
        );

        expect(outcome, isA<AuthSuccess<PasswordRecoveryRequestReceipt>>());
      },
    );

    test(
      'offline session restoration preserves persisted verified session without invalidating',
      () async {
        driver.cachedSession = RawProviderSessionSnapshot(
          userId: 'acc-offline',
          email: 'offline@example.com',
          emailConfirmedAt: DateTime.utc(2026, 9, 28),
        );
        driver.refreshError = const SocketException('Network unreachable');

        final (state, condition) = await gateway.restoreInitialSession();

        expect(state, isA<AuthAuthenticatedState>());
        final authState = state as AuthAuthenticatedState;
        expect(
          authState.session.evidenceSource,
          SessionEvidenceSource.persistedVerifiedSessionOffline,
        );
        expect(condition, AuthConnectionCondition.offlineOrBackendUnreachable);
      },
    );

    test(
      'confirmed 401 token rejection transitions to reauthenticationRequired',
      () async {
        driver.cachedSession = RawProviderSessionSnapshot(
          userId: 'acc-expired',
          email: 'expired@example.com',
          emailConfirmedAt: DateTime.utc(2026, 9, 28),
        );
        driver.refreshError = const AuthException(
          'Refresh token revoked',
          statusCode: '401',
          code: 'refresh_token_not_found',
        );

        final (state, condition) = await gateway.restoreInitialSession();

        expect(state, isA<AuthReauthenticationRequiredState>());
        expect(condition, AuthConnectionCondition.normal);
      },
    );

    test(
      'ingestAuthCallbackUri rejects untrusted redirect origins and validates recovery context',
      () async {
        final untrusted = await gateway.ingestAuthCallbackUri(
          Uri.parse('https://evil.example.org/callback?type=recovery'),
        );
        expect(untrusted, isA<AuthFailureOutcome<AuthAccountState>>());

        driver.callbackResult = (
          RawProviderSessionSnapshot(
            userId: 'acc-rec',
            email: 'recover@example.com',
            emailConfirmedAt: DateTime.utc(2026, 9, 29),
          ),
          true,
        );
        final trusted = await gateway.ingestAuthCallbackUri(
          Uri.parse('io.streakup.app://auth-callback?type=recovery'),
        );
        expect(trusted, isA<AuthSuccess<AuthAccountState>>());
        final nextState = (trusted as AuthSuccess<AuthAccountState>).value;
        expect(nextState.canAccessPasswordResetForm, isTrue);

        driver.updatePasswordResult = RawProviderSessionSnapshot(
          userId: 'acc-rec',
          email: 'recover@example.com',
          emailConfirmedAt: DateTime.utc(2026, 9, 29),
        );
        final updated = await gateway.submitNewPassword(
          newPassword: 'newStrongPassword99',
        );
        expect(updated, isA<AuthSuccess<AuthAccountState>>());
      },
    );
  });
}
