import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note_item.dart';

/// CRUD Service for managing user items/notes
/// Demonstrates Create, Read, Update, Delete operations with Firestore
class CrudService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;

  /// Get reference to user's items collection
  CollectionReference _getUserItemsCollection() {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }
    return _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('items');
  }

  // ==================== CREATE ====================

  /// Create a new item
  Future<String> createItem({
    required String title,
    required String description,
  }) async {
    try {
      if (_currentUserId == null) {
        throw Exception('User must be logged in to create items');
      }

      final item = NoteItem(
        title: title,
        description: description,
        createdAt: DateTime.now(),
        userId: _currentUserId!,
      );

      final docRef = await _getUserItemsCollection().add(item.toMap());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw _handleFirestoreError(e);
    } catch (e) {
      throw 'Failed to create item: $e';
    }
  }

  // ==================== READ ====================

  /// Get stream of all user items (real-time)
  Stream<List<NoteItem>> getUserItemsStream() {
    if (_currentUserId == null) {
      return Stream.value([]);
    }

    return _getUserItemsCollection()
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => NoteItem.fromFirestore(doc))
          .toList();
    });
  }

  /// Get a single item by ID
  Future<NoteItem?> getItemById(String itemId) async {
    try {
      final doc = await _getUserItemsCollection().doc(itemId).get();
      if (!doc.exists) return null;
      return NoteItem.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw _handleFirestoreError(e);
    } catch (e) {
      throw 'Failed to get item: $e';
    }
  }

  /// Get all user items (one-time fetch)
  Future<List<NoteItem>> getUserItems() async {
    try {
      final snapshot = await _getUserItemsCollection()
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => NoteItem.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw _handleFirestoreError(e);
    } catch (e) {
      throw 'Failed to get items: $e';
    }
  }

  // ==================== UPDATE ====================

  /// Update an existing item
  Future<void> updateItem({
    required String itemId,
    required String title,
    required String description,
  }) async {
    try {
      await _getUserItemsCollection().doc(itemId).update({
        'title': title,
        'description': description,
        'updatedAt': Timestamp.now(),
      });
    } on FirebaseException catch (e) {
      throw _handleFirestoreError(e);
    } catch (e) {
      throw 'Failed to update item: $e';
    }
  }

  /// Update only the title
  Future<void> updateTitle(String itemId, String title) async {
    try {
      await _getUserItemsCollection().doc(itemId).update({
        'title': title,
        'updatedAt': Timestamp.now(),
      });
    } on FirebaseException catch (e) {
      throw _handleFirestoreError(e);
    } catch (e) {
      throw 'Failed to update title: $e';
    }
  }

  /// Update only the description
  Future<void> updateDescription(String itemId, String description) async {
    try {
      await _getUserItemsCollection().doc(itemId).update({
        'description': description,
        'updatedAt': Timestamp.now(),
      });
    } on FirebaseException catch (e) {
      throw _handleFirestoreError(e);
    } catch (e) {
      throw 'Failed to update description: $e';
    }
  }

  // ==================== DELETE ====================

  /// Delete an item
  Future<void> deleteItem(String itemId) async {
    try {
      await _getUserItemsCollection().doc(itemId).delete();
    } on FirebaseException catch (e) {
      throw _handleFirestoreError(e);
    } catch (e) {
      throw 'Failed to delete item: $e';
    }
  }

  /// Delete all user items (use with caution)
  Future<void> deleteAllItems() async {
    try {
      final snapshot = await _getUserItemsCollection().get();
      final batch = _firestore.batch();
      
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
    } on FirebaseException catch (e) {
      throw _handleFirestoreError(e);
    } catch (e) {
      throw 'Failed to delete all items: $e';
    }
  }

  // ==================== HELPER METHODS ====================

  /// Handle Firestore errors
  String _handleFirestoreError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'You do not have permission to perform this action';
      case 'not-found':
        return 'Item not found';
      case 'already-exists':
        return 'Item already exists';
      case 'unavailable':
        return 'Service temporarily unavailable. Please try again';
      default:
        return 'An error occurred: ${e.message}';
    }
  }

  /// Get count of user items
  Future<int> getItemCount() async {
    try {
      final snapshot = await _getUserItemsCollection().get();
      return snapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  /// Check if user has any items
  Future<bool> hasItems() async {
    try {
      final count = await getItemCount();
      return count > 0;
    } catch (e) {
      return false;
    }
  }
}
