import 'package:flutter/material.dart';
import 'package:streak_up/app/routing/shell_destination.dart';
import 'package:streak_up/app/theme/app_colors.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/localization/app_localizations.dart';

/// Reusable four-destination bottom navigation (`T017`, `SL01-FR-001`–`002`, `SL01-FR-015`).
///
/// Renders ONLY `Today`, `Habits`, `Challenges`, and `Friends` with the approved
/// pale-green selected pill (`AppColors.selectedGreenPill`) and dark-green icon/text.
/// Adapts naturally to compact widths (`<360px`), wide widths (`>=600px`), RTL,
/// and enlarged system text without fixed item widths or clipping.
class ShellBottomNavigation extends StatelessWidget {
  const ShellBottomNavigation({
    super.key,
    required this.selectedDestination,
    required this.onDestinationSelected,
  });

  final ShellDestination selectedDestination;
  final ValueChanged<ShellDestination> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Center(
          heightFactor: 1.0,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSpacing.maxReadableContentWidth,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact =
                    constraints.maxWidth < AppSpacing.compactWidthMax;
                return Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: isCompact ? AppSpacing.xxs : AppSpacing.xs,
                    vertical: AppSpacing.xs,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      for (final destination in ShellDestination.values)
                        Expanded(
                          child: _BottomNavItem(
                            destination: destination,
                            label: destination.localizedLabel(l10n),
                            semanticLabel: destination == selectedDestination
                                ? l10n.navSemanticsSelected(
                                    destination.localizedLabel(l10n),
                                  )
                                : l10n.navSemanticsUnselected(
                                    destination.localizedLabel(l10n),
                                  ),
                            isSelected: destination == selectedDestination,
                            isCompact: isCompact,
                            onTap: () => onDestinationSelected(destination),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.destination,
    required this.label,
    required this.semanticLabel,
    required this.isSelected,
    required this.isCompact,
    required this.onTap,
  });

  final ShellDestination destination;
  final String label;
  final String semanticLabel;
  final bool isSelected;
  final bool isCompact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = isSelected
        ? AppColors.greenDark
        : AppColors.secondaryText;

    return Semantics(
      excludeSemantics: true,
      selected: isSelected,
      button: true,
      onTap: onTap,
      label: semanticLabel,
      child: InkWell(
        key: ValueKey<String>('shell_bottom_nav_${destination.name}'),
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.minTouchTarget,
            minWidth: AppSpacing.minTouchTarget,
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 2,
              vertical: 2,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  key: ValueKey<String>(
                    'shell_bottom_nav_pill_${destination.name}',
                  ),
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: isCompact ? AppSpacing.sm : AppSpacing.md,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.selectedGreenPill
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Icon(
                    isSelected ? destination.selectedIcon : destination.icon,
                    color: activeColor,
                    size: 22,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: activeColor,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
