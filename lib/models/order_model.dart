import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String orderId;
  final String customerId;
  final String customerName;
  final String farmerId;
  final String farmerName;
  final List<OrderItem> items;
  final String status;
  final DateTime timestamp;
  final String? deliveryAddress;
  final String? phoneNumber;

  OrderModel({
    required this.orderId,
    required this.customerId,
    required this.customerName,
    required this.farmerId,
    required this.farmerName,
    required this.items,
    required this.status,
    required this.timestamp,
    this.deliveryAddress,
    this.phoneNumber,
  });

  // Convert OrderModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'customerId': customerId,
      'customerName': customerName,
      'farmerId': farmerId,
      'farmerName': farmerName,
      'items': items.map((item) => item.toMap()).toList(),
      'status': status,
      'timestamp': Timestamp.fromDate(timestamp),
      'deliveryAddress': deliveryAddress,
      'phoneNumber': phoneNumber,
    };
  }

  // Create OrderModel from Firestore Document
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'] ?? '',
      customerId: map['customerId'] ?? '',
      customerName: map['customerName'] ?? '',
      farmerId: map['farmerId'] ?? '',
      farmerName: map['farmerName'] ?? '',
      items: (map['items'] as List<dynamic>)
          .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      status: map['status'] ?? 'Received',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      deliveryAddress: map['deliveryAddress'],
      phoneNumber: map['phoneNumber'],
    );
  }

  // Create OrderModel from Firestore DocumentSnapshot
  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return OrderModel.fromMap(data);
  }

  // Copy with method
  OrderModel copyWith({
    String? orderId,
    String? customerId,
    String? customerName,
    String? farmerId,
    String? farmerName,
    List<OrderItem>? items,
    String? status,
    DateTime? timestamp,
    String? deliveryAddress,
    String? phoneNumber,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      farmerId: farmerId ?? this.farmerId,
      farmerName: farmerName ?? this.farmerName,
      items: items ?? this.items,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  double get totalAmount {
    return items.fold(
      0.0,
      (total, item) => total + (item.price * item.quantity),
    );
  }
}

class OrderItem {
  final String name;
  final double quantity;
  final String unit;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {'name': name, 'quantity': quantity, 'unit': unit, 'price': price};
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      name: map['name'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      unit: map['unit'] ?? 'kg',
      price: (map['price'] ?? 0).toDouble(),
    );
  }

  double get total => quantity * price;
}
