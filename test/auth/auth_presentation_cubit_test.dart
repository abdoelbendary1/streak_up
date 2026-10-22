import 'dart:async';

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

  Future<bool> signIn() =>
      cubit.signIn(email: accountA.email, password: 'private-password');

  test('initial state is restoring and does not start backend operations', () {
    expect(cubit.state.isSubmitting, isFalse);
    expect(cubit.state.failure, isNull);
    expect(cubit.state.status, AuthStatus.restoring);
    expect(backend.calls, isEmpty);
  });

  test('loading lasts until delayed sign-in completes', () async {
    backend.signInGate = Completer<void>();
    backend.signInStarted = Completer<void>();
    final submission = signIn();
    expect(cubit.state.isSubmitting, isTrue);
    await backend.signInStarted!.future;
    expect(cubit.state.canAccessProtected, isFalse);
    backend.signInGate!.complete();
    expect(await submission, isTrue);
    expect(cubit.state.isSubmitting, isFalse);
    expect(cubit.state.failure, isNull);
    expect(cubit.state.account?.id, accountA.id);
  });

  for (final failure in [
    AuthFailure.invalidCredentials,
    AuthFailure.network,
    AuthFailure.storage,
  ]) {
    test('sign-in exposes only the safe ${failure.name} failure', () async {
      backend.signInResult = Left(failure);
      expect(await signIn(), isFalse);
      expect(cubit.state.failure, failure);
      expect(cubit.state.isSubmitting, isFalse);
      expect(cubit.state.canAccessProtected, isFalse);
      expect(cubit.state.toString(), isNot(contains('private-password')));
      expect(cubit.state.toString(), isNot(contains(accountA.email)));
    });
  }

  test(
    'new submission clears failure and successful sign-in keeps it clear',
    () async {
      backend.signInResult = const Left(AuthFailure.invalidCredentials);
      await signIn();
      backend.signInResult = const Right(accountA);
      backend.signInGate = Completer<void>();
      final submission = signIn();
      expect(cubit.state.failure, isNull);
      backend.signInGate!.complete();
      expect(await submission, isTrue);
      expect(cubit.state.failure, isNull);
    },
  );

  test(
    'registration without a session succeeds without granting access',
    () async {
      expect(
        await cubit.register(
          email: accountA.email,
          password: 'private-password',
          confirmPassword: 'private-password',
        ),
        isTrue,
      );
      expect(cubit.state.isSubmitting, isFalse);
      expect(cubit.state.failure, isNull);
      expect(cubit.state.status, AuthStatus.verificationRequired);
      expect(cubit.state.verificationEmail, accountA.email);
      expect(cubit.state.canAccessProtected, isFalse);
      expect(cubit.state.account, isNull);
    },
  );

  test('unverified registration session still requires verification', () async {
    backend.registration = const Right(
      RegistrationResult(session: unverifiedA),
    );
    expect(
      await cubit.register(
        email: accountA.email,
        password: 'private-password',
        confirmPassword: 'private-password',
      ),
      isTrue,
    );
    expect(cubit.state.status, AuthStatus.verificationRequired);
    expect(cubit.state.canAccessProtected, isFalse);
  });

  test(
    'verified registration session is admitted to authenticated state',
    () async {
      backend.registration = const Right(RegistrationResult(session: accountA));
      expect(
        await cubit.register(
          email: accountA.email,
          password: 'private-password',
          confirmPassword: 'private-password',
        ),
        isTrue,
      );
      expect(cubit.state.account?.id, accountA.id);
      expect(cubit.state.status, AuthStatus.authenticated);
    },
  );

  test('registration failure is presentation safe', () async {
    backend.registration = const Left(AuthFailure.network);
    expect(
      await cubit.register(
        email: accountA.email,
        password: 'private-password',
        confirmPassword: 'private-password',
      ),
      isFalse,
    );
    expect(cubit.state.failure, AuthFailure.network);
    expect(cubit.state.isSubmitting, isFalse);
  });

  test('restoration loading and account admission', () async {
    backend.currentSession = accountA;
    backend.restoreGate = Completer<void>();
    backend.restoreStarted = Completer<void>();
    final restoring = cubit.restore();
    expect(cubit.state.status, AuthStatus.restoring);
    expect(cubit.state.canAccessProtected, isFalse);
    await backend.restoreStarted!.future;
    backend.restoreGate!.complete();
    expect(await restoring, isTrue);
    expect(cubit.state.status, AuthStatus.authenticated);
    expect(cubit.state.account?.id, accountA.id);
  });

  test('repository events notify Cubit listeners and update state', () async {
    final notifications = <AuthState>[];
    final subscription = cubit.stream.listen(notifications.add);
    backend.currentSession = accountA;
    await cubit.restore();
    expect(notifications.isNotEmpty, isTrue);
    expect(cubit.state.account?.id, accountA.id);
    expect(cubit.state.isSubmitting, isFalse);

    backend.event(AuthEventKind.signedOut);
    expect(cubit.state.canAccessProtected, isFalse);
    expect(cubit.state.status, AuthStatus.signedOut);
    expect(cubit.state.account, isNull);
    await subscription.cancel();
  });

  test(
    'sign-out blocks access immediately and transitions to signedOut',
    () async {
      await signIn();
      expect(cubit.state.canAccessProtected, isTrue);
      final exiting = cubit.signOut();
      expect(cubit.state.canAccessProtected, isFalse);
      expect(await exiting, isTrue);
      expect(cubit.state.isSubmitting, isFalse);
      expect(cubit.state.status, AuthStatus.signedOut);
    },
  );

  test(
    'failed sign-out cannot regain access through Cubit restoration',
    () async {
      await signIn();
      backend.signOutFailure = AuthFailure.network;
      expect(await cubit.signOut(), isFalse);
      expect(cubit.state.failure, AuthFailure.network);
      expect(cubit.state.canAccessProtected, isFalse);
      backend.restoreResult = const Left(AuthFailure.network);
      expect(await cubit.restore(), isFalse);
      expect(cubit.state.canAccessProtected, isFalse);
    },
  );

  test(
    'A exits then B signs in; stale A events cannot change derived account',
    () async {
      await signIn();
      await cubit.signOut();
      backend.signInResult = const Right(accountB);
      expect(
        await cubit.signIn(email: accountB.email, password: 'private-password'),
        isTrue,
      );
      backend.event(AuthEventKind.refreshed, session: accountA);
      expect(cubit.state.account?.id, accountB.id);
    },
  );

  test('closing cancels repository observation without throwing', () async {
    await cubit.close();
    expect(cubit.isClosed, isTrue);
    expect(await signIn(), isFalse);
    cubit.clearFailure();
  });

  test(
    'command completion after close cannot emit or signal UI success',
    () async {
      backend.signInGate = Completer<void>();
      backend.signInStarted = Completer<void>();
      final submission = signIn();
      await backend.signInStarted!.future;
      final presentation = cubit.state;
      await cubit.close();
      backend.signInGate!.complete();
      expect(await submission, isFalse);
      expect(identical(cubit.state, presentation), isTrue);
    },
  );
}
