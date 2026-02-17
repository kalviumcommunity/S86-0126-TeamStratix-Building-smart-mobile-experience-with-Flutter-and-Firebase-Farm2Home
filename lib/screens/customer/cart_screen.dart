import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../models/product_model.dart';
import '../../models/order_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/empty_state_widget.dart';
import '../../core/constants.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final user = authProvider.currentUser!;

    if (cartProvider.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cart is empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Group items by farmer
    final itemsByFarmer = cartProvider.getCartItemsByFarmer();
    final totalAmount = cartProvider.cartTotal;

    try {
      String lastOrderId = '';

      // Create separate orders for each farmer
      for (var entry in itemsByFarmer.entries) {
        final farmerId = entry.key;
        final items = entry.value;
        final farmerName = items.first.product.farmerName;

        final order = OrderModel(
          orderId: '',
          customerId: user.uid,
          customerName: user.name,
          farmerId: farmerId,
          farmerName: farmerName,
          items: items.map((cartItem) => cartItem.toOrderItem()).toList(),
          status: AppConstants.statusReceived,
          timestamp: DateTime.now(),
          deliveryAddress: _addressController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
        );

        final success = await orderProvider.createOrder(order);
        if (success) {
          // Get the last created order ID (for success screen)
          final orders = await FirebaseFirestore.instance
              .collection('orders')
              .where('customerId', isEqualTo: user.uid)
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();
          if (orders.docs.isNotEmpty) {
            lastOrderId = orders.docs.first.id;
          }
        }
      }

      if (!mounted) return;

      // Clear cart after successful order
      cartProvider.clearCart();

      // Navigate to success screen
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/order-success',
        (route) => false,
        arguments: {'orderId': lastOrderId, 'totalAmount': totalAmount},
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              if (cartProvider.cartItems.isEmpty) return const SizedBox();
              return TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Clear Cart'),
                      content: const Text('Remove all items from your cart?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            cartProvider.clearCart();
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Clear',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Clear All'),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.cartItems.isEmpty) {
            return EmptyStateWidget(
              message: 'Your cart is empty',
              icon: Icons.shopping_cart_outlined,
              actionText: 'Browse Products',
              onAction: () {
                Navigator.of(context).pop();
              },
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cart Items
                    Text(
                      'Items (${cartProvider.cartItemCount})',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),

                    ...cartProvider.cartItems.map((cartItem) {
                      return _CartItemCard(cartItem: cartItem);
                    }),

                    const SizedBox(height: 24),

                    // Delivery Details
                    Text(
                      'Delivery Details',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _addressController,
                              decoration: const InputDecoration(
                                labelText: 'Delivery Address',
                                prefixIcon: Icon(Icons.location_on_outlined),
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 2,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter delivery address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                prefixIcon: Icon(Icons.phone_outlined),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter phone number';
                                }
                                if (value.length < 10) {
                                  return 'Please enter valid phone number';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Order Summary
                    Card(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Items',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  cartProvider.cartItemCount.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Amount',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '\$${cartProvider.cartTotal.toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Place Order Button
                    CustomButton(
                      text: 'Place Order',
                      onPressed: _placeOrder,
                      icon: Icons.check,
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem cartItem;

  const _CartItemCard({required this.cartItem});

  void _updateQuantity(BuildContext context, double newQuantity) {
    Provider.of<CartProvider>(
      context,
      listen: false,
    ).updateCartItemQuantity(cartItem.product.productId, newQuantity);
  }

  void _removeItem(BuildContext context) {
    Provider.of<CartProvider>(
      context,
      listen: false,
    ).removeFromCart(cartItem.product.productId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${cartItem.product.name} removed from cart'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: cartItem.product.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            cartItem.product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholderImage();
                            },
                          ),
                        )
                      : _buildPlaceholderImage(),
                ),
                const SizedBox(width: 12),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartItem.product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'by ${cartItem.product.farmerName}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${cartItem.product.price.toStringAsFixed(2)} per ${cartItem.product.unit}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

                // Delete Button
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red,
                  onPressed: () => _removeItem(context),
                ),
              ],
            ),

            const Divider(height: 24),

            // Quantity Controls and Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Quantity Controls
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (cartItem.quantity > 1) {
                          _updateQuantity(context, cartItem.quantity - 1);
                        }
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                      color: Theme.of(context).primaryColor,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${cartItem.quantity} ${cartItem.product.unit}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _updateQuantity(context, cartItem.quantity + 1);
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),

                // Total Price
                Text(
                  '\$${cartItem.total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Center(
      child: Icon(Icons.shopping_basket, size: 32, color: Colors.grey.shade400),
    );
  }
}
