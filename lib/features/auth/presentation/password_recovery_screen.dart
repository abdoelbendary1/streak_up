import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_up/app/theme/app_tokens.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/auth_cubit.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_page_scaffold.dart';

/// Approved Password Recovery Request screen (`SL02-UI-004`, `T028`, `SL02-FR-005`).
class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({
    super.key,
    required this.onRecoveryLinkRequested,
    required this.onBackToSignIn,
  });

  final VoidCallback onRecoveryLinkRequested;
  final VoidCallback onBackToSignIn;

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final succeeded = await context
        .read<AuthCubit>()
        .requestPasswordRecovery(email: _emailController.text);
    if (succeeded && mounted) {
      widget.onRecoveryLinkRequested();
    }
  }

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
                      width: 92,
                      height: 92,
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
                          color: AppTokens.surfacePrimary,
                          border: Border.all(
                            color: AppTokens.statusSyncedBorder,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.lock_reset_rounded,
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
                l10n.authPasswordRecoveryTitle,
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium?.copyWith(
                  color: AppTokens.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppTokens.spacingXs),
              Text(
                l10n.authPasswordRecoverySubtitle,
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppTokens.textSecondary,
                ),
              ),
              const SizedBox(height: AppTokens.spacingLg),
              AuthFeedbackCallout(
                failure: state.activeFailure,
                infoMessageKey: state.infoMessageKey,
              ),
              AuthTextField(
                key: const ValueKey<String>('password_recovery_email_field'),
                controller: _emailController,
                label: l10n.authEmailLabel,
                hintText: l10n.authEmailHint,
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: AppTokens.spacingLg),
              AuthPrimaryButton(
                key: const ValueKey<String>('password_recovery_submit_button'),
                label: l10n.authSendResetLinkButton,
                isLoading: state.isSubmitting,
                onPressed: _submit,
              ),
              const SizedBox(height: AppTokens.spacingLg),
              const AuthOrDivider(),
              const SizedBox(height: AppTokens.spacingLg),
              AuthSecondaryPillButton(
                key: const ValueKey<String>('password_recovery_back_button'),
                label: l10n.authBackToSignInButton,
                onPressed: () {
                  context.read<AuthCubit>().clearFeedback();
                  widget.onBackToSignIn();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
