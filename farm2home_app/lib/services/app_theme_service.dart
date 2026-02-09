import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing app-wide theme (light/dark/system mode)
///
/// This service provides theme persistence using SharedPreferences,
/// allowing the user's theme preference to be saved across app sessions.
///
/// Features:
/// - Light, Dark, and System theme modes
/// - Persistent theme preference storage
/// - Automatic theme initialization on app start
/// - Simple toggle and set methods
class AppThemeService extends ChangeNotifier {
  static const String _themePreferenceKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system;
  bool _isInitialized = false;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;
  bool get isInitialized => _isInitialized;

  /// Initialize the theme service and load saved preference
  ///
  /// Call this once during app initialization before showing the UI.
  /// If no preference is saved, defaults to system theme mode.
  Future<void> initialize() async {
    await _loadThemePreference();
    _isInitialized = true;
    notifyListeners();
  }

  /// Load theme preference from SharedPreferences
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeString = prefs.getString(_themePreferenceKey);

      if (themeModeString != null) {
        _themeMode = _themeModeFromString(themeModeString);
      } else {
        // Default to system mode if no preference saved
        _themeMode = ThemeMode.system;
      }
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
      _themeMode = ThemeMode.system;
    }
  }

  /// Save theme preference to SharedPreferences
  Future<void> _saveThemePreference(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themePreferenceKey, _themeModeToString(mode));
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }

  /// Toggle between light and dark theme
  ///
  /// If currently in system mode, switches to dark.
  /// If in light mode, switches to dark.
  /// If in dark mode, switches to light.
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }

  /// Set the theme mode to a specific value
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      await _saveThemePreference(mode);
      notifyListeners();
    }
  }

  /// Set theme to light mode
  Future<void> setLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }

  /// Set theme to dark mode
  Future<void> setDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }

  /// Set theme to follow system settings
  Future<void> setSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }

  /// Convert ThemeMode to string for storage
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Convert string to ThemeMode
  ThemeMode _themeModeFromString(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }
}
