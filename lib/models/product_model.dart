import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_model.dart';

class ProductModel {
  final String productId;
  final String name;
  final String description;
  final double price;
  final String unit;
  final String category;
  final String farmerId;
  final String farmerName;
  final String? imageUrl;
  final bool isAvailable;
  final DateTime createdAt;

  ProductModel({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.category,
    required this.farmerId,
    required this.farmerName,
    this.imageUrl,
    this.isAvailable = true,
    required this.createdAt,
  });

  // Convert ProductModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'description': description,
      'price': price,
      'unit': unit,
      'category': category,
      'farmerId': farmerId,
      'farmerName': farmerName,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create ProductModel from Map
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      unit: map['unit'] ?? 'kg',
      category: map['category'] ?? 'Other',
      farmerId: map['farmerId'] ?? '',
      farmerName: map['farmerName'] ?? '',
      imageUrl: map['imageUrl'],
      isAvailable: map['isAvailable'] ?? true,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Create ProductModel from Firestore DocumentSnapshot
  factory ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ProductModel.fromMap(data);
  }

  // Copy with method
  ProductModel copyWith({
    String? productId,
    String? name,
    String? description,
    double? price,
    String? unit,
    String? category,
    String? farmerId,
    String? farmerName,
    String? imageUrl,
    bool? isAvailable,
    DateTime? createdAt,
  }) {
    return ProductModel(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      farmerId: farmerId ?? this.farmerId,
      farmerName: farmerName ?? this.farmerName,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CartItem {
  final ProductModel product;
  final double quantity;

  CartItem({required this.product, required this.quantity});

  double get total => product.price * quantity;

  CartItem copyWith({ProductModel? product, double? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  // Convert to OrderItem for order placement
  OrderItem toOrderItem() {
    return OrderItem(
      name: product.name,
      quantity: quantity,
      unit: product.unit,
      price: product.price,
    );
  }
}
