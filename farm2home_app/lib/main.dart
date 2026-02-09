import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
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
import 'screens/secure_profile_screen.dart';
import 'screens/location_preview_screen.dart';
import 'screens/splash_screen.dart';
 Using-Provider-for-scalable-state-management
import 'screens/provider_demo_screen.dart';
import 'screens/form_validation_demo_screen.dart';
import 'screens/multi_step_form_screen.dart';
import 'screens/tab_navigation_demo_screen.dart';
import 'screens/advanced_tab_navigation_screen.dart';
import 'services/cart_service.dart';
import 'services/favorites_service.dart';
import 'services/app_theme_service.dart';

import 'screens/my_notes_screen.dart';
import 'screens/products_favorites_screen.dart';
import 'screens/favorites_sync_screen.dart';

import 'services/cart_service.dart';
import 'providers/favorites_provider.dart';

 main
import 'screens/home_screen.dart';

 Entry point of the Farm2Home application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        // Favorites Provider - Global state available across all screens
        ChangeNotifierProvider(
          create: (context) => FavoritesProvider(),
        ),
      ],
      child: const Farm2HomeApp(),
    ),
  );
}

/// Root widget of the Farm2Home application
class Farm2HomeApp extends StatelessWidget {
  const Farm2HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
 Using-Provider-for-scalable-state-management
    // MultiProvider wraps the app and provides multiple state objects
    // All child widgets can access these providers using context.watch or context.read
    return MultiProvider(
      providers: [
        // CartService - Manages shopping cart state across the app
        ChangeNotifierProvider(create: (_) => CartService()),

        // FavoritesService - Manages user's favorite products
        ChangeNotifierProvider(create: (_) => FavoritesService()),

        // AppThemeService - Manages app theme (light/dark mode)
        ChangeNotifierProvider(create: (_) => AppThemeService()),
      ],
      child: Consumer<AppThemeService>(
        builder: (context, themeService, _) {
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
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: themeService.themeMode, // Dynamic theme switching
            // Initial route - starts with authentication check
            initialRoute: '/',
            // Named routes for navigation
            routes: {
              '/': (context) => const AuthWrapper(),
              '/welcome': (context) => const WelcomeScreen(),
              '/login': (context) => const LoginScreen(),
              '/signup': (context) => const SignUpScreen(),
              '/home': (context) =>
                  HomeScreen(cartService: context.read<CartService>()),
              '/products': (context) =>
                  ProductsScreen(cartService: context.read<CartService>()),
              '/cart': (context) =>
                  CartScreen(cartService: context.read<CartService>()),
              '/responsive-layout': (context) => const ResponsiveLayoutScreen(),
              '/scrollable-views': (context) => const ScrollableViewsScreen(),
              '/user-input-form': (context) => const UserInputForm(),
              '/state-management': (context) => const StateManagementDemo(),
              '/reusable-widgets': (context) => const ReusableWidgetsDemo(),
              '/responsive-design': (context) => const ResponsiveDesignDemo(),
              '/responsive-product-grid': (context) =>
                  const ResponsiveProductGrid(),
              '/responsive-form': (context) => const ResponsiveFormLayout(),
              '/assets-management': (context) => const AssetsManagementDemo(),
              '/animations': (context) => const AnimationsDemoScreen(),
              '/provider-demo': (context) => const ProviderDemoScreen(),
              '/form-validation-demo': (context) =>
                  const FormValidationDemoScreen(),
              '/multi-step-form': (context) => const MultiStepFormScreen(),
              '/tab-navigation-demo': (context) =>
                  const TabNavigationDemoScreen(),
              '/advanced-tab-navigation': (context) =>
                  const AdvancedTabNavigationScreen(),
            },
            onGenerateRoute: (settings) => _createPageTransition(settings),
          );
        },
      ),

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
        '/secure-profile': (context) =>
            const SecureProfileScreen(),
        '/location-preview': (context) =>
            const LocationPreviewScreen(),
        '/my-notes': (context) =>
            const MyNotesScreen(),
        '/products-favorites': (context) =>
            const ProductsScreenFavorites(),
        '/favorites-sync': (context) =>
            const FavoritesScreenSync(),
      },
      onGenerateRoute: (settings) =>
          _createPageTransition(settings),
 main
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

 Using-Provider-for-scalable-state-management
        // Check for errorscontext.read<CartService>

 main
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
