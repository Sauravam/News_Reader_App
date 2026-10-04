import 'package:flutter/material.dart';

abstract class AppColors {
  // Light Theme Brand Colors
  static const Color primaryLight = Color(0xFF4A38D9);
  static const Color secondaryLight = Color(0xFFD71D89);
  static const Color tertiaryLight = Color(0xFFF48031);

  // Dark Theme Brand Colors
  static const Color primaryDark = Color(0xFFA89CFF);
  static const Color secondaryDark = Color(0xFFFF6FB8);
  static const Color tertiaryDark = Color(0xFFFFA564);

  // Surface Colors
  static const Color backgroundLight = Color(0xFFFAF9FF);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF121018);
  static const Color surfaceDark = Color(0xFF1C1A24);

  // Outline / Border Colors
  static const Color outlineLight = Color(0xFFE2E0EE);
  static const Color outlineDark = Color(0xFF2E2B3A);

  // Content / Text Colors
  static const Color textPrimaryLight = Color(0xFF1A1829);
  static const Color textSecondaryLight = Color(0xFF635F79);
  static const Color textPrimaryDark = Color(0xFFF1EFFE);
  static const Color textSecondaryDark = Color(0xFFA6A1C4);

  // Brand Gradient (135 Degrees: top-left to bottom-right)
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryLight,
      secondaryLight,
    ],
  );
}

abstract class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
}
