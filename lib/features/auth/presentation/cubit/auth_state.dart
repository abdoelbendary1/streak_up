import 'package:flutter/foundation.dart';
import 'package:streak_up/features/auth/domain/entities/auth_entities.dart';
import 'package:streak_up/features/auth/domain/failures/auth_failure.dart';
import 'package:streak_up/features/auth/presentation/validation/auth_input_validator.dart';

enum AuthStatus {
  restoring,
  signedOut,
  verificationRequired,
  authenticated,
  recoveryRequired,
  signingOut,
  reauthenticationRequired,
}

@immutable
class AuthState {
  const AuthState({
    this.status = AuthStatus.restoring,
    this.session,
    this.isSubmitting = false,
    this.failure,
    this.inputErrors = const AuthInputErrors(),
    this.recoveryEmail,
    String? verificationEmail,
  }) : _verificationEmail = verificationEmail;

  const AuthState.restoring() : this(status: AuthStatus.restoring);

  final AuthStatus status;
  final AuthSession? session;
  final bool isSubmitting;
  final AuthFailure? failure;
  final AuthInputErrors inputErrors;
  final String? recoveryEmail;
  final String? _verificationEmail;

  /// True when verified account evidence is admitted and active.
  bool get canAccessProtected =>
      status == AuthStatus.authenticated &&
      session != null &&
      session!.emailVerified &&
      session!.accessTokenValid;

  String? get verificationEmail => session?.email ?? _verificationEmail;

  AuthState copyWith({
    AuthStatus? status,
    AuthSession? session,
    bool clearSession = false,
    bool? isSubmitting,
    AuthFailure? failure,
    bool clearFailure = false,
    AuthInputErrors? inputErrors,
    bool clearInputErrors = false,
    String? recoveryEmail,
    bool clearRecoveryEmail = false,
    String? verificationEmail,
    bool clearVerificationEmail = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      session: clearSession ? null : (session ?? this.session),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      failure: clearFailure ? null : (failure ?? this.failure),
      inputErrors: clearInputErrors
          ? const AuthInputErrors()
          : (inputErrors ?? this.inputErrors),
      recoveryEmail: clearRecoveryEmail
          ? null
          : (recoveryEmail ?? this.recoveryEmail),
      verificationEmail: clearVerificationEmail
          ? null
          : (verificationEmail ?? _verificationEmail),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          session == other.session &&
          isSubmitting == other.isSubmitting &&
          failure == other.failure &&
          inputErrors == other.inputErrors &&
          recoveryEmail == other.recoveryEmail &&
          _verificationEmail == other._verificationEmail;

  @override
  int get hashCode => Object.hash(
    status,
    session,
    isSubmitting,
    failure,
    inputErrors,
    recoveryEmail,
    _verificationEmail,
  );

  @override
  String toString() =>
      'AuthState(status: $status, isSubmitting: $isSubmitting, failure: $failure, userId: ${session?.userId})';
}
