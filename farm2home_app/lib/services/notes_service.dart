import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

/// Notes Service
/// Handles all CRUD operations for user notes in Firestore
/// Each note is stored under: /users/{uid}/items/{itemId}
class NotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create a new note for the authenticated user
  /// Returns the ID of the created note
  Future<String> createNote({
    required String uid,
    required String title,
    required String content,
  }) async {
    try {
      if (uid.isEmpty) {
        throw 'User not authenticated';
      }

      final now = DateTime.now();
      final note = Note(
        id: '', // Will be set by Firestore
        title: title.trim(),
        content: content.trim(),
        createdAt: now,
        updatedAt: now,
        uid: uid,
      );

      // Add the note to the user's items collection
      // Path: /users/{uid}/items/{itemId}
      final docRef = await _firestore
          .collection('users')
          .doc(uid)
          .collection('items')
          .add(note.toJson());

      return docRef.id;
    } catch (e) {
      throw 'Failed to create note: $e';
    }
  }

  /// Get all notes for the authenticated user as a Stream
  /// Used for real-time updates with StreamBuilder
  Stream<List<Note>> getUserNotesStream(String uid) {
    try {
      if (uid.isEmpty) {
        return Stream.value([]);
      }

      return _firestore
          .collection('users')
          .doc(uid)
          .collection('items')
          .orderBy('updatedAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => Note.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      throw 'Failed to get notes: $e';
    }
  }

  /// Get a single note by ID
  Future<Note?> getNote(String uid, String noteId) async {
    try {
      if (uid.isEmpty || noteId.isEmpty) {
        return null;
      }

      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('items')
          .doc(noteId)
          .get();

      if (!doc.exists) {
        return null;
      }

      return Note.fromFirestore(doc);
    } catch (e) {
      throw 'Failed to get note: $e';
    }
  }

  /// Get all notes for the authenticated user (one-time fetch)
  Future<List<Note>> getUserNotes(String uid) async {
    try {
      if (uid.isEmpty) {
        return [];
      }

      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('items')
          .orderBy('updatedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Note.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw 'Failed to get notes: $e';
    }
  }

  /// Update an existing note
  Future<void> updateNote({
    required String uid,
    required String noteId,
    required String title,
    required String content,
  }) async {
    try {
      if (uid.isEmpty || noteId.isEmpty) {
        throw 'Invalid user ID or note ID';
      }

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('items')
          .doc(noteId)
          .update({
        'title': title.trim(),
        'content': content.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to update note: $e';
    }
  }

  /// Delete a note
  Future<void> deleteNote(String uid, String noteId) async {
    try {
      if (uid.isEmpty || noteId.isEmpty) {
        throw 'Invalid user ID or note ID';
      }

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('items')
          .doc(noteId)
          .delete();
    } catch (e) {
      throw 'Failed to delete note: $e';
    }
  }

  /// Delete all notes for a user (cleanup)
  Future<void> deleteAllNotes(String uid) async {
    try {
      if (uid.isEmpty) {
        throw 'User not authenticated';
      }

      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('items')
          .get();

      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw 'Failed to delete all notes: $e';
    }
  }

  /// Get note count for a user
  Future<int> getNoteCount(String uid) async {
    try {
      if (uid.isEmpty) {
        return 0;
      }

      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('items')
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      throw 'Failed to get note count: $e';
    }
  }
}
