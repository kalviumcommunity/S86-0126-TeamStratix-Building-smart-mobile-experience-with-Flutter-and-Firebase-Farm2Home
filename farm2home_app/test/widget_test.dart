// This is a basic Flutter widget test for Farm2Home app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:farm2home_app/main.dart';
import 'package:farm2home_app/services/app_theme_service.dart';

void main() {
  testWidgets('App loads and shows login screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final themeService = AppThemeService();
    await tester.pumpWidget(Farm2HomeApp(themeService: themeService));

    // Wait for Firebase initialization and widgets to build
    await tester.pumpAndSettle();

    // Verify that login/signup UI elements are present
    expect(find.byType(TextField), findsWidgets);
    expect(find.byType(ElevatedButton), findsWidgets);
  });
}
