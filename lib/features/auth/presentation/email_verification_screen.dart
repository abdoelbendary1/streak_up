import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_up/app/theme/app_tokens.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/auth_cubit.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_page_scaffold.dart';

/// Approved Email Verification gate screen (`SL02-UI-003`, `T028`, `SL02-FR-003`–`004`).
class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({
    super.key,
    required this.onBackToSignIn,
    this.emailOverride,
  });

  final VoidCallback onBackToSignIn;
  final String? emailOverride;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final targetEmail =
            (emailOverride != null && emailOverride!.trim().isNotEmpty)
                ? emailOverride!
                : (state.pendingVerificationEmail ?? 'name@example.com');

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
                        Icons.mark_email_unread_outlined,
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
                          color: AppTokens.surfacePrimary,
                          border: Border.all(
                            color: AppTokens.statusSyncedBorder,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.verified_outlined,
                          size: 18,
                          color: AppTokens.brandPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTokens.spacingLg),
              Text(
                l10n.authVerifyEmailTitle,
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium?.copyWith(
                  color: AppTokens.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppTokens.spacingSm),
              Text(
                l10n.authVerifyEmailSentTo,
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppTokens.textSecondary,
                ),
              ),
              const SizedBox(height: AppTokens.spacingSm),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTokens.spacingMd,
                    vertical: AppTokens.spacingXs,
                  ),
                  decoration: BoxDecoration(
                    color: AppTokens.brandPrimarySubtle,
                    borderRadius: BorderRadius.circular(AppTokens.radiusFull),
                    border: Border.all(color: AppTokens.statusSyncedBorder),
                  ),
                  child: Text(
                    targetEmail,
                    key: const ValueKey<String>('verify_email_target_badge'),
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppTokens.statusSyncedText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppTokens.spacingMd),
              Text(
                l10n.authVerifyEmailBody,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppTokens.textSecondary,
                ),
              ),
              const SizedBox(height: AppTokens.spacingLg),
              AuthFeedbackCallout(
                failure: state.activeFailure,
                infoMessageKey: state.infoMessageKey,
              ),
              AuthPrimaryButton(
                key: const ValueKey<String>('verify_email_check_button'),
                label: l10n.authVerifyEmailPrimaryButton,
                isLoading: state.isSubmitting,
                onPressed: () {
                  context.read<AuthCubit>().checkEmailVerification(
                    email: targetEmail,
                  );
                },
              ),
              const SizedBox(height: AppTokens.spacingSm),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  key: const ValueKey<String>('verify_email_resend_button'),
                  onPressed: state.isSubmitting
                      ? null
                      : () {
                          context.read<AuthCubit>().resendVerificationEmail(
                            email: targetEmail,
                          );
                        },
                  style: TextButton.styleFrom(
                    foregroundColor: AppTokens.brandPrimary,
                    minimumSize: const Size(
                      AppTokens.minTouchTarget,
                      AppTokens.minTouchTarget,
                    ),
                  ),
                  child: Text(
                    l10n.authResendEmailButton,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: AppTokens.spacingMd),
              const AuthOrDivider(),
              const SizedBox(height: AppTokens.spacingLg),
              AuthSecondaryPillButton(
                key: const ValueKey<String>('verify_email_back_button'),
                label: l10n.authBackToSignInButton,
                onPressed: () {
                  context.read<AuthCubit>().clearFeedback();
                  onBackToSignIn();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
