import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/notification_model.dart';

// Top-level function for background message handling
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling background message: ${message.messageId}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _initialized = false;

  // Initialize notification service
  Future<void> initialize() async {
    if (_initialized) return;

    // Request permission on iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    }

    // Initialize local notifications
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Set up message handlers
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    _initialized = true;
  }

  // Get FCM token
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Save FCM token to Firestore
  Future<void> saveToken(String userId) async {
    String? token = await getToken();
    if (token != null) {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': token,
        'tokenUpdatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Got foreground message: ${message.notification?.title}');
    _showLocalNotification(message);
  }

  // Handle notification tap when app is in background
  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('Message opened app: ${message.messageId}');
    // Navigate to appropriate screen based on notification data
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // Navigate to appropriate screen
  }

  // Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'farm2home_channel',
      'Farm2Home Notifications',
      channelDescription: 'Notifications for Farm2Home app',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'Farm2Home',
      message.notification?.body ?? '',
      details,
      payload: message.data['orderId'],
    );
  }

  // Create notification in Firestore
  Future<void> createNotification({
    required String userId,
    required String title,
    required String body,
    required String type,
    String? orderId,
    Map<String, dynamic>? data,
  }) async {
    final notification = NotificationModel(
      notificationId: '',
      userId: userId,
      title: title,
      body: body,
      type: type,
      orderId: orderId,
      createdAt: DateTime.now(),
      data: data,
    );

    await _firestore.collection('notifications').add(notification.toMap());
  }

  // Get user notifications stream
  Stream<List<NotificationModel>> getUserNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .limit(50)
        .snapshots()
        .map((snapshot) {
          final notifications = snapshot.docs
              .map((doc) => NotificationModel.fromFirestore(doc))
              .toList();
          notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Sort by createdAt desc
          return notifications;
        });
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'isRead': true,
    });
  }

  // Get unread count
  Stream<int> getUnreadCount(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).delete();
  }

  // Send order status notification
  Future<void> sendOrderStatusNotification({
    required String userId,
    required String orderId,
    required String status,
  }) async {
    await createNotification(
      userId: userId,
      title: 'Order Status Updated',
      body: 'Your order is now $status',
      type: 'order',
      orderId: orderId,
      data: {'status': status},
    );
  }

  // Send new message notification
  Future<void> sendMessageNotification({
    required String userId,
    required String senderName,
    required String message,
    required String orderId,
  }) async {
    await createNotification(
      userId: userId,
      title: 'New Message from $senderName',
      body: message,
      type: 'message',
      orderId: orderId,
    );
  }

  // Send new rating notification
  Future<void> sendRatingNotification({
    required String farmerId,
    required String customerName,
    required double rating,
  }) async {
    await createNotification(
      userId: farmerId,
      title: 'New Rating Received',
      body: '$customerName rated you ${rating.toStringAsFixed(1)} stars',
      type: 'rating',
    );
  }
}
