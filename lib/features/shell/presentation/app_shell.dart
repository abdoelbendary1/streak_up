import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_up/app/routing/shell_destination.dart';
import 'package:streak_up/app/theme/app_colors.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/core/presentation/feedback/widgets/shared_feedback_host.dart';
import 'package:streak_up/core/presentation/status/status_models.dart';
import 'package:streak_up/core/presentation/status/widgets/action_sync_status_badge.dart';
import 'package:streak_up/core/presentation/status/widgets/shell_status_banner.dart';
import 'package:streak_up/features/shell/presentation/shell_cubit.dart';
import 'package:streak_up/features/shell/presentation/widgets/shell_bottom_navigation.dart';
import 'package:streak_up/features/shell/presentation/widgets/shell_top_bar.dart';

/// Constraint-driven responsive root shell (`T015`, `SL01-FR-001`–`004`, `SL01-FR-015`).
///
/// Adapts across:
/// - Compact width (`< 360` logical px)
/// - Standard phone width (`360–599` logical px)
/// - Wide width (`>= 600` logical px, centering primary content within `maxReadableContentWidth`
///   while preserving the four-destination bottom navigation without a tablet redesign)
/// - Short heights and landscape orientation via natural vertical scrolling
/// - Safe areas and keyboard `viewInsets`
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.activeDestination,
    required this.onDestinationSelected,
    required this.onOpenInbox,
    required this.onOpenProfile,
    required this.onOpenSyncRecovery,
    required this.child,
  });

  final ShellDestination activeDestination;
  final ValueChanged<ShellDestination> onDestinationSelected;
  final VoidCallback onOpenInbox;
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenSyncRecovery;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final viewInsetsBottom = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.topCenter,
          // Constrain and center primary content on wide viewports (>=600px) without introducing a separate tablet navigation model.
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSpacing.maxReadableContentWidth,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact =
                    constraints.maxWidth < AppSpacing.compactWidthMax;
                final horizontalPadding = isCompact
                    ? AppSpacing.sm
                    : AppSpacing.md;

                return Column(
                  children: <Widget>[
                    ShellTopBar(
                      onInboxPressed: onOpenInbox,
                      onProfilePressed: onOpenProfile,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        key: const ValueKey<String>(
                          'shell_scrollable_content_host',
                        ),
                        padding: EdgeInsetsDirectional.fromSTEB(
                          horizontalPadding,
                          AppSpacing.xs,
                          horizontalPadding,
                          AppSpacing.lg + viewInsetsBottom,
                        ),
                        child: BlocBuilder<ShellStatusCubit, ShellStatusState>(
                          builder: (context, statusState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ShellStatusBanner(
                                  statusState: statusState,
                                  onReviewPressed: onOpenSyncRecovery,
                                ),
                                if (statusState.networkState !=
                                        NetworkState.online ||
                                    statusState.pendingCount > 0 ||
                                    statusState.failedCount > 0 ||
                                    statusState.isAuthActionRequired)
                                  const SizedBox(height: AppSpacing.sm),
                                SharedFeedbackHost(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      child,
                                      if (statusState
                                          .actions
                                          .isNotEmpty) ...<Widget>[
                                        const SizedBox(height: AppSpacing.md),
                                        for (final action
                                            in statusState.actions.values)
                                          Padding(
                                            padding:
                                                const EdgeInsetsDirectional.only(
                                                  bottom: AppSpacing.xs,
                                                ),
                                            child: ActionStatusRow(
                                              projection: action,
                                              onReviewFailed:
                                                  action.requiresRecovery
                                                  ? onOpenSyncRecovery
                                                  : null,
                                            ),
                                          ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<ShellCubit, ShellState>(
        builder: (context, shellState) {
          return ShellBottomNavigation(
            selectedDestination: activeDestination,
            onDestinationSelected: onDestinationSelected,
          );
        },
      ),
    );
  }
}

/// Secondary screen shell for global/contextual destinations (`Inbox`, `Profile`, `Sync & Recovery`)
/// outside the four-tab bottom bar (`T022`–`T024`, `DESIGN_SYSTEM.md` §App bar and bottom navigation).
///
/// Uses a direction-aware back affordance and page title, returning predictably
/// to the user's prior selected primary destination (`AS-02`, `AS-03`).
class GlobalRouteShell extends StatelessWidget {
  const GlobalRouteShell({
    super.key,
    required this.title,
    required this.onBack,
    required this.child,
  });

  final String title;
  final VoidCallback onBack;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leadingWidth: AppSpacing.minTouchTarget + AppSpacing.sm,
        leading: Semantics(
          button: true,
          label: l10n.actionBack,
          child: IconButton(
            key: const ValueKey<String>('global_route_back_button'),
            constraints: const BoxConstraints(
              minWidth: AppSpacing.minTouchTarget,
              minHeight: AppSpacing.minTouchTarget,
            ),
            tooltip: l10n.actionBack,
            // Directional navigation icons mirror automatically in RTL to match reading order, unlike the brand wordmark.
            icon: const BackButtonIcon(),
            onPressed: onBack,
          ),
        ),
        title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSpacing.maxReadableContentWidth,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.all(AppSpacing.md),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
