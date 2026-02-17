import 'package:cloud_firestore/cloud_firestore.dart';

class AgroProduct {
  final String productId;
  final String productName;
  final String category; // 'fertilizer', 'seed', 'pesticide'
  final String description;
  final double price;
  final int stock;
  final String unit; // 'kg', 'liter', 'packet'
  final String? imageUrl;
  final double ratings;
  final int reviewCount;
  final String seller;
  final DateTime createdAt;

  AgroProduct({
    required this.productId,
    required this.productName,
    required this.category,
    required this.description,
    required this.price,
    required this.stock,
    required this.unit,
    this.imageUrl,
    required this.ratings,
    required this.reviewCount,
    required this.seller,
    required this.createdAt,
  });

  factory AgroProduct.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AgroProduct(
      productId: doc.id,
      productName: data['productName'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      stock: data['stock'] ?? 0,
      unit: data['unit'] ?? 'kg',
      imageUrl: data['imageUrl'],
      ratings: (data['ratings'] ?? 0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      seller: data['seller'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'category': category,
      'description': description,
      'price': price,
      'stock': stock,
      'unit': unit,
      'imageUrl': imageUrl,
      'ratings': ratings,
      'reviewCount': reviewCount,
      'seller': seller,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class AgroOrder {
  final String orderId;
  final String farmerId;
  final List<Map<String, dynamic>> items; // {productId, quantity, price}
  final double totalAmount;
  final String deliveryAddress;
  final String status; // 'pending', 'confirmed', 'delivered'
  final DateTime deliveryDate;
  final String? trackingId;
  final DateTime createdAt;

  AgroOrder({
    required this.orderId,
    required this.farmerId,
    required this.items,
    required this.totalAmount,
    required this.deliveryAddress,
    required this.status,
    required this.deliveryDate,
    this.trackingId,
    required this.createdAt,
  });

  factory AgroOrder.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AgroOrder(
      orderId: doc.id,
      farmerId: data['farmerId'] ?? '',
      items: List<Map<String, dynamic>>.from(data['items'] ?? []),
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      deliveryAddress: data['deliveryAddress'] ?? '',
      status: data['status'] ?? 'pending',
      deliveryDate: (data['deliveryDate'] as Timestamp).toDate(),
      trackingId: data['trackingId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'farmerId': farmerId,
      'items': items,
      'totalAmount': totalAmount,
      'deliveryAddress': deliveryAddress,
      'status': status,
      'deliveryDate': Timestamp.fromDate(deliveryDate),
      'trackingId': trackingId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
