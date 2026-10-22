import 'package:flutter/material.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_page_header.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_page_scaffold.dart';
import 'package:streak_up/features/auth/presentation/widgets/sign_in_form.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({
    super.key,
    required this.onNavigateToRegister,
    required this.onNavigateToPasswordRecovery,
  });

  final VoidCallback onNavigateToRegister;
  final VoidCallback onNavigateToPasswordRecovery;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AuthPageScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthPageHeader(
            title: l10n.authSignInTitle,
            subtitle: l10n.authSignInSubtitle,
          ),
          const SizedBox(height: AppSpacing.lg),
          SignInForm(
            onNavigateToRegister: onNavigateToRegister,
            onNavigateToPasswordRecovery: onNavigateToPasswordRecovery,
          ),
        ],
      ),
    );
  }
}
