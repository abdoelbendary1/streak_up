import 'package:flutter/material.dart';
import 'package:streak_up/app/theme/app_tokens.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_page_scaffold.dart';

/// Approved Switch Account with Pending Changes Warning view (`SL02-UI-008`, `T029`, `SL02-FR-009`).
class SwitchAccountWarningView extends StatelessWidget {
  const SwitchAccountWarningView({
    super.key,
    required this.onStayOnAccount,
    required this.onSwitchAnyway,
  });

  final VoidCallback onStayOnAccount;
  final VoidCallback onSwitchAnyway;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return AuthPageScaffold(
      child: Container(
        padding: const EdgeInsets.all(AppTokens.spacingLg),
        decoration: BoxDecoration(
          color: AppTokens.surfacePrimary,
          borderRadius: BorderRadius.circular(AppTokens.radiusLg),
          border: Border.all(color: AppTokens.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTokens.brandPrimarySubtle,
                      border: Border.all(
                        color: AppTokens.statusSyncedBorder,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.swap_horiz_rounded,
                      size: 44,
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
                        color: AppTokens.statusPendingSurface,
                        border: Border.all(
                          color: AppTokens.statusPendingBorder,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.cloud_upload_outlined,
                        size: 18,
                        color: AppTokens.statusPendingText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTokens.spacingLg),
            Text(
              l10n.authSwitchAccountWarningTitle,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(
                color: AppTokens.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppTokens.spacingSm),
            Text(
              l10n.authSwitchAccountWarningLead,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: AppTokens.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppTokens.spacingXs),
            Text(
              l10n.authSwitchAccountWarningBody,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: AppTokens.textSecondary,
              ),
            ),
            const SizedBox(height: AppTokens.spacingLg),
            AuthPrimaryButton(
              key: const ValueKey<String>(
                'switch_account_warning_stay_button',
              ),
              label: l10n.authStayOnThisAccountButton,
              onPressed: onStayOnAccount,
            ),
            const SizedBox(height: AppTokens.spacingSm),
            AuthSecondaryPillButton(
              key: const ValueKey<String>(
                'switch_account_warning_confirm_button',
              ),
              label: l10n.authSwitchAnywayButton,
              onPressed: onSwitchAnyway,
            ),
          ],
        ),
      ),
    );
  }
}
