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
    'submitNewPassword succeeds, transitions to signedOut and clears session',
    () async {
      backend.currentSession = accountA;
      await cubit.restore();
      expect(cubit.state.status, AuthStatus.authenticated);

      final success = await cubit.submitNewPassword(
        'NewStrongPassword123!',
        confirmPassword: 'NewStrongPassword123!',
      );

      expect(success, isTrue);
      expect(cubit.state.status, AuthStatus.signedOut);
      expect(cubit.state.account, isNull);
      expect(cubit.state.failure, isNull);
      expect(cubit.state.isSubmitting, isFalse);
      expect(cubit.state.completedSubmission, AuthSubmission.passwordUpdated);
    },
  );

  test('submitNewPassword failure preserves safe failure state', () async {
    backend.resetResult = const Left(AuthFailure.network);

    final success = await cubit.submitNewPassword(
      'NewStrongPassword123!',
      confirmPassword: 'NewStrongPassword123!',
    );

    expect(success, isFalse);
    expect(cubit.state.failure, AuthFailure.network);
    expect(cubit.state.isSubmitting, isFalse);
  });

  test('password values are never exposed in Cubit state toString', () async {
    const secretPassword = 'MySecretPassword99!';
    backend.resetResult = const Left(AuthFailure.invalidCredentials);

    await cubit.submitNewPassword(
      secretPassword,
      confirmPassword: secretPassword,
    );

    expect(cubit.state.toString(), isNot(contains(secretPassword)));
  });
}
