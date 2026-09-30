import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_up/app/theme/app_colors.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/core/presentation/feedback/feedback_models.dart';

/// Shared feedback presenter rendering persistent banners, transient snackbar/toast
/// cards, and inline action-level feedback (`T041`, `SL01-FR-013`–`016`, `AS-12`–`15`).
class SharedFeedbackHost extends StatelessWidget {
  const SharedFeedbackHost({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackCoordinator, FeedbackCoordinatorState>(
      builder: (context, feedbackState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (final banner in feedbackState.persistentBanners)
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  bottom: AppSpacing.xs,
                ),
                child: SharedFeedbackCard(
                  key: ValueKey<String>('persistent_feedback_${banner.id}'),
                  descriptor: banner,
                  onDismiss: () => context
                      .read<FeedbackCoordinator>()
                      .dismissBannerOnly(banner.id),
                ),
              ),
            if (feedbackState.activeTransient != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  bottom: AppSpacing.xs,
                ),
                child: SharedFeedbackCard(
                  key: const ValueKey<String>('transient_feedback_card'),
                  descriptor: feedbackState.activeTransient!,
                  onDismiss: () =>
                      context.read<FeedbackCoordinator>().dismissTransient(),
                ),
              ),
            Flexible(child: child),
          ],
        );
      },
    );
  }
}

/// Visual card used by persistent banners, transient snackbars, and inline feedback
/// (`T041`). Pairs semantic color with a distinct icon, severity prefix, and text.
class SharedFeedbackCard extends StatelessWidget {
  const SharedFeedbackCard({
    super.key,
    required this.descriptor,
    this.onDismiss,
  });

  final FeedbackDescriptor descriptor;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final prefix = descriptor.resolveKindPrefix(l10n);
    final message = descriptor.resolveMessage(l10n);
    final (IconData icon, Color fg, Color bg, Color border) = switch (
      descriptor.kind
    ) {
      FeedbackKind.success => (
        Icons.check_circle_outline_rounded,
        AppColors.greenDark,
        AppColors.softGreenSurface,
        AppColors.selectedGreenPill,
      ),
      FeedbackKind.information => (
        Icons.info_outline_rounded,
        AppColors.information,
        AppColors.infoBannerBackground,
        AppColors.infoBannerBorder,
      ),
      FeedbackKind.warning => (
        Icons.warning_amber_rounded,
        AppColors.warning,
        AppColors.warningBannerBackground,
        AppColors.warningBannerBorder,
      ),
      FeedbackKind.recoverableError => (
        Icons.error_outline_rounded,
        AppColors.errorTextDark,
        AppColors.errorBannerBackground,
        AppColors.errorBannerBorder,
      ),
      FeedbackKind.offline => (
        Icons.wifi_off_rounded,
        AppColors.pending,
        AppColors.offlineBannerBackground,
        AppColors.offlineBannerBorder,
      ),
      FeedbackKind.sync => (
        Icons.sync_rounded,
        AppColors.pending,
        AppColors.offlineBannerBackground,
        AppColors.offlineBannerBorder,
      ),
      FeedbackKind.actionRequired => (
        Icons.report_problem_outlined,
        AppColors.errorTextDark,
        AppColors.errorBannerBackground,
        AppColors.errorBannerBorder,
      ),
    };

    return Semantics(
      container: true,
      liveRegion: true,
      label: '$prefix: $message',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: <Widget>[
            Icon(icon, color: fg, size: 22),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 160, maxWidth: 420),
              child: Text(
                '$prefix: $message',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (descriptor.actionIntent != null)
              TextButton(
                key: ValueKey<String>(
                  'feedback_action_${descriptor.actionIntent!.actionId}',
                ),
                style: TextButton.styleFrom(
                  minimumSize: const Size(
                    AppSpacing.minTouchTarget,
                    AppSpacing.minTouchTarget,
                  ),
                ),
                onPressed: descriptor.actionIntent!.onTriggered,
                child: Text(
                  descriptor.actionIntent!.localizedLabel(l10n),
                  style: TextStyle(
                    color: fg,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            if (onDismiss != null)
              IconButton(
                key: ValueKey<String>('feedback_dismiss_${descriptor.id}'),
                constraints: const BoxConstraints(
                  minWidth: AppSpacing.minTouchTarget,
                  minHeight: AppSpacing.minTouchTarget,
                ),
                tooltip: l10n.actionDismiss,
                icon: const Icon(Icons.close_rounded, size: 18),
                onPressed: onDismiss,
              ),
          ],
        ),
      ),
    );
  }
}

/// Inline action-level feedback host that remains visible even if a global
/// transient message or banner is dismissed (`T041`, `AS-14`).
class InlineActionFeedbackHost extends StatelessWidget {
  const InlineActionFeedbackHost({
    super.key,
    required this.actionKey,
  });

  final String actionKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackCoordinator, FeedbackCoordinatorState>(
      builder: (context, state) {
        final descriptor = state.inlineFeedbackByAction[actionKey];
        if (descriptor == null) {
          return const SizedBox.shrink();
        }
        return SharedFeedbackCard(
          key: ValueKey<String>('inline_feedback_$actionKey'),
          descriptor: descriptor,
        );
      },
    );
  }
}
