import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_up/app/theme/app_tokens.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/auth_cubit.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_page_scaffold.dart';

/// Approved Password Recovery Email Sent screen (`SL02-UI-004B`, `T028`, `SL02-FR-005`).
///
/// Always displays generic non-enumerating confirmation copy (`SL02-AS-07`).
class PasswordRecoverySentScreen extends StatelessWidget {
  const PasswordRecoverySentScreen({
    super.key,
    required this.onBackToSignIn,
  });

  final VoidCallback onBackToSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return AuthPageScaffold(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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
                        Icons.mail_outline_rounded,
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
                          color: AppTokens.brandPrimary,
                          border: Border.all(
                            color: AppTokens.surfacePrimary,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTokens.spacingLg),
              Text(
                l10n.authPasswordRecoverySentTitle,
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium?.copyWith(
                  color: AppTokens.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppTokens.spacingSm),
              Text(
                l10n.authPasswordRecoverySentGenericBody,
                key: const ValueKey<String>(
                  'password_recovery_generic_message',
                ),
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppTokens.textSecondary,
                ),
              ),
              const SizedBox(height: AppTokens.spacingSm),
              Text(
                l10n.authPasswordRecoverySentFollowUp,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppTokens.textMuted,
                ),
              ),
              const SizedBox(height: AppTokens.spacingLg),
              AuthFeedbackCallout(
                failure: state.activeFailure,
                infoMessageKey: state.infoMessageKey,
              ),
              AuthPrimaryButton(
                key: const ValueKey<String>(
                  'password_recovery_sent_back_button',
                ),
                label: l10n.authBackToSignInButton,
                onPressed: () {
                  context.read<AuthCubit>().clearFeedback();
                  onBackToSignIn();
                },
              ),
              const SizedBox(height: AppTokens.spacingSm),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  key: const ValueKey<String>(
                    'password_recovery_send_again_button',
                  ),
                  onPressed: state.isSubmitting
                      ? null
                      : () {
                          context.read<AuthCubit>().resendPasswordRecovery();
                        },
                  style: TextButton.styleFrom(
                    foregroundColor: AppTokens.brandPrimary,
                    minimumSize: const Size(
                      AppTokens.minTouchTarget,
                      AppTokens.minTouchTarget,
                    ),
                  ),
                  child: Text(
                    l10n.authSendAgainButton,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
