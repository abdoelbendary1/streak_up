import 'package:flutter/material.dart';
import 'package:streak_up/app/theme/app_tokens.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_page_scaffold.dart';

/// Approved Session Expired / Reauthentication screen (`SL02-UI-006`, `T029`, `SL02-FR-007`).
class SessionExpiredScreen extends StatelessWidget {
  const SessionExpiredScreen({
    super.key,
    required this.onSignInAgain,
  });

  final VoidCallback onSignInAgain;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return AuthPageScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: AppTokens.spacingMd),
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTokens.brandPrimarySubtle,
                    border: Border.all(
                      color: AppTokens.statusSyncedBorder,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    size: 46,
                    color: AppTokens.brandPrimary,
                  ),
                ),
                PositionedDirectional(
                  bottom: -4,
                  end: -4,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTokens.statusFailedSurface,
                      border: Border.all(
                        color: AppTokens.statusFailedBorder,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.schedule_rounded,
                      size: 18,
                      color: AppTokens.statusFailedText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTokens.spacingLg),
          Text(
            l10n.authSessionExpiredTitle,
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium?.copyWith(
              color: AppTokens.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppTokens.spacingXs),
          Text(
            l10n.authSessionExpiredSubtitle,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(
              color: AppTokens.textSecondary,
            ),
          ),
          const SizedBox(height: AppTokens.spacingXl),
          AuthPrimaryButton(
            key: const ValueKey<String>('session_expired_sign_in_button'),
            label: l10n.authSignInAgainButton,
            onPressed: onSignInAgain,
          ),
          const SizedBox(height: AppTokens.spacingLg),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTokens.spacingMd,
              vertical: AppTokens.spacingSm,
            ),
            decoration: BoxDecoration(
              color: AppTokens.surfacePrimary,
              borderRadius: BorderRadius.circular(AppTokens.radiusFull),
              border: Border.all(color: AppTokens.borderSubtle),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(
                  Icons.verified_user_outlined,
                  size: 18,
                  color: AppTokens.brandPrimary,
                ),
                const SizedBox(width: AppTokens.spacingXs),
                Flexible(
                  child: Text(
                    l10n.authSessionDataProtectedNote,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppTokens.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
