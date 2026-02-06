import '../models/product.dart';
import 'firestore_service.dart';

/// Convert Product objects to Firestore-compatible maps
List<Map<String, dynamic>> productsToFirestoreData(List<Product> products) {
  return products.map((product) {
    return {
      'id': product.id,
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'unit': product.unit,
      'category': product.category,
      'imageIcon': product.imageIcon,
      'isAvailable': true,
      'stock': 100,
      'farmerId': 'seed_farmer_001',
      'rating': 4.5,
      'reviewCount': 0,
    };
  }).toList();
}

/// Sample categories for Firestore
List<Map<String, dynamic>> getSampleCategories() {
  return [
    {
      'id': 'vegetables',
      'name': 'Vegetables',
      'description': 'Fresh organic vegetables',
      'icon': 'eco',
      'sortOrder': 1,
      'isActive': true,
    },
    {
      'id': 'fruits',
      'name': 'Fruits',
      'description': 'Seasonal fresh fruits',
      'icon': 'apple',
      'sortOrder': 2,
      'isActive': true,
    },
    {
      'id': 'herbs',
      'name': 'Herbs & Spices',
      'description': 'Aromatic herbs and spices',
      'icon': 'spa',
      'sortOrder': 3,
      'isActive': true,
    },
    {
      'id': 'dairy',
      'name': 'Dairy',
      'description': 'Fresh dairy products',
      'icon': 'water_drop',
      'sortOrder': 4,
      'isActive': true,
    },
  ];
}

/// Seed Firestore with sample data
/// Usage: Call this once from a button or during initial setup
/// Example:
/// ```dart
/// await seedFirestoreData();
/// ```
Future<void> seedFirestoreData() async {
  final firestoreService = FirestoreService();

  // Seed categories first
  final categories = getSampleCategories();
  await firestoreService.seedCategories(categories);

  // Seed products
  final products = productsToFirestoreData(sampleProducts);
  await firestoreService.seedProducts(products);
}
