/// SDK-free evidence of a user's authentication session.
class AuthSession {
  const AuthSession({
    required this.userId,
    required this.email,
    required this.emailVerified,
    required this.expiresAt,
  });

  final String userId;
  final String? email;
  final bool emailVerified;

  /// Known token expiry; null when the token or its expiry evidence is missing.
  final DateTime? expiresAt;

  bool get accessTokenValid {
    final expiry = expiresAt;
    if (expiry == null) return false;
    // Preserve the SDK's thirty-second latency margin without caching validity.
    return DateTime.now().add(const Duration(seconds: 30)).isBefore(expiry);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthSession &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          email == other.email &&
          emailVerified == other.emailVerified &&
          expiresAt == other.expiresAt;

  @override
  int get hashCode => Object.hash(userId, email, emailVerified, expiresAt);
}
