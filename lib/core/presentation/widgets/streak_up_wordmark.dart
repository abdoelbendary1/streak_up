import 'package:flutter/material.dart';
import 'package:streak_up/core/localization/app_localizations.dart';

/// Reusable brand wordmark widget.
///
/// Renders the approved `docs/design/identity/LOGO.png` bytes without redrawing
/// and preserves left-to-right orientation even in RTL layouts (`matchTextDirection: false`).
class StreakUpWordmark extends StatelessWidget {
  const StreakUpWordmark({super.key, this.height = 32.0});

  static const String assetPath = 'docs/design/identity/LOGO.png';

  final double height;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Brand wordmarks must keep their original LTR geometry in Arabic RTL, unlike directional chevrons.
    return Semantics(
      label: l10n.brandName,
      header: true,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Image.asset(
          assetPath,
          height: height,
          fit: BoxFit.contain,
          matchTextDirection: false,
          excludeFromSemantics: true,
          filterQuality: FilterQuality.medium,
        ),
      ),
    );
  }
}
