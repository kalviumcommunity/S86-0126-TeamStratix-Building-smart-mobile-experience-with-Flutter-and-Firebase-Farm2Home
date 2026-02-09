import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/favorite_item.dart';
import '../providers/favorites_provider.dart';

/// Products Screen (Screen A - Add to Favorites)
/// Demonstrates how to add items to favorites using global state management
/// No prop-drilling involved - directly accessing FavoritesProvider
class ProductsScreenFavorites extends StatefulWidget {
  const ProductsScreenFavorites({super.key});

  @override
  State<ProductsScreenFavorites> createState() =>
      _ProductsScreenFavoritesState();
}

class _ProductsScreenFavoritesState extends State<ProductsScreenFavorites> {
  /// Sample products for demonstration
  final List<Map<String, dynamic>> products = [
    {
      'id': 'prod_1',
      'name': 'Organic Tomatoes',
      'description': 'Fresh organic tomatoes from local farms',
      'price': 4.99,
      'image': '🍅',
    },
    {
      'id': 'prod_2',
      'name': 'Farm Fresh Lettuce',
      'description': 'Crispy green lettuce - direct from farm',
      'price': 3.49,
      'image': '🥬',
    },
    {
      'id': 'prod_3',
      'name': 'Organic Carrots',
      'description': 'Sweet and crunchy carrots',
      'price': 2.99,
      'image': '🥕',
    },
    {
      'id': 'prod_4',
      'name': 'Fresh Strawberries',
      'description': 'Juicy seasonal strawberries',
      'price': 5.99,
      'image': '🍓',
    },
    {
      'id': 'prod_5',
      'name': 'Corn on the Cob',
      'description': 'Sweet golden corn - peak season',
      'price': 3.99,
      'image': '🌽',
    },
    {
      'id': 'prod_6',
      'name': 'Organic Apples',
      'description': 'Red crisp apples - no pesticides',
      'price': 4.49,
      'image': '🍎',
    },
    {
      'id': 'prod_7',
      'name': 'Fresh Spinach',
      'description': 'Dark leafy spinach - rich in iron',
      'price': 2.49,
      'image': '🥬',
    },
    {
      'id': 'prod_8',
      'name': 'Organic Broccoli',
      'description': 'Green broccoli florets - healthy choice',
      'price': 3.49,
      'image': '🥦',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        actions: [
          // Show favorites count badge in app bar
          Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, _) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '❤️ ${favoritesProvider.favoriteCount}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header card explaining the feature
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.green.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Add Items to Favorites',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tap the ❤️ icon to add items to your favorites list. '
                    'Your favorites will be instantly available in the Favorites screen.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // Products grid
            Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _buildProductCard(context, product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build product card widget
  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, _) {
        // Check if this product is already in favorites
        final isFavorited = favoritesProvider.isFavorited(product['id']);

        return Card(
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image/emoji
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      product['image'],
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                ),
              ),
              // Product details
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      product['name'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Product description
                    Text(
                      product['description'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Price and favorite button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Text(
                          '\$${product['price'].toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.green.shade700,
                          ),
                        ),
                        // Favorite button
                        GestureDetector(
                          onTap: () {
                            // Create FavoriteItem from product
                            final favoriteItem = FavoriteItem(
                              id: product['id'],
                              name: product['name'],
                              description: product['description'],
                              price: product['price'],
                              image: product['image'],
                              addedAt: DateTime.now(),
                            );

                            // Toggle favorite using Provider
                            // No need to pass data around - state is global!
                            favoritesProvider.toggleFavorite(favoriteItem);

                            // Show feedback
                            _showFeedback(context, product['name'], isFavorited);
                          },
                          child: Icon(
                            isFavorited
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Show feedback snackbar
  void _showFeedback(BuildContext context, String productName, bool isFavorited) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorited
              ? '$productName removed from favorites ❌'
              : '$productName added to favorites ❤️',
        ),
        duration: const Duration(seconds: 1),
        backgroundColor:
            isFavorited ? Colors.red.shade700 : Colors.green.shade700,
      ),
    );
  }
}
