import 'package:flutter/material.dart';

/// Welcome Screen - The first screen users see when opening Farm2Home
/// Demonstrates basic Flutter UI components and state management
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // State variable to track if user has tapped the button
  bool _isWelcomed = false;
  Color _backgroundColor = Colors.green.shade50;

  // Toggle state when button is pressed
  void _handleWelcomePressed() {
    setState(() {
      _isWelcomed = !_isWelcomed;
      _backgroundColor = _isWelcomed ? Colors.green.shade100 : Colors.green.shade50;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Farm2Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade700,
        elevation: 2,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Icon/Image
              Icon(
                Icons.agriculture,
                size: 120,
                color: Colors.green.shade700,
              ),
              const SizedBox(height: 30),
              
              // Welcome Title
              Text(
                _isWelcomed ? 'Welcome to Farm2Home!' : 'Fresh from Farm to Your Home',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Subtitle
              Text(
                _isWelcomed 
                    ? 'Your journey to fresh, organic produce starts here! 🌱'
                    : 'Connecting farmers directly with you',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              
              // Interactive Button
              ElevatedButton(
                onPressed: _handleWelcomePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  _isWelcomed ? 'Get Started!' : 'Welcome Me!',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Status indicator
              if (_isWelcomed)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'You\'re all set!',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
