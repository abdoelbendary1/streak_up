import 'package:flutter/material.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_illustrations.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_page_header.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_page_scaffold.dart';
import 'package:streak_up/features/auth/presentation/widgets/password_recovery_form.dart';

class PasswordRecoveryScreen extends StatelessWidget {
  const PasswordRecoveryScreen({
    super.key,
    required this.onRecoveryLinkRequested,
    required this.onBackToSignIn,
  });

  final VoidCallback onRecoveryLinkRequested;
  final VoidCallback onBackToSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AuthPageScaffold(
      wordmarkGap: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: AuthEmailIllustration(badge: Icons.lock_rounded)),
          const SizedBox(height: 12),
          AuthPageHeader(
            title: l10n.authPasswordRecoveryTitle,
            subtitle: l10n.authPasswordRecoverySubtitle,
            centered: true,
            titleMaxWidth: 280,
          ),
          const SizedBox(height: AppSpacing.lg),
          PasswordRecoveryForm(
            onRecoveryLinkRequested: onRecoveryLinkRequested,
            onBackToSignIn: onBackToSignIn,
          ),
        ],
      ),
    );
  }
}
