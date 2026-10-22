import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:streak_up/features/auth/domain/events/auth_event.dart';
import 'package:streak_up/features/auth/domain/failures/auth_failure.dart';
import 'package:streak_up/features/auth/domain/use_cases/auth_use_cases.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_state.dart';
import 'package:streak_up/features/auth/presentation/validation/auth_input_validator.dart';

export 'auth_state.dart';

/// Single app-side owner of authentication presentation and lifecycle state.
@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required WatchAuthEventsUseCase watchAuthEventsUseCase,
    required GetCurrentSessionUseCase getCurrentSessionUseCase,
    required RestoreSessionUseCase restoreSessionUseCase,
    required SignInUseCase signInUseCase,
    required RegisterUseCase registerUseCase,
    required RequestPasswordRecoveryUseCase requestPasswordRecoveryUseCase,
    required ResendVerificationEmailUseCase resendVerificationEmailUseCase,
    required CheckVerificationUseCase checkVerificationUseCase,
    required SubmitNewPasswordUseCase submitNewPasswordUseCase,
    required SignOutUseCase signOutUseCase,
  }) : _getCurrentSessionUseCase = getCurrentSessionUseCase,
       _restoreSessionUseCase = restoreSessionUseCase,
       _signInUseCase = signInUseCase,
       _registerUseCase = registerUseCase,
       _requestPasswordRecoveryUseCase = requestPasswordRecoveryUseCase,
       _resendVerificationEmailUseCase = resendVerificationEmailUseCase,
       _checkVerificationUseCase = checkVerificationUseCase,
       _submitNewPasswordUseCase = submitNewPasswordUseCase,
       _signOutUseCase = signOutUseCase,
       super(const AuthState.restoring()) {
    _subscription = watchAuthEventsUseCase().listen(
      _handleAuthEvent,
      onError: (Object error) {
        if (!isClosed) {
          emit(state.copyWith(failure: AuthFailure.unexpected));
        }
      },
    );
  }

  final GetCurrentSessionUseCase _getCurrentSessionUseCase;
  final RestoreSessionUseCase _restoreSessionUseCase;
  final SignInUseCase _signInUseCase;
  final RegisterUseCase _registerUseCase;
  final RequestPasswordRecoveryUseCase _requestPasswordRecoveryUseCase;
  final ResendVerificationEmailUseCase _resendVerificationEmailUseCase;
  final CheckVerificationUseCase _checkVerificationUseCase;
  final SubmitNewPasswordUseCase _submitNewPasswordUseCase;
  final SignOutUseCase _signOutUseCase;

  late final StreamSubscription<AuthEvent> _subscription;
  final _validator = const AuthInputValidator();

  void _handleAuthEvent(AuthEvent event) {
    if (isClosed) return;
    // SDK logout events precede the awaited network/storage result.
    if (state.status == AuthStatus.signingOut) return;

    // Stale event rule: delayed Account A event cannot replace Account B.
    if (event.session != null &&
        state.session != null &&
        state.status == AuthStatus.authenticated &&
        event.session!.userId != state.session!.userId) {
      return;
    }

    switch (event.kind) {
      case AuthEventKind.restored:
      case AuthEventKind.signedIn:
      case AuthEventKind.refreshed:
      case AuthEventKind.updated:
        final session = event.session;
        if (session == null) {
          emit(
            state.copyWith(
              status: AuthStatus.signedOut,
              clearSession: true,
              clearFailure: true,
            ),
          );
        } else if (session.emailVerified) {
          emit(
            state.copyWith(
              status: AuthStatus.authenticated,
              session: session,
              clearFailure: true,
              clearRecoveryEmail: true,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: AuthStatus.verificationRequired,
              session: session,
              clearFailure: true,
            ),
          );
        }
      case AuthEventKind.signedOut:
        emit(
          state.copyWith(
            status: AuthStatus.signedOut,
            clearSession: true,
            clearRecoveryEmail: true,
            clearVerificationEmail: true,
            clearInputErrors: true,
          ),
        );
      case AuthEventKind.recovery:
        emit(
          state.copyWith(
            status: AuthStatus.recoveryRequired,
            clearFailure: true,
          ),
        );
      case AuthEventKind.failure:
        if (event.failure == AuthFailure.invalidSession) {
          emit(
            state.copyWith(
              status: AuthStatus.reauthenticationRequired,
              failure: event.failure,
              clearSession: true,
            ),
          );
        } else if (event.failure != null) {
          emit(state.copyWith(failure: event.failure));
        }
    }
  }

  Future<bool> restore() async {
    if (isClosed || state.isSubmitting) return false;
    final before = state;
    emit(
      state.copyWith(
        status: AuthStatus.restoring,
        isSubmitting: true,
        clearFailure: true,
      ),
    );

    final result = await _restoreSessionUseCase();
    if (isClosed) return false;

    return result.fold(
      (failure) {
        if (failure == AuthFailure.invalidSession) {
          emit(
            state.copyWith(
              status: AuthStatus.reauthenticationRequired,
              clearSession: true,
              isSubmitting: false,
              failure: failure,
            ),
          );
          return false;
        }
        if (failure == AuthFailure.network) {
          final localSession = _getCurrentSessionUseCase();
          if (localSession != null) {
            // A failed refresh does not prove invalidation or erase identity.
            // Existing access-token checks still guard protected content.
            var status = localSession.emailVerified
                ? AuthStatus.authenticated
                : AuthStatus.verificationRequired;
            if (before.status == AuthStatus.recoveryRequired ||
                state.status == AuthStatus.recoveryRequired) {
              status = AuthStatus.recoveryRequired;
            } else if (before.status == AuthStatus.reauthenticationRequired ||
                state.status == AuthStatus.reauthenticationRequired) {
              status = AuthStatus.reauthenticationRequired;
            }
            emit(
              state.copyWith(
                status: status,
                session: localSession,
                isSubmitting: false,
                failure: failure,
              ),
            );
            return false;
          }
        }
        emit(
          state.copyWith(
            status: AuthStatus.signedOut,
            clearSession: true,
            isSubmitting: false,
            failure: failure,
          ),
        );
        return false;
      },
      (session) {
        if (session == null) {
          emit(
            state.copyWith(
              status: AuthStatus.signedOut,
              clearSession: true,
              isSubmitting: false,
              clearFailure: true,
            ),
          );
          return true;
        }
        if (!session.accessTokenValid) {
          emit(
            state.copyWith(
              status: AuthStatus.reauthenticationRequired,
              clearSession: true,
              isSubmitting: false,
              failure: AuthFailure.invalidSession,
            ),
          );
          return false;
        }
        var status = session.emailVerified
            ? AuthStatus.authenticated
            : AuthStatus.verificationRequired;
        if (before.status == AuthStatus.recoveryRequired ||
            state.status == AuthStatus.recoveryRequired) {
          status = AuthStatus.recoveryRequired;
        }
        emit(
          state.copyWith(
            status: status,
            session: session,
            isSubmitting: false,
            clearFailure: true,
          ),
        );
        return true;
      },
    );
  }

  Future<bool> signIn({required String email, required String password}) async {
    if (isClosed || state.isSubmitting) return false;

    final normalized = _validator.normalizeEmail(email);
    final errors = _validator.email(normalized);

    if (!errors.isEmpty) {
      emit(state.copyWith(inputErrors: errors, clearFailure: true));
      return false;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        clearFailure: true,
        clearInputErrors: true,
      ),
    );

    final result = await _signInUseCase(email: normalized, password: password);
    if (isClosed) return false;

    return result.fold(
      (failure) {
        if (failure == AuthFailure.verificationStillPending) {
          emit(
            state.copyWith(
              status: AuthStatus.verificationRequired,
              verificationEmail: normalized,
              isSubmitting: false,
              failure: failure,
            ),
          );
          return false;
        }
        emit(state.copyWith(isSubmitting: false, failure: failure));
        return false;
      },
      (session) {
        if (session.emailVerified) {
          emit(
            state.copyWith(
              status: AuthStatus.authenticated,
              session: session,
              isSubmitting: false,
              clearFailure: true,
              clearRecoveryEmail: true,
            ),
          );
          return true;
        }
        emit(
          state.copyWith(
            status: AuthStatus.verificationRequired,
            session: session,
            isSubmitting: false,
            clearFailure: true,
          ),
        );
        return true;
      },
    );
  }

  Future<bool> register({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (isClosed || state.isSubmitting) return false;

    final normalized = _validator.normalizeEmail(email);
    final errors = _validator.registration(
      normalized,
      password,
      confirmPassword,
    );

    if (!errors.isEmpty) {
      emit(state.copyWith(inputErrors: errors, clearFailure: true));
      return false;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        clearFailure: true,
        clearInputErrors: true,
      ),
    );

    final result = await _registerUseCase(
      email: normalized,
      password: password,
    );
    if (isClosed) return false;

    return result.fold(
      (failure) {
        emit(state.copyWith(isSubmitting: false, failure: failure));
        return false;
      },
      (session) {
        if (session?.emailVerified == true) {
          emit(
            state.copyWith(
              status: AuthStatus.authenticated,
              session: session,
              isSubmitting: false,
              clearFailure: true,
            ),
          );
          return true;
        }
        emit(
          state.copyWith(
            status: AuthStatus.verificationRequired,
            session: session,
            clearSession: session == null,
            verificationEmail: normalized,
            isSubmitting: false,
            clearFailure: true,
          ),
        );
        return true;
      },
    );
  }

  Future<bool> requestPasswordRecovery(String email) async {
    if (isClosed || state.isSubmitting) return false;

    final normalized = _validator.normalizeEmail(email);
    final errors = _validator.email(normalized);

    if (!errors.isEmpty) {
      emit(state.copyWith(inputErrors: errors, clearFailure: true));
      return false;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        clearFailure: true,
        clearInputErrors: true,
      ),
    );

    final result = await _requestPasswordRecoveryUseCase(normalized);
    if (isClosed) return false;

    return result.fold(
      (failure) {
        emit(state.copyWith(isSubmitting: false, failure: failure));
        return false;
      },
      (_) {
        emit(
          state.copyWith(
            isSubmitting: false,
            recoveryEmail: normalized,
            clearFailure: true,
          ),
        );
        return true;
      },
    );
  }

  Future<bool> resendPasswordRecovery() async {
    if (isClosed) return false;
    final email = state.recoveryEmail;
    if (email == null) {
      emit(state.copyWith(failure: AuthFailure.rejected));
      return false;
    }
    return requestPasswordRecovery(email);
  }

  Future<bool> resendVerificationEmail() async {
    if (isClosed || state.isSubmitting) return false;

    final email = state.verificationEmail;
    if (email == null) {
      emit(state.copyWith(failure: AuthFailure.rejected));
      return false;
    }

    emit(state.copyWith(isSubmitting: true, clearFailure: true));

    final result = await _resendVerificationEmailUseCase(email);
    if (isClosed) return false;

    return result.fold(
      (failure) {
        emit(state.copyWith(isSubmitting: false, failure: failure));
        return false;
      },
      (_) {
        emit(state.copyWith(isSubmitting: false, clearFailure: true));
        return true;
      },
    );
  }

  Future<bool> checkVerification() async {
    if (isClosed || state.isSubmitting) return false;

    emit(state.copyWith(isSubmitting: true, clearFailure: true));

    final result = await _checkVerificationUseCase();
    if (isClosed) return false;

    return result.fold(
      (failure) {
        emit(state.copyWith(isSubmitting: false, failure: failure));
        return false;
      },
      (session) {
        if (session?.emailVerified == true) {
          emit(
            state.copyWith(
              status: AuthStatus.authenticated,
              session: session,
              isSubmitting: false,
              clearFailure: true,
            ),
          );
          return true;
        }
        emit(
          state.copyWith(
            status: AuthStatus.verificationRequired,
            session: session ?? state.session,
            isSubmitting: false,
            failure: AuthFailure.verificationStillPending,
          ),
        );
        return false;
      },
    );
  }

  Future<bool> submitNewPassword(
    String newPassword, {
    required String confirmPassword,
  }) async {
    if (isClosed || state.isSubmitting) return false;

    final errors = _validator.password(newPassword, confirmPassword);
    if (!errors.isEmpty) {
      emit(state.copyWith(inputErrors: errors, clearFailure: true));
      return false;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        clearFailure: true,
        clearInputErrors: true,
      ),
    );

    final result = await _submitNewPasswordUseCase(newPassword);
    if (isClosed) return false;

    return result.fold(
      (failure) {
        emit(state.copyWith(isSubmitting: false, failure: failure));
        return false;
      },
      (_) {
        emit(
          state.copyWith(
            status: AuthStatus.signedOut,
            clearSession: true,
            isSubmitting: false,
            clearFailure: true,
            clearRecoveryEmail: true,
          ),
        );
        return true;
      },
    );
  }

  Future<bool> signOut() async {
    if (isClosed || state.isSubmitting) return false;
    final before = state;

    // Close access while the command determines whether local logout completed.
    emit(
      state.copyWith(
        status: AuthStatus.signingOut,
        isSubmitting: true,
        clearFailure: true,
      ),
    );

    final result = await _signOutUseCase();
    if (isClosed) return false;

    return result.fold(
      (failure) {
        final localSession = _getCurrentSessionUseCase();
        // Health checks can fail before SDK logout; later failures may happen
        // after SDK session removal but before credential cleanup completes.
        var status = before.status;
        if (localSession == null) {
          status = AuthStatus.reauthenticationRequired;
        } else if (status == AuthStatus.restoring ||
            status == AuthStatus.signingOut) {
          status = localSession.emailVerified
              ? AuthStatus.authenticated
              : AuthStatus.verificationRequired;
        }
        emit(
          before.copyWith(
            status: status,
            session: localSession,
            clearSession: localSession == null,
            isSubmitting: false,
            failure: failure,
          ),
        );
        return false;
      },
      (_) {
        emit(
          state.copyWith(
            status: AuthStatus.signedOut,
            clearSession: true,
            isSubmitting: false,
            clearFailure: true,
            clearRecoveryEmail: true,
            clearVerificationEmail: true,
            clearInputErrors: true,
          ),
        );
        return true;
      },
    );
  }

  @override
  @disposeMethod
  Future<void> close() async {
    await _subscription.cancel();
    await super.close();
  }
}
