import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../models/order_model.dart';
import '../../widgets/order_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state_widget.dart';

class FarmerHomeScreen extends StatefulWidget {
  const FarmerHomeScreen({super.key});

  @override
  State<FarmerHomeScreen> createState() => _FarmerHomeScreenState();
}

class _FarmerHomeScreenState extends State<FarmerHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Changed from 2 to 3
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
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
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 4),
            child: IconButton(
              icon: const Icon(Icons.inventory_2),
              onPressed: () {
                Navigator.of(context).pushNamed('/my-products');
              },
              tooltip: 'My Products',
              iconSize: 22,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.of(context).pushNamed('/profile');
              },
              tooltip: 'Profile',
              iconSize: 22,
            ),
          ),
        ],
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
            Tab(text: 'Pending', icon: Icon(Icons.pending_actions, size: 20)),
            Tab(text: 'All', icon: Icon(Icons.list_alt, size: 20)),  
            Tab(text: 'Delivered', icon: Icon(Icons.history, size: 20)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Header Card  
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.waving_hand,
                      color: Colors.amber[300],
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Welcome, ${user.name}!',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Manage your orders and deliveries',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Stats Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FutureBuilder<Map<String, int>>(
              future: orderProvider.getFarmerStats(user.uid),
              builder: (context, snapshot) {
                final totalOrders = snapshot.data?['totalOrders'] ?? 0;
                final pendingOrders = snapshot.data?['pendingOrders'] ?? 0;
                final deliveredOrders = snapshot.data?['deliveredOrders'] ?? 0;
                return Row(
                  children: [
                    Expanded(
                      child: _buildModernStatCard(
                        context,
                        'Total',
                        totalOrders.toString(),
                        Icons.shopping_bag_outlined,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildModernStatCard(
                        context,
                        'Pending',
                        pendingOrders.toString(),
                        Icons.pending_actions_outlined,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildModernStatCard(
                        context,
                        'Delivered',
                        deliveredOrders.toString(),
                        Icons.check_circle_outline,
                        Colors.green,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Pending Orders Tab
                _buildOrdersList(
                  orderProvider.streamPendingOrders(user.uid),
                  'No pending orders',
                ),
                // All Orders Tab
                _buildOrdersList(
                  orderProvider.streamFarmerOrders(user.uid),
                  'No orders yet',
                ),
                // Previous Orders Tab (Delivered)
                _buildOrdersList(
                  orderProvider.streamDeliveredOrders(user.uid),
                  'No delivered orders yet',
                ),
              ],
            ),
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

  Widget _buildOrdersList(
    Stream<List<OrderModel>> ordersStream,
    String emptyMessage,
  ) {
    return StreamBuilder<List<OrderModel>>(
      stream: ordersStream,
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
            message: emptyMessage,
            icon: Icons.shopping_bag_outlined,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return OrderCard(
              order: order,
              onTap: () {
                Navigator.of(
                  context,
                ).pushNamed('/update-order-status', arguments: order.orderId);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildModernStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
