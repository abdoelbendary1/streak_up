import 'package:flutter/material.dart';
import 'package:streak_up/app/theme/app_tokens.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/core/presentation/widgets/streak_up_wordmark.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_page_scaffold.dart';

/// Approved Session Restoring screen (`SL02-UI-005`, `T029`, `SL02-FR-006`).
///
/// Shown at startup while session validity is restored so protected shell content
/// never flashes before authentication and email verification are confirmed.
class SessionRestoringScreen extends StatelessWidget {
  const SessionRestoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return AuthPageScaffold(
      showTopWordmark: false,
      centerContentVertically: true,
      child: Semantics(
        liveRegion: true,
        label: '${l10n.authRestoringTitle}. ${l10n.authRestoringSubtitle}',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Center(
              child: StreakUpWordmark(height: 44),
            ),
            const SizedBox(height: AppTokens.spacingXl),
            const SizedBox(
              width: 44,
              height: 44,
              child: CircularProgressIndicator(
                strokeWidth: 3.2,
                color: AppTokens.brandPrimary,
              ),
            ),
            const SizedBox(height: AppTokens.spacingLg),
            Text(
              l10n.authRestoringTitle,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(
                color: AppTokens.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppTokens.spacingXs),
            Text(
              l10n.authRestoringSubtitle,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: AppTokens.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
