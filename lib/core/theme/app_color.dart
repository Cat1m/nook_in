import 'package:flutter/material.dart';

/// 🎨 App Color Palette
///
/// Cozy, warm colors for a comfortable focus environment
class AppColors {
  AppColors._();

  // Primary - Warm brown/wood tone for "nook" feeling
  static const Color primary = Color(0xFF8B7355);
  static const Color primaryLight = Color(0xFFA89080);
  static const Color primaryDark = Color(0xFF6B5940);

  // Secondary - Soft green for plants/nature
  static const Color secondary = Color(0xFF7C9A7E);
  static const Color secondaryLight = Color(0xFF9FB5A0);
  static const Color secondaryDark = Color(0xFF5A7A5C);

  // Accent - Warm orange for notifications/highlights
  static const Color accent = Color(0xFFD4916D);

  // Neutrals
  static const Color background = Color(0xFFFAF8F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F1ED);

  // Text
  static const Color textPrimary = Color(0xFF2C2416);
  static const Color textSecondary = Color(0xFF6B6254);
  static const Color textTertiary = Color(0xFF9C9589);

  // Status
  static const Color success = Color(0xFF7C9A7E);
  static const Color warning = Color(0xFFE5A854);
  static const Color error = Color(0xFFD47B6D);
  static const Color info = Color(0xFF7B9BC4);

  // Timer specific
  static const Color timerActive = Color(0xFF8B7355);
  static const Color timerPaused = Color(0xFF9C9589);
  static const Color timerComplete = Color(0xFF7C9A7E);

  // Overlay
  static const Color overlay = Color(0x80000000);
  static const Color scrim = Color(0x4D000000);
}
