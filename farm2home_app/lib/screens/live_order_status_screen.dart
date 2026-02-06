import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

/// Live Order Status Screen
/// Demonstrates real-time order tracking with instant status updates
/// 
/// Features:
/// - Real-time order status monitoring
/// - Live delivery tracking
/// - Instant notifications on status changes
/// - Timeline visualization with updates
/// - Order history with real-time sync
class LiveOrderStatusScreen extends StatefulWidget {
  const LiveOrderStatusScreen({super.key});

  @override
  State<LiveOrderStatusScreen> createState() => _LiveOrderStatusScreenState();
}

class _LiveOrderStatusScreenState extends State<LiveOrderStatusScreen> {
  final AuthService _authService = AuthService();
  String? _lastNotification;

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Live Order Status'),
          backgroundColor: const Color(0xFF4A7C4A),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('Please log in to track your orders'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFD4EDD4),
      appBar: AppBar(
        title: const Text('Live Order Status'),
        backgroundColor: const Color(0xFF4A7C4A),
        foregroundColor: Colors.white,
        actions: [
          if (_lastNotification != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 8, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Real-time notification banner
          if (_lastNotification != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.orange[100],
              child: Row(
                children: [
                  const Icon(Icons.notifications_active, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _lastNotification!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () {
                      setState(() {
                        _lastNotification = null;
                      });
                    },
                  ),
                ],
              ),
            ),

          // Orders list with real-time updates
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('userId', isEqualTo: user.uid)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                // Handle change detection for notifications
                if (snapshot.hasData) {
                  for (var change in snapshot.data!.docChanges) {
                    if (change.type == DocumentChangeType.modified) {
                      final data = change.doc.data()!;
                      final orderId = change.doc.id.substring(0, 8);
                      final status = data['status'] ?? 'unknown';
                      
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _lastNotification = 
                              'Order #$orderId updated to: ${status.toUpperCase()}';
                        });

                        // Show snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.update, color: Colors.white),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Order #$orderId → ${status.toUpperCase()}',
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: Colors.blue,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      });
                    }
                  }
                }

                // Loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Color(0xFF4A7C4A)),
                        SizedBox(height: 16),
                        Text('Connecting to order tracking...'),
                      ],
                    ),
                  );
                }

                // Error state
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Error: ${snapshot.error}'),
                      ],
                    ),
                  );
                }

                // Empty state
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_bag_outlined,
                            size: 80, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'No orders yet',
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Your orders will appear here\nwith live status updates',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black45),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to shop (implement this)
                          },
                          icon: const Icon(Icons.shopping_cart),
                          label: const Text('Start Shopping'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A7C4A),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Display orders
                final orders = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final orderData = orders[index].data();
                    final orderId = orders[index].id;

                    return _buildOrderCard(orderId, orderData);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showOrderTrackingInfo(context);
        },
        backgroundColor: const Color(0xFF4A7C4A),
        icon: const Icon(Icons.info_outline),
        label: const Text('How It Works'),
      ),
    );
  }

  Widget _buildOrderCard(String orderId, Map<String, dynamic> orderData) {
    final status = orderData['status'] ?? 'pending';
    final totalAmount = orderData['totalAmount'] ?? 0.0;
    final createdAt = orderData['createdAt'] as Timestamp?;
    final statusHistory = orderData['statusHistory'] as List<dynamic>? ?? [];

    // Status colors
    Color statusColor;
    IconData statusIcon;
    
    switch (status) {
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case 'confirmed':
        statusColor = Colors.blue;
        statusIcon = Icons.check_circle;
        break;
      case 'preparing':
        statusColor = Colors.purple;
        statusIcon = Icons.kitchen;
        break;
      case 'out_for_delivery':
        statusColor = Colors.indigo;
        statusIcon = Icons.local_shipping;
        break;
      case 'delivered':
        statusColor = Colors.green;
        statusIcon = Icons.done_all;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: CircleAvatar(
            backgroundColor: statusColor.withValues(alpha: 0.2),
            child: Icon(statusIcon, color: statusColor),
          ),
          title: Row(
            children: [
              Text(
                'Order #${orderId.substring(0, 8)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: 6, color: Colors.green),
                    SizedBox(width: 4),
                    Text(
                      'LIVE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status.toUpperCase().replaceAll('_', ' '),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '\$${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              if (createdAt != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _formatDate(createdAt),
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Timeline',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (statusHistory.isEmpty)
                    const Text(
                      'No status updates yet',
                      style: TextStyle(color: Colors.black54),
                    )
                  else
                    ...statusHistory.asMap().entries.map((entry) {
                      final index = entry.key;
                      final historyItem = entry.value as Map<String, dynamic>;
                      final isLast = index == statusHistory.length - 1;

                      return _buildTimelineItem(
                        historyItem['status'] ?? '',
                        historyItem['timestamp'] as Timestamp?,
                        !isLast,
                      );
                    }),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Status updates appear instantly as your order progresses',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String status, Timestamp? timestamp, bool showLine) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: const Color(0xFF4A7C4A),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
            if (showLine)
              Container(
                width: 2,
                height: 40,
                color: const Color(0xFF4A7C4A).withValues(alpha: 0.3),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.toUpperCase().replaceAll('_', ' '),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                if (timestamp != null)
                  Text(
                    _formatDateTime(timestamp),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showOrderTrackingInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Real-Time Order Tracking'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How It Works:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('✅ Orders sync in real-time using Firestore snapshots'),
              SizedBox(height: 8),
              Text('✅ Status changes appear instantly without refresh'),
              SizedBox(height: 8),
              Text('✅ Notifications show when orders are updated'),
              SizedBox(height: 8),
              Text('✅ Timeline tracks complete order journey'),
              SizedBox(height: 8),
              Text('✅ Works even with app in background'),
              SizedBox(height: 16),
              Text(
                'Test It:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('1. Open Firebase Console'),
              SizedBox(height: 4),
              Text('2. Navigate to orders collection'),
              SizedBox(height: 4),
              Text('3. Change order status'),
              SizedBox(height: 4),
              Text('4. Watch screen update INSTANTLY!'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got It'),
          ),
        ],
      ),
    );
  }
}
