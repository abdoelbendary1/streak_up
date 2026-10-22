import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/core/presentation/app_notifier.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_buttons.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_illustrations.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_page_scaffold.dart';

/// Always displays generic non-enumerating confirmation copy.
class PasswordRecoverySentScreen extends StatelessWidget {
  const PasswordRecoverySentScreen({super.key, required this.onBackToSignIn});

  final VoidCallback onBackToSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return AuthPageScaffold(
      wordmarkGap: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Center(
            child: AuthEmailIllustration(badge: Icons.check_rounded),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.authPasswordRecoverySentTitle,
            textAlign: TextAlign.center,
            style: textTheme.headlineLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.authPasswordRecoverySentGenericBody,
            key: const ValueKey<String>('password_recovery_generic_message'),
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.authPasswordRecoverySentFollowUp,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          AuthPrimaryButton(
            key: const ValueKey<String>('password_recovery_sent_back_button'),
            label: l10n.authBackToSignInButton,
            onPressed: onBackToSignIn,
          ),
          const SizedBox(height: AppSpacing.sm),
          const _SendAgainButton(),
        ],
      ),
    );
  }
}

class _SendAgainButton extends StatelessWidget {
  const _SendAgainButton();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isSubmitting = context.select(
      (AuthCubit cubit) => cubit.state.isSubmitting,
    );

    return Align(
      alignment: Alignment.center,
      child: TextButton(
        key: const ValueKey<String>('password_recovery_send_again_button'),
        onPressed: isSubmitting
            ? null
            : () async {
                final success = await context
                    .read<AuthCubit>()
                    .resendPasswordRecovery();
                if (!success || !context.mounted) return;
                AppNotifier.info(context, l10n.authRecoveryResentBanner);
              },
        child: Text(l10n.authSendAgainButton),
      ),
    );
  }
}
