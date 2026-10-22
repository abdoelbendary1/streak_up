import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:streak_up/features/auth/domain/entities/auth_session.dart';
import 'package:streak_up/features/auth/domain/events/auth_event.dart';
import 'package:streak_up/features/auth/domain/failures/auth_failure.dart';
import 'package:streak_up/features/auth/domain/repositories/auth_repository.dart';
import 'package:streak_up/features/auth/domain/use_cases/auth_use_cases.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';

final testSessionA = AuthSession(
  userId: 'account-a',
  email: 'a@example.com',
  emailVerified: true,
  expiresAt: DateTime.now().add(const Duration(hours: 1)),
);

final testSessionB = AuthSession(
  userId: 'account-b',
  email: 'b@example.com',
  emailVerified: true,
  expiresAt: DateTime.now().add(const Duration(hours: 1)),
);

final unverifiedSessionA = AuthSession(
  userId: 'account-a',
  email: 'a@example.com',
  emailVerified: false,
  expiresAt: DateTime.now().add(const Duration(hours: 1)),
);

/// Creates an [AuthCubit] wired to the given [repository] using production UseCases.
AuthCubit createTestAuthCubit(AuthRepository repository) {
  return AuthCubit(
    watchAuthEventsUseCase: WatchAuthEventsUseCase(repository),
    getCurrentSessionUseCase: GetCurrentSessionUseCase(repository),
    restoreSessionUseCase: RestoreSessionUseCase(repository),
    signInUseCase: SignInUseCase(repository),
    registerUseCase: RegisterUseCase(repository),
    requestPasswordRecoveryUseCase: RequestPasswordRecoveryUseCase(repository),
    resendVerificationEmailUseCase: ResendVerificationEmailUseCase(repository),
    checkVerificationUseCase: CheckVerificationUseCase(repository),
    submitNewPasswordUseCase: SubmitNewPasswordUseCase(repository),
    signOutUseCase: SignOutUseCase(repository),
  );
}

class FakeAuthRepository implements AuthRepository {
  final controller = StreamController<AuthEvent>.broadcast(sync: true);

  @override
  Stream<AuthEvent> get events => controller.stream;

  @override
  AuthSession? currentSession;

  Either<AuthFailure, AuthSession?>? restoreResult;
  Either<AuthFailure, AuthSession> signInResult = Right(testSessionA);
  Either<AuthFailure, AuthSession?> registrationResult = const Right(null);
  Either<AuthFailure, Unit> emailResult = const Right(unit);
  Either<AuthFailure, AuthSession?>? verificationResult;
  Either<AuthFailure, Unit> resetResult = const Right(unit);
  Either<AuthFailure, Unit> signOutResult = const Right(unit);

  bool retainSessionOnSignOutFailure = false;
  final calls = <String>[];

  @override
  Future<Either<AuthFailure, AuthSession?>> restoreSession() async {
    calls.add('restoreSession');
    return restoreResult ?? Right(currentSession);
  }

  @override
  Future<Either<AuthFailure, AuthSession>> signIn({
    required String email,
    required String password,
  }) async {
    calls.add('signIn');
    signInResult.fold((_) {}, (session) {
      currentSession = session;
    });
    return signInResult;
  }

  @override
  Future<Either<AuthFailure, AuthSession?>> register({
    required String email,
    required String password,
  }) async {
    calls.add('register');
    registrationResult.fold((_) {}, (session) {
      currentSession = session;
    });
    return registrationResult;
  }

  @override
  Future<Either<AuthFailure, Unit>> requestPasswordRecovery(
    String email,
  ) async {
    calls.add('requestPasswordRecovery');
    return emailResult;
  }

  @override
  Future<Either<AuthFailure, Unit>> resendVerificationEmail(
    String email,
  ) async {
    calls.add('resendVerificationEmail');
    return emailResult;
  }

  @override
  Future<Either<AuthFailure, AuthSession?>> checkVerification() async {
    calls.add('checkVerification');
    verificationResult?.fold((_) {}, (session) {
      currentSession = session;
    });
    return verificationResult ?? Right(currentSession);
  }

  @override
  Future<Either<AuthFailure, Unit>> submitNewPassword(
    String newPassword,
  ) async {
    calls.add('submitNewPassword');
    return resetResult;
  }

  @override
  Future<Either<AuthFailure, Unit>> signOut() async {
    calls.add('signOut');
    return signOutResult.fold(
      (failure) {
        if (!retainSessionOnSignOutFailure) {
          currentSession = null;
        }
        return Left(failure);
      },
      (success) {
        currentSession = null;
        return const Right(unit);
      },
    );
  }

  void emitEvent(AuthEvent event) => controller.add(event);

  void dispose() {
    controller.close();
  }
}
