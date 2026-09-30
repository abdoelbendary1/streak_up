import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:streak_up/app/routing/shell_destination.dart';
import 'package:streak_up/app/theme/app_colors.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/application/auth_session_coordinator.dart';
import 'package:streak_up/features/auth/presentation/auth_cubit.dart';
import 'package:streak_up/features/auth/presentation/sign_out_warning_sheet.dart';
import 'package:streak_up/features/auth/presentation/switch_account_warning_view.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_page_scaffold.dart';

/// Host contract for injecting primary and global destination content into the SL-01 shell
/// (`T008`, `T018`–`T024`, `SL01-FR-001`–`004`).
///
/// Later slices supply their screen builders through this boundary. When no owning
/// slice builder is supplied, a lightweight labeled SL-01 host surface is rendered
/// without fabricating product behavior or mock persistence.
@lazySingleton
class FeatureRouteHosts {
  const FeatureRouteHosts()
    : todayBuilder = null,
      habitsBuilder = null,
      challengesBuilder = null,
      friendsBuilder = null,
      inboxBuilder = null,
      profileBuilder = null,
      syncRecoveryBuilder = null;

  const FeatureRouteHosts.custom({
    this.todayBuilder,
    this.habitsBuilder,
    this.challengesBuilder,
    this.friendsBuilder,
    this.inboxBuilder,
    this.profileBuilder,
    this.syncRecoveryBuilder,
  });

  final WidgetBuilder? todayBuilder;
  final WidgetBuilder? habitsBuilder;
  final WidgetBuilder? challengesBuilder;
  final WidgetBuilder? friendsBuilder;
  final WidgetBuilder? inboxBuilder;
  final WidgetBuilder? profileBuilder;
  final WidgetBuilder? syncRecoveryBuilder;

  Widget buildDestination(BuildContext context, ShellDestination destination) {
    final builder = switch (destination) {
      ShellDestination.today => todayBuilder,
      ShellDestination.habits => habitsBuilder,
      ShellDestination.challenges => challengesBuilder,
      ShellDestination.friends => friendsBuilder,
    };
    if (builder != null) {
      return builder(context);
    }
    // Render a labeled host contract until the owning slice injects real screen content, avoiding mock product logic in SL-01.
    return LabeledShellHostSurface(destination: destination);
  }

  Widget buildInbox(BuildContext context) {
    if (inboxBuilder != null) {
      return inboxBuilder!(context);
    }
    final l10n = AppLocalizations.of(context);
    return LabeledGlobalRouteSurface(
      surfaceKey: const ValueKey<String>('global_host_inbox'),
      title: l10n.screenInboxTitle,
      description: l10n.screenInboxPlaceholderBody,
      icon: Icons.notifications_none_rounded,
    );
  }

  Widget buildProfile(BuildContext context) {
    if (profileBuilder != null) {
      return profileBuilder!(context);
    }
    return const ProfileRouteSessionHostSurface();
  }

  Widget buildSyncRecovery(BuildContext context) {
    if (syncRecoveryBuilder != null) {
      return syncRecoveryBuilder!(context);
    }
    final l10n = AppLocalizations.of(context);
    return LabeledGlobalRouteSurface(
      surfaceKey: const ValueKey<String>('global_host_sync_recovery'),
      title: l10n.screenSyncRecoveryTitle,
      description: l10n.screenSyncRecoveryPlaceholderBody,
      icon: Icons.sync_problem_rounded,
    );
  }
}

/// Development/test host surface for a primary shell branch (`T008`, `T018`–`T021`).
class LabeledShellHostSurface extends StatelessWidget {
  const LabeledShellHostSurface({super.key, required this.destination});

  final ShellDestination destination;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = destination.localizedLabel(l10n);
    return Semantics(
      container: true,
      label: l10n.hostPlaceholderTitle(label),
      child: Card(
        key: ValueKey<String>('shell_host_${destination.name}'),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.selectedGreenPill,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      destination.selectedIcon,
                      color: AppColors.greenDark,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.hostPlaceholderTitle(label),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.hostPlaceholderSubtitle(destination.sliceCode),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Development/test host surface for global/contextual routes (`T022`–`T024`).
class LabeledGlobalRouteSurface extends StatelessWidget {
  const LabeledGlobalRouteSurface({
    super.key,
    required this.surfaceKey,
    required this.title,
    required this.description,
    required this.icon,
  });

  final Key surfaceKey;
  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: surfaceKey,
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.iconContainerNeutral,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.navy),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

/// Profile route host surface exposing SL-02 session actions (`Sign Out` and `Switch Account`)
/// while preserving the SL-01 `global_host_profile` contract and keeping non-SL-02
/// profile preferences out of scope (`T030`, `SL02-FR-008`–`009`).
class ProfileRouteSessionHostSurface extends StatelessWidget {
  const ProfileRouteSessionHostSurface({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authCubit = context.read<AuthCubit?>();

    if (authCubit == null) {
      return LabeledGlobalRouteSurface(
        surfaceKey: const ValueKey<String>('global_host_profile'),
        title: l10n.screenProfileTitle,
        description: l10n.screenProfilePlaceholderBody,
        icon: Icons.person_outline_rounded,
      );
    }

    return BlocBuilder<AuthCubit, AuthState>(
      bloc: authCubit,
      builder: (context, authState) {
        final activePrompt = authState.activeExitPrompt;
        if (activePrompt != null) {
          if (activePrompt.kind == PendingExitKind.switchAccount) {
            return SwitchAccountWarningView(
              onStayOnAccount: authCubit.cancelPendingExitPrompt,
              onSwitchAnyway: authCubit.confirmPendingExitPrompt,
            );
          }
          if (activePrompt.kind == PendingExitKind.signOut) {
            return SignOutWarningSheet(
              onStaySignedIn: authCubit.cancelPendingExitPrompt,
              onSignOutAnyway: authCubit.confirmPendingExitPrompt,
            );
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LabeledGlobalRouteSurface(
              surfaceKey: const ValueKey<String>('global_host_profile'),
              title: l10n.screenProfileTitle,
              description: l10n.screenProfilePlaceholderBody,
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: AppSpacing.md),
            AuthSecondaryPillButton(
              key: const ValueKey<String>('profile_switch_account_button'),
              label: l10n.authSwitchAccountAction,
              onPressed: () => authCubit.requestAccountSwitch(),
            ),
            const SizedBox(height: AppSpacing.sm),
            AuthSecondaryPillButton(
              key: const ValueKey<String>('profile_sign_out_button'),
              label: l10n.authSignOutAction,
              isDestructive: true,
              onPressed: () => authCubit.requestSignOut(),
            ),
          ],
        );
      },
    );
  }
}
