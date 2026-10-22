import 'package:dartz/dartz.dart';
import 'package:streak_up/features/auth/domain/entities/auth_entities.dart';
import 'package:streak_up/features/auth/domain/events/auth_event.dart';
import 'package:streak_up/features/auth/domain/failures/auth_failure.dart';

/// SDK-free contract for authentication operations.
/// All methods return [Either] with domain [AuthFailure] on the left.
abstract interface class AuthRepository {
  Stream<AuthEvent> get events;
  AuthSession? get currentSession;

  Future<Either<AuthFailure, AuthSession?>> restoreSession();

  Future<Either<AuthFailure, AuthSession>> signIn({
    required String email,
    required String password,
  });

  Future<Either<AuthFailure, AuthSession?>> register({
    required String email,
    required String password,
  });

  Future<Either<AuthFailure, Unit>> requestPasswordRecovery(String email);

  Future<Either<AuthFailure, Unit>> resendVerificationEmail(String email);

  Future<Either<AuthFailure, AuthSession?>> checkVerification();

  Future<Either<AuthFailure, Unit>> submitNewPassword(String newPassword);

  Future<Either<AuthFailure, Unit>> signOut();
}
