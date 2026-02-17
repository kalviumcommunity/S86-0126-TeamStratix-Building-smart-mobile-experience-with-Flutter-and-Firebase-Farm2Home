import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  List<NotificationModel> _notifications = [];
  int _unreadCount = 0;
  final bool _isLoading = false;
  String? _error;

  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize notifications
  Future<void> initialize(String userId) async {
    await _notificationService.initialize();
    await _notificationService.saveToken(userId);
    _listenToNotifications(userId);
    _listenToUnreadCount(userId);
  }

  // Listen to notifications stream
  void _listenToNotifications(String userId) {
    _notificationService.getUserNotifications(userId).listen(
      (notifications) {
        _notifications = notifications;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  // Listen to unread count
  void _listenToUnreadCount(String userId) {
    _notificationService.getUnreadCount(userId).listen(
      (count) {
        _unreadCount = count;
        notifyListeners();
      },
    );
  }

  // Mark as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _notificationService.markAsRead(notificationId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _notificationService.deleteNotification(notificationId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
