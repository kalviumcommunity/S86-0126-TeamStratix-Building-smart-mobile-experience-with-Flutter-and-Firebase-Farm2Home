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
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
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
}
