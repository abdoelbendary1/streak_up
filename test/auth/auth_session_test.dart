import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/features/auth/domain/entities/auth_session.dart';

void main() {
  group('AuthSession token validity', () {
    test(
      'accessTokenValid is true when expiresAt is clearly in the future',
      () {
        final session = AuthSession(
          userId: 'user-123',
          email: 'test@example.com',
          emailVerified: true,
          expiresAt: DateTime.now().add(const Duration(minutes: 15)),
        );

        expect(session.accessTokenValid, isTrue);
      },
    );

    test('accessTokenValid is false when expiresAt is clearly in the past', () {
      final session = AuthSession(
        userId: 'user-123',
        email: 'test@example.com',
        emailVerified: true,
        expiresAt: DateTime.now().subtract(const Duration(minutes: 5)),
      );

      expect(session.accessTokenValid, isFalse);
    });

    test('accessTokenValid is false when expiresAt is null', () {
      const session = AuthSession(
        userId: 'user-123',
        email: 'test@example.com',
        emailVerified: true,
        expiresAt: null,
      );

      expect(session.accessTokenValid, isFalse);
    });

    test(
      'accessTokenValid respects 30-second safety margin (false within 30s, true beyond 30s)',
      () {
        // Expiry 15 seconds in future is within the 30-second safety margin -> invalid
        final nearExpirySession = AuthSession(
          userId: 'user-123',
          email: 'test@example.com',
          emailVerified: true,
          expiresAt: DateTime.now().add(const Duration(seconds: 15)),
        );
        expect(nearExpirySession.accessTokenValid, isFalse);

        // Expiry 60 seconds in future is safely beyond 30-second safety margin -> valid
        final safeExpirySession = AuthSession(
          userId: 'user-123',
          email: 'test@example.com',
          emailVerified: true,
          expiresAt: DateTime.now().add(const Duration(seconds: 60)),
        );
        expect(safeExpirySession.accessTokenValid, isTrue);
      },
    );

    test('value equality and hashCode include all properties', () {
      final now = DateTime.now();
      final sessionA = AuthSession(
        userId: 'user-1',
        email: 'user@example.com',
        emailVerified: true,
        expiresAt: now,
      );
      final sessionB = AuthSession(
        userId: 'user-1',
        email: 'user@example.com',
        emailVerified: true,
        expiresAt: now,
      );
      final sessionC = AuthSession(
        userId: 'user-2',
        email: 'user@example.com',
        emailVerified: true,
        expiresAt: now,
      );

      expect(sessionA, equals(sessionB));
      expect(sessionA.hashCode, equals(sessionB.hashCode));
      expect(sessionA, isNot(equals(sessionC)));
    });
  });
}
