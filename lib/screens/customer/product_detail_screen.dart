import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_widget.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  double _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('products')
            .doc(widget.productId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(message: 'Loading product...');
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              !snapshot.data!.exists) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Product not found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final product = ProductModel.fromMap(data);
          final ingredients = data['ingredients'] as String? ?? 'Not available';
          final nutritionInfo =
              data['nutritionInfo'] as Map<String, dynamic>? ?? {};

          return CustomScrollView(
            slivers: [
              // App Bar with Image
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: product.imageUrl != null
                      ? Image.network(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholderImage();
                          },
                        )
                      : _buildPlaceholderImage(),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Header
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              product.category,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Product Name
                          Text(
                            product.name,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),

                          // Farmer Name
                          Row(
                            children: [
                              const Icon(
                                Icons.agriculture,
                                size: 18,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'by ${product.farmerName}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Price
                          Row(
                            children: [
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                ' per ${product.unit}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Description
                          Text(
                            product.description,
                            style: const TextStyle(fontSize: 16, height: 1.5),
                          ),
                        ],
                      ),
                    ),

                    const Divider(height: 1),

                    // Quantity Selector
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quantity',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (_quantity > 1) {
                                    setState(() {
                                      _quantity--;
                                    });
                                  }
                                },
                                icon: const Icon(Icons.remove_circle_outline),
                                iconSize: 36,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${_quantity.toStringAsFixed(_quantity % 1 == 0 ? 0 : 1)} ${product.unit}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _quantity++;
                                  });
                                },
                                icon: const Icon(Icons.add_circle_outline),
                                iconSize: 36,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Total: \$${(product.price * _quantity).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Divider(height: 1),

                    // Ingredients Section
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.list_alt,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Ingredients',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            ingredients,
                            style: const TextStyle(fontSize: 16, height: 1.5),
                          ),
                        ],
                      ),
                    ),

                    const Divider(height: 1),

                    // Nutrition Info Section
                    if (nutritionInfo.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.health_and_safety,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Nutrition Information',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ...nutritionInfo.entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatNutritionKey(entry.key),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      entry.value.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                    const SizedBox(height: 100), // Space for bottom button
                  ],
                ),
              ),
            ],
          );
        },
      ),

      // Add to Cart Button
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('products')
                    .doc(widget.productId)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  final product = ProductModel.fromMap(data);

                  return CustomButton(
                    text: 'Add to Cart',
                    onPressed: () {
                      cartProvider.addToCart(product, _quantity);
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added to cart'),
                          backgroundColor: Colors.green,
                          action: SnackBarAction(
                            label: 'VIEW CART',
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.of(context).pushNamed('/cart');
                            },
                          ),
                        ),
                      );
                    },
                    icon: Icons.add_shopping_cart,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Icon(
          Icons.shopping_basket,
          size: 100,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  String _formatNutritionKey(String key) {
    // Convert camelCase to Title Case
    final result = key.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(0)}',
    );
    return result[0].toUpperCase() + result.substring(1);
  }
}
