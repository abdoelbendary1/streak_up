import 'package:flutter/material.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/app/theme/app_theme.dart';
import 'package:streak_up/core/localization/app_localizations.dart';

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
          child: isLoading
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                )
              : Text(label, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}

/// Secondary soft-mint pill card button.
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
    return Semantics(
      button: true,
      label: leadingPrompt != null ? '$leadingPrompt $label' : label,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52),
        child: OutlinedButton(
          onPressed: onPressed,
          style: isDestructive ? AppTheme.destructiveOutlinedButtonStyle : null,
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.xs,
            children: <Widget>[
              if (leadingPrompt != null)
                Text(
                  leadingPrompt!,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}

/// Horizontal `"or"` divider.
class AuthOrDivider extends StatelessWidget {
  const AuthOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: <Widget>[
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            l10n.authOrDivider,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
