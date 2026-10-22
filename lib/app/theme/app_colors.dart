import 'package:flutter/material.dart';

/// Approved color palette and semantic color roles from `docs/design/DESIGN_SYSTEM.md`
/// and `docs/design/identity/BRAND_IDENTITY.md`.
abstract final class AppColors {
  // Primary Brand Colors
  static const Color primaryGreen = Color(0xFF22C55E);
  static const Color greenDark = Color(0xFF16A34A);
  static const Color navy = Color(0xFF0F172A);

  // Secondary Accents
  static const Color orange = Color(0xFFF97316);
  static const Color blue = Color(0xFF3B82F6);
  static const Color purple = Color(0xFFA855F7);
  static const Color peach = Color(0xFFFB923C);

  // Neutral Surfaces & Typography
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);
  static const Color secondaryText = Color(0xFF64748B);

  // Semantic Status Roles
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color pending = Color(0xFFF97316);
  static const Color information = Color(0xFF3B82F6);

  // Soft Surface Tints (derived from approved PNG visual treatments)
  static const Color selectedGreenPill = Color(0xFFE8F8EE);
  static const Color softGreenSurface = Color(0xFFECFDF3);
  static const Color offlineBannerBackground = Color(0xFFFFF7ED);
  static const Color offlineBannerBorder = Color(0xFFFED7AA);
  static const Color errorBannerBackground = Color(0xFFFEF2F2);
  static const Color errorBannerBorder = Color(0xFFFECACA);
  static const Color errorPillBackground = Color(0xFFFEE2E2);
  static const Color errorTextDark = Color(0xFFB91C1C);
  static const Color warningBannerBackground = Color(0xFFFFFBEB);
  static const Color warningBannerBorder = Color(0xFFFDE68A);
  static const Color infoBannerBackground = Color(0xFFEFF6FF);
  static const Color infoBannerBorder = Color(0xFFBFDBFE);
  static const Color iconContainerNeutral = Color(0xFFF1F5F9);
  static const Color statusSyncedBorder = Color(0xFFBBF7D0);
}
