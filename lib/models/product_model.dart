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
  final List<String> imageUrls; // Multiple image URLs from Cloudinary
  final List<String> cloudinaryPublicIds; // Public IDs for Cloudinary management
  final String? imageUrl; // Keep for backward compatibility
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ProductModel({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.category,
    required this.farmerId,
    required this.farmerName,
    this.imageUrls = const [],
    this.cloudinaryPublicIds = const [],
    this.imageUrl, // Backward compatibility
    this.isAvailable = true,
    required this.createdAt,
    this.updatedAt,
  });

  // Get primary image URL (first image or fallback to imageUrl)
  String? get primaryImageUrl {
    if (imageUrls.isNotEmpty) return imageUrls.first;
    return imageUrl;
  }

  // Check if product has images
  bool get hasImages => imageUrls.isNotEmpty || imageUrl != null;

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
      'imageUrls': imageUrls,
      'cloudinaryPublicIds': cloudinaryPublicIds,
      'imageUrl': imageUrl, // Keep for backward compatibility
      'isAvailable': isAvailable,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
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
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      cloudinaryPublicIds: List<String>.from(map['cloudinaryPublicIds'] ?? []),
      imageUrl: map['imageUrl'], // Backward compatibility
      isAvailable: map['isAvailable'] ?? true,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
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
    List<String>? imageUrls,
    List<String>? cloudinaryPublicIds,
    String? imageUrl,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
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
      imageUrls: imageUrls ?? this.imageUrls,
      cloudinaryPublicIds: cloudinaryPublicIds ?? this.cloudinaryPublicIds,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
