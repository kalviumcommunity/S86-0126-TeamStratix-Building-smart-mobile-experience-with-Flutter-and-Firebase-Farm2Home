import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../services/auth_service.dart';
import 'products_screen.dart';

/// Home screen for Farm2Home app with navigation to demo screens
class HomeScreen extends StatelessWidget {
  final CartService cartService;

  const HomeScreen({super.key, required this.cartService});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Farm2Home'),
            if (user != null)
              Text(user.email ?? '', style: const TextStyle(fontSize: 12)),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              try {
                await AuthService().logout();
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Logged out')));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              }
            },
          ),

          // Navigation to State Management Demo
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Demos',
            onPressed: () {
              _showDemoMenu(context);
            },
          ),
        ],
      ),
      body: ProductsScreen(cartService: cartService),
    );
  }

  /// Shows a menu with all available demo screens
  void _showDemoMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Demo Screens',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.science, color: Colors.blue),
              title: const Text('State Management Demo'),
              subtitle: const Text('Learn setState() with counter example'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/state-management');
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone_android, color: Colors.purple),
              title: const Text('Responsive Layout'),
              subtitle: const Text('Adaptive UI for different screen sizes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/responsive-layout');
              },
            ),
            ListTile(
              leading: const Icon(Icons.view_list, color: Colors.orange),
              title: const Text('Scrollable Views'),
              subtitle: const Text('ListView and GridView examples'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/scrollable-views');
              },
            ),
            ListTile(
              leading: const Icon(Icons.input, color: Colors.green),
              title: const Text('User Input Form'),
              subtitle: const Text('Form validation and input handling'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/user-input-form');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.verified_user,
                color: Colors.deepOrange,
              ),
              title: const Text('Advanced Form Validation'),
              subtitle: const Text(
                'Complex validation patterns & multi-field validation',
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/form-validation-demo');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.checklist_rtl,
                color: Colors.deepPurple,
              ),
              title: const Text('Multi-Step Form'),
              subtitle: const Text('Step-by-step form with progress tracking'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/multi-step-form');
              },
            ),
            ListTile(
              leading: const Icon(Icons.tab, color: Colors.blueAccent),
              title: const Text('Tab Navigation'),
              subtitle: const Text('BottomNavigationBar with tab switching'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/tab-navigation-demo');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.view_carousel,
                color: Colors.deepOrangeAccent,
              ),
              title: const Text('Advanced Tab Navigation'),
              subtitle: const Text(
                'PageView with state preservation & swipe gestures',
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/advanced-tab-navigation');
              },
            ),
            ListTile(
              leading: const Icon(Icons.palette, color: Colors.purpleAccent),
              title: const Text('Theming & Dark Mode'),
              subtitle: const Text('Custom themes with persistence'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/theming-demo');
              },
            ),
            ListTile(
              leading: const Icon(Icons.widgets, color: Colors.teal),
              title: const Text('Reusable Widgets'),
              subtitle: const Text('Custom widgets for modular design'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/reusable-widgets');
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone_android, color: Colors.indigo),
              title: const Text('Responsive Design'),
              subtitle: const Text('MediaQuery & LayoutBuilder examples'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/responsive-design');
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_3x3, color: Colors.cyan),
              title: const Text('Responsive Grid'),
              subtitle: const Text('Adaptive product grid layout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/responsive-product-grid');
              },
            ),
            ListTile(
              leading: const Icon(Icons.description, color: Colors.amber),
              title: const Text('Responsive Form'),
              subtitle: const Text('Adaptive form layouts'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/responsive-form');
              },
            ),
            ListTile(
              leading: const Icon(Icons.image_search, color: Colors.pink),
              title: const Text('Assets & Icons'),
              subtitle: const Text('Managing images and icons in Flutter'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/assets-management');
              },
            ),
            ListTile(
              leading: const Icon(Icons.animation, color: Colors.red),
              title: const Text('Animations Demo'),
              subtitle: const Text('Various animation patterns'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/animations');
              },
            ),
            ListTile(
              leading: const Icon(Icons.storage, color: Colors.deepOrange),
              title: const Text('Firestore Queries'),
              subtitle: const Text('where(), orderBy(), limit() patterns'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/firestore-queries');
              },
            ),
            ListTile(
              leading: const Icon(Icons.cloud_upload, color: Colors.cyan),
              title: const Text('Media Upload'),
              subtitle: const Text('Upload images to Firebase Storage'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/media-upload');
              },
            ),
            ListTile(
              leading: const Icon(Icons.cloud_done, color: Colors.purple),
              title: const Text('Cloud Functions'),
              subtitle: const Text('Call serverless functions'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/cloud-functions');
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_active, color: Colors.blue),
              title: const Text('Push Notifications'),
              subtitle: const Text('Firebase Cloud Messaging (FCM)'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/fcm');
              },
            ),
            ListTile(
              leading: const Icon(Icons.security, color: Colors.green),
              title: const Text('Secure Profile'),
              subtitle: const Text('Auth + Firestore Security Rules'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/secure-profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.map, color: Colors.blue),
              title: const Text('Location Preview'),
              subtitle: const Text('Google Maps Integration'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/location-preview');
              },
            ),
          ],
        ),
      ),
    );
  }
}
