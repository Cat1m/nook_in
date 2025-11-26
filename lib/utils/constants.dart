class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Nook In';
  static const String appTagline = 'Your cozy focus companion';

  // Timer Defaults
  static const int defaultPomodoroMinutes = 25;
  static const int defaultShortBreakMinutes = 5;
  static const int defaultLongBreakMinutes = 15;

  // Audio
  static const double defaultVolume = 0.5;
  static const double minVolume = 0.0;
  static const double maxVolume = 1.0;

  // UI
  static const double borderRadius = 16.0;
  static const double cardElevation = 2.0;
  static const double maxContentWidth = 1200.0;

  // Animation
  static const Duration shortAnimation = Duration(milliseconds: 150);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Assets Paths (will be replaced by flutter_gen)
  static const String backgroundsPath = 'assets/backgrounds/';
  static const String soundsPath = 'assets/sounds/';
}

/// 🎯 Template IDs
class TemplateIds {
  TemplateIds._();

  static const String basic = 'basic';
  static const String cafeMorning = 'cafe-morning';
  static const String rainyNight = 'rainy-night';
  static const String forestDay = 'forest-day';
  static const String oceanWaves = 'ocean-waves';
}

/// 🔊 Sound IDs
class SoundIds {
  SoundIds._();

  static const String rain = 'rain';
  static const String cafe = 'cafe';
  static const String fire = 'fire';
  static const String waves = 'waves';
  static const String birds = 'birds';
  static const String jazz = 'jazz';
  static const String thunder = 'thunder';
}

/// 🖼️ Background IDs
class BackgroundIds {
  BackgroundIds._();

  static const String minimal = 'minimal';
  static const String cafe = 'cafe';
  static const String rainWindow = 'rain-window';
  static const String forest = 'forest';
  static const String ocean = 'ocean';
}
