import 'package:flutter/material.dart';
import 'package:streak_up/app/theme/app_colors.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/core/presentation/status/status_models.dart';

/// Reusable icon-plus-text badge for `Pending`, `Synced`, and `Failed` action synchronization
/// (`T033`, `SL01-FR-011`–`012`, `SL01-FR-015`, `AS-09`–`10`).
///
/// Never relies on color alone: each state pairs a distinct icon and localized label.
class ActionSyncStatusBadge extends StatelessWidget {
  const ActionSyncStatusBadge({
    super.key,
    required this.status,
    this.savedWhileOffline = false,
    this.onReviewFailed,
  });

  final ActionSyncStatus status;
  final bool savedWhileOffline;
  final VoidCallback? onReviewFailed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (IconData icon, Color color, String label) = switch (status) {
      ActionSyncStatus.pending => (
        Icons.sync_rounded,
        AppColors.pending,
        savedWhileOffline
            ? l10n.actionStatusSavedOffline
            : l10n.actionStatusPending,
      ),
      ActionSyncStatus.synced => (
        Icons.cloud_done_outlined,
        AppColors.secondaryText,
        l10n.actionStatusSynced,
      ),
      ActionSyncStatus.failed => (
        Icons.sync_problem_rounded,
        AppColors.error,
        l10n.actionStatusFailed,
      ),
    };

    return Semantics(
      container: true,
      label: label,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.xxs,
        runSpacing: AppSpacing.xxs,
        children: <Widget>[
          Icon(icon, size: 16, color: color),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: status == ActionSyncStatus.synced
                  ? FontWeight.w500
                  : FontWeight.w600,
            ),
          ),
          if (status == ActionSyncStatus.failed && onReviewFailed != null)
            InkWell(
              key: const ValueKey<String>('action_failed_review_button'),
              borderRadius: BorderRadius.circular(12),
              onTap: onReviewFailed,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: AppSpacing.minTouchTarget,
                  minWidth: AppSpacing.minTouchTarget,
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: AppSpacing.xxs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        l10n.actionReview,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: AppColors.errorTextDark,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: AppColors.errorTextDark,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Reusable action row presenting local completion separately from remote sync status
/// (`T033`, `AS-09`, `AS-10`, `SL01-FR-011`–`012`).
class ActionStatusRow extends StatelessWidget {
  const ActionStatusRow({
    super.key,
    required this.projection,
    this.onReviewFailed,
  });

  final ActionStatusProjection projection;
  final VoidCallback? onReviewFailed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final actionLabel = projection.actionLabel;
    final localLabel = l10n.actionLocalCompletedLabel;
    final syncLabel = switch (projection.remoteSyncStatus) {
      ActionSyncStatus.pending =>
        projection.savedWhileOffline
            ? l10n.actionStatusSavedOffline
            : l10n.actionStatusPending,
      ActionSyncStatus.synced => l10n.actionStatusSynced,
      ActionSyncStatus.failed => l10n.actionStatusFailed,
    };

    return Semantics(
      container: true,
      label: l10n.actionSemanticsCombined(
        actionLabel,
        projection.isCompletedLocally ? localLabel : '',
        syncLabel,
      ),
      child: Card(
        key: ValueKey<String>('action_status_row_${projection.actionKey}'),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Use Wrap instead of a fixed Row so the action title and local-save pill stack cleanly at <360px compact widths and 1.3x–1.6x text scales.
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xxs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(
                    actionLabel,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  // Local completion confirms on-device persistence only; remote reconciliation is shown separately by ActionSyncStatusBadge below.
                  if (projection.isCompletedLocally)
                    Container(
                      key: ValueKey<String>(
                        'action_local_complete_${projection.actionKey}',
                      ),
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: AppSpacing.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.selectedGreenPill,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(
                            Icons.check_rounded,
                            size: 18,
                            color: AppColors.greenDark,
                          ),
                          const SizedBox(width: AppSpacing.xxs),
                          Flexible(
                            child: Text(
                              localLabel,
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(color: AppColors.greenDark),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              ActionSyncStatusBadge(
                status: projection.remoteSyncStatus,
                savedWhileOffline: projection.savedWhileOffline,
                onReviewFailed: onReviewFailed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
