import 'package:injectable/injectable.dart';
import 'package:streak_up/features/auth/domain/events/auth_event.dart';
import 'package:streak_up/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class WatchAuthEventsUseCase {
  const WatchAuthEventsUseCase(this._repository);

  final AuthRepository _repository;

  Stream<AuthEvent> call() => _repository.events;
}
