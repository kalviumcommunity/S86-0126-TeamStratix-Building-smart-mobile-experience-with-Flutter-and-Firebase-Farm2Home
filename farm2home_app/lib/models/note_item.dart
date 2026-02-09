import 'package:cloud_firestore/cloud_firestore.dart';

/// Note Item Model
/// Represents a user's note or item in the app
class NoteItem {
  final String? id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String userId;

  NoteItem({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.updatedAt,
    required this.userId,
  });

  /// Create NoteItem from Firestore document
  factory NoteItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoteItem(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      userId: data['userId'] ?? '',
    );
  }

  /// Convert NoteItem to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'userId': userId,
    };
  }

  /// Create a copy with updated fields
  NoteItem copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
  }) {
    return NoteItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }
}
