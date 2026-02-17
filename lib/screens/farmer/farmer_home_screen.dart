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
    _tabController = TabController(length: 3, vsync: this); // 3 tabs: Pending, All, Delivered
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
            // Updated Logo
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.eco,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Flexible(
              child: Text(
                'Farm2Home',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.3,
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
      drawer: _buildServicesDrawer(context),
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

  Widget _buildServicesDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          Container(
            width: double.infinity,
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
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.eco,
                      size: 28,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Services',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Explore all features',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // Drawer Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildDrawerItem(
                  context,
                  Icons.add_shopping_cart,
                  'Book Supplies',
                  '/book-supplies',
                ),
                _buildDrawerItem(
                  context,
                  Icons.receipt_long,
                  'My Bookings',
                  '/my-bookings',
                ),
                const Divider(height: 8, thickness: 0.5),
                _buildDrawerSectionTitle(context, 'Expert Services'),
                _buildDrawerItem(
                  context,
                  Icons.person_outline,
                  'Ask Agronomist',
                  '/ask-agronomist',
                ),
                _buildDrawerItem(
                  context,
                  Icons.storefront_outlined,
                  'Agro Store',
                  '/agro-store',
                ),
                _buildDrawerItem(
                  context,
                  Icons.construction_outlined,
                  'Equipment Rental',
                  '/equipment-rental',
                ),
                const Divider(height: 8, thickness: 0.5),
                _buildDrawerSectionTitle(context, 'Farm Management'),
                _buildDrawerItem(
                  context,
                  Icons.cloud,
                  'Weather Alerts',
                  '/weather-alerts',
                ),
                _buildDrawerItem(
                  context,
                  Icons.health_and_safety_outlined,
                  'Disease Detection',
                  '/disease-detection',
                ),
                _buildDrawerItem(
                  context,
                  Icons.book_outlined,
                  'Farm Log',
                  '/farm-log',
                ),
                _buildDrawerItem(
                  context,
                  Icons.water_drop_outlined,
                  'Irrigation Plan',
                  '/irrigation-scheduler',
                ),
                _buildDrawerItem(
                  context,
                  Icons.science_outlined,
                  'Book Soil Testing',
                  '/book-soil-testing',
                ),
                const Divider(height: 8, thickness: 0.5),
                _buildDrawerSectionTitle(context, 'Marketplace & Community'),
                _buildDrawerItem(
                  context,
                  Icons.local_offer_outlined,
                  'Marketplace',
                  '/marketplace',
                ),
                _buildDrawerItem(
                  context,
                  Icons.assignment_outlined,
                  'Government Schemes',
                  '/government-schemes',
                ),
                _buildDrawerItem(
                  context,
                  Icons.forum_outlined,
                  'Farmers Hub',
                  '/farm-community',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          leading: Icon(
            icon,
            size: 22,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(route);
          },
          hoverColor: Theme.of(context).primaryColor.withValues(alpha: 0.08),
        ),
      ),
    );
  }

  Widget _buildDrawerSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).primaryColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
