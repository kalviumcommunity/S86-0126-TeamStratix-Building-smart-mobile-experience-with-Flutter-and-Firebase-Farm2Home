import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_theme_service.dart';

/// Comprehensive theming demonstration screen
///
/// This screen demonstrates:
/// - Theme mode selection (Light/Dark/System)
/// - Quick theme toggle
/// - Visual examples of all themed components
/// - Real-time theme switching
class ThemingDemoScreen extends StatefulWidget {
  const ThemingDemoScreen({super.key});

  @override
  State<ThemingDemoScreen> createState() => _ThemingDemoScreenState();
}

class _ThemingDemoScreenState extends State<ThemingDemoScreen> {
  bool _switchValue = true;
  double _sliderValue = 50;
  int _selectedChip = 0;

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<AppThemeService>(context);
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theming & Dark Mode'),
        actions: [
          // Quick theme toggle button
          IconButton(
            icon: Icon(
              themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => themeService.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Mode Selection Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.palette, color: theme.colorScheme.primary),
                      const SizedBox(width: 12),
                      Text('Theme Mode', style: theme.textTheme.titleLarge),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // ignore: deprecated_member_use
                  ListTile(
                    leading: const Icon(Icons.light_mode),
                    title: const Text('Light Mode'),
                    subtitle: const Text('Always use light theme'),
                    trailing: Radio<ThemeMode>(
                      value: ThemeMode.light,
                      // ignore: deprecated_member_use
                      groupValue: themeService.themeMode,
                      // ignore: deprecated_member_use
                      onChanged: (mode) {
                        if (mode != null) themeService.setThemeMode(mode);
                      },
                    ),
                    onTap: () => themeService.setThemeMode(ThemeMode.light),
                  ),
                  // ignore: deprecated_member_use
                  ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Always use dark theme'),
                    trailing: Radio<ThemeMode>(
                      value: ThemeMode.dark,
                      // ignore: deprecated_member_use
                      groupValue: themeService.themeMode,
                      // ignore: deprecated_member_use
                      onChanged: (mode) {
                        if (mode != null) themeService.setThemeMode(mode);
                      },
                    ),
                    onTap: () => themeService.setThemeMode(ThemeMode.dark),
                  ),
                  // ignore: deprecated_member_use
                  ListTile(
                    leading: const Icon(Icons.brightness_auto),
                    title: const Text('System Default'),
                    subtitle: const Text('Follow system settings'),
                    trailing: Radio<ThemeMode>(
                      value: ThemeMode.system,
                      // ignore: deprecated_member_use
                      groupValue: themeService.themeMode,
                      // ignore: deprecated_member_use
                      onChanged: (mode) {
                        if (mode != null) themeService.setThemeMode(mode);
                      },
                    ),
                    onTap: () => themeService.setThemeMode(ThemeMode.system),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Current Theme Info
          Card(
            child: ListTile(
              leading: Icon(
                brightness == Brightness.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                'Current Theme: ${brightness == Brightness.dark ? 'Dark' : 'Light'}',
                style: theme.textTheme.titleMedium,
              ),
              subtitle: Text(
                'Theme preference is saved automatically',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Components Preview Section
          Text('Components Preview', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'See how different components look in the current theme',
            style: theme.textTheme.bodyMedium,
          ),

          const SizedBox(height: 16),

          // Buttons Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Buttons', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Elevated'),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('Outlined'),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Text Button'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.send),
                        label: const Text('With Icon'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Input Fields Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Input Fields', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: Icon(Icons.visibility),
                    ),
                    obscureText: true,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Interactive Components Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Interactive Components',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Switch Component'),
                    subtitle: const Text('Toggle me on/off'),
                    value: _switchValue,
                    onChanged: (value) {
                      setState(() => _switchValue = value);
                    },
                  ),
                  const Divider(),
                  const CheckboxListTile(
                    title: Text('Checkbox Item'),
                    subtitle: Text('Check this option'),
                    value: true,
                    onChanged: null,
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Slider: ${_sliderValue.round()}'),
                        Slider(
                          value: _sliderValue,
                          min: 0,
                          max: 100,
                          divisions: 10,
                          label: _sliderValue.round().toString(),
                          onChanged: (value) {
                            setState(() => _sliderValue = value);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Chips Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Chips', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: List.generate(5, (index) {
                      return ChoiceChip(
                        label: Text('Option ${index + 1}'),
                        selected: _selectedChip == index,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedChip = index);
                          }
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Color Palette Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Color Palette', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 16),
                  _buildColorSwatch('Primary', theme.colorScheme.primary),
                  const SizedBox(height: 8),
                  _buildColorSwatch('Secondary', theme.colorScheme.secondary),
                  const SizedBox(height: 8),
                  _buildColorSwatch('Tertiary', theme.colorScheme.tertiary),
                  const SizedBox(height: 8),
                  _buildColorSwatch('Error', theme.colorScheme.error),
                  const SizedBox(height: 8),
                  _buildColorSwatch('Surface', theme.colorScheme.surface),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Typography Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Typography', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 16),
                  Text(
                    'Display Large',
                    style: theme.textTheme.displayLarge?.copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Headline Large',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Title Large', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Body Large', style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 8),
                  Text('Body Medium', style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Text('Body Small', style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // FAB Example Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Floating Action Button',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: FloatingActionButton.extended(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text('Add Item'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Info Card
          Card(
            color: theme.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Theme Persistence',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your theme preference is automatically saved using SharedPreferences. '
                    'The selected theme will be restored when you reopen the app.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSwatch(String name, Color color) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: Theme.of(context).textTheme.titleSmall),
              Text(
                '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
