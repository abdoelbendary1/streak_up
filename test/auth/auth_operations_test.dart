import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/features/auth/domain/models/auth_models.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';

import '../support/fake_auth_repository.dart';

void main() {
  late FakeAuthRepository backend;
  late AuthCubit cubit;

  setUp(() {
    backend = FakeAuthRepository();
    cubit = AuthCubit(backend);
  });

  tearDown(() async {
    await cubit.close();
    await backend.controller.close();
  });

  test(
    'recovery initiation has generic success and never authenticates',
    () async {
      expect(
        await cubit.requestPasswordRecovery('fixture@example.com'),
        isTrue,
      );
      expect(cubit.state.canAccessProtected, isFalse);
      expect(cubit.state.failure, isNull);
    },
  );

  test('email failure remains safe presentation failure', () async {
    backend.emailResult = const Left(AuthFailure.network);
    expect(await cubit.requestPasswordRecovery('fixture@example.com'), isFalse);
    expect(cubit.state.failure, AuthFailure.network);
  });

  test('verification resend requires verification state', () async {
    expect(await cubit.resendVerificationEmail(), isFalse);
    await cubit.register(
      email: accountA.email,
      password: 'fixture-password',
      confirmPassword: 'fixture-password',
    );
    expect(await cubit.resendVerificationEmail(), isTrue);
    expect(cubit.state.status, AuthStatus.verificationRequired);
  });

  test('verification check requires established verified session', () async {
    backend.registration = const Right(
      RegistrationResult(session: unverifiedA),
    );
    await cubit.register(
      email: accountA.email,
      password: 'fixture-password',
      confirmPassword: 'fixture-password',
    );
    await cubit.checkVerification();
    expect(cubit.state.canAccessProtected, isFalse);
    backend.verificationResult = const Right(accountA);
    expect(await cubit.checkVerification(), isTrue);
    expect(cubit.state.account?.id, accountA.id);
  });

  test('network failure retains verification state', () async {
    await cubit.register(
      email: accountA.email,
      password: 'fixture-password',
      confirmPassword: 'fixture-password',
    );
    backend.verificationResult = const Left(AuthFailure.network);
    expect(await cubit.checkVerification(), isFalse);
    expect(cubit.state.status, AuthStatus.verificationRequired);
  });

  test(
    'unconfirmed sign-in requires verification without granting access',
    () async {
      backend.signInResult = const Left(AuthFailure.verificationStillPending);
      expect(
        await cubit.signIn(email: accountA.email, password: 'fixture-password'),
        isFalse,
      );
      expect(cubit.state.status, AuthStatus.verificationRequired);
      expect(cubit.state.canAccessProtected, isFalse);
      expect(await cubit.resendVerificationEmail(), isTrue);
      expect(
        cubit.state.infoMessageKey,
        AuthInfoMessageKey.verificationEmailResent,
      );
    },
  );

  test(
    'recovery resend is UI-only and cleared when an account is admitted',
    () async {
      await cubit.requestPasswordRecovery('fixture@example.test');
      expect(await cubit.resendPasswordRecovery(), isTrue);
      expect(
        cubit.state.infoMessageKey,
        AuthInfoMessageKey.recoveryEmailResent,
      );
      await cubit.signIn(email: accountA.email, password: 'fixture-password');
      expect(await cubit.resendPasswordRecovery(), isFalse);
      expect(cubit.state.account?.id, accountA.id);
      expect(cubit.state.toString().contains('fixture@example.test'), isFalse);
    },
  );
}
