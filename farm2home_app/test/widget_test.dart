// This is a basic Flutter widget test for Farm2Home app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:farm2home_app/main.dart';

void main() {
  testWidgets('App loads and shows login screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Farm2HomeApp());

    // Wait for Firebase initialization and widgets to build
    await tester.pumpAndSettle();

    // Verify that login/signup UI elements are present
    expect(find.byType(TextField), findsWidgets);
    expect(find.byType(ElevatedButton), findsWidgets);
  });
}
