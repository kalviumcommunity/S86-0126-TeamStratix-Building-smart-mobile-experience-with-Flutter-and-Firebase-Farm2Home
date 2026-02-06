import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/products_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/responsive_layout_screen.dart';
import 'screens/scrollable_views_screen.dart';
import 'screens/user_input_form.dart';
import 'screens/state_management_demo.dart';
import 'screens/reusable_widgets_demo.dart';
import 'screens/responsive_design_demo.dart';
import 'screens/responsive_product_grid.dart';
import 'screens/responsive_form_layout.dart';
import 'screens/assets_management_demo.dart';
import 'screens/animations_demo_screen.dart';
import 'screens/firestore_queries_demo_screen.dart';
import 'screens/media_upload_screen.dart';
import 'screens/cloud_functions_demo_screen.dart';
import 'screens/fcm_demo_screen.dart';
import 'screens/splash_screen.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => HomeScreen(cartService: CartService()),
        '/products': (context) =>
            ProductsScreen(cartService: CartService()),
        '/cart': (context) => CartScreen(cartService: CartService()),
        '/responsive-layout': (context) =>
            const ResponsiveLayoutScreen(),
        '/scrollable-views': (context) =>
            const ScrollableViewsScreen(),
        '/user-input-form': (context) => const UserInputForm(),
        '/state-management': (context) =>
            const StateManagementDemo(),
        '/reusable-widgets': (context) =>
            const ReusableWidgetsDemo(),
        '/responsive-design': (context) =>
            const ResponsiveDesignDemo(),
        '/responsive-product-grid': (context) =>
            const ResponsiveProductGrid(),
        '/responsive-form': (context) =>
            const ResponsiveFormLayout(),
        '/assets-management': (context) =>
            const AssetsManagementDemo(),
        '/animations': (context) =>
            const AnimationsDemoScreen(),
        '/firestore-queries': (context) =>
            const FirestoreQueriesDemoScreen(),
        '/media-upload': (context) =>
            const MediaUploadScreen(),
        '/cloud-functions': (context) =>
            const CloudFunctionsDemoScreen(),
        '/fcm': (context) =>
            const FCMDemoScreen(),
      },
      onGenerateRoute: (settings) =>
          _createPageTransition(settings),
    );
  }
}

/// Create page transition with slide animation
Route<dynamic> _createPageTransition(RouteSettings settings) {
  return PageRouteBuilder(
    settings: settings,
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const Scaffold();
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        ),
        child: child,
      );
    },
  );
}

/// Auth wrapper to check if user is logged in
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Authentication Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return HomeScreen(cartService: CartService());
        }

        return const LoginScreen();
      },
    );
  }
}
