import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_up/app/theme/app_colors.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_buttons.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_messages.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_text_field.dart';

/// Raw password/confirmation entry; the session owns recovery admission.
class PasswordResetForm extends StatefulWidget {
  const PasswordResetForm({
    super.key,
    required this.onPasswordUpdated,
    required this.onBackToSignIn,
  });

  final VoidCallback onPasswordUpdated;
  final VoidCallback onBackToSignIn;

  @override
  State<PasswordResetForm> createState() => _PasswordResetFormState();
}

class _PasswordResetFormState extends State<PasswordResetForm> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final success = await context.read<AuthCubit>().submitNewPassword(
      _newPasswordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
    if (success && mounted) {
      widget.onPasswordUpdated();
    }
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
          key: const ValueKey<String>('password_reset_new_field'),
          controller: _newPasswordController,
          label: l10n.authNewPasswordLabel,
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.next,
          errorText: inputErrors.password?.localizedMessage(l10n),
          suffixIcon: IconButton(
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
          key: const ValueKey<String>('password_reset_confirm_field'),
          controller: _confirmPasswordController,
          label: l10n.authConfirmPasswordLabel,
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: _obscureConfirm,
          textInputAction: TextInputAction.done,
          errorText: inputErrors.confirmation?.localizedMessage(l10n),
          onSubmitted: (_) => _submit(),
          suffixIcon: IconButton(
            tooltip: _obscureConfirm
                ? l10n.authShowPasswordTooltip
                : l10n.authHidePasswordTooltip,
            onPressed: () {
              setState(() {
                _obscureConfirm = !_obscureConfirm;
              });
            },
            icon: Icon(
              _obscureConfirm
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppColors.secondaryText,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AuthPrimaryButton(
          key: const ValueKey<String>('password_reset_submit_button'),
          label: l10n.authSaveNewPasswordButton,
          isLoading: isSubmitting,
          onPressed: _submit,
        ),
        const SizedBox(height: AppSpacing.md),
        AuthSecondaryPillButton(
          key: const ValueKey<String>('password_reset_back_button'),
          label: l10n.authBackToSignInButton,
          onPressed: widget.onBackToSignIn,
        ),
      ],
    );
  }
}
