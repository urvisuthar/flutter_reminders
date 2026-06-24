import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'PlusJakartaSans',

      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        tertiary: AppColors.tertiary,
        onTertiary: Colors.white,
        error: AppColors.error,
        onError: Colors.white,
        background: AppColors.backgroundLight,
        onBackground: AppColors.onSurfaceLight,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.onSurfaceLight,
      ),

      scaffoldBackgroundColor: AppColors.backgroundLight,

      // 📝 TEXT
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 14),
        bodyMedium: TextStyle(fontSize: 12),
        labelLarge: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      ),

      // 🧾 INPUT
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceSoftLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),

      // 📦 CARD
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      dividerColor: AppColors.outline.withOpacity(0.2),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'PlusJakartaSans',
      brightness: Brightness.dark,

      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primary,
        onPrimary: Colors.black,
        secondary: AppColors.secondary,
        onSecondary: Colors.black,
        tertiary: AppColors.tertiary,
        onTertiary: Colors.black,
        error: AppColors.error,
        onError: Colors.black,
        background: AppColors.backgroundDark,
        onBackground: AppColors.onSurfaceDark,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.onSurfaceDark,
      ),

      scaffoldBackgroundColor: AppColors.backgroundDark,

      // 📝 TEXT
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(fontSize: 14, color: Color(0xFFE4EAF0)),
        bodyMedium: TextStyle(fontSize: 12, color: Color(0xFFE4EAF0)),
      ),

      // 🧾 INPUT
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceSoftDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),

      // 📦 CARD
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerColor: Colors.white.withOpacity(0.1),
    );
  }
}
