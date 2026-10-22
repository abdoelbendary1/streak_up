import 'package:flutter/material.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_page_header.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_page_scaffold.dart';
import 'package:streak_up/features/auth/presentation/widgets/registration_form.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key, required this.onNavigateToSignIn});

  final VoidCallback onNavigateToSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AuthPageScaffold(
      wordmarkGap: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthPageHeader(
            title: l10n.authRegisterTitle,
            subtitle: l10n.authRegisterSubtitle,
            titleMaxWidth: 270,
          ),
          const SizedBox(height: AppSpacing.lg),
          RegistrationForm(onNavigateToSignIn: onNavigateToSignIn),
        ],
      ),
    );
  }
}
