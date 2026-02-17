import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityPost {
  final String postId;
  final String farmerIdId;
  final String farmerName;
  final String? farmerImageUrl;
  final String title;
  final String content;
  final String category; // 'discussion', 'advice', 'tips', 'question'
  final List<String> tags;
  final int likes;
  final int commentCount;
  final DateTime createdAt;
  final DateTime? editedAt;

  CommunityPost({
    required this.postId,
    required this.farmerIdId,
    required this.farmerName,
    this.farmerImageUrl,
    required this.title,
    required this.content,
    required this.category,
    required this.tags,
    required this.likes,
    required this.commentCount,
    required this.createdAt,
    this.editedAt,
  });

  factory CommunityPost.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CommunityPost(
      postId: doc.id,
      farmerIdId: data['farmerId'] ?? '',
      farmerName: data['farmerName'] ?? '',
      farmerImageUrl: data['farmerImageUrl'],
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      category: data['category'] ?? 'discussion',
      tags: List<String>.from(data['tags'] ?? []),
      likes: data['likes'] ?? 0,
      commentCount: data['commentCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      editedAt: data['editedAt'] != null 
          ? (data['editedAt'] as Timestamp).toDate() 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'farmerId': farmerIdId,
      'farmerName': farmerName,
      'farmerImageUrl': farmerImageUrl,
      'title': title,
      'content': content,
      'category': category,
      'tags': tags,
      'likes': likes,
      'commentCount': commentCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'editedAt': editedAt != null ? Timestamp.fromDate(editedAt!) : null,
    };
  }
}

class CommunityComment {
  final String commentId;
  final String postId;
  final String farmerIdId;
  final String farmerName;
  final String? farmerImageUrl;
  final String content;
  final int likes;
  final DateTime createdAt;

  CommunityComment({
    required this.commentId,
    required this.postId,
    required this.farmerIdId,
    required this.farmerName,
    this.farmerImageUrl,
    required this.content,
    required this.likes,
    required this.createdAt,
  });

  factory CommunityComment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CommunityComment(
      commentId: doc.id,
      postId: data['postId'] ?? '',
      farmerIdId: data['farmerId'] ?? '',
      farmerName: data['farmerName'] ?? '',
      farmerImageUrl: data['farmerImageUrl'],
      content: data['content'] ?? '',
      likes: data['likes'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'farmerId': farmerIdId,
      'farmerName': farmerName,
      'farmerImageUrl': farmerImageUrl,
      'content': content,
      'likes': likes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
