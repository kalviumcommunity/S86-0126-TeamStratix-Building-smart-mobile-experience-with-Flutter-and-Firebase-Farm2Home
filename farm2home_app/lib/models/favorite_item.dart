/// Favorite Item Model
/// Represents an item that has been added to the favorites list
class FavoriteItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final DateTime addedAt;

  FavoriteItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.addedAt,
  });

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      image: json['image'] ?? '',
      addedAt: json['addedAt'] != null
          ? DateTime.parse(json['addedAt'])
          : DateTime.now(),
    );
  }

  /// Copy with method for immutability
  FavoriteItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? image,
    DateTime? addedAt,
  }) {
    return FavoriteItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      image: image ?? this.image,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  String toString() =>
      'FavoriteItem(id: $id, name: $name, price: $price, addedAt: $addedAt)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
