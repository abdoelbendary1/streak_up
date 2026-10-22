import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:streak_up/features/auth/domain/entities/auth_entities.dart';
import 'package:streak_up/features/auth/domain/failures/auth_failure.dart';
import 'package:streak_up/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class SignInUseCase {
  const SignInUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<AuthFailure, AuthSession>> call({
    required String email,
    required String password,
  }) {
    return _repository.signIn(email: email, password: password);
  }
}
