import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_up/app/theme/app_colors.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_buttons.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_messages.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_text_field.dart';

/// Raw sign-in fields and local password visibility.
class SignInForm extends StatefulWidget {
  const SignInForm({
    super.key,
    required this.onNavigateToRegister,
    required this.onNavigateToPasswordRecovery,
  });

  final VoidCallback onNavigateToRegister;
  final VoidCallback onNavigateToPasswordRecovery;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<AuthCubit>().signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isSubmitting = context.select(
      (AuthCubit cubit) => cubit.state.isSubmitting,
    );
    final emailError = context.select(
      (AuthCubit cubit) => cubit.state.inputErrors.email,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AuthTextField(
          key: const ValueKey<String>('sign_in_email_field'),
          controller: _emailController,
          label: l10n.authEmailLabel,
          prefixIcon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const <String>[AutofillHints.email],
          errorText: emailError?.localizedMessage(l10n),
        ),
        const SizedBox(height: AppSpacing.md),
        AuthTextField(
          key: const ValueKey<String>('sign_in_password_field'),
          controller: _passwordController,
          label: l10n.authPasswordLabel,
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          autofillHints: const <String>[AutofillHints.password],
          onSubmitted: (_) => _submit(),
          suffixIcon: IconButton(
            key: const ValueKey<String>('sign_in_toggle_password'),
            tooltip: _obscurePassword
                ? l10n.authShowPasswordTooltip
                : l10n.authHidePasswordTooltip,
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppColors.secondaryText,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AuthPrimaryButton(
          key: const ValueKey<String>('sign_in_submit_button'),
          label: l10n.authSignInButton,
          isLoading: isSubmitting,
          onPressed: _submit,
        ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.center,
          child: TextButton(
            key: const ValueKey<String>('sign_in_forgot_password_button'),
            onPressed: widget.onNavigateToPasswordRecovery,
            child: Text(l10n.authForgotPasswordButton),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const AuthOrDivider(),
        const SizedBox(height: AppSpacing.lg),
        AuthSecondaryPillButton(
          key: const ValueKey<String>('sign_in_create_account_button'),
          leadingPrompt: l10n.authNewToStreakUpPrompt,
          label: l10n.authCreateAccountLink,
          onPressed: widget.onNavigateToRegister,
        ),
      ],
    );
  }
}
