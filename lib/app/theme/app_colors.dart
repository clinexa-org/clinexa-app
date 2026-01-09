// app/theme/app_colors.dart
import 'package:flutter/material.dart';

/// Banni Flow - Complete Color Palette
/// Dark theme optimized color system
class AppColors {
  // ============== Background & Surfaces ==============
  static const Color background = Color(0xFF181A1B);
  static const Color surface = Color(0xFF1A1C1E);
  static const Color surfaceElevated = Color(0xFF1E2122);
  static const Color surfaceSubtle = Color(0xFF1D1F20);
  static const Color surfaceBlue = Color(0xFF243142);

  // ============== Text ==============
  static const Color textPrimary = Color(0xFFCDC9C2);
  static const Color textSecondary = Color(0xFF9E9589);
  static const Color textMuted = Color(0xFF909BA1);

  // ============== Borders & Dividers ==============
  static const Color border = Color(0xFF383B3D);
  static const Color borderStrong = Color(0xFF46494C);

  // ============== Brand & Primary ==============
  static const Color primary = Color(0xFF0056C6);
  static const Color primaryDark = Color(0xFF0960A7);
  static const Color blueInk = Color(0xFF27374C);

  // ============== Accent & Highlights ==============
  static const Color accent = Color(0xFF51AFF6);
  static const Color accentLight = Color(0xFF79B7F5);

  // ============== Status Colors ==============
  // Success - Green with good contrast on dark background
  static const Color success = Color(0xFF10B981);
  static const Color successForeground = Color(0xFFECFDF5);

  // Warning - Amber/Orange that stands out
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningForeground = Color(0xFFFEF3C7);

  // Error - Red with strong visibility
  static const Color error = Color(0xFFEF4444);
  static const Color errorForeground = Color(0xFFFEE2E2);

  // Private constructor to prevent instantiation
  AppColors._();
}
