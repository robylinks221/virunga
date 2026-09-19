import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Virunga approved brand colours.
  static const primary = Color(0xFF032329);
  static const primaryDeep = Color(0xFF032329);
  static const primarySoft = Color(0xFF0A3941);

  static const accent = Color(0xFFF58020);
  static const accentLight = Color(0xFFFFA45C);
  static const accentSoft = Color(0xFFFFEBDD);

  static const background = Color(0xFFF5F1E8);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF14231D);
  static const textSecondary = Color(0xFF6F7A75);
  static const textMuted = Color(0xFF9AA19D);

  static const success = Color(0xFF17854B);
  static const warning = Color(0xFFE69D18);
  static const danger = Color(0xFFC85145);
  static const blue = Color(0xFF2D6ED8);
  static const purple = Color(0xFF8658DD);
  static const mintSoft = Color(0xFFE9F6EE);
  static const blueSoft = Color(0xFFE9F1FF);
  static const purpleSoft = Color(0xFFF0EAFF);

  static const divider = Color(0xFFE5EAE7);
  static const cardBorder = Color(0xFFE5EAE7);
}

class AppTypography {
  AppTypography._();
  static const fontFamily = 'Poppins';
  static const h1 = 27.0;
  static const h2 = 22.0;
  static const h3 = 18.0;
  static const bodyLarge = 16.0;
  static const body = 14.0;
  static const small = 12.0;
  static const tiny = 10.5;
}

class AppSpacing {
  AppSpacing._();
  static const double xs = 6;
  static const double sm = 10;
  static const double md = 16;
  static const double lg = 22;
  static const double xl = 30;
  static const double xxl = 42;
}

class AppRadii {
  AppRadii._();
  static const medium = 18.0;
  static const large = 28.0;
  static const pill = 999.0;
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: AppTypography.fontFamily,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.surface,
    ),
    dividerColor: AppColors.divider,
  );
}
