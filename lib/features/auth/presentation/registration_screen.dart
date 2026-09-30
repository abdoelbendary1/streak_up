import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_up/app/theme/app_tokens.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/auth_cubit.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_page_scaffold.dart';

/// Approved Registration screen (`SL02-UI-002`, `T027`, `SL02-FR-001`).
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({
    super.key,
    required this.onNavigateToSignIn,
  });

  final VoidCallback onNavigateToSignIn;

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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

  Future<void> _submit() async {
    await context.read<AuthCubit>().register(
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
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
                l10n.authRegisterTitle,
                style: textTheme.headlineMedium?.copyWith(
                  color: AppTokens.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppTokens.spacingXs),
              Text(
                l10n.authRegisterSubtitle,
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
                key: const ValueKey<String>('register_email_field'),
                controller: _emailController,
                label: l10n.authEmailLabel,
                hintText: l10n.authEmailHint,
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const <String>[AutofillHints.email],
              ),
              const SizedBox(height: AppTokens.spacingMd),
              AuthTextField(
                key: const ValueKey<String>('register_password_field'),
                controller: _passwordController,
                label: l10n.authPasswordLabel,
                hintText: l10n.authPasswordHint,
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.next,
                autofillHints: const <String>[AutofillHints.newPassword],
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
                    color: AppTokens.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: AppTokens.spacingMd),
              AuthTextField(
                key: const ValueKey<String>('register_confirm_password_field'),
                controller: _confirmPasswordController,
                label: l10n.authConfirmPasswordLabel,
                hintText: l10n.authConfirmPasswordHint,
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: _obscureConfirmPassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                suffixIcon: IconButton(
                  key: const ValueKey<String>(
                    'register_toggle_confirm_password',
                  ),
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
                    color: AppTokens.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: AppTokens.spacingLg),
              AuthPrimaryButton(
                key: const ValueKey<String>('register_submit_button'),
                label: l10n.authCreateAccountButton,
                isLoading: state.isSubmitting,
                onPressed: _submit,
              ),
              const SizedBox(height: AppTokens.spacingLg),
              const AuthOrDivider(),
              const SizedBox(height: AppTokens.spacingLg),
              AuthSecondaryPillButton(
                key: const ValueKey<String>('register_sign_in_button'),
                leadingPrompt: l10n.authAlreadyHaveAccountPrompt,
                label: l10n.authSignInLink,
                onPressed: () {
                  context.read<AuthCubit>().clearFeedback();
                  widget.onNavigateToSignIn();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
