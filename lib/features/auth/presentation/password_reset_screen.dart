import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_up/app/theme/app_tokens.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/auth_cubit.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_page_scaffold.dart';

/// Password Reset entry screen reached only after a recovery deep-link is validated (`T028`, `SL02-FR-005`).
class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({
    super.key,
    required this.onPasswordUpdated,
    required this.onBackToSignIn,
  });

  final VoidCallback onPasswordUpdated;
  final VoidCallback onBackToSignIn;

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
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
    final succeeded = await context.read<AuthCubit>().submitNewPassword(
      newPassword: _newPasswordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
    if (succeeded && mounted) {
      widget.onPasswordUpdated();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return AuthPageScaffold(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                l10n.authPasswordResetFormTitle,
                style: textTheme.headlineMedium?.copyWith(
                  color: AppTokens.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppTokens.spacingXs),
              Text(
                l10n.authPasswordResetFormSubtitle,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppTokens.textSecondary,
                ),
              ),
              const SizedBox(height: AppTokens.spacingLg),
              AuthFeedbackCallout(
                failure: state.activeFailure,
                infoMessageKey: state.infoMessageKey,
              ),
              AuthTextField(
                key: const ValueKey<String>('password_reset_new_field'),
                controller: _newPasswordController,
                label: l10n.authNewPasswordLabel,
                hintText: l10n.authPasswordHint,
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.next,
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
                    color: AppTokens.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: AppTokens.spacingMd),
              AuthTextField(
                key: const ValueKey<String>('password_reset_confirm_field'),
                controller: _confirmPasswordController,
                label: l10n.authConfirmPasswordLabel,
                hintText: l10n.authConfirmPasswordHint,
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: _obscureConfirm,
                textInputAction: TextInputAction.done,
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
                    color: AppTokens.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: AppTokens.spacingLg),
              AuthPrimaryButton(
                key: const ValueKey<String>('password_reset_submit_button'),
                label: l10n.authSaveNewPasswordButton,
                isLoading: state.isSubmitting,
                onPressed: _submit,
              ),
              const SizedBox(height: AppTokens.spacingMd),
              AuthSecondaryPillButton(
                key: const ValueKey<String>('password_reset_back_button'),
                label: l10n.authBackToSignInButton,
                onPressed: widget.onBackToSignIn,
              ),
            ],
          ),
        );
      },
    );
  }
}
