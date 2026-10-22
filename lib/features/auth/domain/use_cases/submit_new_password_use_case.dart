import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:streak_up/features/auth/domain/failures/auth_failure.dart';
import 'package:streak_up/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class SubmitNewPasswordUseCase {
  const SubmitNewPasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<AuthFailure, Unit>> call(String newPassword) {
    return _repository.submitNewPassword(newPassword);
  }
}
