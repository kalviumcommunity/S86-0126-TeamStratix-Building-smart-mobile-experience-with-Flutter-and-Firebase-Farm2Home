import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart'; // SignUpScreen class
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
import 'screens/splash_screen.dart';
import 'screens/provider_demo_screen.dart';
import 'screens/form_validation_demo_screen.dart';
import 'screens/multi_step_form_screen.dart';
import 'screens/tab_navigation_demo_screen.dart';
import 'screens/advanced_tab_navigation_screen.dart';
import 'screens/theming_demo_screen.dart';
import 'services/cart_service.dart';
import 'styles/app_theme.dart';
import 'services/favorites_service.dart';
import 'services/app_theme_service.dart';
import 'screens/home_screen.dart';

/// Entry point of the Farm2Home application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize and configure theme service before running the app
  final themeService = AppThemeService();
  await themeService.initialize();

  runApp(Farm2HomeApp(themeService: themeService));
}

/// Root widget of the Farm2Home application
class Farm2HomeApp extends StatelessWidget {
  final AppThemeService themeService;

  const Farm2HomeApp({super.key, required this.themeService});

  @override
  Widget build(BuildContext context) {
    // MultiProvider wraps the app and provides multiple state objects
    // All child widgets can access these providers using context.watch or context.read
    return MultiProvider(
      providers: [
        // CartService - Manages shopping cart state across the app
        ChangeNotifierProvider(create: (_) => CartService()),

        // FavoritesService - Manages user's favorite products
        ChangeNotifierProvider(create: (_) => FavoritesService()),

        // AppThemeService - Manages app theme (light/dark mode) with persistence
        ChangeNotifierProvider.value(value: themeService),
      ],
      child: Consumer<AppThemeService>(
        builder: (context, themeService, _) {
          return MaterialApp(
            title: 'Farm2Home',
            debugShowCheckedModeBanner: false,
            // Custom light theme with Material 3 design
            theme: AppTheme.lightTheme,
            // Custom dark theme with Material 3 design
            darkTheme: AppTheme.darkTheme,
            // Dynamic theme switching with persistence
            themeMode: themeService.themeMode,
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
              '/theming-demo': (context) => const ThemingDemoScreen(),
            },
            onGenerateRoute: (settings) => _createPageTransition(settings),
          );
        },
      ),
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
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
        child: child,
      );
    },
  );
}

/// Auth wrapper to check if user is logged in
/// Uses Firebase authStateChanges() stream to automatically handle session persistence
/// This ensures users stay logged in across app restarts without manual intervention
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to Firebase Auth state changes
    // This stream automatically handles:
    // - User login
    // - User logout
    // - Session restoration on app restart
    // - Token refresh
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show splash screen while checking authentication state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        // Check for errorscontext.read<CartService>
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Authentication Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      // Sign out and retry
                      await FirebaseAuth.instance.signOut();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // User is authenticated - redirect to HomeScreen
        if (snapshot.hasData && snapshot.data != null) {
          return HomeScreen(cartService: CartService());
        }

        // No authenticated user - show LoginScreen
        return const LoginScreen();
      },
    );
  }
}
