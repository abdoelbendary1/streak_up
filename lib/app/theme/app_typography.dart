import 'package:flutter/material.dart';
import 'package:streak_up/app/theme/app_colors.dart';

/// Semantic typography hierarchy supporting English and Arabic with readable line heights.
abstract final class AppTypography {
  static TextTheme buildTextTheme() {
    return const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: AppColors.navy,
        height: 1.12,
        letterSpacing: -0.6,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.navy,
        height: 1.25,
        letterSpacing: -0.3,
      ),
      headlineSmall: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: AppColors.navy,
        height: 1.12,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.navy,
        height: 1.35,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.navy,
        height: 1.4,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: AppColors.secondaryText,
        height: 1.3,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.secondaryText,
        height: 1.45,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.navy,
        height: 1.3,
      ),
      labelSmall: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.secondaryText,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.secondaryText,
        height: 1.3,
      ),
    );
  }
}
