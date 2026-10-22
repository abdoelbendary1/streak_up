/// Approved 4-unit base and 8-unit spacing rhythm plus responsive layout breakpoints
/// from `docs/design/DESIGN_SYSTEM.md`.
abstract final class AppSpacing {
  // 4-unit base / 8-unit spacing rhythm
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;

  // Minimum accessible touch target dimension (WCAG / Material 3)
  static const double minTouchTarget = 48.0;

  // 390x844 is a design reference canvas only; runtime layouts adapt to actual constraints instead of scaling globally.
  static const double compactWidthMax = 360.0;

  // Wide screens cap and center body content so cards and status banners do not stretch uncomfortably.
  static const double maxReadableContentWidth = 560.0;
}
