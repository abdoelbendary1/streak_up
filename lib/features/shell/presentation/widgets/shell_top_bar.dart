import 'package:flutter/material.dart';
import 'package:streak_up/app/theme/app_colors.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/core/presentation/widgets/streak_up_wordmark.dart';

/// Shared root top bar (`T016`, `SL01-FR-003`, `SL01-FR-015`, `AS-02`, `AS-15`).
///
/// Displays the approved StreakUp wordmark (`LOGO.png`, unmirrored in RTL) and
/// separate Inbox and Profile global action buttons with 48x48 logical-pixel
/// touch targets and localized accessible labels.
class ShellTopBar extends StatelessWidget {
  const ShellTopBar({
    super.key,
    required this.onInboxPressed,
    required this.onProfilePressed,
  });

  final VoidCallback onInboxPressed;
  final VoidCallback onProfilePressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < AppSpacing.compactWidthMax;
        final wordmarkHeight = isCompact ? 26.0 : 32.0;

        return Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: isCompact ? AppSpacing.sm : AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: StreakUpWordmark(height: wordmarkHeight),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              _CircularTopActionButton(
                buttonKey: const ValueKey<String>('shell_top_action_inbox'),
                label: l10n.actionInbox,
                icon: Icons.notifications_none_rounded,
                onPressed: onInboxPressed,
              ),
              SizedBox(width: isCompact ? AppSpacing.xxs : AppSpacing.xs),
              _CircularTopActionButton(
                buttonKey: const ValueKey<String>('shell_top_action_profile'),
                label: l10n.actionProfile,
                icon: Icons.person_outline_rounded,
                onPressed: onProfilePressed,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CircularTopActionButton extends StatelessWidget {
  const _CircularTopActionButton({
    required this.buttonKey,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final Key buttonKey;
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        key: buttonKey,
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: AppSpacing.minTouchTarget,
            minHeight: AppSpacing.minTouchTarget,
          ),
          child: Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.iconContainerNeutral,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.navy,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
