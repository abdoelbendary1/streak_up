import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_up/app/theme/app_colors.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_buttons.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_messages.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_text_field.dart';

/// Raw registration fields and local password visibility.
class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key, required this.onNavigateToSignIn});

  final VoidCallback onNavigateToSignIn;

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<AuthCubit>().register(
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isSubmitting = context.select(
      (AuthCubit cubit) => cubit.state.isSubmitting,
    );
    final inputErrors = context.select(
      (AuthCubit cubit) => cubit.state.inputErrors,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AuthTextField(
          key: const ValueKey<String>('register_email_field'),
          controller: _emailController,
          label: l10n.authEmailLabel,
          prefixIcon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const <String>[AutofillHints.email],
          errorText: inputErrors.email?.localizedMessage(l10n),
        ),
        const SizedBox(height: AppSpacing.md),
        AuthTextField(
          key: const ValueKey<String>('register_password_field'),
          controller: _passwordController,
          label: l10n.authPasswordLabel,
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.next,
          autofillHints: const <String>[AutofillHints.newPassword],
          errorText: inputErrors.password?.localizedMessage(l10n),
          suffixIcon: IconButton(
            key: const ValueKey<String>('register_toggle_password'),
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
        const SizedBox(height: AppSpacing.md),
        AuthTextField(
          key: const ValueKey<String>('register_confirm_password_field'),
          controller: _confirmPasswordController,
          label: l10n.authConfirmPasswordLabel,
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: _obscureConfirmPassword,
          textInputAction: TextInputAction.done,
          errorText: inputErrors.confirmation?.localizedMessage(l10n),
          onSubmitted: (_) => _submit(),
          suffixIcon: IconButton(
            key: const ValueKey<String>('register_toggle_confirm_password'),
            tooltip: _obscureConfirmPassword
                ? l10n.authShowPasswordTooltip
                : l10n.authHidePasswordTooltip,
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
            icon: Icon(
              _obscureConfirmPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppColors.secondaryText,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AuthPrimaryButton(
          key: const ValueKey<String>('register_submit_button'),
          label: l10n.authCreateAccountButton,
          isLoading: isSubmitting,
          onPressed: _submit,
        ),
        const SizedBox(height: AppSpacing.lg),
        const AuthOrDivider(),
        const SizedBox(height: AppSpacing.lg),
        AuthSecondaryPillButton(
          key: const ValueKey<String>('register_sign_in_button'),
          leadingPrompt: l10n.authAlreadyHaveAccountPrompt,
          label: l10n.authSignInLink,
          onPressed: widget.onNavigateToSignIn,
        ),
      ],
    );
  }
}
