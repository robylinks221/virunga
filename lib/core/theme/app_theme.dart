import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  // Virunga brand colours
  static const Color primary = Color(0xFF0E3A35);
  static const Color secondary = Color(0xFFD8C2A3);

  // Compatibility aliases used throughout the existing app.
  static const Color primaryDeep = Color(0xFF0E3A35);
  static const Color primarySoft = Color(0xFFE7EEEC);

  static const Color accent = Color(0xFFD8C2A3);
  static const Color accentLight = Color(0xFFF1E7D8);
  static const Color accentSoft = Color(0xFFF7F1E8);

  static const Color background = Color(0xFFFAFBF8);
  static const Color surface = Colors.white;

  static const Color textPrimary = Color(0xFF14231D);
  static const Color textSecondary = Color(0xFF6F7A75);
  static const Color textMuted = Color(0xFF7A8580);

  static const Color border = Color(0xFFE5EAE7);
  static const Color cardBorder = Color(0xFFE5EAE7);
  static const Color divider = Color(0xFFE5EAE7);

  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Color(0xFF0E3A35);

  // Existing dashboard/status colours retained as supporting UI colours.
  static const Color success = Color(0xFF2E7D5B);
  static const Color warning = Color(0xFFC58A2A);
  static const Color danger = Color(0xFFB84A4A);
  static const Color blue = Color(0xFF3D6F91);
  static const Color purple = Color(0xFF765A8C);

  static const Color mintSoft = Color(0xFFE7F3ED);
  static const Color blueSoft = Color(0xFFE8F0F5);
  static const Color purpleSoft = Color(0xFFF0EBF4);
}

class AppTypography {
  AppTypography._();

  static const double h1 = 28;
  static const double h2 = 22;
  static const double h3 = 17;
  static const double bodyLarge = 16;
  static const double body = 14;
  static const double small = 12;
  static const double tiny = 10;
}

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

class AppRadii {
  AppRadii._();

  static const double small = 8;
  static const double medium = 14;
  static const double large = 20;
  static const double extraLarge = 28;
  static const double pill = 999;
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
    );

    final textTheme = GoogleFonts.poppinsTextTheme(base.textTheme).apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        onPrimary: AppColors.onPrimary,
        onSecondary: AppColors.onSecondary,
        onSurface: AppColors.textPrimary,
        error: AppColors.danger,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primary,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.medium),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.medium),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.medium),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.medium),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.secondary,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          return IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.textSecondary,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return textTheme.labelSmall?.copyWith(
            color: states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.textSecondary,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          );
        }),
      ),
      dividerColor: AppColors.divider,
    );
  }
}
