import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/order_model.dart';
import '../../widgets/order_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state_widget.dart';
import 'products_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser!;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Icon(
                Icons.agriculture,
                size: 16,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'Farm2Home',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(icon: Icon(Icons.shopping_basket, size: 20), text: 'Products'),
            Tab(icon: Icon(Icons.receipt_long, size: 20), text: 'My Orders'),
          ],
        ),
        actions: [
          // Cart Icon with Badge
          Container(
            margin: const EdgeInsets.only(right: 4),
            child: Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                final cartCount = cartProvider.cartItemCount;
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/cart');
                      },
                      iconSize: 22,
                      tooltip: 'Cart',
                    ),
                    if (cartCount > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            cartCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.of(context).pushNamed('/profile');
              },
              iconSize: 22,
              tooltip: 'Profile',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${user.name}!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Fresh produce from local farmers',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Products Tab
                const ProductsScreen(),

                // Orders Tab
                _OrdersTab(userId: user.uid),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Orders Tab Widget
class _OrdersTab extends StatelessWidget {
  final String userId;

  const _OrdersTab({required this.userId});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Column(
      children: [
        // Stats Card
        Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<Map<String, int>>(
            future: orderProvider.getCustomerStats(userId),
            builder: (context, snapshot) {
              final totalOrders = snapshot.data?['totalOrders'] ?? 0;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        context,
                        'Total Orders',
                        totalOrders.toString(),
                        Icons.shopping_bag_outlined,
                      ),
                      Container(
                        height: 50,
                        width: 1,
                        color: Colors.grey.shade300,
                      ),
                      _buildStatItem(
                        context,
                        'Status',
                        'Active',
                        Icons.check_circle_outline,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Orders List
        Expanded(
          child: StreamBuilder<List<OrderModel>>(
            stream: orderProvider.streamCustomerOrders(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingWidget(message: 'Loading orders...');
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final orders = snapshot.data ?? [];

              if (orders.isEmpty) {
                return EmptyStateWidget(
                  message: 'No orders yet',
                  icon: Icons.shopping_bag_outlined,
                  actionText: 'Browse Products',
                  onAction: () {
                    // Switch to products tab
                    DefaultTabController.of(context).animateTo(0);
                  },
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return OrderCard(
                    order: order,
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushNamed('/order-status', arguments: order.orderId);
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
