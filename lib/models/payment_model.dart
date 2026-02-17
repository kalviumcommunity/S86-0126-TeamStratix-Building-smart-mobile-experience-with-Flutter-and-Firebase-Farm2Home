import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final String paymentId;
  final String orderId;
  final String customerId;
  final double amount;
  final String currency;
  final String status; // 'pending', 'completed', 'failed', 'refunded'
  final String paymentMethod; // 'card', 'upi', 'cash_on_delivery'
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? transactionId;
  final Map<String, dynamic>? metadata;

  Payment({
    required this.paymentId,
    required this.orderId,
    required this.customerId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
    this.completedAt,
    this.transactionId,
    this.metadata,
  });

  // From Firestore
  factory Payment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Payment(
      paymentId: doc.id,
      orderId: data['orderId'] ?? '',
      customerId: data['customerId'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      currency: data['currency'] ?? 'INR',
      status: data['status'] ?? 'pending',
      paymentMethod: data['paymentMethod'] ?? 'cash_on_delivery',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
      transactionId: data['transactionId'],
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }

  // To Firestore
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'customerId': customerId,
      'amount': amount,
      'currency': currency,
      'status': status,
      'paymentMethod': paymentMethod,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedAt':
          completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'transactionId': transactionId,
      'metadata': metadata,
    };
  }

  // Copy with
  Payment copyWith({
    String? paymentId,
    String? orderId,
    String? customerId,
    double? amount,
    String? currency,
    String? status,
    String? paymentMethod,
    DateTime? createdAt,
    DateTime? completedAt,
    String? transactionId,
    Map<String, dynamic>? metadata,
  }) {
    return Payment(
      paymentId: paymentId ?? this.paymentId,
      orderId: orderId ?? this.orderId,
      customerId: customerId ?? this.customerId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      transactionId: transactionId ?? this.transactionId,
      metadata: metadata ?? this.metadata,
    );
  }
}
