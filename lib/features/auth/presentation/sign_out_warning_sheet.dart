import 'package:flutter/material.dart';
import 'package:streak_up/app/theme/app_tokens.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_page_scaffold.dart';

/// Approved Sign Out with Pending Changes Warning sheet/dialog (`SL02-UI-007`, `T029`, `SL02-FR-008`).
class SignOutWarningSheet extends StatelessWidget {
  const SignOutWarningSheet({
    super.key,
    required this.onStaySignedIn,
    required this.onSignOutAnyway,
  });

  final VoidCallback onStaySignedIn;
  final VoidCallback onSignOutAnyway;

  /// Displays the modal bottom sheet warning (`SL02-UI-007`).
  static Future<void> show(
    BuildContext context, {
    required VoidCallback onStaySignedIn,
    required VoidCallback onSignOutAnyway,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SignOutWarningSheet(
        onStaySignedIn: () {
          Navigator.of(ctx).pop();
          onStaySignedIn();
        },
        onSignOutAnyway: () {
          Navigator.of(ctx).pop();
          onSignOutAnyway();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AuthPageScaffold.maxContentWidth,
          ),
          child: Container(
            margin: const EdgeInsets.all(AppTokens.spacingMd),
            padding: const EdgeInsets.all(AppTokens.spacingLg),
            decoration: BoxDecoration(
              color: AppTokens.surfacePrimary,
              borderRadius: BorderRadius.circular(AppTokens.radiusLg),
              border: Border.all(color: AppTokens.borderSubtle),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppTokens.borderSubtle,
                        borderRadius: BorderRadius.circular(
                          AppTokens.radiusFull,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTokens.spacingLg),
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        Container(
                          width: 84,
                          height: 84,
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
                            size: 40,
                            color: AppTokens.statusPendingText,
                          ),
                        ),
                        PositionedDirectional(
                          bottom: -4,
                          end: -4,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTokens.surfacePrimary,
                              border: Border.all(
                                color: AppTokens.statusPendingBorder,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.schedule_rounded,
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
                    l10n.authSignOutWarningTitle,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      color: AppTokens.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppTokens.spacingSm),
                  Text(
                    l10n.authSignOutWarningLead,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppTokens.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppTokens.spacingXs),
                  Text(
                    l10n.authSignOutWarningBody,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppTokens.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppTokens.spacingLg),
                  AuthPrimaryButton(
                    key: const ValueKey<String>('sign_out_warning_stay_button'),
                    label: l10n.authStaySignedInButton,
                    onPressed: onStaySignedIn,
                  ),
                  const SizedBox(height: AppTokens.spacingSm),
                  AuthSecondaryPillButton(
                    key: const ValueKey<String>(
                      'sign_out_warning_confirm_button',
                    ),
                    label: l10n.authSignOutAnywayButton,
                    isDestructive: true,
                    onPressed: onSignOutAnyway,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
