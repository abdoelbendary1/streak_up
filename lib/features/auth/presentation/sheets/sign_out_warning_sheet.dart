import 'package:flutter/material.dart';
import 'package:streak_up/app/theme/app_colors.dart';
import 'package:streak_up/app/theme/app_radii.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_buttons.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_page_scaffold.dart';

/// Modal bottom sheet warning when signing out with pending changes.
///
/// Returns `true` if the user confirms sign-out ("Sign Out Anyway"),
/// or `false` if dismissed / stay signed in.
class SignOutWarningSheet extends StatelessWidget {
  const SignOutWarningSheet({super.key});

  /// Displays the modal bottom sheet warning and returns whether sign-out was confirmed.
  static Future<bool> show(BuildContext context) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const SignOutWarningSheet(),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _SheetHandle(),
        const SizedBox(height: AppSpacing.lg),
        const _PendingWorkIllustration(),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.authSignOutWarningTitle,
          textAlign: TextAlign.center,
          style: textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.authSignOutWarningLead,
          textAlign: TextAlign.center,
          style: textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.authSignOutWarningBody,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            fontSize: 16,
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AuthPrimaryButton(
          key: const ValueKey<String>('sign_out_warning_stay_button'),
          label: l10n.authStaySignedInButton,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        const SizedBox(height: AppSpacing.sm),
        AuthSecondaryPillButton(
          key: const ValueKey<String>('sign_out_warning_confirm_button'),
          label: l10n.authSignOutAnywayButton,
          isDestructive: true,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );

    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AuthPageScaffold.maxContentWidth,
          ),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(26),
              ),
              border: Border.all(color: AppColors.border),
            ),
            child: SingleChildScrollView(child: content),
          ),
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 44,
        height: 5,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(AppRadii.full),
        ),
      ),
    );
  }
}

class _PendingWorkIllustration extends StatelessWidget {
  const _PendingWorkIllustration();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.offlineBannerBackground,
              border: Border.all(
                color: AppColors.offlineBannerBorder,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.cloud_upload_outlined,
              size: 40,
              color: AppColors.pending,
            ),
          ),
          PositionedDirectional(
            bottom: -4,
            end: -4,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
                border: Border.all(
                  color: AppColors.offlineBannerBorder,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.schedule_rounded,
                size: 18,
                color: AppColors.pending,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
