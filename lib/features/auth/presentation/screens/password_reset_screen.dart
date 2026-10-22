import 'package:flutter/material.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_page_header.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_page_scaffold.dart';
import 'package:streak_up/features/auth/presentation/widgets/password_reset_form.dart';

class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({
    super.key,
    required this.onPasswordUpdated,
    required this.onBackToSignIn,
  });

  final VoidCallback onPasswordUpdated;
  final VoidCallback onBackToSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AuthPageScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthPageHeader(
            title: l10n.authPasswordResetFormTitle,
            subtitle: l10n.authPasswordResetFormSubtitle,
          ),
          const SizedBox(height: AppSpacing.lg),
          PasswordResetForm(
            onPasswordUpdated: onPasswordUpdated,
            onBackToSignIn: onBackToSignIn,
          ),
        ],
      ),
    );
  }
}
