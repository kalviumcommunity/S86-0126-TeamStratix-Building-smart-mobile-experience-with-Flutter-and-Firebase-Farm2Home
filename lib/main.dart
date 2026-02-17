import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Firebase Options
import 'firebase_options.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/order_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/messaging_provider.dart';
import 'providers/rating_provider.dart';
import 'providers/payment_provider.dart';

// Theme
import 'theme/app_theme.dart';

// Widgets
import 'widgets/role_wrapper.dart';

// Screens - Auth
import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';

// Screens - Shared
import 'screens/shared/profile_screen.dart';
import 'screens/shared/chat_screen.dart';
import 'screens/shared/notifications_screen.dart';
import 'screens/shared/conversations_screen.dart';

// Screens - Customer
import 'screens/customer/customer_home_screen.dart';
import 'screens/customer/place_order_screen.dart';
import 'screens/customer/order_status_screen.dart';
import 'screens/customer/cart_screen.dart';
import 'screens/customer/product_detail_screen.dart';
import 'screens/customer/order_success_screen.dart';
import 'screens/customer/rating_screen.dart';
import 'screens/customer/payment_screen.dart';

// Screens - Farmer
import 'screens/farmer/farmer_home_screen.dart';
import 'screens/farmer/update_order_status_screen.dart';
import 'screens/farmer/add_product_screen.dart';
import 'screens/farmer/my_products_screen.dart';
import 'screens/farmer/book_supplies_screen.dart';
import 'screens/farmer/my_bookings_screen.dart';
import 'screens/farmer/enhanced_soil_testing_screen.dart';
import 'screens/farmer/ask_agronomist_screen.dart';
import 'screens/farmer/agro_store_screen.dart';
import 'screens/farmer/equipment_rental_screen.dart';
import 'screens/farmer/weather_alerts_screen.dart';
import 'screens/farmer/disease_detection_screen.dart';
import 'screens/farmer/farm_log_screen.dart';
import 'screens/farmer/marketplace_screen.dart';
import 'screens/farmer/government_schemes_screen.dart';
import 'screens/farmer/irrigation_scheduler_screen.dart';
import 'screens/farmer/farm_community_screen.dart';

// Screens - Admin
import 'screens/admin/cleanup_products_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Warning: .env file not found or failed to load: $e');
  }

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => MessagingProvider()),
        ChangeNotifierProvider(create: (_) => RatingProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
      ],
      child: MaterialApp(
        title: 'Farm2Home',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) => const SplashScreen());

            // Auth Routes
            case '/login':
              return MaterialPageRoute(builder: (_) => const LoginScreen());
            case '/signup':
              return MaterialPageRoute(builder: (_) => const SignupScreen());

            // Shared Routes
            case '/profile':
              return MaterialPageRoute(builder: (_) => const ProfileScreen());
            case '/notifications':
              return MaterialPageRoute(
                builder: (_) => const NotificationsScreen(),
              );
            case '/conversations':
              return MaterialPageRoute(
                builder: (_) => const ConversationsScreen(),
              );
            case '/chat':
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) => ChatScreen(
                  orderId: args['orderId'] as String,
                  otherUserId: args['otherUserId'] as String,
                  otherUserName: args['otherUserName'] as String,
                ),
              );

            // Customer Routes
            case '/customer-home':
              return MaterialPageRoute(
                builder: (_) => const CustomerOnlyWrapper(
                  child: CustomerHomeScreen(),
                ),
              );
            case '/place-order':
              return MaterialPageRoute(
                builder: (_) => const CustomerOnlyWrapper(
                  child: PlaceOrderScreen(),
                ),
              );
            case '/cart':
              return MaterialPageRoute(
                builder: (_) => CustomerOnlyWrapper(
                  child: CartScreen(),
                ),
              );
            case '/product-detail':
              final productId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => CustomerOnlyWrapper(
                  child: ProductDetailScreen(productId: productId),
                ),
              );
            case '/order-success':
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) => CustomerOnlyWrapper(
                  child: OrderSuccessScreen(
                    orderId: args['orderId'] as String,
                    totalAmount: args['totalAmount'] as double,
                  ),
                ),
              );
            case '/order-status':
              final orderId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => CustomerOnlyWrapper(
                  child: OrderStatusScreen(orderId: orderId),
                ),
              );
            case '/rating':
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) => CustomerOnlyWrapper(
                  child: RatingScreen(
                    orderId: args['orderId'] as String,
                    farmerId: args['farmerId'] as String,
                    farmerName: args['farmerName'] as String,
                  ),
                ),
              );
            case '/payment':
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) => CustomerOnlyWrapper(
                  child: PaymentScreen(
                    orderId: args['orderId'] as String,
                    amount: args['amount'] as double,
                  ),
                ),
              );

            // Farmer Routes
            case '/farmer-home':
              return MaterialPageRoute(
                builder: (_) => const FarmerOnlyWrapper(
                  child: FarmerHomeScreen(),
                ),
              );
            case '/add-product':
              return MaterialPageRoute(
                builder: (_) => const FarmerOnlyWrapper(
                  child: AddProductScreen(),
                ),
              );
            case '/my-products':
              return MaterialPageRoute(
                builder: (_) => const FarmerOnlyWrapper(
                  child: MyProductsScreen(),
                ),
              );
            case '/update-order-status':
              final orderId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => FarmerOnlyWrapper(
                  child: UpdateOrderStatusScreen(orderId: orderId),
                ),
              );
            case '/book-supplies':
              return MaterialPageRoute(
                builder: (_) => const FarmerOnlyWrapper(
                  child: BookSuppliesScreen(),
                ),
              );
            case '/my-bookings':
              return MaterialPageRoute(
                builder: (_) => const FarmerOnlyWrapper(
                  child: MyBookingsScreen(),
                ),
              );
            case '/book-soil-testing':
              return MaterialPageRoute(
                builder: (_) => const FarmerOnlyWrapper(
                  child: EnhancedSoilTestingScreen(),
                ),
              );
            case '/ask-agronomist':
              return MaterialPageRoute(
                builder: (_) => const FarmerOnlyWrapper(
                  child: AskAgronomiScreen(),
                ),
              );
            case '/agro-store':
              return MaterialPageRoute(
                builder: (_) => const FarmerOnlyWrapper(
                  child: AgroStoreScreen(),
                ),
              );
            case '/equipment-rental':
              return MaterialPageRoute(
                builder: (_) => const FarmerOnlyWrapper(
                  child: EquipmentRentalScreen(),
                ),
              );
            case '/weather-alerts':
              return MaterialPageRoute(
                builder: (_) => const FarmerOnlyWrapper(
                  child: WeatherAlertsScreen(),
                ),
              );
            case '/disease-detection':
              return MaterialPageRoute(
                builder: (_) => const FarmerOnlyWrapper(
                  child: DiseaseDetectionScreen(),
                ),
              );
            case '/farm-log':
              return MaterialPageRoute(
                builder: (_) => const FarmerOnlyWrapper(
                  child: FarmLogScreen(),
                ),
              );
            case '/marketplace':
              return MaterialPageRoute(
                builder: (_) => const FarmerOnlyWrapper(
                  child: MarketplaceScreen(),
                ),
              );
            case '/government-schemes':
              return MaterialPageRoute(
                builder: (_) => const FarmerOnlyWrapper(
                  child: GovernmentSchemesScreen(),
                ),
              );
            case '/irrigation-scheduler':
              return MaterialPageRoute(
                builder: (_) => const FarmerOnlyWrapper(
                  child: IrrigationSchedulerScreen(),
                ),
              );
            case '/farm-community':
              return MaterialPageRoute(
                builder: (_) => const FarmerOnlyWrapper(
                  child: FarmCommunityScreen(),
                ),
              );

            // Admin Routes
            case '/cleanup-products':
              return MaterialPageRoute(
                builder: (_) => const CleanupProductsScreen(),
              );
            case '/admin-dashboard':
              return MaterialPageRoute(
                builder: (_) => const AdminDashboardScreen(),
              );

            default:
              return MaterialPageRoute(builder: (_) => const SplashScreen());
          }
        },
      ),
    );
  }
}
