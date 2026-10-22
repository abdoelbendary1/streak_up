import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_up/app/theme/app_colors.dart';
import 'package:streak_up/app/theme/app_radii.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/core/presentation/app_notifier.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_buttons.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_illustrations.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_page_header.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_page_scaffold.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key, required this.onBackToSignIn});

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
          const Center(child: AuthEmailIllustration()),
          const SizedBox(height: 12),
          AuthPageHeader(
            title: l10n.authVerifyEmailTitle,
            subtitle: l10n.authVerifyEmailSentTo,
            centered: true,
            subtitleGap: AppSpacing.sm,
          ),
          const SizedBox(height: AppSpacing.sm),
          const _VerificationEmailBadge(),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.authVerifyEmailBody,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          _VerificationActions(onBackToSignIn: onBackToSignIn),
        ],
      ),
    );
  }
}

class _VerificationEmailBadge extends StatelessWidget {
  const _VerificationEmailBadge();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final email = context.select(
      (AuthCubit cubit) => cubit.state.verificationEmail ?? '',
    );

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.selectedGreenPill,
          borderRadius: BorderRadius.circular(AppRadii.full),
          border: Border.all(color: AppColors.statusSyncedBorder),
        ),
        child: Text(
          email,
          key: const ValueKey<String>('verify_email_target_badge'),
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.greenDark,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _VerificationActions extends StatelessWidget {
  const _VerificationActions({required this.onBackToSignIn});

  final VoidCallback onBackToSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isSubmitting = context.select(
      (AuthCubit cubit) => cubit.state.isSubmitting,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AuthPrimaryButton(
          key: const ValueKey<String>('verify_email_check_button'),
          label: l10n.authVerifyEmailPrimaryButton,
          isLoading: isSubmitting,
          onPressed: () => context.read<AuthCubit>().checkVerification(),
        ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.center,
          child: TextButton(
            key: const ValueKey<String>('verify_email_resend_button'),
            onPressed: isSubmitting
                ? null
                : () async {
                    final success = await context
                        .read<AuthCubit>()
                        .resendVerificationEmail();
                    if (!success || !context.mounted) return;
                    AppNotifier.info(
                      context,
                      l10n.authVerificationResentBanner,
                    );
                  },
            child: Text(l10n.authResendEmailButton),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const AuthOrDivider(),
        const SizedBox(height: AppSpacing.lg),
        AuthSecondaryPillButton(
          key: const ValueKey<String>('verify_email_back_button'),
          label: l10n.authBackToSignInButton,
          onPressed: onBackToSignIn,
        ),
      ],
    );
  }
}
