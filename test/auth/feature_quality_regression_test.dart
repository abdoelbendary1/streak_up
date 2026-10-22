import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/app/theme/app_theme.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/domain/models/auth_models.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:streak_up/features/auth/presentation/sheets/sign_out_warning_sheet.dart';
import 'package:streak_up/features/auth/presentation/validation/auth_input_validator.dart';
import 'package:streak_up/features/auth/presentation/widgets/password_recovery_form.dart';

import '../support/fake_auth_repository.dart';

class _RecordingRepository extends FakeAuthRepository {
  String? submittedEmail;
  String? submittedPassword;
  int restorations = 0;

  @override
  Future<Either<AuthFailure, AuthSessionEvidence>> signIn({
    required String email,
    required String password,
  }) {
    submittedEmail = email;
    submittedPassword = password;
    return super.signIn(email: email, password: password);
  }

  @override
  Future<Either<AuthFailure, AuthSessionEvidence?>> restoreSession() {
    restorations++;
    return super.restoreSession();
  }
}

void main() {
  late _RecordingRepository repository;
  late AuthCubit cubit;

  setUp(() {
    repository = _RecordingRepository();
    cubit = AuthCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
    await repository.controller.close();
  });

  test('raw email is normalized, password whitespace is preserved', () async {
    expect(
      await cubit.signIn(email: '  a@example.com  ', password: ' password '),
      isTrue,
    );
    expect(repository.submittedEmail, 'a@example.com');
    expect(repository.submittedPassword, ' password ');
    expect(cubit.state.account?.id, accountA.id);
  });

  test(
    'input errors never dispatch auth commands or masquerade as failures',
    () async {
      expect(await cubit.signIn(email: 'bad', password: 'password'), isFalse);
      expect(cubit.state.inputErrors.email, AuthInputError.invalidEmail);
      expect(cubit.state.failure, isNull);
      expect(await cubit.requestPasswordRecovery('bad'), isFalse);
      expect(
        await cubit.register(
          email: accountA.email,
          password: 'short',
          confirmPassword: 'other',
        ),
        isFalse,
      );
      expect(
        cubit.state.inputErrors.confirmation,
        AuthInputError.passwordMismatch,
      );
      expect(cubit.state.inputErrors.password, AuthInputError.weakPassword);
      expect(cubit.state.isSubmitting, isFalse);
      expect(repository.calls, isEmpty);
      expect(cubit.state.status, AuthStatus.restoring);
    },
  );

  test('recovery email and completion are explicit observable state', () async {
    await cubit.requestPasswordRecovery('  a@example.com  ');
    expect(cubit.state.recoveryEmail, accountA.email);
    expect(cubit.state.completedSubmission, AuthSubmission.recoveryRequested);
    await cubit.resendPasswordRecovery();
    expect(cubit.state.infoMessageKey, AuthInfoMessageKey.recoveryEmailResent);
    await cubit.signIn(email: accountA.email, password: 'password');
    expect(cubit.state.recoveryEmail, isNull);
  });

  testWidgets('recovery form submits raw email through its supplied callback', (
    tester,
  ) async {
    final inputs = <String>[];
    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: PasswordRecoveryForm(
              onSubmit: inputs.add,
              onBackToSignIn: () {},
            ),
          ),
        ),
      ),
    );
    await tester.enterText(find.byType(TextField), ' raw@example.com ');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.tap(
      find.byKey(const ValueKey('password_recovery_submit_button')),
    );
    expect(inputs, [' raw@example.com ', ' raw@example.com ']);
    expect(repository.calls, isEmpty);
  });

  testWidgets(
    'staying signed in dismisses the warning without a session command',
    (tester) async {
      await tester.runAsync(
        () => cubit.signIn(email: accountA.email, password: 'password'),
      );
      await tester.pumpWidget(
        BlocProvider.value(
          value: cubit,
          child: MaterialApp(
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () => SignOutWarningSheet.show(
                    context,
                    onStaySignedIn: () {},
                    onSignOutAnyway: () => cubit.signOut(),
                  ),
                  child: const Text('Open warning'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open warning'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.byKey(const ValueKey('sign_out_warning_stay_button')),
      );
      await tester.tap(
        find.byKey(const ValueKey('sign_out_warning_stay_button')),
      );
      await tester.pumpAndSettle();
      expect(cubit.state.account?.id, accountA.id);
      expect(repository.calls, ['signIn']);
      expect(
        find.byKey(const ValueKey('sign_out_warning_stay_button')),
        findsNothing,
      );
    },
  );
}
