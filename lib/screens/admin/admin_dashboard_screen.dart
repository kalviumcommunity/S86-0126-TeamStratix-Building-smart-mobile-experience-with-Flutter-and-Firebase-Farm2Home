import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        elevation: 0,
      ),
      body: Row(
        children: [
          // Sidebar navigation
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() => _selectedIndex = index);
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text('Overview'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people),
                label: Text('Users'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.shopping_bag),
                label: Text('Orders'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.inventory),
                label: Text('Products'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.star),
                label: Text('Ratings'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),

          // Main content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildOverview();
      case 1:
        return _buildUsersPanel();
      case 2:
        return _buildOrdersPanel();
      case 3:
        return _buildProductsPanel();
      case 4:
        return _buildRatingsPanel();
      default:
        return _buildOverview();
    }
  }

  Widget _buildOverview() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').snapshots(),
      builder: (context, usersSnapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('orders').snapshots(),
          builder: (context, ordersSnapshot) {
            return StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('products').snapshots(),
              builder: (context, productsSnapshot) {
                return StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('ratings').snapshots(),
                  builder: (context, ratingsSnapshot) {
                    final totalUsers = usersSnapshot.data?.docs.length ?? 0;
                    final totalOrders = ordersSnapshot.data?.docs.length ?? 0;
                    final totalProducts = productsSnapshot.data?.docs.length ?? 0;
                    final totalRatings = ratingsSnapshot.data?.docs.length ?? 0;

                    final customers = usersSnapshot.data?.docs
                            .where((doc) => doc['role'] == 'customer')
                            .length ??
                        0;
                    final farmers = usersSnapshot.data?.docs
                            .where((doc) => doc['role'] == 'farmer')
                            .length ??
                        0;

                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dashboard Overview',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              children: [
                                _buildStatCard(
                                  'Total Users',
                                  totalUsers.toString(),
                                  Icons.people,
                                  Colors.blue,
                                ),
                                _buildStatCard(
                                  'Total Orders',
                                  totalOrders.toString(),
                                  Icons.shopping_bag,
                                  Colors.green,
                                ),
                                _buildStatCard(
                                  'Total Products',
                                  totalProducts.toString(),
                                  Icons.inventory,
                                  Colors.orange,
                                ),
                                _buildStatCard(
                                  'Total Ratings',
                                  totalRatings.toString(),
                                  Icons.star,
                                  Colors.amber,
                                ),
                                _buildStatCard(
                                  'Customers',
                                  customers.toString(),
                                  Icons.person,
                                  Colors.purple,
                                ),
                                _buildStatCard(
                                  'Farmers',
                                  farmers.toString(),
                                  Icons.agriculture,
                                  Colors.teal,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withValues(alpha: 0.2),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersPanel() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data!.docs;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Users Management',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index].data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: user['role'] == 'farmer'
                              ? Colors.green
                              : Colors.blue,
                          child: Icon(
                            user['role'] == 'farmer'
                                ? Icons.agriculture
                                : Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(user['name'] ?? 'Unknown'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user['email'] ?? ''),
                            Text(
                              'Role: ${user['role'] ?? 'N/A'}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'view',
                              child: Text('View Details'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete User'),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'delete') {
                              _deleteUser(users[index].id);
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrdersPanel() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('orders').orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = snapshot.data!.docs;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Orders Management',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index].data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getStatusColor(order['status']),
                          child: const Icon(Icons.shopping_bag,
                              color: Colors.white),
                        ),
                        title: Text('Order #${orders[index].id.substring(0, 8)}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Status: ${order['status'] ?? 'N/A'}'),
                            Text(
                              'Date: ${_formatDate(order['timestamp'])}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: Text(
                          '₹${(order['totalAmount'] ?? 0).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/order-status',
                            arguments: orders[index].id,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductsPanel() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final products = snapshot.data!.docs;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Products Management',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product =
                        products[index].data() as Map<String, dynamic>;
                    return Card(
                      elevation: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                              child: const Center(
                                child: Icon(Icons.image, size: 48),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'] ?? 'Unknown',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '₹${product['price']}/kg',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRatingsPanel() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('ratings').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final ratings = snapshot.data!.docs;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ratings & Reviews',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: ratings.length,
                  itemBuilder: (context, index) {
                    final rating =
                        ratings[index].data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.amber,
                          child: Text(
                            rating['rating'].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(rating['customerName'] ?? 'Anonymous'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (rating['review'] != null)
                              Text(rating['review']),
                            Text(
                              _formatDate(rating['createdAt']),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: rating['review'] != null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Delivered':
        return Colors.green;
      case 'Out for Delivery':
        return Colors.blue;
      case 'Packed':
        return Colors.orange;
      case 'Harvesting':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'N/A';
    try {
      final date = (timestamp as Timestamp).toDate();
      return DateFormat('MMM d, y').format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }

  Future<void> _deleteUser(String userId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _firestore.collection('users').doc(userId).delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User deleted successfully')),
        );
      }
    }
  }
}
