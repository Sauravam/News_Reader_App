import 'package:flutter/material.dart';

abstract class AppTypography {
  static const String fontFamily = 'Inter';

  static const TextStyle headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    height: 1.33,
  );

  static TextTheme textTheme(Color primaryColor, Color secondaryColor) {
    return TextTheme(
      headlineLarge: headline.copyWith(color: primaryColor),
      headlineMedium: headline.copyWith(color: primaryColor),
      titleLarge: title.copyWith(color: primaryColor),
      titleMedium: title.copyWith(color: primaryColor),
      bodyLarge: body.copyWith(color: primaryColor),
      bodyMedium: body.copyWith(color: primaryColor),
      bodySmall: caption.copyWith(color: secondaryColor),
      labelMedium: caption.copyWith(color: secondaryColor),
    );
  }
}
