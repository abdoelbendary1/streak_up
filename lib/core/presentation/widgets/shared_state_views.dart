import 'package:flutter/material.dart';
import 'package:streak_up/app/theme/app_colors.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/localization/app_localizations.dart';

/// Shared section state kind (`T042`, `SL01-FR-016`, `AS-16`).
///
/// Loading is strictly separate from Empty and Error so an in-progress load
/// or unavailable remote connection is never mislabeled as truly empty.
enum SectionContentStateKind {
  loading,
  trulyEmpty,
  inlineError,
}

/// Reusable loading, truly empty, and inline-error presentation (`T042`, `SL01-FR-016`, `AS-16`).
class SharedSectionStateView extends StatelessWidget {
  const SharedSectionStateView({
    super.key,
    required this.kind,
    this.customTitle,
    this.customDescription,
    this.nextActionLabel,
    this.onNextAction,
  });

  final SectionContentStateKind kind;
  final String? customTitle;
  final String? customDescription;
  final String? nextActionLabel;
  final VoidCallback? onNextAction;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final disableAnimations =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    final (IconData icon, Color iconBg, Color iconFg, String title, String desc) =
        switch (kind) {
          SectionContentStateKind.loading => (
            Icons.hourglass_top_rounded,
            AppColors.infoBannerBackground,
            AppColors.information,
            customTitle ?? l10n.stateLoadingTitle,
            customDescription ?? l10n.stateLoadingDescription,
          ),
          SectionContentStateKind.trulyEmpty => (
            Icons.inbox_outlined,
            AppColors.softGreenSurface,
            AppColors.greenDark,
            customTitle ?? l10n.stateEmptyTitle,
            customDescription ?? l10n.stateEmptyDescription,
          ),
          SectionContentStateKind.inlineError => (
            Icons.error_outline_rounded,
            AppColors.errorBannerBackground,
            AppColors.errorTextDark,
            customTitle ?? l10n.stateErrorTitle,
            customDescription ?? l10n.stateErrorDescription,
          ),
        };

    return Semantics(
      container: true,
      label: '$title. $desc',
      child: Card(
        key: ValueKey<String>('shared_section_state_${kind.name}'),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: (kind == SectionContentStateKind.loading &&
                        !disableAnimations)
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : Icon(icon, color: iconFg, size: 28),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                desc,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (nextActionLabel != null && onNextAction != null) ...<Widget>[
                const SizedBox(height: AppSpacing.md),
                ElevatedButton(
                  key: ValueKey<String>(
                    'shared_section_action_${kind.name}',
                  ),
                  onPressed: onNextAction,
                  child: Text(nextActionLabel!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
