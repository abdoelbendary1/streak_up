import 'package:flutter/foundation.dart';

/// Non-empty, immutable account identifier (`T005`, `SL02-FR-008`–`011`).
///
/// Used as the sole authority for active account ownership and transition epoch
/// validation across session switches.
@immutable
class AccountId {
  AccountId(String raw) : value = raw.trim() {
    if (value.isEmpty) {
      throw ArgumentError.value(raw, 'raw', 'AccountId must not be empty.');
    }
  }

  final String value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is AccountId && other.value == value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'AccountId(redacted)';
}

/// Source of verification evidence for an authenticated account session (`SL02-FR-006`).
enum SessionEvidenceSource {
  /// Confirmed directly against the remote authentication service.
  remoteSessionVerified,

  /// Restored while offline from previously verified persisted session evidence on this device.
  persistedVerifiedSessionOffline,
}

/// Verified session evidence required before entering the protected SL-01 shell (`T005`, `SL02-FR-003`, `SL02-FR-006`).
@immutable
class VerifiedAccountSession {
  const VerifiedAccountSession({
    required this.accountId,
    required this.email,
    required this.verifiedAt,
    required this.evidenceSource,
  });

  final AccountId accountId;
  final String email;
  final DateTime verifiedAt;
  final SessionEvidenceSource evidenceSource;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VerifiedAccountSession &&
        other.accountId == accountId &&
        other.email == email &&
        other.verifiedAt == verifiedAt &&
        other.evidenceSource == evidenceSource;
  }

  @override
  int get hashCode =>
      Object.hash(accountId, email, verifiedAt, evidenceSource);
}

/// Finite, explicit account/session states (`T005`, `SL02-FR-003`–`007`).
///
/// Account state is never represented by a single boolean flag.
enum AuthAccountStatus {
  restoring,
  signedOut,
  verificationRequired,
  authenticated,
  reauthenticationRequired,
}

/// Connectivity condition orthogonal to account validity (`T005`, `SL02-FR-006`–`007`).
///
/// Transport or backend reachability issues must never be conflated with
/// confirmed session invalidation (`reauthenticationRequired`).
enum AuthConnectionCondition {
  normal,
  offlineOrBackendUnreachable,
}

/// Explicit discriminated domain representation of the current account session state (`T005`).
@immutable
sealed class AuthAccountState {
  const AuthAccountState();

  const factory AuthAccountState.restoring() = AuthRestoringState;

  const factory AuthAccountState.signedOut({
    bool hasValidatedPasswordResetContext,
    String? recoveryEmail,
  }) = AuthSignedOutState;

  const factory AuthAccountState.verificationRequired({
    required String email,
    AccountId? accountId,
  }) = AuthVerificationRequiredState;

  const factory AuthAccountState.authenticated({
    required VerifiedAccountSession session,
    bool hasValidatedPasswordResetContext,
  }) = AuthAuthenticatedState;

  const factory AuthAccountState.reauthenticationRequired({
    AccountId? previousAccountId,
    String? emailHint,
  }) = AuthReauthenticationRequiredState;

  AuthAccountStatus get status;

  AccountId? get activeAccountId => switch (this) {
    AuthAuthenticatedState(:final session) => session.accountId,
    _ => null,
  };

  bool get isAuthenticatedVerified => this is AuthAuthenticatedState;

  bool get canAccessPasswordResetForm => switch (this) {
    AuthSignedOutState(:final hasValidatedPasswordResetContext) =>
      hasValidatedPasswordResetContext,
    AuthAuthenticatedState(:final hasValidatedPasswordResetContext) =>
      hasValidatedPasswordResetContext,
    _ => false,
  };
}

final class AuthRestoringState extends AuthAccountState {
  const AuthRestoringState();

  @override
  AuthAccountStatus get status => AuthAccountStatus.restoring;

  @override
  bool operator ==(Object other) => other is AuthRestoringState;

  @override
  int get hashCode => (AuthRestoringState).hashCode;
}

final class AuthSignedOutState extends AuthAccountState {
  const AuthSignedOutState({
    this.hasValidatedPasswordResetContext = false,
    this.recoveryEmail,
  });

  final bool hasValidatedPasswordResetContext;
  final String? recoveryEmail;

  @override
  AuthAccountStatus get status => AuthAccountStatus.signedOut;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthSignedOutState &&
          other.hasValidatedPasswordResetContext ==
              hasValidatedPasswordResetContext &&
          other.recoveryEmail == recoveryEmail);

  @override
  int get hashCode =>
      Object.hash(hasValidatedPasswordResetContext, recoveryEmail);
}

final class AuthVerificationRequiredState extends AuthAccountState {
  const AuthVerificationRequiredState({
    required this.email,
    this.accountId,
  });

  final String email;
  final AccountId? accountId;

  @override
  AuthAccountStatus get status => AuthAccountStatus.verificationRequired;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthVerificationRequiredState &&
          other.email == email &&
          other.accountId == accountId);

  @override
  int get hashCode => Object.hash(email, accountId);
}

final class AuthAuthenticatedState extends AuthAccountState {
  const AuthAuthenticatedState({
    required this.session,
    this.hasValidatedPasswordResetContext = false,
  });

  final VerifiedAccountSession session;
  final bool hasValidatedPasswordResetContext;

  @override
  AuthAccountStatus get status => AuthAccountStatus.authenticated;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthAuthenticatedState &&
          other.session == session &&
          other.hasValidatedPasswordResetContext ==
              hasValidatedPasswordResetContext);

  @override
  int get hashCode => Object.hash(session, hasValidatedPasswordResetContext);
}

final class AuthReauthenticationRequiredState extends AuthAccountState {
  const AuthReauthenticationRequiredState({
    this.previousAccountId,
    this.emailHint,
  });

  final AccountId? previousAccountId;
  final String? emailHint;

  @override
  AuthAccountStatus get status => AuthAccountStatus.reauthenticationRequired;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthReauthenticationRequiredState &&
          other.previousAccountId == previousAccountId &&
          other.emailHint == emailHint);

  @override
  int get hashCode => Object.hash(previousAccountId, emailHint);
}

/// Finite failure categories for authentication operations (`T005`, `SL02-FR-001`–`007`).
enum AuthFailureCode {
  invalidCredentials,
  emailAlreadyInUse,
  weakPassword,
  passwordMismatch,
  invalidEmail,
  verificationStillPending,
  verificationLinkExpiredOrInvalid,
  recoveryLinkExpiredOrInvalid,
  rateLimited,
  networkOrBackendUnreachable,
  sessionInvalidated,
  unexpected,
}

/// Privacy-safe failure descriptor that never exposes raw provider error messages or tokens.
@immutable
class AuthFailure {
  const AuthFailure(
    this.code, {
    this.isTransportFailure = false,
  });

  final AuthFailureCode code;
  final bool isTransportFailure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthFailure &&
          other.code == code &&
          other.isTransportFailure == isTransportFailure);

  @override
  int get hashCode => Object.hash(code, isTransportFailure);
}

/// Typed outcome for auth operations (`T005`).
@immutable
sealed class AuthOutcome<T> {
  const AuthOutcome();

  const factory AuthOutcome.success(T value) = AuthSuccess<T>;
  const factory AuthOutcome.failure(AuthFailure failure) =
      AuthFailureOutcome<T>;
}

final class AuthSuccess<T> extends AuthOutcome<T> {
  const AuthSuccess(this.value);
  final T value;
}

final class AuthFailureOutcome<T> extends AuthOutcome<T> {
  const AuthFailureOutcome(this.failure);
  final AuthFailure failure;
}

/// Generic, non-enumerating acknowledgment returned by password recovery requests (`SL02-FR-005`, `SL02-AS-07`).
@immutable
class PasswordRecoveryRequestReceipt {
  const PasswordRecoveryRequestReceipt({required this.submittedEmail});

  /// Kept only in ephemeral UI state to support resend on SL02-UI-004B; never logged.
  final String submittedEmail;
}

/// Gateway-emitted session/lifecycle signal (`T006`, `T008`).
@immutable
sealed class AuthGatewaySignal {
  const AuthGatewaySignal();
}

final class AuthGatewayStateChangedSignal extends AuthGatewaySignal {
  const AuthGatewayStateChangedSignal({
    required this.accountState,
    this.connectionCondition = AuthConnectionCondition.normal,
  });

  final AuthAccountState accountState;
  final AuthConnectionCondition connectionCondition;
}

final class AuthGatewayPasswordRecoveryReadySignal extends AuthGatewaySignal {
  const AuthGatewayPasswordRecoveryReadySignal({
    this.accountId,
    this.email,
  });

  final AccountId? accountId;
  final String? email;
}
