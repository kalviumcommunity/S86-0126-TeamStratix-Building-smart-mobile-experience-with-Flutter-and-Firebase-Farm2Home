import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';

/// Favorites Screen (Screen B - View & Remove from Favorites)
/// Demonstrates how to:
/// 1. Listen to global state changes from another screen
/// 2. Automatically update UI when favorites change
/// 3. Remove items from favorites list
/// 4. Real-time synchronization without navigation
class FavoritesScreenSync extends StatefulWidget {
  const FavoritesScreenSync({super.key});

  @override
  State<FavoritesScreenSync> createState() => _FavoritesScreenSyncState();
}

class _FavoritesScreenSyncState extends State<FavoritesScreenSync> {
  /// Sorting options
  List<String> sortOptions = ['Date Added', 'Name A-Z', 'Price Low-High', 'Price High-Low'];
  String selectedSort = 'Date Added';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorites'),
        backgroundColor: Colors.red.shade700,
        elevation: 0,
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, _) {
          // Get all favorites from global state
          final favorites = favoritesProvider.favorites;

          // Empty state
          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_outline,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Favorites Yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add items to favorites from the Products screen',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Go to Products'),
                  ),
                ],
              ),
            );
          }

          // Favorites list
          return Column(
            children: [
              // Header with stats and sorting
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.red.shade50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Items',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '${favorites.length}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Total Value',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '\$${favoritesProvider.getTotalPrice().toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Sorting dropdown
                    DropdownButton<String>(
                      value: selectedSort,
                      isExpanded: true,
                      items: sortOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() => selectedSort = newValue);
                          _applySorting(favoritesProvider, newValue);
                        }
                      },
                    ),
                  ],
                ),
              ),
              // Favorites list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final favorite = favorites[index];
                    return _buildFavoriteCard(context, favorite, favoritesProvider);
                  },
                ),
              ),
              // Action buttons
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  children: [
                    // Continue shopping button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text('Continue Shopping'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Clear all favorites button
                    ElevatedButton.icon(
                      onPressed: () => _showClearConfirmDialog(
                        context,
                        favoritesProvider,
                      ),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Clear All'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Build favorite item card
  Widget _buildFavoriteCard(
    BuildContext context,
    dynamic favorite,
    FavoritesProvider favoritesProvider,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        // Product image/emoji
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              favorite.image ?? '📦',
              style: const TextStyle(fontSize: 32),
            ),
          ),
        ),
        // Product details
        title: Text(
          favorite.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              favorite.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              'Added: ${_formatDate(favorite.addedAt)}',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Price
            Text(
              '\$${favorite.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.green.shade700,
              ),
            ),
            // Remove button
            GestureDetector(
              onTap: () {
                // Remove from favorites using global state
                favoritesProvider.removeFromFavorites(favorite.id);
                _showSnackBar(context, '${favorite.name} removed ❌');
              },
              child: Icon(
                Icons.close,
                color: Colors.red.shade700,
                size: 20,
              ),
            ),
          ],
        ),
        onTap: () => _showItemDetails(context, favorite),
      ),
    );
  }

  /// Show item details dialog
  void _showItemDetails(BuildContext context, dynamic favorite) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Item Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  favorite.image ?? '📦',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 64),
                ),
              ),
              const SizedBox(height: 16),
              // Name
              const Text(
                'Name',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(favorite.name),
              const SizedBox(height: 12),
              // Description
              const Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(favorite.description),
              const SizedBox(height: 12),
              // Price
              const Text(
                'Price',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${favorite.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 12),
              // Date added
              const Text(
                'Added to Favorites',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(_formatDate(favorite.addedAt)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Show clear all confirmation dialog
  void _showClearConfirmDialog(
    BuildContext context,
    FavoritesProvider favoritesProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Favorites?'),
        content: const Text(
          'This will remove all items from your favorites list. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Clear all favorites from global state
              favoritesProvider.clearAllFavorites();
              Navigator.pop(context);
              _showSnackBar(context, 'All favorites cleared ❌');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  /// Apply sorting to favorites
  void _applySorting(FavoritesProvider provider, String sortOption) {
    switch (sortOption) {
      case 'Name A-Z':
        provider.sortByName();
        break;
      case 'Price Low-High':
        provider.sortByPrice();
        break;
      case 'Price High-Low':
        provider.sortByPriceDesc();
        break;
      case 'Date Added':
      default:
        provider.sortByDateAdded();
        break;
    }
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  /// Show snack bar
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
