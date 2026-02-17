import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/notification_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/notification_model.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        elevation: 0,
        actions: [
          if (notificationProvider.unreadCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${notificationProvider.unreadCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: notificationProvider.notifications.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: notificationProvider.notifications.length,
              itemBuilder: (context, index) {
                final notification = notificationProvider.notifications[index];
                return _buildNotificationItem(context, notification);
              },
            ),
    );
  }

  Widget _buildNotificationItem(
      BuildContext context, NotificationModel notification) {
    final notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Dismissible(
      key: Key(notification.notificationId),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        notificationProvider.deleteNotification(notification.notificationId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification deleted')),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        color: notification.isRead ? Colors.white : Colors.green[50],
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _getIconColor(notification.type),
            child: Icon(
              _getIcon(notification.type),
              color: Colors.white,
            ),
          ),
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(notification.body),
              const SizedBox(height: 4),
              Text(
                _formatTimestamp(notification.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          isThreeLine: true,
          onTap: () {
            if (!notification.isRead) {
              notificationProvider.markAsRead(notification.notificationId);
            }
            // Navigate to relevant screen based on type and user role
            if (notification.orderId != null) {
              final currentUser = authProvider.currentUser;
              if (currentUser != null) {
                if (currentUser.isCustomer) {
                  // Customers view order status
                  Navigator.pushNamed(
                    context,
                    '/order-status',
                    arguments: notification.orderId,
                  );
                } else if (currentUser.isFarmer) {
                  // Farmers update order status
                  Navigator.pushNamed(
                    context,
                    '/update-order-status',
                    arguments: notification.orderId,
                  );
                }
              }
            }
          },
        ),
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'order':
        return Icons.shopping_bag;
      case 'message':
        return Icons.message;
      case 'rating':
        return Icons.star;
      case 'payment':
        return Icons.payment;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'order':
        return Colors.blue;
      case 'message':
        return Colors.green;
      case 'rating':
        return Colors.amber;
      case 'payment':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, y').format(timestamp);
    }
  }
}
