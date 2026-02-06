import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore Service
/// Handles all Firestore database operations
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ========== USER DATA OPERATIONS ==========

  /// Add user data to Firestore
  Future<void> addUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to add user data: $e';
    }
  }

  /// Get user data
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      throw 'Failed to get user data: $e';
    }
  }

  /// Update user data
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to update user data: $e';
    }
  }

  /// Delete user data
  Future<void> deleteUserData(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
    } catch (e) {
      throw 'Failed to delete user data: $e';
    }
  }

  /// Stream user data (real-time updates)
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUserData(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  // ========== ORDER OPERATIONS ==========

  /// Add order to Firestore
  Future<String> addOrder(String uid, Map<String, dynamic> orderData) async {
    try {
      final docRef = await _firestore.collection('orders').add({
        'userId': uid,
        ...orderData,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      });
      return docRef.id;
    } catch (e) {
      throw 'Failed to create order: $e';
    }
  }

  /// Get user orders
  Future<List<Map<String, dynamic>>> getUserOrders(String uid) async {
    try {
      final querySnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      throw 'Failed to get orders: $e';
    }
  }

  /// Stream user orders (real-time)
  Stream<QuerySnapshot<Map<String, dynamic>>> streamUserOrders(String uid) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to update order: $e';
    }
  }

  /// Delete order
  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();
    } catch (e) {
      throw 'Failed to delete order: $e';
    }
  }

  // ========== FAVORITES OPERATIONS ==========

  /// Add product to favorites
  Future<void> addToFavorites(String uid, String productId) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'favorites': FieldValue.arrayUnion([productId]),
      });
    } catch (e) {
      throw 'Failed to add to favorites: $e';
    }
  }

  /// Remove product from favorites
  Future<void> removeFromFavorites(String uid, String productId) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'favorites': FieldValue.arrayRemove([productId]),
      });
    } catch (e) {
      throw 'Failed to remove from favorites: $e';
    }
  }

  /// Get user favorites
  Future<List<String>> getUserFavorites(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null && data.containsKey('favorites')) {
        return List<String>.from(data['favorites']);
      }
      return [];
    } catch (e) {
      throw 'Failed to get favorites: $e';
    }
  }

  // ========== PRODUCT READ OPERATIONS ==========

  /// Get all products (one-time read)
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      final querySnapshot = await _firestore.collection('products').get();
      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      throw 'Failed to get products: $e';
    }
  }

  /// Stream all products (real-time updates)
  Stream<QuerySnapshot<Map<String, dynamic>>> streamAllProducts() {
    return _firestore.collection('products').snapshots();
  }

  /// Get single product by ID
  Future<Map<String, dynamic>?> getProductById(String productId) async {
    try {
      final doc = await _firestore.collection('products').doc(productId).get();
      if (doc.exists) {
        return {'id': doc.id, ...doc.data()!};
      }
      return null;
    } catch (e) {
      throw 'Failed to get product: $e';
    }
  }

  /// Stream single product by ID (real-time)
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamProductById(
    String productId,
  ) {
    return _firestore.collection('products').doc(productId).snapshots();
  }

  /// Get products by category (with query)
  Future<List<Map<String, dynamic>>> getProductsByCategory(
    String category,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .get();
      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      throw 'Failed to get products by category: $e';
    }
  }

  /// Stream products by category (real-time)
  Stream<QuerySnapshot<Map<String, dynamic>>> streamProductsByCategory(
    String category,
  ) {
    return _firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .snapshots();
  }

  /// Get available products only
  Stream<QuerySnapshot<Map<String, dynamic>>> streamAvailableProducts() {
    return _firestore
        .collection('products')
        .where('isAvailable', isEqualTo: true)
        .orderBy('name')
        .snapshots();
  }

  /// Search products by name (contains query)
  Future<List<Map<String, dynamic>>> searchProducts(String searchTerm) async {
    try {
      // Firestore doesn't support full-text search, so we get all and filter
      final querySnapshot = await _firestore.collection('products').get();
      final searchLower = searchTerm.toLowerCase();

      return querySnapshot.docs
          .where((doc) {
            final data = doc.data();
            final name = (data['name'] ?? '').toString().toLowerCase();
            final category = (data['category'] ?? '').toString().toLowerCase();
            return name.contains(searchLower) || category.contains(searchLower);
          })
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      throw 'Failed to search products: $e';
    }
  }

  // ========== CATEGORY READ OPERATIONS ==========

  /// Get all categories
  Future<List<Map<String, dynamic>>> getAllCategories() async {
    try {
      final querySnapshot = await _firestore
          .collection('categories')
          .orderBy('sortOrder')
          .get();
      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      throw 'Failed to get categories: $e';
    }
  }

  /// Stream all categories (real-time)
  Stream<QuerySnapshot<Map<String, dynamic>>> streamAllCategories() {
    return _firestore.collection('categories').orderBy('sortOrder').snapshots();
  }

  /// Get active categories only
  Stream<QuerySnapshot<Map<String, dynamic>>> streamActiveCategories() {
    return _firestore
        .collection('categories')
        .where('isActive', isEqualTo: true)
        .orderBy('sortOrder')
        .snapshots();
  }

  // ========== PRODUCT REVIEWS READ OPERATIONS ==========

  /// Get reviews for a product
  Future<List<Map<String, dynamic>>> getProductReviews(String productId) async {
    try {
      final querySnapshot = await _firestore
          .collection('products')
          .doc(productId)
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      throw 'Failed to get reviews: $e';
    }
  }

  /// Stream product reviews (real-time)
  Stream<QuerySnapshot<Map<String, dynamic>>> streamProductReviews(
    String productId,
  ) {
    return _firestore
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ========== SEED DATA HELPER ==========

  /// Add sample products to Firestore (for testing)
  Future<void> seedProducts(List<Map<String, dynamic>> products) async {
    try {
      final batch = _firestore.batch();

      for (var product in products) {
        final docRef = _firestore.collection('products').doc(product['id']);
        batch.set(docRef, {
          ...product,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
    } catch (e) {
      throw 'Failed to seed products: $e';
    }
  }

  /// Add sample categories to Firestore
  Future<void> seedCategories(List<Map<String, dynamic>> categories) async {
    try {
      final batch = _firestore.batch();

      for (var category in categories) {
        final docRef = _firestore.collection('categories').doc(category['id']);
        batch.set(docRef, {
          ...category,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
    } catch (e) {
      throw 'Failed to seed categories: $e';
    }
  }
}
