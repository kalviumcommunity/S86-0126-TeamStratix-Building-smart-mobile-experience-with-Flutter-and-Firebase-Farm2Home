import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/product_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state_widget.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  Future<void> _editProductStatus(ProductModel product) async {
    final newStatus = await _showStatusEditDialog(product);
    if (newStatus == null || newStatus == product.isAvailable) return;

    setState(() => _isLoading = true);

    try {
      await _firestore.collection('products').doc(product.productId).update({
        'isAvailable': newStatus,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Product status updated to ${newStatus ? "Available" : "Out of stock"}',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update product status: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<bool?> _showStatusEditDialog(ProductModel product) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        bool selectedStatus = product.isAvailable;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit ${product.name}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Product Status:'),
                  const SizedBox(height: 12),
                  RadioListTile<bool>(
                    title: const Text('Available'),
                    subtitle: const Text('Customers can order this product'),
                    value: true,
                    groupValue: selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value!;
                      });
                    },
                    activeColor: Colors.green,
                  ),
                  RadioListTile<bool>(
                    title: const Text('Out of Stock'),  
                    subtitle: const Text('Product is temporarily unavailable'),
                    value: false,
                    groupValue: selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value!;
                      });
                    },
                    activeColor: Colors.red,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(selectedStatus),
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteProduct(String productId, String productName) async {
    final confirmed = await _showDeleteConfirmDialog(productName);
    if (!confirmed) return;

    setState(() => _isLoading = true);

    try {
      await _firestore.collection('products').doc(productId).delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$productName deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete product: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<bool> _showDeleteConfirmDialog(String productName) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Product'),
              content: Text('Are you sure you want to delete "$productName"?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final farmerId = authProvider.currentUser?.uid;

    if (farmerId == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to view your products')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('products')
                .where('farmerId', isEqualTo: farmerId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingWidget(message: 'Loading your products...');
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              final products = snapshot.data?.docs
                      .map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        data['productId'] = doc.id; // Include document ID
                        return ProductModel.fromMap(data);
                      })
                      .toList() ??
                  [];

              // Sort products by creation date (newest first)
              products.sort((a, b) => b.createdAt.compareTo(a.createdAt));

              if (products.isEmpty) {
                return const EmptyStateWidget(
                  message: 'You haven\'t added any products yet.\nTap the + button to add your first product!',
                  icon: Icons.inventory_2_outlined,
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _buildProductCard(product);
                },
              );
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed('/add-product');
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 80,
                height: 80,
                child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: product.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 32,
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image_outlined,
                          color: Colors.grey,
                          size: 32,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 16),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.category,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)} per ${product.unit}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        product.isAvailable ? Icons.check_circle : Icons.cancel,
                        size: 16,
                        color: product.isAvailable ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.isAvailable ? 'Available' : 'Out of stock',
                        style: TextStyle(
                          fontSize: 12,
                          color: product.isAvailable ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action Buttons
            Column(
              children: [
                IconButton(
                  onPressed: () => _editProductStatus(product),
                  icon: const Icon(Icons.edit),
                  color: Colors.blue,
                  tooltip: 'Edit Product Status',
                ),
                IconButton(
                  onPressed: () => _deleteProduct(product.productId, product.name),
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  tooltip: 'Delete Product',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}