import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_service.dart';
import '../services/favorites_service.dart';
import '../services/app_theme_service.dart';

/// Comprehensive demo screen showcasing Provider state management
/// Demonstrates reading, updating, and sharing state across the app
class ProviderDemoScreen extends StatelessWidget {
  const ProviderDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider State Management'),
        actions: [
          // Theme toggle button - demonstrates context.read for one-time access
          IconButton(
            icon: Icon(
              context.watch<AppThemeService>().isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              // Use context.read when you only need to call a method
              // (not rebuild the widget when state changes)
              context.read<AppThemeService>().toggleTheme();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Cart State Demo
            _buildCartDemo(),
            const SizedBox(height: 32),
            
            // Section 2: Favorites State Demo
            _buildFavoritesDemo(),
            const SizedBox(height: 32),
            
            // Section 3: Theme State Demo
            _buildThemeDemo(),
            const SizedBox(height: 32),
            
            // Section 4: Navigation to see shared state
            _buildNavigationDemo(context),
            const SizedBox(height: 32),
            
            // Section 5: Best Practices Info
            _buildBestPractices(),
          ],
        ),
      ),
    );
  }

  Widget _buildCartDemo() {
    return Consumer<CartService>(
      builder: (context, cartService, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shopping_cart, color: Colors.green),
                    const SizedBox(width: 8),
                    const Text(
                      'Shopping Cart State',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Display cart count - automatically updates when cart changes
                Text(
                  'Items in Cart: ${cartService.itemCount}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Total Price: \$${cartService.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                
                // Button to clear cart - demonstrates state update
                ElevatedButton.icon(
                  onPressed: cartService.itemCount > 0
                      ? () => cartService.clearCart()
                      : null,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Clear Cart'),
                ),
                
                const SizedBox(height: 8),
                const Text(
                  '💡 This uses Consumer<CartService> to rebuild only this widget when cart changes',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFavoritesDemo() {
    return Consumer<FavoritesService>(
      builder: (context, favoritesService, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.red),
                    const SizedBox(width: 8),
                    const Text(
                      'Favorites State',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Display favorites count
                Text(
                  'Favorite Products: ${favoritesService.favoriteCount}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                
                // Buttons to add/remove favorites
                Wrap(
                  spacing: 8,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        favoritesService.addFavorite('product_${DateTime.now().millisecond}');
                      },
                      icon: const Icon(Icons.favorite_border),
                      label: const Text('Add Favorite'),
                    ),
                    ElevatedButton.icon(
                      onPressed: favoritesService.favoriteCount > 0
                          ? () => favoritesService.clearFavorites()
                          : null,
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Clear All'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                const Text(
                  '💡 Changes here are visible across all screens using this provider',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeDemo() {
    return Consumer<AppThemeService>(
      builder: (context, themeService, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      themeService.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Theme State',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                Text(
                  'Current Theme: ${themeService.isDarkMode ? "Dark" : "Light"}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                
                // Theme toggle buttons
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text('Light'),
                      icon: Icon(Icons.light_mode),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text('Dark'),
                      icon: Icon(Icons.dark_mode),
                    ),
                  ],
                  selected: {themeService.themeMode},
                  onSelectionChanged: (Set<ThemeMode> newSelection) {
                    themeService.setThemeMode(newSelection.first);
                  },
                ),
                
                const SizedBox(height: 8),
                const Text(
                  '💡 Theme changes apply to entire app instantly',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavigationDemo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.compare_arrows, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Multi-Screen Shared State',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Navigate to StateDetailScreen to see how the same state is shared across screens.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StateDetailScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Go to Detail Screen'),
            ),
            const SizedBox(height: 8),
            const Text(
              '💡 Changes made on the detail screen will reflect here without passing data back',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBestPractices() {
    return Card(
      color: Colors.green.shade50,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tips_and_updates, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Provider Best Practices',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12),
            _BestPracticeTile(
              icon: '✅',
              title: 'Use context.watch<T>()',
              description: 'When widget needs to rebuild on state changes',
            ),
            _BestPracticeTile(
              icon: '✅',
              title: 'Use context.read<T>()',
              description: 'When you only call methods (no rebuild needed)',
            ),
            _BestPracticeTile(
              icon: '✅',
              title: 'Use Consumer<T>',
              description: 'To rebuild only specific widget subtree',
            ),
            _BestPracticeTile(
              icon: '⚠️',
              title: 'Never store BuildContext in Provider',
              description: 'It causes memory leaks and errors',
            ),
            _BestPracticeTile(
              icon: '⚠️',
              title: 'Keep business logic in providers',
              description: 'UI widgets should be thin and focused',
            ),
          ],
        ),
      ),
    );
  }
}

class _BestPracticeTile extends StatelessWidget {
  final String icon;
  final String title;
  final String description;

  const _BestPracticeTile({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Detail screen to demonstrate shared state across screens
class StateDetailScreen extends StatelessWidget {
  const StateDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access providers without rebuilding on changes
    final cartService = context.read<CartService>();
    final favoritesService = context.read<FavoritesService>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('State Detail Screen'),
        // Watch theme to update icon
        actions: [
          IconButton(
            icon: Icon(
              context.watch<AppThemeService>().isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => context.read<AppThemeService>().toggleTheme(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This screen shares the same state with the previous screen.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            
            // Cart count - uses Consumer to rebuild only this part
            Consumer<CartService>(
              builder: (context, cart, _) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.shopping_cart),
                    title: const Text('Cart Items'),
                    subtitle: Text('${cart.itemCount} items'),
                    trailing: Text('\$${cart.totalPrice.toStringAsFixed(2)}'),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            
            // Favorites count
            Consumer<FavoritesService>(
              builder: (context, favorites, _) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.favorite),
                    title: const Text('Favorite Products'),
                    subtitle: Text('${favorites.favoriteCount} favorites'),
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        favorites.addFavorite('product_${DateTime.now().millisecond}');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to favorites')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            
            // Action buttons
            ElevatedButton(
              onPressed: () => cartService.clearCart(),
              child: const Text('Clear Cart (Updates Previous Screen)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => favoritesService.clearFavorites(),
              child: const Text('Clear Favorites (Updates Previous Screen)'),
            ),
            const SizedBox(height: 24),
            
            const Text(
              '💡 Try changing values here and going back - the previous screen will show updated values without passing data back!',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
