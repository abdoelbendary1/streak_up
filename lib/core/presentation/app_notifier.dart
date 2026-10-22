import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

/// Single, stateless application-wide transient notification utility.
///
/// Uses [toastification] for rendering and respects the active [ThemeData].
abstract final class AppNotifier {
  static void success(BuildContext context, String message) {
    _show(context, message, ToastificationType.success);
  }

  static void error(BuildContext context, String message) {
    _show(context, message, ToastificationType.error);
  }

  static void info(BuildContext context, String message) {
    _show(context, message, ToastificationType.info);
  }

  static void warning(BuildContext context, String message) {
    _show(context, message, ToastificationType.warning);
  }

  static void _show(
    BuildContext context,
    String message,
    ToastificationType type,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final accent = switch (type) {
      ToastificationType.success => colors.primary,
      ToastificationType.error => colors.error,
      ToastificationType.warning => colors.secondary,
      _ => colors.tertiary,
    };

    toastification.show(
      context: context,
      type: type,
      primaryColor: accent,
      backgroundColor: colors.surface,
      foregroundColor: colors.onSurface,
      title: Text(message, style: theme.textTheme.bodyMedium),
      autoCloseDuration: const Duration(seconds: 3),
      showProgressBar: false,
    );
  }
}
