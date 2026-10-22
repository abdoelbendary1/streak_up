import 'package:streak_up/features/auth/domain/entities/auth_session.dart';
import 'package:streak_up/features/auth/domain/failures/auth_failure.dart';

enum AuthEventKind {
  restored,
  signedIn,
  refreshed,
  updated,
  signedOut,
  recovery,
  failure,
}

/// Domain event for authentication state and lifecycle updates.
class AuthEvent {
  const AuthEvent(this.kind, {this.session, this.failure});

  final AuthEventKind kind;
  final AuthSession? session;
  final AuthFailure? failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthEvent &&
          runtimeType == other.runtimeType &&
          kind == other.kind &&
          session == other.session &&
          failure == other.failure;

  @override
  int get hashCode => Object.hash(kind, session, failure);
}
