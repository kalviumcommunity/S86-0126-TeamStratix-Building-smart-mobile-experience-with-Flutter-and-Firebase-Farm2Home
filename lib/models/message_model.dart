import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String messageId;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String receiverName;
  final String orderId;
  final String content;
  final DateTime createdAt;
  final bool isRead;
  final String? imageUrl;

  Message({
    required this.messageId,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.receiverName,
    required this.orderId,
    required this.content,
    required this.createdAt,
    this.isRead = false,
    this.imageUrl,
  });

  // From Firestore
  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Message(
      messageId: doc.id,
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? 'Unknown',
      receiverId: data['receiverId'] ?? '',
      receiverName: data['receiverName'] ?? 'Unknown',
      orderId: data['orderId'] ?? '',
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
      imageUrl: data['imageUrl'],
    );
  }

  // To Firestore
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'orderId': orderId,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
      'imageUrl': imageUrl,
    };
  }

  // Copy with
  Message copyWith({
    String? messageId,
    String? senderId,
    String? senderName,
    String? receiverId,
    String? receiverName,
    String? orderId,
    String? content,
    DateTime? createdAt,
    bool? isRead,
    String? imageUrl,
  }) {
    return Message(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
      orderId: orderId ?? this.orderId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
