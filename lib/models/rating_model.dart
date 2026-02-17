import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  final String ratingId;
  final String orderId;
  final String customerId;
  final String customerName;
  final String farmerId;
  final double rating;
  final String? review;
  final DateTime createdAt;

  Rating({
    required this.ratingId,
    required this.orderId,
    required this.customerId,
    required this.customerName,
    required this.farmerId,
    required this.rating,
    this.review,
    required this.createdAt,
  });

  // From Firestore
  factory Rating.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Rating(
      ratingId: doc.id,
      orderId: data['orderId'] ?? '',
      customerId: data['customerId'] ?? '',
      customerName: data['customerName'] ?? 'Anonymous',
      farmerId: data['farmerId'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      review: data['review'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // To Firestore
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'customerId': customerId,
      'customerName': customerName,
      'farmerId': farmerId,
      'rating': rating,
      'review': review,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Copy with
  Rating copyWith({
    String? ratingId,
    String? orderId,
    String? customerId,
    String? customerName,
    String? farmerId,
    double? rating,
    String? review,
    DateTime? createdAt,
  }) {
    return Rating(
      ratingId: ratingId ?? this.ratingId,
      orderId: orderId ?? this.orderId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      farmerId: farmerId ?? this.farmerId,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
