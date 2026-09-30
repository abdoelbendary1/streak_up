import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:streak_up/features/auth/application/auth_session_coordinator.dart';
import 'package:streak_up/features/auth/domain/auth_models.dart';

/// Presentation-level informational banner keys for auth screens (`T019`).
enum AuthInfoMessageKey { verificationEmailResent, recoveryEmailResent }

/// Immutable presentation state for `AuthCubit` (`T019`).
@immutable
class AuthState {
  const AuthState({
    this.accountState = const AuthAccountState.restoring(),
    this.connectionCondition = AuthConnectionCondition.normal,
    this.transitionEpoch = 0,
    this.isSubmitting = false,
    this.activeFailure,
    this.infoMessageKey,
    this.activeExitPrompt,
    this.lastRecoveryReceipt,
  });

  final AuthAccountState accountState;
  final AuthConnectionCondition connectionCondition;
  final int transitionEpoch;
  final bool isSubmitting;
  final AuthFailure? activeFailure;
  final AuthInfoMessageKey? infoMessageKey;
  final PendingAccountExitPrompt? activeExitPrompt;
  final PasswordRecoveryRequestReceipt? lastRecoveryReceipt;

  AuthAccountStatus get status => accountState.status;

  AccountId? get activeAccountId => accountState.activeAccountId;

  String? get pendingVerificationEmail => switch (accountState) {
    AuthVerificationRequiredState(:final email) => email,
    _ => null,
  };

  AuthState copyWith({
    AuthAccountState? accountState,
    AuthConnectionCondition? connectionCondition,
    int? transitionEpoch,
    bool? isSubmitting,
    AuthFailure? activeFailure,
    bool clearFailure = false,
    AuthInfoMessageKey? infoMessageKey,
    bool clearInfoMessage = false,
    PendingAccountExitPrompt? activeExitPrompt,
    bool clearActiveExitPrompt = false,
    PasswordRecoveryRequestReceipt? lastRecoveryReceipt,
  }) {
    return AuthState(
      accountState: accountState ?? this.accountState,
      connectionCondition: connectionCondition ?? this.connectionCondition,
      transitionEpoch: transitionEpoch ?? this.transitionEpoch,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      activeFailure: clearFailure
          ? null
          : (activeFailure ?? this.activeFailure),
      infoMessageKey: clearInfoMessage
          ? null
          : (infoMessageKey ?? this.infoMessageKey),
      activeExitPrompt: clearActiveExitPrompt
          ? null
          : (activeExitPrompt ?? this.activeExitPrompt),
      lastRecoveryReceipt: lastRecoveryReceipt ?? this.lastRecoveryReceipt,
    );
  }

  @override
  String toString() =>
      'AuthState(status: ${status.name}, epoch: $transitionEpoch, isSubmitting: $isSubmitting)';
}

/// Presentation Cubit driving all SL-02 authentication, verification, recovery,
/// and account-switch/sign-out warning screens (`T019`).
@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._coordinator)
    : super(_fromCoordinatorSnapshot(_coordinator.snapshot)) {
    _lastObservedCallbackFailure = _coordinator.snapshot.lastCallbackFailure;
    _subscription = _coordinator.stream.listen((snapshot) {
      if (!isClosed) {
        final callbackFailure = snapshot.lastCallbackFailure;
        final hasNewCallbackFailure =
            callbackFailure != null &&
            !identical(callbackFailure, _lastObservedCallbackFailure);
        final callbackFailureWasCleared =
            callbackFailure == null && _lastObservedCallbackFailure != null;
        final previousCallbackFailure = _lastObservedCallbackFailure;
        _lastObservedCallbackFailure = callbackFailure;
        emit(
          state.copyWith(
            accountState: snapshot.accountState,
            connectionCondition: snapshot.connectionCondition,
            transitionEpoch: snapshot.transitionEpoch,
            activeExitPrompt: snapshot.activeExitPrompt,
            clearActiveExitPrompt: snapshot.activeExitPrompt == null,
            lastRecoveryReceipt: snapshot.lastRecoveryReceipt,
            activeFailure: hasNewCallbackFailure
                ? callbackFailure
                : state.activeFailure,
            clearFailure:
                callbackFailureWasCleared &&
                identical(state.activeFailure, previousCallbackFailure),
          ),
        );
      }
    });
  }

  final AuthSessionCoordinator _coordinator;
  StreamSubscription<AuthCoordinatorSnapshot>? _subscription;
  AuthFailure? _lastObservedCallbackFailure;

  static AuthState _fromCoordinatorSnapshot(AuthCoordinatorSnapshot snapshot) {
    return AuthState(
      accountState: snapshot.accountState,
      connectionCondition: snapshot.connectionCondition,
      transitionEpoch: snapshot.transitionEpoch,
      activeExitPrompt: snapshot.activeExitPrompt,
      lastRecoveryReceipt: snapshot.lastRecoveryReceipt,
    );
  }

  Future<void> restoreInitialSession() async {
    emit(state.copyWith(isSubmitting: true, clearFailure: true));
    final snapshot = await _coordinator.restoreInitialSession();
    if (!isClosed) {
      emit(
        state.copyWith(
          accountState: snapshot.accountState,
          connectionCondition: snapshot.connectionCondition,
          transitionEpoch: snapshot.transitionEpoch,
          isSubmitting: false,
        ),
      );
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        clearFailure: true,
        clearInfoMessage: true,
      ),
    );
    final outcome = await _coordinator.signIn(email: email, password: password);
    if (isClosed) return false;

    return switch (outcome) {
      AuthSuccess<AuthAccountState>() => () {
        emit(state.copyWith(isSubmitting: false, clearFailure: true));
        return true;
      }(),
      AuthFailureOutcome<AuthAccountState>(:final failure) => () {
        emit(state.copyWith(isSubmitting: false, activeFailure: failure));
        return false;
      }(),
    };
  }

  Future<bool> register({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      emit(
        state.copyWith(
          activeFailure: const AuthFailure(AuthFailureCode.passwordMismatch),
          clearInfoMessage: true,
        ),
      );
      return false;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        clearFailure: true,
        clearInfoMessage: true,
      ),
    );
    final outcome = await _coordinator.register(
      email: email,
      password: password,
    );
    if (isClosed) return false;

    return switch (outcome) {
      AuthSuccess<AuthAccountState>() => () {
        emit(state.copyWith(isSubmitting: false, clearFailure: true));
        return true;
      }(),
      AuthFailureOutcome<AuthAccountState>(:final failure) => () {
        emit(state.copyWith(isSubmitting: false, activeFailure: failure));
        return false;
      }(),
    };
  }

  Future<bool> checkEmailVerification({String? email}) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        clearFailure: true,
        clearInfoMessage: true,
      ),
    );
    final outcome = await _coordinator.checkEmailVerification(email: email);
    if (isClosed) return false;

    return switch (outcome) {
      AuthSuccess<AuthAccountState>() => () {
        emit(state.copyWith(isSubmitting: false, clearFailure: true));
        return true;
      }(),
      AuthFailureOutcome<AuthAccountState>(:final failure) => () {
        emit(state.copyWith(isSubmitting: false, activeFailure: failure));
        return false;
      }(),
    };
  }

  Future<bool> resendVerificationEmail({String? email}) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        clearFailure: true,
        clearInfoMessage: true,
      ),
    );
    final outcome = await _coordinator.resendVerificationEmail(email: email);
    if (isClosed) return false;

    return switch (outcome) {
      AuthSuccess<void>() => () {
        emit(
          state.copyWith(
            isSubmitting: false,
            infoMessageKey: AuthInfoMessageKey.verificationEmailResent,
          ),
        );
        return true;
      }(),
      AuthFailureOutcome<void>(:final failure) => () {
        emit(state.copyWith(isSubmitting: false, activeFailure: failure));
        return false;
      }(),
    };
  }

  Future<bool> requestPasswordRecovery({required String email}) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        clearFailure: true,
        clearInfoMessage: true,
      ),
    );
    final outcome = await _coordinator.requestPasswordRecovery(email: email);
    if (isClosed) return false;

    return switch (outcome) {
      AuthSuccess<PasswordRecoveryRequestReceipt>(:final value) => () {
        emit(
          state.copyWith(
            isSubmitting: false,
            lastRecoveryReceipt: value,
            clearFailure: true,
          ),
        );
        return true;
      }(),
      AuthFailureOutcome<PasswordRecoveryRequestReceipt>(:final failure) => () {
        emit(state.copyWith(isSubmitting: false, activeFailure: failure));
        return false;
      }(),
    };
  }

  Future<bool> resendPasswordRecovery() async {
    final email = state.lastRecoveryReceipt?.submittedEmail;
    if (email == null || email.trim().isEmpty) {
      return false;
    }
    emit(
      state.copyWith(
        isSubmitting: true,
        clearFailure: true,
        clearInfoMessage: true,
      ),
    );
    final outcome = await _coordinator.requestPasswordRecovery(email: email);
    if (isClosed) return false;

    return switch (outcome) {
      AuthSuccess<PasswordRecoveryRequestReceipt>(:final value) => () {
        emit(
          state.copyWith(
            isSubmitting: false,
            lastRecoveryReceipt: value,
            infoMessageKey: AuthInfoMessageKey.recoveryEmailResent,
          ),
        );
        return true;
      }(),
      AuthFailureOutcome<PasswordRecoveryRequestReceipt>(:final failure) => () {
        emit(state.copyWith(isSubmitting: false, activeFailure: failure));
        return false;
      }(),
    };
  }

  Future<bool> submitNewPassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (newPassword != confirmPassword) {
      emit(
        state.copyWith(
          activeFailure: const AuthFailure(AuthFailureCode.passwordMismatch),
          clearInfoMessage: true,
        ),
      );
      return false;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        clearFailure: true,
        clearInfoMessage: true,
      ),
    );
    final outcome = await _coordinator.submitRecoveredPassword(
      newPassword: newPassword,
    );
    if (isClosed) return false;

    return switch (outcome) {
      AuthSuccess<AuthAccountState>() => () {
        emit(state.copyWith(isSubmitting: false, clearFailure: true));
        return true;
      }(),
      AuthFailureOutcome<AuthAccountState>(:final failure) => () {
        emit(state.copyWith(isSubmitting: false, activeFailure: failure));
        return false;
      }(),
    };
  }

  Future<bool> requestSignOut({bool forceAfterWarning = false}) {
    return _coordinator.requestSignOut(forceAfterWarning: forceAfterWarning);
  }

  Future<bool> requestAccountSwitch({
    bool forceAfterWarning = false,
    String? nextEmail,
    String? nextPassword,
  }) {
    return _coordinator.requestAccountSwitch(
      forceAfterWarning: forceAfterWarning,
      nextEmail: nextEmail,
      nextPassword: nextPassword,
    );
  }

  void cancelPendingExitPrompt() {
    _coordinator.cancelPendingExitPrompt();
  }

  Future<void> confirmPendingExitPrompt() {
    return _coordinator.confirmPendingExitPrompt();
  }

  void clearFeedback() {
    emit(state.copyWith(clearFailure: true, clearInfoMessage: true));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
