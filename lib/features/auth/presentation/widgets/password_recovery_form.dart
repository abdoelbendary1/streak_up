import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_buttons.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_messages.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_text_field.dart';

/// Raw recovery email entry.
class PasswordRecoveryForm extends StatefulWidget {
  const PasswordRecoveryForm({
    super.key,
    required this.onRecoveryLinkRequested,
    required this.onBackToSignIn,
  });

  final VoidCallback onRecoveryLinkRequested;
  final VoidCallback onBackToSignIn;

  @override
  State<PasswordRecoveryForm> createState() => _PasswordRecoveryFormState();
}

class _PasswordRecoveryFormState extends State<PasswordRecoveryForm> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final success = await context.read<AuthCubit>().requestPasswordRecovery(
      _emailController.text,
    );
    if (success && mounted) {
      widget.onRecoveryLinkRequested();
    }
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
          key: const ValueKey<String>('password_recovery_email_field'),
          controller: _emailController,
          label: l10n.authEmailLabel,
          prefixIcon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          errorText: emailError?.localizedMessage(l10n),
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: AppSpacing.lg),
        AuthPrimaryButton(
          key: const ValueKey<String>('password_recovery_submit_button'),
          label: l10n.authSendResetLinkButton,
          isLoading: isSubmitting,
          onPressed: _submit,
        ),
        const SizedBox(height: AppSpacing.lg),
        const AuthOrDivider(),
        const SizedBox(height: AppSpacing.lg),
        AuthSecondaryPillButton(
          key: const ValueKey<String>('password_recovery_back_button'),
          label: l10n.authBackToSignInButton,
          onPressed: widget.onBackToSignIn,
        ),
      ],
    );
  }
}
