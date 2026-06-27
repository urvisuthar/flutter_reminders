import 'package:flutter/material.dart';

class AppColors {
  // 🌈 Primary Palette

  static const Color primary = Color(0xFFBFA9B9);
  static const Color primaryDim = Color(0xFFC89FB4);
  static const Color primaryContainer = Color(0xFF9C8FB8);

  static const Color secondary = Color(0xFF8FAFC2);
  static const Color tertiary = Color(0xFF7B8FB0);
  static const Color accent = Color(0xFFD6E4EC);

  // 🌞 Light
  static const Color backgroundLight = Color(0xFFF4F6F8);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceSoftLight = Color(0xFFE9EDF1);

  // 🌙 Dark
  static const Color backgroundDark = Color(0xFF0F1418);
  static const Color surfaceDark = Color(0xFF1A1F24);
  static const Color surfaceSoftDark = Color(0xFF22282E);

  // 📝 Text
  static const Color onSurfaceLight = Color(0xFF2F3A40);
  static const Color onSurfaceDark = Color(0xFFE4EAF0);

  // 🔲 Border
  static const Color outline = Color(0xFFB0BEC5);

  // ❌ Error (soft)
  static const Color error = Color(0xFFB76E79);

  // 📦 Containers
  static const Color containerLight = Color(0xFFE6EBF0);
  static const Color containerDark = Color(0xFF2A3138);

  // 🌈 Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFFD6E4EC),
      Color(0xFFBFA9B9),
      Color(0xFFC89FB4),
      Color(0xFF9C8FB8),
      Color(0xFF8FAFC2),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}