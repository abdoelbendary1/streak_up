import 'package:flutter/material.dart';
import 'package:streak_up/app/theme/app_colors.dart';
import 'package:streak_up/app/theme/app_spacing.dart';

/// Unified semantic design token façade over [AppColors] and [AppSpacing] (`docs/design/DESIGN_SYSTEM.md`).
abstract final class AppTokens {
  // Spacing & Layout
  static const double spacingXs = AppSpacing.xs;
  static const double spacingSm = AppSpacing.sm;
  static const double spacingMd = AppSpacing.md;
  static const double spacingLg = AppSpacing.lg;
  static const double spacingXl = AppSpacing.xl;

  static const double minTouchTarget = AppSpacing.minTouchTarget;
  static const double compactBreakpoint = AppSpacing.compactWidthMax;
  static const double wideBreakpoint = AppSpacing.wideWidthMin;

  // Radii
  static const double radiusSm = 8.0;
  static const double radiusMd = 14.0;
  static const double radiusLg = 24.0;
  static const double radiusFull = 999.0;

  // Brand & Surfaces
  static const Color brandPrimary = AppColors.greenDark;
  static const Color brandPrimarySubtle = AppColors.selectedGreenPill;
  static const Color backgroundPrimary = AppColors.background;
  static const Color surfacePrimary = AppColors.surface;
  static const Color borderSubtle = AppColors.border;

  // Typography
  static const Color textPrimary = AppColors.navy;
  static const Color textSecondary = AppColors.secondaryText;
  static const Color textMuted = AppColors.secondaryText;

  // Semantic Status Tokens
  static const Color statusSyncedSurface = AppColors.softGreenSurface;
  static const Color statusSyncedBorder = Color(0xFFBBF7D0);
  static const Color statusSyncedText = AppColors.greenDark;

  static const Color statusPendingSurface = AppColors.offlineBannerBackground;
  static const Color statusPendingBorder = AppColors.offlineBannerBorder;
  static const Color statusPendingText = AppColors.pending;

  static const Color statusFailedSurface = AppColors.errorBannerBackground;
  static const Color statusFailedBorder = AppColors.errorBannerBorder;
  static const Color statusFailedText = AppColors.errorTextDark;
}
