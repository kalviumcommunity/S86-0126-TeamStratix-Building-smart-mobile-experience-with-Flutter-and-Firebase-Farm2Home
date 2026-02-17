import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../services/messaging_service.dart';

class MessagingProvider with ChangeNotifier {
  final MessagingService _messagingService = MessagingService();

  List<Message> _messages = [];
  List<Map<String, dynamic>> _conversations = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _error;

  List<Message> get messages => _messages;
  List<Map<String, dynamic>> get conversations => _conversations;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load conversations for user
  void loadConversations(String userId) {
    _messagingService.getUserConversations(userId).listen(
      (conversations) {
        _conversations = conversations;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  // Load messages for order
  void loadOrderMessages(String orderId) {
    _messagingService.getOrderMessages(orderId).listen(
      (messages) {
        _messages = messages;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  // Send message
  Future<bool> sendMessage({
    required String senderId,
    required String senderName,
    required String receiverId,
    required String receiverName,
    required String orderId,
    required String content,
    String? imageUrl,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _messagingService.sendMessage(
        senderId: senderId,
        senderName: senderName,
        receiverId: receiverId,
        receiverName: receiverName,
        orderId: orderId,
        content: content,
        imageUrl: imageUrl,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Listen to unread count
  void listenToUnreadCount(String userId) {
    _messagingService.getUnreadMessageCount(userId).listen(
      (count) {
        _unreadCount = count;
        notifyListeners();
      },
    );
  }

  // Mark message as read
  Future<void> markAsRead(String messageId) async {
    try {
      await _messagingService.markMessageAsRead(messageId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Clear messages
  void clearMessages() {
    _messages = [];
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
