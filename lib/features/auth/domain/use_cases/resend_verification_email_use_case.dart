import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:streak_up/features/auth/domain/failures/auth_failure.dart';
import 'package:streak_up/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class ResendVerificationEmailUseCase {
  const ResendVerificationEmailUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<AuthFailure, Unit>> call(String email) {
    return _repository.resendVerificationEmail(email);
  }
}
