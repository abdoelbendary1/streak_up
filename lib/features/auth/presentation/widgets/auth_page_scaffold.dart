import 'package:flutter/material.dart';
import 'package:streak_up/app/theme/app_tokens.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/core/presentation/widgets/streak_up_wordmark.dart';
import 'package:streak_up/features/auth/domain/auth_models.dart';
import 'package:streak_up/features/auth/presentation/auth_cubit.dart';

/// Shared constraint-driven scaffold for SL-02 authentication, verification,
/// recovery, and session screens (`T027`–`T029`, `SL02-UI-001`–`008`).
class AuthPageScaffold extends StatelessWidget {
  const AuthPageScaffold({
    super.key,
    required this.child,
    this.showTopWordmark = true,
    this.centerContentVertically = false,
  });

  final Widget child;
  final bool showTopWordmark;
  final bool centerContentVertically;

  static const double maxContentWidth = 560.0;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final viewportWidth = mediaQuery.size.width;
    final isCompact = viewportWidth < AppTokens.compactBreakpoint;
    final horizontalPadding =
        isCompact ? AppTokens.spacingMd : AppTokens.spacingLg;

    return Scaffold(
      backgroundColor: AppTokens.backgroundPrimary,
      body: Stack(
        children: <Widget>[
          // Decorative background shapes matching the approved SL-02 PNG set.
          PositionedDirectional(
            top: -80,
            end: -60,
            child: IgnorePointer(
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTokens.brandPrimarySubtle.withValues(alpha: 0.65),
                ),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: -90,
            start: -70,
            child: IgnorePointer(
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTokens.brandPrimarySubtle.withValues(alpha: 0.45),
                ),
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    top: isCompact ? AppTokens.spacingMd : AppTokens.spacingLg,
                    bottom:
                        AppTokens.spacingXl + mediaQuery.viewInsets.bottom,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: centerContentVertically
                          ? (constraints.maxHeight -
                                  (isCompact
                                      ? AppTokens.spacingMd
                                      : AppTokens.spacingLg) -
                                  AppTokens.spacingXl)
                              .clamp(0.0, double.infinity)
                          : 0.0,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: maxContentWidth,
                        ),
                        child: Column(
                          mainAxisAlignment: centerContentVertically
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            if (showTopWordmark) ...<Widget>[
                              const Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: StreakUpWordmark(),
                              ),
                              SizedBox(
                                height: isCompact
                                    ? AppTokens.spacingLg
                                    : AppTokens.spacingXl,
                              ),
                            ],
                            child,
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Accessible input field styled after the approved SL-02 PNG specifications (`SL02-UI-001`, `002`, `004`).
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.suffixIcon,
    this.onSubmitted,
    this.autofillHints,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppTokens.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTokens.spacingXs),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onSubmitted: onSubmitted,
          autofillHints: autofillHints,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: AppTokens.textMuted),
            filled: true,
            fillColor: AppTokens.surfacePrimary,
            prefixIcon: Icon(prefixIcon, color: AppTokens.textMuted),
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppTokens.spacingMd,
              vertical: AppTokens.spacingMd,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTokens.radiusMd),
              borderSide: const BorderSide(color: AppTokens.borderSubtle),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTokens.radiusMd),
              borderSide: const BorderSide(color: AppTokens.borderSubtle),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTokens.radiusMd),
              borderSide: const BorderSide(
                color: AppTokens.brandPrimary,
                width: 1.8,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Full-width primary green pill button (`#16A34A`) with `48dp+` touch target (`SL02-UI-001`–`008`).
class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null && !isLoading,
      label: label,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52),
        child: FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppTokens.brandPrimary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: AppTokens.spacingLg,
              vertical: AppTokens.spacingMd,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTokens.radiusFull),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: Colors.white,
                  ),
                )
              : Text(label, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}

/// Secondary soft-mint pill card button (`SL02-UI-001`–`004`, `008`).
class AuthSecondaryPillButton extends StatelessWidget {
  const AuthSecondaryPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingPrompt,
    this.isDestructive = false,
  });

  final String label;
  final String? leadingPrompt;
  final VoidCallback? onPressed;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final bgColor = isDestructive
        ? AppTokens.statusFailedSurface
        : AppTokens.brandPrimarySubtle;
    final borderColor = isDestructive
        ? AppTokens.statusFailedBorder
        : AppTokens.statusSyncedBorder;
    final actionTextColor = isDestructive
        ? AppTokens.statusFailedText
        : AppTokens.brandPrimary;

    return Semantics(
      button: true,
      label: leadingPrompt != null ? '$leadingPrompt $label' : label,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52),
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: bgColor,
            side: BorderSide(color: borderColor),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTokens.spacingLg,
              vertical: AppTokens.spacingMd,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTokens.radiusFull),
            ),
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppTokens.spacingXs,
            children: <Widget>[
              if (leadingPrompt != null)
                Text(
                  leadingPrompt!,
                  style: TextStyle(
                    color: AppTokens.textSecondary,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              Text(
                label,
                style: TextStyle(
                  color: actionTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Horizontal `"or"` divider (`SL02-UI-001`–`004`).
class AuthOrDivider extends StatelessWidget {
  const AuthOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: <Widget>[
        const Expanded(child: Divider(color: AppTokens.borderSubtle)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTokens.spacingMd),
          child: Text(
            l10n.authOrDivider,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTokens.textMuted,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppTokens.borderSubtle)),
      ],
    );
  }
}

/// Localized, accessible inline error/info callout for SL-02 screens (`T027`–`T029`).
class AuthFeedbackCallout extends StatelessWidget {
  const AuthFeedbackCallout({
    super.key,
    this.failure,
    this.infoMessageKey,
  });

  final AuthFailure? failure;
  final AuthInfoMessageKey? infoMessageKey;

  @override
  Widget build(BuildContext context) {
    if (failure == null && infoMessageKey == null) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context);
    final isError = failure != null;
    final message = isError
        ? _localizeFailure(l10n, failure!.code)
        : _localizeInfo(l10n, infoMessageKey!);

    final backgroundColor = isError
        ? AppTokens.statusFailedSurface
        : AppTokens.statusSyncedSurface;
    final borderColor = isError
        ? AppTokens.statusFailedBorder
        : AppTokens.statusSyncedBorder;
    final textColor =
        isError ? AppTokens.statusFailedText : AppTokens.statusSyncedText;
    final icon = isError ? Icons.error_outline : Icons.check_circle_outline;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTokens.spacingMd),
      child: Semantics(
        liveRegion: true,
        label: message,
        child: Container(
          padding: const EdgeInsets.all(AppTokens.spacingMd),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppTokens.radiusMd),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(icon, color: textColor, size: 20),
              const SizedBox(width: AppTokens.spacingSm),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _localizeFailure(
    AppLocalizations l10n,
    AuthFailureCode code,
  ) {
    return switch (code) {
      AuthFailureCode.invalidCredentials => l10n.authErrorInvalidCredentials,
      AuthFailureCode.emailAlreadyInUse => l10n.authErrorEmailAlreadyInUse,
      AuthFailureCode.weakPassword => l10n.authErrorWeakPassword,
      AuthFailureCode.passwordMismatch => l10n.authErrorPasswordMismatch,
      AuthFailureCode.invalidEmail => l10n.authErrorInvalidEmail,
      AuthFailureCode.verificationStillPending =>
        l10n.authErrorVerificationStillPending,
      AuthFailureCode.verificationLinkExpiredOrInvalid =>
        l10n.authErrorVerificationLinkExpired,
      AuthFailureCode.recoveryLinkExpiredOrInvalid =>
        l10n.authErrorRecoveryLinkExpired,
      AuthFailureCode.rateLimited => l10n.authErrorRateLimited,
      AuthFailureCode.networkOrBackendUnreachable =>
        l10n.authErrorNetworkOrBackend,
      AuthFailureCode.sessionInvalidated => l10n.authSessionExpiredSubtitle,
      AuthFailureCode.unexpected => l10n.authErrorUnexpected,
    };
  }

  static String _localizeInfo(
    AppLocalizations l10n,
    AuthInfoMessageKey key,
  ) {
    return switch (key) {
      AuthInfoMessageKey.verificationEmailResent =>
        l10n.authVerificationResentBanner,
      AuthInfoMessageKey.recoveryEmailResent => l10n.authRecoveryResentBanner,
    };
  }
}
