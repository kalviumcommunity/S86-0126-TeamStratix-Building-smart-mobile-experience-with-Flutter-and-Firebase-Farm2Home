# Firestore Read Operations - Implementation Guide

## Overview
This guide shows how to use the new Firestore read operations to display live product data in Farm2Home.

## Files Created/Modified

### New Files
1. `lib/screens/products_screen_firestore.dart` - New StreamBuilder-based products screen
2. `lib/services/seed_data.dart` - Helper functions for seeding Firestore

### Modified Files
1. `lib/models/product.dart` - Added Firestore serialization methods
2. `lib/services/firestore_service.dart` - Added 15+ read operation methods
3. `README.md` - Added comprehensive documentation (600+ lines)

## Quick Start

### Option 1: Use Firestore Version (Recommended for Production)

Update `lib/main.dart` to use the new Firestore screen:

```dart
import 'screens/products_screen_firestore.dart'; // Add this import

// In routes:
'/products': (context) => ProductsScreenFirestore(cartService: _cartService),
```

### Option 2: Keep Static Version

The original `products_screen.dart` still works with hardcoded data. No changes needed.

## Usage Workflow

### First Time Setup

1. **Launch the app** → Shows "No products available"
2. **Click "Seed Sample Data"** → Populates Firestore with 55 products
3. **Products appear automatically** → StreamBuilder detects new data

### Subsequent Launches

- Products load from Firestore automatically
- Real-time updates (new products appear instantly)
- Search works on live data
- Home button clears search

## Available Read Operations

### Products

```dart
// Get all products (one-time)
final products = await firestoreService.getAllProducts();

// Stream products (real-time updates)
Stream<QuerySnapshot> stream = firestoreService.streamAllProducts();

// Get single product
final product = await firestoreService.getProductById('product_123');

// Stream single product
Stream<DocumentSnapshot> stream = firestoreService.streamProductById('product_123');

// Filter by category
final veggies = await firestoreService.getProductsByCategory('vegetables');

// Stream available products only
Stream<QuerySnapshot> stream = firestoreService.streamAvailableProducts();

// Search products
final results = await firestoreService.searchProducts('tomato');
```

### Categories

```dart
// Get all categories
final categories = await firestoreService.getAllCategories();

// Stream categories
Stream<QuerySnapshot> stream = firestoreService.streamAllCategories();

// Stream active categories only
Stream<QuerySnapshot> stream = firestoreService.streamActiveCategories();
```

### Product Reviews

```dart
// Get reviews for a product
final reviews = await firestoreService.getProductReviews('product_123');

// Stream reviews (real-time)
Stream<QuerySnapshot> stream = firestoreService.streamProductReviews('product_123');
```

## StreamBuilder Pattern

### Basic Usage

```dart
StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
  stream: _firestoreService.streamAvailableProducts(),
  builder: (context, snapshot) {
    // 1. Handle loading
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    
    // 2. Handle errors
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    
    // 3. Handle empty data
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return Text('No products');
    }
    
    // 4. Display data
    List<Product> products = snapshot.data!.docs
        .map((doc) => Product.fromFirestore(doc.data()))
        .toList();
    
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) => Text(products[index].name),
    );
  },
)
```

### StreamBuilder vs FutureBuilder

| Feature | StreamBuilder | FutureBuilder |
|---------|---------------|---------------|
| **Updates** | Automatic real-time | One-time fetch |
| **Use Case** | Live data (products, orders) | Static data (user profile) |
| **Performance** | Higher (constant listener) | Lower (single query) |
| **Offline** | Works with cache | Works with cache |

## Product Model Changes

### Before
```dart
class Product {
  final String id;
  final String name;
  final double price;
  // ... basic fields only
}
```

### After
```dart
class Product {
  final String id;
  final String name;
  final double price;
  // New fields:
  final bool isAvailable;
  final int stock;
  final String farmerId;
  final double rating;
  final int reviewCount;
  
  // New methods:
  factory Product.fromFirestore(Map<String, dynamic> data) { ... }
  Map<String, dynamic> toFirestore() { ... }
}
```

## Seeding Data

### Method 1: UI Button (Easiest)

1. Launch app with empty database
2. See "No products available" message
3. Click "Seed Sample Data" button
4. Wait for success message (2-3 seconds)
5. Products appear automatically

### Method 2: Manual Function Call

```dart
import 'package:farm2home_app/services/seed_data.dart';

// In your code
await seedFirestoreData();
```

### Method 3: Admin Screen

Create an admin screen with:
```dart
ElevatedButton(
  onPressed: () async {
    await seedFirestoreData();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data seeded!')),
    );
  },
  child: Text('Seed Database'),
)
```

## Testing Checklist

- [ ] Products load from Firestore on first launch
- [ ] Empty database shows seed button
- [ ] Seed button populates 55 products + 4 categories
- [ ] Products display in 2-column grid
- [ ] Search filters products by name and category
- [ ] Home button clears search
- [ ] Loading indicator appears during fetch
- [ ] Error state shows retry button
- [ ] Cart badge updates when adding products
- [ ] Real-time: New products appear without refresh

## Performance Tips

### 1. Use Indexes

Create composite indexes in Firestore console:

```
Collection: products
Fields: category (ASC), name (ASC)
```

### 2. Limit Results

```dart
Stream<QuerySnapshot> stream = _firestore
    .collection('products')
    .where('isAvailable', isEqualTo: true)
    .orderBy('name')
    .limit(20)  // Only fetch 20 products
    .snapshots();
```

### 3. Pagination

```dart
// First page
QuerySnapshot first = await _firestore
    .collection('products')
    .limit(20)
    .get();

// Next page
QuerySnapshot next = await _firestore
    .collection('products')
    .startAfterDocument(first.docs.last)
    .limit(20)
    .get();
```

### 4. Offline Persistence

Firestore automatically caches data:

```dart
// Enable offline persistence (enabled by default in Flutter)
await FirebaseFirestore.instance.enablePersistence();
```

## Troubleshooting

### Products not loading

1. **Check Firestore console** → Verify `products` collection exists
2. **Check internet connection** → StreamBuilder shows error state
3. **Seed data** → Click "Seed Sample Data" button
4. **Check Firebase config** → Verify `firebase_options.dart` exists

### "Permission denied" error

Update Firestore security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /products/{productId} {
      allow read: if true;  // Anyone can read products
      allow write: if request.auth != null;  // Only authenticated users can write
    }
    
    match /categories/{categoryId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

### Search not working

Search is client-side filtering:

```dart
// Applied after fetching all products
List<Product> filteredProducts = allProducts
    .where((p) =>
        p.name.toLowerCase().contains(_searchQuery) ||
        p.category.toLowerCase().contains(_searchQuery))
    .toList();
```

For better search, consider:
- Algolia (full-text search service)
- ElasticSearch
- Firestore composite queries with field preprocessing

### StreamBuilder rebuilds too often

Use `const` widgets where possible:

```dart
return const Center(
  child: CircularProgressIndicator(),  // const!
);
```

## Next Steps

1. **Add pagination** → Load 20 products at a time
2. **Category filters** → Server-side `.where('category', isEqualTo: 'vegetables')`
3. **Product detail screen** → Show reviews subcollection
4. **Favorites** → Stream user-specific favorites
5. **Price sorting** → `.orderBy('price', descending: true)`
6. **Stock tracking** → Real-time stock updates

## Resources

- [Firestore Documentation](https://firebase.google.com/docs/firestore)
- [StreamBuilder Widget](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html)
- [Cloud Firestore Queries](https://firebase.google.com/docs/firestore/query-data/queries)
- [Farm2Home README](../README.md) - Full implementation documentation

## Support

For issues or questions:
1. Check `README.md` Sprint 3 section (lines 1939-2500)
2. Review Firestore console for data structure
3. Run `flutter analyze` for code issues
4. Check Firebase console logs for errors
