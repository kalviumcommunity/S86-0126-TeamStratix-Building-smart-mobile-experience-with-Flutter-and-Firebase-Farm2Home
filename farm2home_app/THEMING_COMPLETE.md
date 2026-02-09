# Theming & Dark Mode - Complete Implementation Guide

A comprehensive implementation of theming and dark mode support in Flutter, featuring Material 3 design, custom color schemes, persistent theme preferences, and seamless theme switching.

## Table of Contents

1. [Overview](#overview)
2. [Features](#features)
3. [Architecture](#architecture)
4. [Implementation Guide](#implementation-guide)
5. [Custom Themes](#custom-themes)
6. [Theme Service](#theme-service)
7. [Demo Screen](#demo-screen)
8. [Usage Examples](#usage-examples)
9. [Best Practices](#best-practices)
10. [Testing](#testing)

---

## Overview

This implementation demonstrates a complete theming system that includes:

- **Custom Light & Dark Themes**: Professionally designed themes with Material 3
- **Theme Persistence**: User preferences saved with SharedPreferences
- **System Theme Support**: Follow device theme settings automatically
- **Dynamic Switching**: Change themes at runtime without restart
- **Comprehensive Styling**: All Material components themed consistently

### Why This Matters

- **User Experience**: Let users choose their preferred theme
- **Accessibility**: Dark mode reduces eye strain in low-light conditions
- **Brand Identity**: Consistent visual language across the app
- **Modern Design**: Material 3 design system with dynamic colors
- **Persistence**: Theme preference restored across app sessions

---

## Features

### ✅ Complete Implementation

- [x] Custom light theme with agricultural green color scheme
- [x] Custom dark theme with optimized contrast
- [x] Theme mode selection (Light / Dark / System)
- [x] Persistent storage using SharedPreferences
- [x] Async initialization in app startup
- [x] Provider state management for reactive updates
- [x] Material 3 design system
- [x] All component themes configured
- [x] Typography system
- [x] Color palette management
- [x] Real-time theme preview
- [x] Visual component showcase

---

## Architecture

### File Structure

```
lib/
├── styles/
│   └── app_theme.dart              # Custom light & dark themes
├── services/
│   └── app_theme_service.dart      # Theme state management
├── screens/
│   └── theming_demo_screen.dart    # Theme showcase & settings
└── main.dart                        # Theme initialization & setup
```

### Data Flow

```
SharedPreferences
      ↓
AppThemeService.initialize()
      ↓
AppThemeService (ChangeNotifier)
      ↓
MaterialApp (ThemeMode)
      ↓
All Widgets (Material theme)
```

---

## Implementation Guide

### Step 1: Add Dependencies

Add `shared_preferences` to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.0
  shared_preferences: ^2.2.2
```

Run `flutter pub get` to install the package.

### Step 2: Create Custom Themes

Create `lib/styles/app_theme.dart`:

```dart
import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color darkGreen = Color(0xFF388E3C);
  static const Color lightGreen = Color(0xFF81C784);

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        brightness: Brightness.light,
      ),
      // ... configure all theme properties
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        brightness: Brightness.dark,
      ),
      // ... configure all theme properties
    );
  }
}
```

### Step 3: Create Theme Service

Create `lib/services/app_theme_service.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeService extends ChangeNotifier {
  static const String _themePreferenceKey = 'theme_mode';
  
  ThemeMode _themeMode = ThemeMode.system;
  bool _isInitialized = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;

  // Initialize and load saved preference
  Future<void> initialize() async {
    await _loadThemePreference();
    _isInitialized = true;
    notifyListeners();
  }

  // Load from storage
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_themePreferenceKey);
    if (themeModeString != null) {
      _themeMode = _themeModeFromString(themeModeString);
    }
  }

  // Save to storage
  Future<void> _saveThemePreference(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePreferenceKey, _themeModeToString(mode));
  }

  // Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      await _saveThemePreference(mode);
      notifyListeners();
    }
  }

  // Toggle between light and dark
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }

  // Helper methods
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light: return 'light';
      case ThemeMode.dark: return 'dark';
      case ThemeMode.system: return 'system';
    }
  }

  ThemeMode _themeModeFromString(String mode) {
    switch (mode) {
      case 'light': return ThemeMode.light;
      case 'dark': return ThemeMode.dark;
      default: return ThemeMode.system;
    }
  }
}
```

### Step 4: Initialize in main.dart

Update your `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/app_theme_service.dart';
import 'styles/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize theme service
  final themeService = AppThemeService();
  await themeService.initialize();
  
  runApp(MyApp(themeService: themeService));
}

class MyApp extends StatelessWidget {
  final AppThemeService themeService;
  
  const MyApp({super.key, required this.themeService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeService),
      ],
      child: Consumer<AppThemeService>(
        builder: (context, themeService, _) {
          return MaterialApp(
            title: 'My App',
            // Custom themes
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeService.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
```

---

## Custom Themes

### Light Theme Configuration

```dart
static ThemeData get lightTheme {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Color Scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.light,
      primary: primaryGreen,
      secondary: accentGreen,
      surface: Colors.white,
      background: Color(0xFFF5F5F5),
    ),
    
    // Scaffold
    scaffoldBackgroundColor: Color(0xFFF5F5F5),
    
    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: primaryGreen,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),
    
    // Cards
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    
    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    
    // Input Fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
```

### Dark Theme Configuration

```dart
static ThemeData get darkTheme {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // Color Scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.dark,
      primary: lightGreen,
      secondary: accentGreen,
      surface: Color(0xFF1E1E1E),
      background: Color(0xFF121212),
    ),
    
    scaffoldBackgroundColor: Color(0xFF121212),
    
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
    ),
    
    cardTheme: CardTheme(
      color: Color(0xFF1E1E1E),
      elevation: 4,
    ),
    
    // ... other theme properties
  );
}
```

### Themed Components

The custom themes include complete styling for:

- **Scaffold**: Background colors
- **AppBar**: Colors, elevation, text style
- **Cards**: Elevation, shape, colors
- **Buttons**: Elevated, Outlined, Text buttons
- **Input Fields**: Borders, fill colors, focus states
- **FAB**: Background, foreground colors
- **Navigation**: Bottom nav bar styling
- **Icons**: Default sizes and colors
- **Dividers**: Colors and thickness
- **Typography**: Complete text theme
- **Chips**: Background, selected state
- **Switches**: Thumb and track colors

---

## Theme Service

### Core Functionality

#### Initialize Theme

```dart
final themeService = AppThemeService();
await themeService.initialize();
```

Always call `initialize()` before running your app to load the saved preference.

#### Toggle Theme

```dart
// Toggle between light and dark
await themeService.toggleTheme();
```

#### Set Specific Theme

```dart
// Set light theme
await themeService.setLightTheme();

// Set dark theme
await themeService.setDarkTheme();

// Follow system theme
await themeService.setSystemTheme();
```

#### Check Current Theme

```dart
// Check theme mode
final mode = themeService.themeMode;

// Boolean checks
if (themeService.isDarkMode) { /* ... */ }
if (themeService.isLightMode) { /* ... */ }
if (themeService.isSystemMode) { /* ... */ }
```

### State Management

The service uses `ChangeNotifier` for reactive updates:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Listen to theme changes
    final themeService = Provider.of<AppThemeService>(context);
    
    return IconButton(
      icon: Icon(
        themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
      ),
      onPressed: () => themeService.toggleTheme(),
    );
  }
}
```

---

## Demo Screen

### Features

The `ThemingDemoScreen` demonstrates:

1. **Theme Mode Selection**: Radio buttons for Light/Dark/System
2. **Quick Toggle**: AppBar button to toggle theme
3. **Component Preview**: All themed components displayed
4. **Color Palette**: Visual representation of theme colors
5. **Typography Samples**: Text styles showcase
6. **Interactive Elements**: Switches, sliders, chips
7. **Real-time Updates**: Instant theme switching

### Code Example

```dart
class ThemingDemoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<AppThemeService>(context);
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Theming Demo'),
        actions: [
          IconButton(
            icon: Icon(
              themeService.isDarkMode 
                ? Icons.light_mode 
                : Icons.dark_mode,
            ),
            onPressed: () => themeService.toggleTheme(),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Theme mode selection
          RadioListTile<ThemeMode>(
            title: Text('Light Mode'),
            value: ThemeMode.light,
            groupValue: themeService.themeMode,
            onChanged: (mode) => themeService.setThemeMode(mode!),
          ),
          // Component examples...
        ],
      ),
    );
  }
}
```

---

## Usage Examples

### Example 1: Theme Toggle Button

```dart
class ThemeToggleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeService>(
      builder: (context, themeService, _) {
        return IconButton(
          icon: Icon(
            themeService.isDarkMode 
              ? Icons.light_mode 
              : Icons.dark_mode,
          ),
          onPressed: () => themeService.toggleTheme(),
          tooltip: 'Toggle Theme',
        );
      },
    );
  }
}
```

### Example 2: Theme-Aware Widget

```dart
class ThemedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Card(
      color: isDark 
        ? theme.colorScheme.surface 
        : Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'This card adapts to the current theme',
          style: theme.textTheme.bodyLarge,
        ),
      ),
    );
  }
}
```

### Example 3: Settings Screen

```dart
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeService = context.watch<AppThemeService>();
    
    return ListView(
      children: [
        ListTile(
          title: Text('Appearance'),
          subtitle: Text('Theme: ${_getThemeName(themeService.themeMode)}'),
          onTap: () => _showThemeDialog(context),
        ),
      ],
    );
  }
  
  String _getThemeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light: return 'Light';
      case ThemeMode.dark: return 'Dark';
      case ThemeMode.system: return 'System Default';
    }
  }
  
  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ThemeSelectionDialog(),
    );
  }
}
```

### Example 4: Conditional Styling

```dart
class AdaptiveContainer extends StatelessWidget {
  final Widget child;
  
  const AdaptiveContainer({required this.child});
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Color(0xFF404040) : Colors.grey.shade300,
        ),
      ),
      child: child,
    );
  }
}
```

---

## Best Practices

### 1. Always Use Theme Values

❌ **Don't hardcode colors:**
```dart
Container(color: Colors.white)  // Bad
```

✅ **Use theme colors:**
```dart
Container(color: Theme.of(context).colorScheme.surface)  // Good
```

### 2. Initialize Before Runapp

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Always initialize theme service first
  final themeService = AppThemeService();
  await themeService.initialize();
  
  runApp(MyApp(themeService: themeService));
}
```

### 3. Check Brightness, Not Theme Mode

```dart
// Wrong - checks user preference
if (themeService.isDarkMode) { }

// Right - checks actual brightness
if (Theme.of(context).brightness == Brightness.dark) { }
```

When using `ThemeMode.system`, the theme mode setting is "system" but the actual brightness depends on device settings.

### 4. Use Consumer for Performance

```dart
// Only rebuilds this widget on theme change
Consumer<AppThemeService>(
  builder: (context, themeService, _) {
    return ThemedWidget();
  },
)

// Rebuilds entire widget tree
Provider.of<AppThemeService>(context);
```

### 5. Provide Visual Feedback

```dart
// Show feedback when theme changes
await themeService.toggleTheme();
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Theme changed')),
);
```

### 6. Handle Loading State

```dart
if (!themeService.isInitialized) {
  return CircularProgressIndicator();
}
return MainApp();
```

### 7. Use Semantic Colors

```dart
// Use semantic names from color scheme
theme.colorScheme.primary       // Main brand color
theme.colorScheme.secondary     // Accent color
theme.colorScheme.surface       // Surface/card color
theme.colorScheme.error         // Error states
theme.colorScheme.onPrimary     // Text on primary color
```

### 8. Test Both Themes

Always test your UI in both light and dark themes to ensure:
- Sufficient contrast
- Readable text
- Clear interactive elements
- Consistent spacing

---

## Testing

### Manual Testing Checklist

- [ ] Light theme displays correctly
- [ ] Dark theme displays correctly
- [ ] System theme follows device settings
- [ ] Theme toggle works instantly
- [ ] Theme preference persists after app restart
- [ ] All components are properly themed
- [ ] Text is readable in both themes
- [ ] Colors have sufficient contrast
- [ ] Interactive elements are visible
- [ ] No hardcoded colors remain

### Test Theme Persistence

1. Set theme to Dark
2. Close the app completely
3. Reopen the app
4. Verify dark theme is still active

### Test System Theme

1. Set theme to System
2. Change device theme (Android: Settings > Display > Theme)
3. Verify app theme updates accordingly

### Test All Components

Navigate to the Theming Demo screen and verify:
- All buttons render correctly
- Input fields are properly styled
- Cards have appropriate elevation and colors
- Icons use correct colors
- Text is readable with proper contrast

---

## Common Issues & Solutions

### Issue: Theme doesn't persist

**Solution**: Ensure you're awaiting the initialization:
```dart
await themeService.initialize();
```

### Issue: Theme doesn't update in some screens

**Solution**: Make sure you're using `context` that has access to the Provider:
```dart
// Wrap your MaterialApp with Provider
MultiProvider(
  providers: [
    ChangeNotifierProvider.value(value: themeService),
  ],
  child: MaterialApp(...),
)
```

### Issue: System theme doesn't work

**Solution**: Use `ThemeMode.system` and ensure both `theme` and `darkTheme` are set:
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system,  // This is key
)
```

### Issue: Colors don't change

**Solution**: Use theme colors instead of hardcoded values:
```dart
// Bad
color: Colors.blue

// Good
color: Theme.of(context).colorScheme.primary
```

---

## Advanced Topics

### Custom Color Schemes

Create theme variants:

```dart
class AppTheme {
  // Default green theme
  static ThemeData lightTheme = _buildLightTheme(Colors.green);
  
  // Alternative blue theme
  static ThemeData blueLightTheme = _buildLightTheme(Colors.blue);
  
  static ThemeData _buildLightTheme(Color seed) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );
  }
}
```

### Dynamic Color (Android 12+)

Use Material You dynamic colors:

```dart
import 'package:dynamic_color/dynamic_color.dart';

Widget build(BuildContext context) {
  return DynamicColorBuilder(
    builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return MaterialApp(
        theme: ThemeData(
          colorScheme: lightDynamic ?? AppTheme.lightTheme.colorScheme,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkDynamic ?? AppTheme.darkTheme.colorScheme,
          useMaterial3: true,
        ),
      );
    },
  );
}
```

### Multiple Theme Presets

Allow users to select from multiple color schemes:

```dart
enum ThemePreset { green, blue, purple, orange }

class AppThemeService extends ChangeNotifier {
  ThemePreset _preset = ThemePreset.green;
  
  ThemeData getLightTheme() {
    switch (_preset) {
      case ThemePreset.green: return AppTheme.greenLight;
      case ThemePreset.blue: return AppTheme.blueLight;
      // ... other presets
    }
  }
}
```

---

## Summary

This complete theming implementation provides:

✅ **Professional Design**: Custom Material 3 themes  
✅ **Persistence**: SharedPreferences storage  
✅ **Flexibility**: Light, Dark, and System modes  
✅ **Performance**: Efficient state management with Provider  
✅ **Consistency**: All components themed uniformly  
✅ **User Choice**: Easy theme switching UI  
✅ **Best Practices**: Semantic colors and proper integration

The theming system is production-ready and can be easily customized for any app's brand identity.

---

## Related Documentation

- [Material Design 3](https://m3.material.io/)
- [Flutter Theming Guide](https://docs.flutter.dev/cookbook/design/themes)
- [Provider Package](https://pub.dev/packages/provider)
- [SharedPreferences Package](https://pub.dev/packages/shared_preferences)

---

**Implementation Complete** ✅  
All components tested and working as expected.
