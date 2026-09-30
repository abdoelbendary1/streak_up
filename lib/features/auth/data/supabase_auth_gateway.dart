import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:streak_up/app/bootstrap/app_logger.dart';
import 'package:streak_up/app/bootstrap/supabase_environment.dart';
import 'package:streak_up/features/auth/domain/auth_gateway.dart';
import 'package:streak_up/features/auth/domain/auth_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Snapshot of a provider user/session used by [SupabaseAuthGateway] to map SDK
/// responses into domain models without leaking `supabase_flutter` types (`T008`).
@immutable
class RawProviderSessionSnapshot {
  const RawProviderSessionSnapshot({
    required this.userId,
    required this.email,
    this.emailConfirmedAt,
    this.hasActiveAccessToken = true,
  });

  final String userId;
  final String email;
  final DateTime? emailConfirmedAt;
  final bool hasActiveAccessToken;

  bool get isEmailVerified => emailConfirmedAt != null;
}

/// Raw provider auth event mapped from `supabase_flutter` (`T008`).
enum RawProviderAuthEventKind {
  initialSession,
  signedIn,
  tokenRefreshed,
  userUpdated,
  passwordRecovery,
  signedOut,
}

@immutable
class RawProviderAuthEvent {
  const RawProviderAuthEvent({
    required this.kind,
    this.session,
  });

  final RawProviderAuthEventKind kind;
  final RawProviderSessionSnapshot? session;
}

/// Internal adapter wrapping `GoTrueClient` so `SupabaseAuthGateway` uses the
/// real `supabase_flutter` SDK in production while remaining deterministically
/// testable in unit tests (`T008`–`T013`).
abstract interface class SupabaseAuthClientDriver {
  Stream<RawProviderAuthEvent> get onAuthStateChange;
  RawProviderSessionSnapshot? get currentSession;

  Future<RawProviderSessionSnapshot?> signUp({
    required String email,
    required String password,
    required String emailRedirectTo,
  });

  Future<RawProviderSessionSnapshot?> signInWithPassword({
    required String email,
    required String password,
  });

  Future<RawProviderSessionSnapshot?> refreshOrFetchUser();

  Future<void> resendSignupVerification({
    required String email,
    required String emailRedirectTo,
  });

  Future<void> resetPasswordForEmail({
    required String email,
    required String redirectTo,
  });

  Future<(RawProviderSessionSnapshot?, bool isPasswordRecovery)>
      getSessionFromUrl(Uri callbackUri);

  Future<RawProviderSessionSnapshot?> updatePassword(String newPassword);

  Future<void> signOut();
}

/// Production driver backed directly by `Supabase.instance.client.auth` (`GoTrueClient`).
class GoTrueSupabaseAuthClientDriver implements SupabaseAuthClientDriver {
  GoTrueSupabaseAuthClientDriver(this._auth);

  final GoTrueClient _auth;

  @override
  Stream<RawProviderAuthEvent> get onAuthStateChange {
    return _auth.onAuthStateChange.map((authState) {
      final kind = switch (authState.event) {
        AuthChangeEvent.initialSession =>
          RawProviderAuthEventKind.initialSession,
        AuthChangeEvent.signedIn => RawProviderAuthEventKind.signedIn,
        AuthChangeEvent.tokenRefreshed =>
          RawProviderAuthEventKind.tokenRefreshed,
        AuthChangeEvent.userUpdated => RawProviderAuthEventKind.userUpdated,
        AuthChangeEvent.passwordRecovery =>
          RawProviderAuthEventKind.passwordRecovery,
        AuthChangeEvent.signedOut => RawProviderAuthEventKind.signedOut,
        _ => RawProviderAuthEventKind.userUpdated,
      };
      return RawProviderAuthEvent(
        kind: kind,
        session: _snapshotFromUserAndSession(
          authState.session?.user ?? _auth.currentUser,
          authState.session,
        ),
      );
    });
  }

  @override
  RawProviderSessionSnapshot? get currentSession =>
      _snapshotFromUserAndSession(_auth.currentUser, _auth.currentSession);

  @override
  Future<RawProviderSessionSnapshot?> signUp({
    required String email,
    required String password,
    required String emailRedirectTo,
  }) async {
    final response = await _auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: emailRedirectTo,
    );
    return _snapshotFromUserAndSession(response.user, response.session);
  }

  @override
  Future<RawProviderSessionSnapshot?> signInWithPassword({
    required String email,
    required String password,
  }) async {
    final response = await _auth.signInWithPassword(
      email: email,
      password: password,
    );
    return _snapshotFromUserAndSession(response.user, response.session);
  }

  @override
  Future<RawProviderSessionSnapshot?> refreshOrFetchUser() async {
    final refreshed = await _auth.refreshSession();
    if (refreshed.user != null || refreshed.session != null) {
      return _snapshotFromUserAndSession(refreshed.user, refreshed.session);
    }
    final userResponse = await _auth.getUser();
    return _snapshotFromUserAndSession(userResponse.user, _auth.currentSession);
  }

  @override
  Future<void> resendSignupVerification({
    required String email,
    required String emailRedirectTo,
  }) async {
    await _auth.resend(
      type: OtpType.signup,
      email: email,
      emailRedirectTo: emailRedirectTo,
    );
  }

  @override
  Future<void> resetPasswordForEmail({
    required String email,
    required String redirectTo,
  }) async {
    await _auth.resetPasswordForEmail(email, redirectTo: redirectTo);
  }

  @override
  Future<(RawProviderSessionSnapshot?, bool isPasswordRecovery)>
      getSessionFromUrl(Uri callbackUri) async {
    final response = await _auth.getSessionFromUrl(callbackUri);
    final isRecovery = response.redirectType?.toLowerCase() == 'recovery' ||
        callbackUri.queryParameters['type']?.toLowerCase() == 'recovery' ||
        callbackUri.fragment.toLowerCase().contains('type=recovery');
    return (
      _snapshotFromUserAndSession(response.session.user, response.session),
      isRecovery,
    );
  }

  @override
  Future<RawProviderSessionSnapshot?> updatePassword(String newPassword) async {
    final response = await _auth.updateUser(
      UserAttributes(password: newPassword),
    );
    return _snapshotFromUserAndSession(response.user, _auth.currentSession);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  static RawProviderSessionSnapshot? _snapshotFromUserAndSession(
    User? user,
    Session? session,
  ) {
    final effectiveUser = user ?? session?.user;
    if (effectiveUser == null || effectiveUser.id.trim().isEmpty) {
      return null;
    }
    DateTime? confirmedAt;
    if (effectiveUser.emailConfirmedAt != null) {
      confirmedAt = DateTime.tryParse(effectiveUser.emailConfirmedAt!);
    }
    return RawProviderSessionSnapshot(
      userId: effectiveUser.id,
      email: effectiveUser.email ?? '',
      emailConfirmedAt: confirmedAt,
      hasActiveAccessToken:
          session != null && session.accessToken.trim().isNotEmpty,
    );
  }
}

/// Data-layer implementation of [AuthGateway] backed by `supabase_flutter` (`T008`–`T012`).
@LazySingleton(as: AuthGateway)
class SupabaseAuthGateway implements AuthGateway {
  SupabaseAuthGateway(
    this._driver,
    this._environmentConfig,
    this._logger,
  ) {
    _subscription = _driver.onAuthStateChange.listen(_handleProviderAuthEvent);
  }

  final SupabaseAuthClientDriver _driver;
  final SupabaseEnvironmentConfig _environmentConfig;
  final AppLogger _logger;

  final StreamController<AuthGatewaySignal> _signalController =
      StreamController<AuthGatewaySignal>.broadcast();
  StreamSubscription<RawProviderAuthEvent>? _subscription;

  AccountId? _lastVerifiedAccountId;
  String? _lastKnownEmail;
  bool _hasValidatedPasswordResetContext = false;
  bool _voluntarySignOutInProgress = false;

  @override
  Stream<AuthGatewaySignal> get signals => _signalController.stream;

  void _handleProviderAuthEvent(RawProviderAuthEvent event) {
    switch (event.kind) {
      case RawProviderAuthEventKind.passwordRecovery:
        _hasValidatedPasswordResetContext = true;
        final session = event.session;
        final accountId =
            session != null ? AccountId(session.userId) : _lastVerifiedAccountId;
        _signalController.add(
          AuthGatewayPasswordRecoveryReadySignal(
            accountId: accountId,
            email: session?.email ?? _lastKnownEmail,
          ),
        );
      case RawProviderAuthEventKind.signedIn:
      case RawProviderAuthEventKind.tokenRefreshed:
      case RawProviderAuthEventKind.userUpdated:
      case RawProviderAuthEventKind.initialSession:
        final snapshot = event.session;
        if (snapshot == null) {
          return;
        }
        final mapped = _mapSnapshotToState(
          snapshot,
          evidenceSource: SessionEvidenceSource.remoteSessionVerified,
        );
        _signalController.add(
          AuthGatewayStateChangedSignal(accountState: mapped),
        );
      case RawProviderAuthEventKind.signedOut:
        if (_voluntarySignOutInProgress) {
          return;
        }
        // If an authenticated session was previously active and the provider
        // involuntarily drops the session, require explicit re-authentication (`SL02-FR-007`).
        if (_lastVerifiedAccountId != null) {
          final previousId = _lastVerifiedAccountId;
          final previousEmail = _lastKnownEmail;
          _lastVerifiedAccountId = null;
          _signalController.add(
            AuthGatewayStateChangedSignal(
              accountState: AuthAccountState.reauthenticationRequired(
                previousAccountId: previousId,
                emailHint: previousEmail,
              ),
            ),
          );
        } else {
          _signalController.add(
            const AuthGatewayStateChangedSignal(
              accountState: AuthAccountState.signedOut(),
            ),
          );
        }
    }
  }

  @override
  Future<(AuthAccountState, AuthConnectionCondition)>
      restoreInitialSession() async {
    final cached = _driver.currentSession;
    if (cached == null) {
      return (
        const AuthAccountState.signedOut(),
        AuthConnectionCondition.normal,
      );
    }

    if (!cached.isEmailVerified) {
      _lastKnownEmail = cached.email;
      return (
        AuthAccountState.verificationRequired(
          email: cached.email,
          accountId: AccountId(cached.userId),
        ),
        AuthConnectionCondition.normal,
      );
    }

    // Attempt to refresh/validate with the remote provider (`SL02-FR-006`).
    try {
      final refreshed = await _driver.refreshOrFetchUser();
      if (refreshed == null) {
        return (
          AuthAccountState.reauthenticationRequired(
            previousAccountId: AccountId(cached.userId),
            emailHint: cached.email,
          ),
          AuthConnectionCondition.normal,
        );
      }
      final state = _mapSnapshotToState(
        refreshed,
        evidenceSource: SessionEvidenceSource.remoteSessionVerified,
      );
      return (state, AuthConnectionCondition.normal);
    } catch (error) {
      // Transport/offline errors must NOT invalidate a persisted verified session (`SL02-FR-006`, `SL02-AS-09`–`10`).
      if (_isTransportOrReachabilityError(error)) {
        _logger.info(
          'auth.restore.offline_preserved',
          metadata: <String, Object?>{
            'networkState': 'offline',
          },
        );
        final offlineState = _mapSnapshotToState(
          cached,
          evidenceSource:
              SessionEvidenceSource.persistedVerifiedSessionOffline,
        );
        return (
          offlineState,
          AuthConnectionCondition.offlineOrBackendUnreachable,
        );
      }

      // Confirmed auth/token rejection transitions to reauthenticationRequired (`SL02-FR-007`).
      _logger.warning(
        'auth.restore.invalidated',
        metadata: <String, Object?>{
          'errorType': error.runtimeType.toString(),
        },
      );
      return (
        AuthAccountState.reauthenticationRequired(
          previousAccountId: AccountId(cached.userId),
          emailHint: cached.email,
        ),
        AuthConnectionCondition.normal,
      );
    }
  }

  @override
  Future<AuthOutcome<AuthAccountState>> registerWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim();
    if (!_isValidEmail(normalizedEmail)) {
      return const AuthOutcome.failure(
        AuthFailure(AuthFailureCode.invalidEmail),
      );
    }
    if (password.length < 8) {
      return const AuthOutcome.failure(
        AuthFailure(AuthFailureCode.weakPassword),
      );
    }

    try {
      final snapshot = await _driver.signUp(
        email: normalizedEmail,
        password: password,
        emailRedirectTo: _environmentConfig.authRedirectUri,
      );
      if (snapshot == null) {
        _lastKnownEmail = normalizedEmail;
        return AuthOutcome.success(
          AuthAccountState.verificationRequired(email: normalizedEmail),
        );
      }
      final state = _mapSnapshotToState(
        snapshot,
        evidenceSource: SessionEvidenceSource.remoteSessionVerified,
        fallbackEmail: normalizedEmail,
      );
      return AuthOutcome.success(state);
    } catch (error) {
      return AuthOutcome.failure(_mapErrorToFailure(error));
    }
  }

  @override
  Future<AuthOutcome<AuthAccountState>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim();
    if (!_isValidEmail(normalizedEmail)) {
      return const AuthOutcome.failure(
        AuthFailure(AuthFailureCode.invalidEmail),
      );
    }
    if (password.isEmpty) {
      return const AuthOutcome.failure(
        AuthFailure(AuthFailureCode.invalidCredentials),
      );
    }

    try {
      final snapshot = await _driver.signInWithPassword(
        email: normalizedEmail,
        password: password,
      );
      if (snapshot == null) {
        return const AuthOutcome.failure(
          AuthFailure(AuthFailureCode.invalidCredentials),
        );
      }
      final state = _mapSnapshotToState(
        snapshot,
        evidenceSource: SessionEvidenceSource.remoteSessionVerified,
        fallbackEmail: normalizedEmail,
      );
      return AuthOutcome.success(state);
    } catch (error) {
      final failure = _mapErrorToFailure(error);
      // If Supabase rejects sign-in specifically because email is not confirmed yet,
      // route the user to the email verification gate (`SL02-FR-003`, `SL02-AS-04`).
      if (failure.code == AuthFailureCode.verificationStillPending) {
        _lastKnownEmail = normalizedEmail;
        return AuthOutcome.success(
          AuthAccountState.verificationRequired(email: normalizedEmail),
        );
      }
      return AuthOutcome.failure(failure);
    }
  }

  @override
  Future<AuthOutcome<AuthAccountState>> checkEmailVerificationStatus({
    required String email,
  }) async {
    final targetEmail = email.trim().isNotEmpty
        ? email.trim()
        : (_lastKnownEmail ?? '');
    try {
      final snapshot = await _driver.refreshOrFetchUser();
      if (snapshot == null || !snapshot.isEmailVerified) {
        return const AuthOutcome.failure(
          AuthFailure(AuthFailureCode.verificationStillPending),
        );
      }
      final state = _mapSnapshotToState(
        snapshot,
        evidenceSource: SessionEvidenceSource.remoteSessionVerified,
        fallbackEmail: targetEmail,
      );
      return AuthOutcome.success(state);
    } catch (error) {
      final failure = _mapErrorToFailure(error);
      if (failure.isTransportFailure) {
        return AuthOutcome.failure(failure);
      }
      return const AuthOutcome.failure(
        AuthFailure(AuthFailureCode.verificationStillPending),
      );
    }
  }

  @override
  Future<AuthOutcome<void>> resendVerificationEmail({
    required String email,
  }) async {
    final targetEmail = email.trim().isNotEmpty
        ? email.trim()
        : (_lastKnownEmail ?? '');
    if (!_isValidEmail(targetEmail)) {
      return const AuthOutcome.failure(
        AuthFailure(AuthFailureCode.invalidEmail),
      );
    }
    try {
      await _driver.resendSignupVerification(
        email: targetEmail,
        emailRedirectTo: _environmentConfig.authRedirectUri,
      );
      return const AuthOutcome.success(null);
    } catch (error) {
      return AuthOutcome.failure(_mapErrorToFailure(error));
    }
  }

  @override
  Future<AuthOutcome<PasswordRecoveryRequestReceipt>> requestPasswordRecovery({
    required String email,
  }) async {
    final normalizedEmail = email.trim();
    if (!_isValidEmail(normalizedEmail)) {
      return const AuthOutcome.failure(
        AuthFailure(AuthFailureCode.invalidEmail),
      );
    }
    try {
      await _driver.resetPasswordForEmail(
        email: normalizedEmail,
        redirectTo: _environmentConfig.authRedirectUri,
      );
      _lastKnownEmail = normalizedEmail;
      return AuthOutcome.success(
        PasswordRecoveryRequestReceipt(submittedEmail: normalizedEmail),
      );
    } catch (error) {
      final failure = _mapErrorToFailure(error);
      // Only surface transport/rate-limit failures; never disclose whether an
      // account exists for the submitted email address (`SL02-FR-005`, `SL02-AS-07`).
      if (failure.isTransportFailure ||
          failure.code == AuthFailureCode.rateLimited) {
        return AuthOutcome.failure(failure);
      }
      _lastKnownEmail = normalizedEmail;
      return AuthOutcome.success(
        PasswordRecoveryRequestReceipt(submittedEmail: normalizedEmail),
      );
    }
  }

  @override
  Future<AuthOutcome<AuthAccountState>> ingestAuthCallbackUri(
    Uri callbackUri,
  ) async {
    if (!_environmentConfig.isAllowedCallbackUri(callbackUri)) {
      return const AuthOutcome.failure(
        AuthFailure(AuthFailureCode.verificationLinkExpiredOrInvalid),
      );
    }

    try {
      final (snapshot, isPasswordRecovery) =
          await _driver.getSessionFromUrl(callbackUri);
      if (isPasswordRecovery) {
        _hasValidatedPasswordResetContext = true;
        if (snapshot != null && snapshot.isEmailVerified) {
          final state = _mapSnapshotToState(
            snapshot,
            evidenceSource: SessionEvidenceSource.remoteSessionVerified,
            hasValidatedPasswordResetContext: true,
          );
          return AuthOutcome.success(state);
        }
        return AuthOutcome.success(
          AuthAccountState.signedOut(
            hasValidatedPasswordResetContext: true,
            recoveryEmail: snapshot?.email ?? _lastKnownEmail,
          ),
        );
      }

      if (snapshot == null) {
        return const AuthOutcome.failure(
          AuthFailure(AuthFailureCode.verificationLinkExpiredOrInvalid),
        );
      }

      final state = _mapSnapshotToState(
        snapshot,
        evidenceSource: SessionEvidenceSource.remoteSessionVerified,
      );
      return AuthOutcome.success(state);
    } catch (error) {
      final isRecoveryCallback =
          callbackUri.queryParameters['type']?.toLowerCase() == 'recovery' ||
              callbackUri.fragment.toLowerCase().contains('type=recovery');
      final failure = _mapErrorToFailure(
        error,
        isRecoveryLink: isRecoveryCallback,
        isVerificationLink: !isRecoveryCallback,
      );
      return AuthOutcome.failure(failure);
    }
  }

  @override
  Future<AuthOutcome<AuthAccountState>> submitNewPassword({
    required String newPassword,
  }) async {
    if (!_hasValidatedPasswordResetContext) {
      return const AuthOutcome.failure(
        AuthFailure(AuthFailureCode.recoveryLinkExpiredOrInvalid),
      );
    }
    if (newPassword.length < 8) {
      return const AuthOutcome.failure(
        AuthFailure(AuthFailureCode.weakPassword),
      );
    }

    try {
      final snapshot = await _driver.updatePassword(newPassword);
      _hasValidatedPasswordResetContext = false;
      if (snapshot != null && snapshot.isEmailVerified) {
        final state = _mapSnapshotToState(
          snapshot,
          evidenceSource: SessionEvidenceSource.remoteSessionVerified,
          hasValidatedPasswordResetContext: false,
        );
        return AuthOutcome.success(state);
      }
      return const AuthOutcome.success(AuthAccountState.signedOut());
    } catch (error) {
      return AuthOutcome.failure(
        _mapErrorToFailure(error, isRecoveryLink: true),
      );
    }
  }

  @override
  Future<AuthOutcome<void>> signOut() async {
    _voluntarySignOutInProgress = true;
    try {
      await _driver.signOut();
      _lastVerifiedAccountId = null;
      _hasValidatedPasswordResetContext = false;
      return const AuthOutcome.success(null);
    } catch (error) {
      // Even if remote sign-out encounters a transport error, clear local session state
      // so the device immediately leaves the account (`SL02-FR-008`).
      _lastVerifiedAccountId = null;
      _hasValidatedPasswordResetContext = false;
      final failure = _mapErrorToFailure(error);
      if (failure.isTransportFailure) {
        return const AuthOutcome.success(null);
      }
      return AuthOutcome.failure(failure);
    } finally {
      _voluntarySignOutInProgress = false;
    }
  }

  AuthAccountState _mapSnapshotToState(
    RawProviderSessionSnapshot snapshot, {
    required SessionEvidenceSource evidenceSource,
    String? fallbackEmail,
    bool? hasValidatedPasswordResetContext,
  }) {
    final resolvedEmail = snapshot.email.trim().isNotEmpty
        ? snapshot.email.trim()
        : (fallbackEmail ?? _lastKnownEmail ?? '');
    final accountId = AccountId(snapshot.userId);
    _lastKnownEmail = resolvedEmail;

    if (!snapshot.isEmailVerified) {
      return AuthAccountState.verificationRequired(
        email: resolvedEmail,
        accountId: accountId,
      );
    }

    _lastVerifiedAccountId = accountId;
    return AuthAccountState.authenticated(
      session: VerifiedAccountSession(
        accountId: accountId,
        email: resolvedEmail,
        verifiedAt: snapshot.emailConfirmedAt!,
        evidenceSource: evidenceSource,
      ),
      hasValidatedPasswordResetContext:
          hasValidatedPasswordResetContext ?? _hasValidatedPasswordResetContext,
    );
  }

  static bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  static bool _isTransportOrReachabilityError(Object error) {
    if (error is SocketException ||
        error is TimeoutException ||
        error is AuthRetryableFetchException) {
      return true;
    }
    final lower = error.toString().toLowerCase();
    return lower.contains('socketexception') ||
        lower.contains('failed host lookup') ||
        lower.contains('network is unreachable') ||
        lower.contains('connection refused') ||
        lower.contains('timed out');
  }

  static AuthFailure _mapErrorToFailure(
    Object error, {
    bool isRecoveryLink = false,
    bool isVerificationLink = false,
  }) {
    if (_isTransportOrReachabilityError(error)) {
      return const AuthFailure(
        AuthFailureCode.networkOrBackendUnreachable,
        isTransportFailure: true,
      );
    }

    if (error is AuthException) {
      final code = (error.code ?? '').toLowerCase();
      final msg = error.message.toLowerCase();
      if (code == 'email_not_confirmed' || msg.contains('email not confirmed')) {
        return const AuthFailure(AuthFailureCode.verificationStillPending);
      }
      if (code == 'user_already_exists' ||
          code == 'email_exists' ||
          msg.contains('already registered')) {
        return const AuthFailure(AuthFailureCode.emailAlreadyInUse);
      }
      if (code == 'weak_password' || msg.contains('password should be')) {
        return const AuthFailure(AuthFailureCode.weakPassword);
      }
      if (code == 'over_request_rate_limit' ||
          code == 'over_email_send_rate_limit' ||
          error.statusCode == '429') {
        return const AuthFailure(AuthFailureCode.rateLimited);
      }
      if (isRecoveryLink ||
          code == 'otp_expired' && isRecoveryLink ||
          msg.contains('recovery')) {
        return const AuthFailure(
          AuthFailureCode.recoveryLinkExpiredOrInvalid,
        );
      }
      if (isVerificationLink || code == 'otp_expired' || code == 'bad_jwt') {
        return const AuthFailure(
          AuthFailureCode.verificationLinkExpiredOrInvalid,
        );
      }
      if (code == 'invalid_credentials' ||
          msg.contains('invalid login credentials') ||
          error.statusCode == '400') {
        return const AuthFailure(AuthFailureCode.invalidCredentials);
      }
      if (error.statusCode == '401' ||
          error.statusCode == '403' ||
          code == 'session_not_found' ||
          code == 'refresh_token_not_found') {
        return const AuthFailure(AuthFailureCode.sessionInvalidated);
      }
    }

    if (isRecoveryLink) {
      return const AuthFailure(AuthFailureCode.recoveryLinkExpiredOrInvalid);
    }
    if (isVerificationLink) {
      return const AuthFailure(
        AuthFailureCode.verificationLinkExpiredOrInvalid,
      );
    }

    return const AuthFailure(AuthFailureCode.unexpected);
  }

  @override
  @disposeMethod
  Future<void> dispose() async {
    await _subscription?.cancel();
    await _signalController.close();
  }
}
