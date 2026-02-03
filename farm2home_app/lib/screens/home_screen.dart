import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import 'products_screen.dart';

/// Home screen for Farm2Home app with navigation to demo screens
class HomeScreen extends StatelessWidget {
  final CartService cartService;

  const HomeScreen({super.key, required this.cartService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm2Home'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
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
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
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
          ],
        ),
      ),
    );
  }
}

