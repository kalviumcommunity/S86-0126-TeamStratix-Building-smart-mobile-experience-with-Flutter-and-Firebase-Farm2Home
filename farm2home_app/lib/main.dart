import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'services/cart_service.dart';
import 'screens/home_screen.dart';

/// Entry point of the Farm2Home application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: const AuthWrapper(),
    );
  }
}

/// Auth wrapper to check if user is logged in
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    
    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFD4EDD4),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4A7C4A),
              ),
            ),
          );
        }
        
        if (snapshot.hasData) {
          // User is logged in
          return HomeScreen(cartService: CartService());
        }
        
        // User is not logged in
        return const LoginScreen();
      },
    );
  }
}
