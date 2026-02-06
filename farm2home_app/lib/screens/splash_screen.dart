import 'package:flutter/material.dart';

/// Splash screen shown while checking authentication state
/// This provides a professional loading experience when the app starts
/// and Firebase is checking if a valid session exists
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4EDD4), // Light green background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo/Icon
            Icon(Icons.agriculture, size: 100, color: Colors.green.shade700),
            const SizedBox(height: 24),
            // App Name
            Text(
              'Farm2Home',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fresh from farm to your home',
              style: TextStyle(fontSize: 14, color: Colors.green.shade700),
            ),
            const SizedBox(height: 48),
            // Loading Indicator
            CircularProgressIndicator(
              color: Colors.green.shade700,
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading...',
              style: TextStyle(fontSize: 14, color: Colors.green.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
