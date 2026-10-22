import 'package:flutter/material.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/localization/app_localizations.dart';

/// Secondary screen shell for global/contextual destinations (`Inbox`, `Profile`, `Sync & Recovery`)
/// outside the four-tab bottom bar.
///
/// Uses a direction-aware back affordance and page title, returning predictably
/// to the user's prior selected primary destination.
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
      appBar: AppBar(
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
            child: Padding(
              padding: const EdgeInsetsDirectional.all(AppSpacing.md),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
