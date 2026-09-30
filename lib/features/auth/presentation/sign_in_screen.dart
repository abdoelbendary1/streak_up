import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_up/app/theme/app_tokens.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/auth_cubit.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_page_scaffold.dart';

/// Approved Sign In screen (`SL02-UI-001`, `T027`, `SL02-FR-002`).
class SignInScreen extends StatefulWidget {
  const SignInScreen({
    super.key,
    required this.onNavigateToRegister,
    required this.onNavigateToPasswordRecovery,
    this.initialEmail,
  });

  final VoidCallback onNavigateToRegister;
  final VoidCallback onNavigateToPasswordRecovery;
  final String? initialEmail;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final TextEditingController _emailController = TextEditingController(
    text: widget.initialEmail ?? '',
  );
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final cubit = context.read<AuthCubit>();
    await cubit.signIn(
      email: _emailController.text,
      password: _passwordController.text,
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
                l10n.authSignInTitle,
                style: textTheme.headlineMedium?.copyWith(
                  color: AppTokens.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppTokens.spacingXs),
              Text(
                l10n.authSignInSubtitle,
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
                key: const ValueKey<String>('sign_in_email_field'),
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
                key: const ValueKey<String>('sign_in_password_field'),
                controller: _passwordController,
                label: l10n.authPasswordLabel,
                hintText: l10n.authPasswordHint,
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
                    color: AppTokens.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: AppTokens.spacingLg),
              AuthPrimaryButton(
                key: const ValueKey<String>('sign_in_submit_button'),
                label: l10n.authSignInButton,
                isLoading: state.isSubmitting,
                onPressed: _submit,
              ),
              const SizedBox(height: AppTokens.spacingSm),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  key: const ValueKey<String>('sign_in_forgot_password_button'),
                  onPressed: () {
                    context.read<AuthCubit>().clearFeedback();
                    widget.onNavigateToPasswordRecovery();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppTokens.brandPrimary,
                    minimumSize: const Size(
                      AppTokens.minTouchTarget,
                      AppTokens.minTouchTarget,
                    ),
                  ),
                  child: Text(
                    l10n.authForgotPasswordButton,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: AppTokens.spacingMd),
              const AuthOrDivider(),
              const SizedBox(height: AppTokens.spacingLg),
              AuthSecondaryPillButton(
                key: const ValueKey<String>('sign_in_create_account_button'),
                leadingPrompt: l10n.authNewToStreakUpPrompt,
                label: l10n.authCreateAccountLink,
                onPressed: () {
                  context.read<AuthCubit>().clearFeedback();
                  widget.onNavigateToRegister();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
