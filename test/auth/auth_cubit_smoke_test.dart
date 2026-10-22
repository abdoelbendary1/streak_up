import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/features/auth/domain/entities/auth_session.dart';
import 'package:streak_up/features/auth/domain/failures/auth_failure.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';
import '../support/fake_auth_repository.dart';

void main() {
  late FakeAuthRepository repository;
  late AuthCubit cubit;

  setUp(() {
    repository = FakeAuthRepository();
    cubit = createTestAuthCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
    repository.dispose();
  });

  group('AuthCubit smoke tests', () {
    test(
      'signIn success: updates to authenticated with valid session',
      () async {
        repository.signInResult = Right(testSessionA);

        final result = await cubit.signIn(
          email: 'test@example.com',
          password: 'Password123',
        );

        expect(result, isTrue);
        expect(cubit.state.status, AuthStatus.authenticated);
        expect(cubit.state.session, equals(testSessionA));
        expect(cubit.state.failure, isNull);
        expect(cubit.state.isSubmitting, isFalse);
      },
    );

    test(
      'signIn failure: updates state with failure without creating session',
      () async {
        repository.signInResult = const Left(AuthFailure.invalidCredentials);

        final result = await cubit.signIn(
          email: 'test@example.com',
          password: 'WrongPassword123',
        );

        expect(result, isFalse);
        expect(cubit.state.status, isNot(AuthStatus.authenticated));
        expect(cubit.state.failure, AuthFailure.invalidCredentials);
        expect(cubit.state.session, isNull);
        expect(cubit.state.isSubmitting, isFalse);
      },
    );

    test(
      'signOut success: clears session and failure, updates to signedOut',
      () async {
        repository.signInResult = Right(testSessionA);
        await cubit.signIn(email: 'test@example.com', password: 'Password123');
        expect(cubit.state.status, AuthStatus.authenticated);

        repository.signOutResult = const Right(unit);
        final result = await cubit.signOut();

        expect(result, isTrue);
        expect(cubit.state.status, AuthStatus.signedOut);
        expect(cubit.state.session, isNull);
        expect(cubit.state.failure, isNull);
        expect(cubit.state.isSubmitting, isFalse);
      },
    );

    test(
      'signOut failure with surviving local session: restores stable status, retains session, stores failure',
      () async {
        repository.signInResult = Right(testSessionA);
        await cubit.signIn(email: 'test@example.com', password: 'Password123');
        expect(cubit.state.status, AuthStatus.authenticated);

        // Configure repository to fail signOut while retaining currentSession locally
        repository.signOutResult = const Left(AuthFailure.network);
        repository.retainSessionOnSignOutFailure = true;

        final result = await cubit.signOut();

        expect(result, isFalse);
        expect(cubit.state.status, AuthStatus.authenticated);
        expect(cubit.state.session, equals(testSessionA));
        expect(cubit.state.failure, AuthFailure.network);
        expect(cubit.state.isSubmitting, isFalse);
      },
    );

    group('Domain coverage for live-excluded operations', () {
      test(
        'registration requiring verification sets verificationRequired',
        () async {
          final unverifiedNewUser = AuthSession(
            userId: 'new-user-123',
            email: 'newuser@example.com',
            emailVerified: false,
            expiresAt: DateTime.now().add(const Duration(hours: 1)),
          );
          repository.registrationResult = Right(unverifiedNewUser);

          final result = await cubit.register(
            email: 'newuser@example.com',
            password: 'Password123!',
            confirmPassword: 'Password123!',
          );

          expect(result, isTrue);
          expect(cubit.state.status, AuthStatus.verificationRequired);
          expect(cubit.state.session, equals(unverifiedNewUser));
          expect(cubit.state.verificationEmail, 'newuser@example.com');
          expect(cubit.state.isSubmitting, isFalse);
        },
      );

      test('registration failure stores typed AuthFailure', () async {
        repository.registrationResult = const Left(
          AuthFailure.emailAlreadyInUse,
        );

        final result = await cubit.register(
          email: 'existing@example.com',
          password: 'Password123!',
          confirmPassword: 'Password123!',
        );

        expect(result, isFalse);
        expect(cubit.state.failure, AuthFailure.emailAlreadyInUse);
        expect(cubit.state.session, isNull);
        expect(cubit.state.isSubmitting, isFalse);
      });

      test('requestPasswordRecovery success stores recoveryEmail', () async {
        repository.emailResult = const Right(unit);

        final result = await cubit.requestPasswordRecovery(
          'recover@example.com',
        );

        expect(result, isTrue);
        expect(cubit.state.recoveryEmail, 'recover@example.com');
        expect(cubit.state.failure, isNull);
        expect(cubit.state.isSubmitting, isFalse);
      });

      test('requestPasswordRecovery failure stores AuthFailure', () async {
        repository.emailResult = const Left(AuthFailure.rateLimited);

        final result = await cubit.requestPasswordRecovery(
          'recover@example.com',
        );

        expect(result, isFalse);
        expect(cubit.state.failure, AuthFailure.rateLimited);
        expect(cubit.state.isSubmitting, isFalse);
      });

      test('resendVerificationEmail success clears failure', () async {
        // First put cubit into verificationRequired state with email
        repository.registrationResult = Right(unverifiedSessionA);
        await cubit.register(
          email: 'verify@example.com',
          password: 'Password123!',
          confirmPassword: 'Password123!',
        );

        repository.emailResult = const Right(unit);
        final result = await cubit.resendVerificationEmail();

        expect(result, isTrue);
        expect(cubit.state.failure, isNull);
        expect(cubit.state.isSubmitting, isFalse);
      });
    });
  });
}
