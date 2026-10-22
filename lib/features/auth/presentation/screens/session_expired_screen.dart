import 'package:flutter/material.dart';
import 'package:streak_up/app/theme/app_colors.dart';
import 'package:streak_up/app/theme/app_radii.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_buttons.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_page_scaffold.dart';

class SessionExpiredScreen extends StatelessWidget {
  const SessionExpiredScreen({super.key, required this.onSignInAgain});

  final VoidCallback onSignInAgain;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return AuthPageScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: AppSpacing.md),
          const _SessionExpiredIllustration(),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.authSessionExpiredTitle,
            textAlign: TextAlign.center,
            style: textTheme.headlineLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.authSessionExpiredSubtitle,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.xl),
          AuthPrimaryButton(
            key: const ValueKey<String>('session_expired_sign_in_button'),
            label: l10n.authSignInAgainButton,
            onPressed: onSignInAgain,
          ),
          const SizedBox(height: AppSpacing.lg),
          const _DataProtectedNote(),
        ],
      ),
    );
  }
}

class _SessionExpiredIllustration extends StatelessWidget {
  const _SessionExpiredIllustration();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.selectedGreenPill,
              border: Border.all(color: AppColors.statusSyncedBorder, width: 2),
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              size: 46,
              color: AppColors.greenDark,
            ),
          ),
          PositionedDirectional(
            bottom: -4,
            end: -4,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.errorBannerBackground,
                border: Border.all(
                  color: AppColors.errorBannerBorder,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.schedule_rounded,
                size: 18,
                color: AppColors.errorTextDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DataProtectedNote extends StatelessWidget {
  const _DataProtectedNote();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.full),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.verified_user_outlined,
              size: 18,
              color: AppColors.greenDark,
            ),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                l10n.authSessionDataProtectedNote,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
