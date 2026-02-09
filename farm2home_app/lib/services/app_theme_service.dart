import 'package:flutter/material.dart';

/// Service to manage app theme (light/dark mode)
/// Demonstrates state management for app-wide settings
class AppThemeService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  /// Get current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Check if dark mode is enabled
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Toggle between light and dark mode
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    debugPrint('Theme changed to: $_themeMode');
  }

  /// Set specific theme mode
  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
      debugPrint('Theme set to: $_themeMode');
    }
  }

  /// Set light theme
  void setLightTheme() => setThemeMode(ThemeMode.light);

  /// Set dark theme
  void setDarkTheme() => setThemeMode(ThemeMode.dark);
}
