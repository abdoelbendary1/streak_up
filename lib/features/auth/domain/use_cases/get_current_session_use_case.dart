import 'package:injectable/injectable.dart';
import 'package:streak_up/features/auth/domain/entities/auth_entities.dart';
import 'package:streak_up/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class GetCurrentSessionUseCase {
  const GetCurrentSessionUseCase(this._repository);

  final AuthRepository _repository;

  AuthSession? call() => _repository.currentSession;
}
