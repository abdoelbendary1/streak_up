import 'package:streak_up/features/auth/domain/auth_models.dart';

/// Clean Architecture authentication gateway boundary (`T006`, `Architecture A-06`, `SL02-FR-001`–`007`).
///
/// Isolates all `supabase_flutter` SDK types inside the data layer.
abstract interface class AuthGateway {
  /// Asynchronous stream of session, verification, recovery, and invalidation signals.
  Stream<AuthGatewaySignal> get signals;

  /// Restores the initial account state from remote or persisted verified session evidence (`T012`, `SL02-FR-006`).
  Future<(AuthAccountState, AuthConnectionCondition)> restoreInitialSession();

  /// Creates an account with email and password (`T009`, `SL02-FR-001`, `SL02-FR-003`).
  Future<AuthOutcome<AuthAccountState>> registerWithEmailPassword({
    required String email,
    required String password,
  });

  /// Signs in with email and password (`T009`, `SL02-FR-002`, `SL02-FR-003`).
  Future<AuthOutcome<AuthAccountState>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  /// Refreshes the user session to check if email verification has completed (`T010`, `SL02-FR-003`, `SL02-FR-004`).
  Future<AuthOutcome<AuthAccountState>> checkEmailVerificationStatus({
    required String email,
  });

  /// Resends the verification link to the pending email address (`T010`, `SL02-FR-004`).
  Future<AuthOutcome<void>> resendVerificationEmail({required String email});

  /// Requests a password recovery link (`T011`, `SL02-FR-005`).
  ///
  /// Always returns a generic [PasswordRecoveryRequestReceipt] when input and transport
  /// succeed so account existence cannot be enumerated (`SL02-AS-07`).
  Future<AuthOutcome<PasswordRecoveryRequestReceipt>> requestPasswordRecovery({
    required String email,
  });

  /// Processes an allowlisted deep-link callback URI for email verification or password recovery (`T010`, `T011`, `T024`).
  Future<AuthOutcome<AuthAccountState>> ingestAuthCallbackUri(Uri callbackUri);

  /// Updates the user's password inside a validated recovery context (`T011`, `SL02-FR-005`, `SL02-AS-08`).
  Future<AuthOutcome<AuthAccountState>> submitNewPassword({
    required String newPassword,
  });

  /// Ends the active provider session on this device (`T012`, `SL02-FR-008`).
  Future<AuthOutcome<void>> signOut();

  /// Releases any internal subscriptions.
  Future<void> dispose();
}
