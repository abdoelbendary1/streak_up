import 'package:flutter/material.dart';
import 'package:streak_up/app/theme/app_colors.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/core/presentation/status/status_models.dart';

/// Shared shell status banner host (`T034`–`T037`, `SL01-FR-004`, `SL01-FR-009`–`012`).
///
/// Renders distinct visual, icon, and localized text explanations for:
/// - `Online` (concise accessible indicator when requested or silent when normal)
/// - `Offline` (warm pale-orange informational banner matching `SL01-UI-002-offline-en.png`)
/// - `Reconnecting` (in-progress reachability restoration banner)
/// - `Syncing` (in-progress synchronization banner that does not imply acknowledgment)
/// - `SyncFailed` (persistent pale-red issue banner with `Review` button matching `SL01-UI-001` & `SL01-UI-004`)
/// - `Auth/Session Action Required` (distinct from Offline, directing to account recovery)
class ShellStatusBanner extends StatelessWidget {
  const ShellStatusBanner({
    super.key,
    required this.statusState,
    required this.onReviewPressed,
    this.showOnlineIndicator = false,
  });

  final ShellStatusState statusState;
  final VoidCallback onReviewPressed;
  final bool showOnlineIndicator;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final disableAnimations =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    if (statusState.isAuthActionRequired) {
      return _StatusBannerCard(
        bannerKey: const ValueKey<String>('shell_status_banner_auth_required'),
        backgroundColor: AppColors.errorBannerBackground,
        borderColor: AppColors.errorBannerBorder,
        icon: Icons.manage_accounts_rounded,
        iconColor: AppColors.errorTextDark,
        title: l10n.networkAuthRequiredTitle,
        description: l10n.networkAuthRequiredDescription,
        actionLabel: l10n.actionAccountRecovery,
        onActionPressed: onReviewPressed,
      );
    }

    final networkState = statusState.failedCount > 0
        ? NetworkState.syncFailed
        : statusState.networkState;
    switch (networkState) {
      case NetworkState.online:
        if (!showOnlineIndicator && statusState.pendingCount == 0) {
          return const SizedBox.shrink();
        }
        if (statusState.pendingCount > 0) {
          return _StatusBannerCard(
            bannerKey: const ValueKey<String>('shell_status_banner_pending'),
            backgroundColor: AppColors.offlineBannerBackground,
            borderColor: AppColors.offlineBannerBorder,
            icon: Icons.sync_rounded,
            iconColor: AppColors.pending,
            title: l10n.networkPendingQueueBannerTitle(
              statusState.pendingCount,
            ),
            description: l10n.networkPendingQueueBannerDescription,
            actionLabel: l10n.actionReview,
            onActionPressed: onReviewPressed,
          );
        }
        return _StatusBannerCard(
          bannerKey: const ValueKey<String>('shell_status_banner_online'),
          backgroundColor: AppColors.softGreenSurface,
          borderColor: AppColors.selectedGreenPill,
          icon: Icons.cloud_done_outlined,
          iconColor: AppColors.greenDark,
          title: l10n.networkOnlineTitle,
          description: l10n.networkOnlineDescription,
        );

      case NetworkState.offline:
        return _StatusBannerCard(
          bannerKey: const ValueKey<String>('shell_status_banner_offline'),
          backgroundColor: AppColors.offlineBannerBackground,
          borderColor: AppColors.offlineBannerBorder,
          icon: Icons.wifi_off_rounded,
          iconColor: AppColors.pending,
          title: l10n.networkOfflineTitle,
          description: l10n.networkOfflineDescription,
        );

      case NetworkState.reconnecting:
        return _StatusBannerCard(
          bannerKey: const ValueKey<String>('shell_status_banner_reconnecting'),
          backgroundColor: AppColors.warningBannerBackground,
          borderColor: AppColors.warningBannerBorder,
          icon: disableAnimations
              ? Icons.wifi_find_rounded
              : Icons.sync_rounded,
          iconColor: AppColors.warning,
          title: l10n.networkReconnectingTitle,
          description: l10n.networkReconnectingDescription,
        );

      case NetworkState.syncing:
        return _StatusBannerCard(
          bannerKey: const ValueKey<String>('shell_status_banner_syncing'),
          backgroundColor: AppColors.infoBannerBackground,
          borderColor: AppColors.infoBannerBorder,
          icon: disableAnimations
              ? Icons.cloud_upload_outlined
              : Icons.cloud_sync_outlined,
          iconColor: AppColors.information,
          title: l10n.networkSyncingTitle,
          description: l10n.networkSyncingDescription,
        );

      case NetworkState.syncFailed:
        final count = statusState.failedCount > 0 ? statusState.failedCount : 1;
        final title = statusState.compactSyncBanner
            ? l10n.networkSyncFailedCompactTitle(count)
            : l10n.networkSyncFailedTitle;
        final description = statusState.compactSyncBanner
            ? l10n.networkSyncFailedCompactDescription
            : l10n.networkSyncFailedDescription(count);
        return _StatusBannerCard(
          bannerKey: const ValueKey<String>('shell_status_banner_sync_failed'),
          backgroundColor: AppColors.errorBannerBackground,
          borderColor: AppColors.errorBannerBorder,
          icon: Icons.error_outline_rounded,
          iconColor: AppColors.errorTextDark,
          title: title,
          description: description,
          actionLabel: l10n.actionReview,
          onActionPressed: onReviewPressed,
        );
    }
  }
}

class _StatusBannerCard extends StatelessWidget {
  const _StatusBannerCard({
    required this.bannerKey,
    required this.backgroundColor,
    required this.borderColor,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onActionPressed,
  });

  final Key bannerKey;
  final Color backgroundColor;
  final Color borderColor;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      liveRegion: true,
      label: '$title. $description',
      child: Container(
        key: bannerKey,
        width: double.infinity,
        padding: const EdgeInsetsDirectional.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final textScale = MediaQuery.textScalerOf(context).scale(1.0);
            final useStackedAction =
                constraints.maxWidth < AppSpacing.compactWidthMax ||
                textScale > 1.35;

            final actionButton =
                (actionLabel != null && onActionPressed != null)
                ? Semantics(
                    button: true,
                    label: actionLabel,
                    child: InkWell(
                      key: const ValueKey<String>('shell_status_review_action'),
                      borderRadius: BorderRadius.circular(999),
                      onTap: onActionPressed,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: AppSpacing.minTouchTarget,
                          minWidth: AppSpacing.minTouchTarget,
                        ),
                        child: Container(
                          padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.errorPillBackground,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  actionLabel!,
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(
                                        color: AppColors.errorTextDark,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xxs),
                              const Icon(
                                Icons.chevron_right_rounded,
                                size: 18,
                                color: AppColors.errorTextDark,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : null;

            if (useStackedAction && actionButton != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(icon, color: iconColor, size: 24),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _BannerTextColumn(
                          title: title,
                          description: description,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: actionButton,
                  ),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(icon, color: iconColor, size: 24),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _BannerTextColumn(
                    title: title,
                    description: description,
                  ),
                ),
                if (actionButton != null) ...<Widget>[
                  const SizedBox(width: AppSpacing.sm),
                  actionButton,
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BannerTextColumn extends StatelessWidget {
  const _BannerTextColumn({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          description,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryText),
        ),
      ],
    );
  }
}
