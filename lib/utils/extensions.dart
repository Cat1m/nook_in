import 'package:flutter/material.dart';

/// 🕐 Duration Extensions
extension DurationExtensions on Duration {
  /// Format as MM:SS
  String toMinutesSeconds() {
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Format as HH:MM:SS
  String toHoursMinutesSeconds() {
    final hours = inHours.toString().padLeft(2, '0');
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  /// Check if duration is zero
  bool get isZero => inSeconds == 0;

  /// Check if duration is positive
  bool get isPositive => inSeconds > 0;
}

/// 🎨 BuildContext Extensions
extension BuildContextExtensions on BuildContext {
  /// Get theme
  ThemeData get theme => Theme.of(this);

  /// Get color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get text theme
  TextTheme get textTheme => theme.textTheme;

  /// Get media query
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get screen size
  Size get screenSize => mediaQuery.size;

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Check if mobile
  bool get isMobile => screenWidth < 600;

  /// Check if tablet
  bool get isTablet => screenWidth >= 600 && screenWidth < 900;

  /// Check if desktop
  bool get isDesktop => screenWidth >= 900;

  /// Show snackbar
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message), duration: duration, action: action),
    );
  }

  /// Show error snackbar
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

/// 🔢 Double Extensions
extension DoubleExtensions on double {
  /// Clamp between 0 and 1
  double clamp01() => clamp(0.0, 1.0).toDouble();

  /// Convert to percentage string
  String toPercentage() => '${(this * 100).toInt()}%';
}

/// 📝 String Extensions
extension StringExtensions on String {
  /// Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Check if string is empty or null
  bool get isNullOrEmpty => trim().isEmpty;
}

/// 📋 List Extensions
extension ListExtensions<T> on List<T> {
  /// Get item at index or null if out of bounds
  T? getOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }
}
