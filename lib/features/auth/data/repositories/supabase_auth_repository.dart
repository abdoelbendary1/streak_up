import 'dart:async';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:streak_up/app/config/supabase_config.dart';
import 'package:streak_up/core/logging/app_logger.dart';
import 'package:streak_up/features/auth/data/storage/secure_auth_storage.dart';
import 'package:streak_up/features/auth/domain/entities/auth_session.dart';
import 'package:streak_up/features/auth/domain/events/auth_event.dart';
import 'package:streak_up/features/auth/domain/failures/auth_failure.dart';
import 'package:streak_up/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._supabase, this._storage, this._logger);

  final SupabaseClient _supabase;
  final SecureAuthStorage _storage;
  final AppLogger _logger;

  AuthSession? _toAuthSession(Session? session) {
    if (session == null || session.user.id.isEmpty) return null;
    final expirySeconds = session.expiresAt;
    return AuthSession(
      userId: session.user.id,
      email: session.user.email,
      emailVerified:
          DateTime.tryParse(session.user.emailConfirmedAt ?? '') != null,
      expiresAt: session.accessToken.isNotEmpty && expirySeconds != null
          ? DateTime.fromMillisecondsSinceEpoch(
              expirySeconds * 1000,
              isUtc: true,
            )
          : null,
    );
  }

  @override
  AuthSession? get currentSession =>
      _toAuthSession(_supabase.auth.currentSession);

  @override
  Stream<AuthEvent> get events => _supabase.auth.onAuthStateChange.transform(
    StreamTransformer<AuthState, AuthEvent>.fromHandlers(
      handleData: (event, sink) {
        if (event.event == AuthChangeEvent.passwordRecovery) {
          _storage.markRecovery().catchError((Object _) {});
        }
        final kind = switch (event.event) {
          AuthChangeEvent.initialSession => AuthEventKind.restored,
          AuthChangeEvent.signedIn => AuthEventKind.signedIn,
          AuthChangeEvent.tokenRefreshed => AuthEventKind.refreshed,
          AuthChangeEvent.signedOut => AuthEventKind.signedOut,
          AuthChangeEvent.passwordRecovery => AuthEventKind.recovery,
          _ => AuthEventKind.updated,
        };
        sink.add(AuthEvent(kind, session: _toAuthSession(event.session)));
      },
      handleError: (error, stack, sink) => sink.add(
        AuthEvent(AuthEventKind.failure, failure: _mapFailure(error)),
      ),
    ),
  );

  AuthFailure _mapFailure(Object error) {
    if (error is AuthStorageException) return AuthFailure.storage;
    if (error is AuthRetryableFetchException) return AuthFailure.network;
    if (error is AuthException) {
      if (error.statusCode == '429' ||
          error.code == 'over_email_send_rate_limit' ||
          error.code == 'over_request_rate_limit') {
        return AuthFailure.rateLimited;
      }
      if (error.code == 'email_not_confirmed') {
        return AuthFailure.verificationStillPending;
      }
      if (error.code == 'user_already_exists') {
        return AuthFailure.emailAlreadyInUse;
      }
      if (error.code == 'email_address_invalid') {
        return AuthFailure.invalidEmail;
      }
      final status = int.tryParse(error.statusCode ?? '');
      if (status != null && status >= 500) return AuthFailure.network;
      if (error.code == 'weak_password') return AuthFailure.weakPassword;
      if (error.code == 'invalid_credentials') {
        return AuthFailure.invalidCredentials;
      }
      if (const {
        'session_not_found',
        'refresh_token_not_found',
        'refresh_token_already_used',
        'bad_jwt',
      }.contains(error.code)) {
        return AuthFailure.invalidSession;
      }
      return AuthFailure.rejected;
    }
    if (error is _MissingAuthSession) return AuthFailure.sessionMissing;
    return AuthFailure.unexpected;
  }

  bool _hasValidSession(Session? session) =>
      session != null &&
      session.user.id.isNotEmpty &&
      session.accessToken.isNotEmpty &&
      session.expiresAt != null &&
      !session.isExpired;

  // Drain SDK persistence after errors before mapping them: a latched storage
  // failure takes precedence over an SDK failure. Initial health failures skip SDK work.
  @override
  Future<Either<AuthFailure, AuthSession?>> restoreSession() async {
    try {
      await _storage.checkHealth();
      try {
        final session = _supabase.auth.currentSession;
        if (session == null) {
          await _storage.removePersistedSession();
          await _storage.checkHealth();
          return const Right(null);
        }
        Session? resolved = session;
        if (session.isExpired) {
          final response = await _supabase.auth.refreshSession();
          resolved = response.session ?? session;
        }
        await _storage.persistSession(jsonEncode(resolved.toJson()));
        await _storage.checkHealth();
        return Right(_toAuthSession(resolved));
      } catch (_) {
        await _storage.checkHealth();
        rethrow;
      }
    } catch (error) {
      return Left(_mapFailure(error));
    }
  }

  @override
  Future<Either<AuthFailure, AuthSession>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _storage.checkHealth();
      try {
        _logger.info('auth.sign_in.started');
        final response = await _supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
        if (!_hasValidSession(response.session)) {
          throw const _MissingAuthSession();
        }
        final session = _supabase.auth.currentSession;
        if (session == null) {
          await _storage.removePersistedSession();
        } else {
          await _storage.persistSession(jsonEncode(session.toJson()));
        }
        await _storage.checkHealth();
        _logger.info('auth.sign_in.succeeded');
        return Right(_toAuthSession(response.session)!);
      } catch (_) {
        _logger.warning('auth.sign_in.failed');
        await _storage.checkHealth();
        rethrow;
      }
    } catch (error) {
      return Left(_mapFailure(error));
    }
  }

  @override
  Future<Either<AuthFailure, AuthSession?>> register({
    required String email,
    required String password,
  }) async {
    try {
      await _storage.checkHealth();
      try {
        final response = await _supabase.auth.signUp(
          email: email,
          password: password,
          emailRedirectTo: SupabaseConfig.authRedirectUrl,
        );
        final session = _supabase.auth.currentSession;
        if (session == null) {
          await _storage.removePersistedSession();
        } else {
          await _storage.persistSession(jsonEncode(session.toJson()));
        }
        await _storage.checkHealth();
        return Right(_toAuthSession(response.session));
      } catch (_) {
        await _storage.checkHealth();
        rethrow;
      }
    } catch (error) {
      return Left(_mapFailure(error));
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> requestPasswordRecovery(
    String email,
  ) async {
    try {
      await _storage.checkHealth();
      try {
        await _supabase.auth.resetPasswordForEmail(
          email,
          redirectTo: SupabaseConfig.authRedirectUrl,
        );
        await _storage.checkHealth();
      } on AuthException catch (error) {
        await _storage.checkHealth();
        if (!{'user_not_found', 'email_not_found'}.contains(error.code)) {
          rethrow;
        }
      } catch (_) {
        await _storage.checkHealth();
        rethrow;
      }

      return const Right(unit);
    } catch (error) {
      return Left(_mapFailure(error));
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> resendVerificationEmail(
    String email,
  ) async {
    try {
      await _storage.checkHealth();
      try {
        await _supabase.auth.resend(
          type: OtpType.signup,
          email: email,
          emailRedirectTo: SupabaseConfig.authRedirectUrl,
        );
        await _storage.checkHealth();
      } catch (_) {
        await _storage.checkHealth();
        rethrow;
      }

      return const Right(unit);
    } catch (error) {
      return Left(_mapFailure(error));
    }
  }

  @override
  Future<Either<AuthFailure, AuthSession?>> checkVerification() async {
    try {
      await _storage.checkHealth();
      try {
        if (_supabase.auth.currentSession == null) {
          await _storage.checkHealth();
          return const Right(null);
        }
        final response = await _supabase.auth.refreshSession();
        final session = response.session;
        if (session == null) {
          await _storage.removePersistedSession();
        } else {
          await _storage.persistSession(jsonEncode(session.toJson()));
        }
        await _storage.checkHealth();
        return Right(_toAuthSession(session));
      } catch (_) {
        await _storage.checkHealth();
        rethrow;
      }
    } catch (error) {
      return Left(_mapFailure(error));
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> submitNewPassword(
    String newPassword,
  ) async {
    final expectedUserId = currentSession?.userId;
    try {
      await _storage.checkHealth();
      try {
        final before = _supabase.auth.currentSession;
        if (!_hasValidSession(before) || before!.user.id != expectedUserId) {
          throw const _MissingAuthSession();
        }
        final result = await _supabase.auth.updateUser(
          UserAttributes(password: newPassword),
        );
        if (result.user == null || result.user!.id != before.user.id) {
          throw const _MissingAuthSession();
        }
        await _storage.completeRecovery();
        final session = _supabase.auth.currentSession;
        if (session == null) {
          await _storage.removePersistedSession();
        } else {
          await _storage.persistSession(jsonEncode(session.toJson()));
        }
        await _storage.checkHealth();
      } catch (_) {
        await _storage.checkHealth();
        rethrow;
      }

      return const Right(unit);
    } catch (error) {
      return Left(_mapFailure(error));
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signOut() async {
    try {
      await _storage.checkHealth();
      try {
        await _supabase.auth.signOut(scope: SignOutScope.local);
        await _storage.pkceStorage.removeItem(
          key: SecureAuthStorage.legacyPkceKey,
        );
        await _storage.removePersistedSession();
        await _storage.checkHealth();
      } catch (_) {
        await _storage.checkHealth();
        rethrow;
      }

      return const Right(unit);
    } catch (error) {
      return Left(_mapFailure(error));
    }
  }
}

class _MissingAuthSession implements Exception {
  const _MissingAuthSession();
}
