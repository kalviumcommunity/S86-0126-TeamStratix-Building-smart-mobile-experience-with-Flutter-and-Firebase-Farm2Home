import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String notificationId;
  final String userId;
  final String title;
  final String body;
  final String type; // 'order', 'message', 'rating', 'system'
  final String? orderId;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.orderId,
    required this.createdAt,
    this.isRead = false,
    this.data,
  });

  // From Firestore
  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      notificationId: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      type: data['type'] ?? 'system',
      orderId: data['orderId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
      data: data['data'] as Map<String, dynamic>?,
    );
  }

  // To Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
      'type': type,
      'orderId': orderId,
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
      'data': data,
    };
  }

  // Copy with
  NotificationModel copyWith({
    String? notificationId,
    String? userId,
    String? title,
    String? body,
    String? type,
    String? orderId,
    DateTime? createdAt,
    bool? isRead,
    Map<String, dynamic>? data,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      orderId: orderId ?? this.orderId,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
    );
  }
}
