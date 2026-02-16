import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

/// Notification model for displaying messages
class NotificationMessage {
  final String title;
  final String body;
  final String? imageUrl;
  final DateTime receivedAt;
  final String source; // 'foreground', 'background', or 'terminated'
  final Map<String, dynamic>? data;

  NotificationMessage({
    required this.title,
    required this.body,
    this.imageUrl,
    required this.receivedAt,
    required this.source,
    this.data,
  });

  @override
  String toString() => 'NotificationMessage(title: $title, source: $source)';
}

/// Firebase Cloud Messaging Service
/// Handles FCM setup, token management, and message listening
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Streams for notification events
  final StreamController<NotificationMessage> _foregroundMessageStream =
      StreamController<NotificationMessage>.broadcast();
  final StreamController<NotificationMessage> _allMessagesStream =
      StreamController<NotificationMessage>.broadcast();
  final StreamController<String> _tokenStream =
      StreamController<String>.broadcast();

  String? _cachedToken;
  final List<NotificationMessage> _messageHistory = [];

  NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  // Streams for consuming notifications
  Stream<NotificationMessage> get foregroundMessages =>
      _foregroundMessageStream.stream;
  Stream<NotificationMessage> get allMessages => _allMessagesStream.stream;
  Stream<String> get tokenUpdates => _tokenStream.stream;

  List<NotificationMessage> get messageHistory => _messageHistory;

  /// Initialize Firebase Cloud Messaging
  Future<void> initializeNotifications() async {
    try {
      // Request user permission for notifications
      await _requestNotificationPermission();

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Get initial device token
      _cachedToken = await _messaging.getToken();
      _tokenStream.add(_cachedToken ?? '');

      print('FCM Token: $_cachedToken');

      // Listen for token refresh
      _messaging.onTokenRefresh.listen((token) {
        _cachedToken = token;
        _tokenStream.add(token);
        print('FCM Token refreshed: $token');
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle messages when app is in background/terminated
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

      // Handle initial message (app opened from terminated state)
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleTerminatedStateMessage(initialMessage);
      }

      print('Firebase Cloud Messaging initialized successfully');
    } catch (e) {
      print('Error initializing FCM: $e');
    }
  }

  /// Request notification permissions
  Future<void> _requestNotificationPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('Notification permissions granted');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('Notification permissions granted provisionally');
      } else {
        print('Notification permissions denied');
      }
    } catch (e) {
      print('Error requesting notification permission: $e');
    }
  }

  /// Initialize local notifications plugin
  Future<void> _initializeLocalNotifications() async {
    try {
      // Android initialization
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization
      final DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
      );

      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onLocalNotificationTapped,
      );

      print('Local notifications initialized');
    } catch (e) {
      print('Error initializing local notifications: $e');
    }
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    print('Foreground message received:');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');

    final notification = NotificationMessage(
      title: message.notification?.title ?? 'No Title',
      body: message.notification?.body ?? 'No Body',
      imageUrl: message.notification?.android?.imageUrl ??
          message.notification?.apple?.imageUrl,
      receivedAt: DateTime.now(),
      source: 'foreground',
      data: message.data,
    );

    _messageHistory.insert(0, notification);
    _foregroundMessageStream.add(notification);
    _allMessagesStream.add(notification);

    // Show local notification while app is in foreground
    _showLocalNotification(message);
  }

  /// Handle background messages
  void _handleBackgroundMessage(RemoteMessage message) {
    print('Background message opened:');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');

    final notification = NotificationMessage(
      title: message.notification?.title ?? 'No Title',
      body: message.notification?.body ?? 'No Body',
      imageUrl: message.notification?.android?.imageUrl ??
          message.notification?.apple?.imageUrl,
      receivedAt: DateTime.now(),
      source: 'background',
      data: message.data,
    );

    _messageHistory.insert(0, notification);
    _allMessagesStream.add(notification);
  }

  /// Handle terminated state messages
  void _handleTerminatedStateMessage(RemoteMessage message) {
    print('App launched from terminated state with notification:');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');

    final notification = NotificationMessage(
      title: message.notification?.title ?? 'No Title',
      body: message.notification?.body ?? 'No Body',
      imageUrl: message.notification?.android?.imageUrl ??
          message.notification?.apple?.imageUrl,
      receivedAt: DateTime.now(),
      source: 'terminated',
      data: message.data,
    );

    _messageHistory.insert(0, notification);
    _allMessagesStream.add(notification);
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'farm2home_channel',
        'Farm2Home Notifications',
        channelDescription: 'Push notifications for Farm2Home alerts',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );

      const DarwinNotificationDetails iosDetails =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        message.hashCode,
        message.notification?.title ?? 'No Title',
        message.notification?.body ?? 'No Body',
        notificationDetails,
      );
    } catch (e) {
      print('Error showing local notification: $e');
    }
  }

  /// iOS local notification callback
  void _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    print('iOS local notification tapped: $title - $body');
  }

  /// Local notification tapped callback
  void _onLocalNotificationTapped(NotificationResponse response) {
    print('Local notification tapped with payload: ${response.payload}');
  }

  /// Get current FCM token
  Future<String?> getToken() async {
    if (_cachedToken != null) {
      return _cachedToken;
    }

    try {
      _cachedToken = await _messaging.getToken();
      return _cachedToken;
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      print('Subscribed to topic: $topic');
    } catch (e) {
      print('Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      print('Unsubscribed from topic: $topic');
    } catch (e) {
      print('Error unsubscribing from topic: $e');
    }
  }

  /// Clear message history
  void clearHistory() {
    _messageHistory.clear();
    _allMessagesStream.add(NotificationMessage(
      title: 'History Cleared',
      body: 'Message history has been cleared',
      receivedAt: DateTime.now(),
      source: 'system',
    ));
  }

  /// Dispose resources
  void dispose() {
    _foregroundMessageStream.close();
    _allMessagesStream.close();
    _tokenStream.close();
  }
}
