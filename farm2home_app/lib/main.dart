import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

/// Entry point of the Farm2Home application
void main() {
  runApp(const Farm2HomeApp());
}

/// Root widget of the Farm2Home application
class Farm2HomeApp extends StatelessWidget {
  const Farm2HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm2Home',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Green theme matching agricultural/farm concept
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}
