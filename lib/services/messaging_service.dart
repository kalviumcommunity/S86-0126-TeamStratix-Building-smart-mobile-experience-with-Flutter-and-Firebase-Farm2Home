import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';
import 'notification_service.dart';

class MessagingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService _notificationService = NotificationService();

  // Send a message
  Future<void> sendMessage({
    required String senderId,
    required String senderName,
    required String receiverId,
    required String receiverName,
    required String orderId,
    required String content,
    String? imageUrl,
  }) async {
    final message = Message(
      messageId: '',
      senderId: senderId,
      senderName: senderName,
      receiverId: receiverId,
      receiverName: receiverName,
      orderId: orderId,
      content: content,
      createdAt: DateTime.now(),
      imageUrl: imageUrl,
    );

    await _firestore.collection('messages').add(message.toMap());

    // Send notification to receiver
    await _notificationService.sendMessageNotification(
      userId: receiverId,
      senderName: senderName,
      message: content,
      orderId: orderId,
    );
  }

  // Get messages for an order
  Stream<List<Message>> getOrderMessages(String orderId) {
    return _firestore
        .collection('messages')
        .where('orderId', isEqualTo: orderId)
        .snapshots()
        .map((snapshot) {
          final messages = snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList();
          messages.sort((a, b) => a.createdAt.compareTo(b.createdAt)); // Sort by createdAt asc (oldest first)
          return messages;
        });
  }

  // Get conversations for a user
  Stream<List<Map<String, dynamic>>> getUserConversations(String userId) {
    return _firestore
        .collection('messages')
        .where('senderId', isEqualTo: userId)
        .snapshots()
        .asyncMap((senderSnapshot) async {
      // Get messages where user is receiver
      final receiverSnapshot = await _firestore
          .collection('messages')
          .where('receiverId', isEqualTo: userId)
          .get();

      // Combine and organize by order
      final Map<String, Map<String, dynamic>> conversations = {};

      for (var doc in senderSnapshot.docs) {
        final message = Message.fromFirestore(doc);
        if (!conversations.containsKey(message.orderId)) {
          conversations[message.orderId] = {
            'orderId': message.orderId,
            'otherUserId': message.receiverId,
            'otherUserName': message.receiverName,
            'lastMessage': message.content,
            'lastMessageTime': message.createdAt,
            'unreadCount': 0,
          };
        }
      }

      for (var doc in receiverSnapshot.docs) {
        final message = Message.fromFirestore(doc);
        if (!conversations.containsKey(message.orderId)) {
          conversations[message.orderId] = {
            'orderId': message.orderId,
            'otherUserId': message.senderId,
            'otherUserName': message.senderName,
            'lastMessage': message.content,
            'lastMessageTime': message.createdAt,
            'unreadCount': message.isRead ? 0 : 1,
          };
        } else if (message.createdAt.isAfter(
            conversations[message.orderId]!['lastMessageTime'] as DateTime)) {
          conversations[message.orderId]!['lastMessage'] = message.content;
          conversations[message.orderId]!['lastMessageTime'] =
              message.createdAt;
          if (!message.isRead) {
            conversations[message.orderId]!['unreadCount'] =
                (conversations[message.orderId]!['unreadCount'] as int) + 1;
          }
        }
      }

      return conversations.values.toList()
        ..sort((a, b) => (b['lastMessageTime'] as DateTime)
            .compareTo(a['lastMessageTime'] as DateTime));
    });
  }

  // Mark message as read
  Future<void> markMessageAsRead(String messageId) async {
    await _firestore.collection('messages').doc(messageId).update({
      'isRead': true,
    });
  }

  // Get unread message count for user
  Stream<int> getUnreadMessageCount(String userId) {
    return _firestore
        .collection('messages')
        .where('receiverId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Delete message
  Future<void> deleteMessage(String messageId) async {
    await _firestore.collection('messages').doc(messageId).delete();
  }

  // Get last message for order
  Future<Message?> getLastMessage(String orderId) async {
    final snapshot = await _firestore
        .collection('messages')
        .where('orderId', isEqualTo: orderId)
        .get();

    if (snapshot.docs.isEmpty) return null;
    
    // Sort by createdAt and get the last one
    final messages = snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList();
    messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return messages.first;
  }
}
