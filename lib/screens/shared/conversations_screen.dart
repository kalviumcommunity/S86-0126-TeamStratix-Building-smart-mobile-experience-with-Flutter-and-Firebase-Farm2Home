import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/messaging_provider.dart';
import '../../providers/auth_provider.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final messagingProvider =
        Provider.of<MessagingProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      messagingProvider.loadConversations(authProvider.currentUser!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagingProvider = Provider.of<MessagingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        elevation: 0,
      ),
      body: messagingProvider.conversations.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No conversations yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Start chatting about your orders',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: messagingProvider.conversations.length,
              itemBuilder: (context, index) {
                final conversation = messagingProvider.conversations[index];
                return _buildConversationItem(context, conversation);
              },
            ),
    );
  }

  Widget _buildConversationItem(
      BuildContext context, Map<String, dynamic> conversation) {
    final unreadCount = conversation['unreadCount'] as int;
    final lastMessageTime = conversation['lastMessageTime'] as DateTime;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Stack(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.person, color: Colors.white),
            ),
            if (unreadCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          conversation['otherUserName'] as String,
          style: TextStyle(
            fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              conversation['lastMessage'] as String,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: unreadCount > 0 ? Colors.black87 : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(lastMessageTime),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          Navigator.pushNamed(
            context,
            '/chat',
            arguments: {
              'orderId': conversation['orderId'] as String,
              'otherUserId': conversation['otherUserId'] as String,
              'otherUserName': conversation['otherUserName'] as String,
            },
          );
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(time);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(time);
    } else {
      return DateFormat('MMM d').format(time);
    }
  }
}
