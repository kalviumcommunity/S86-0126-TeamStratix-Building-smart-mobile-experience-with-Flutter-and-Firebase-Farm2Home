import 'package:cloud_firestore/cloud_firestore.dart';

class StatusUpdateModel {
  final String updateId;
  final String orderId;
  final String status;
  final DateTime updatedAt;
  final String? notes;

  StatusUpdateModel({
    required this.updateId,
    required this.orderId,
    required this.status,
    required this.updatedAt,
    this.notes,
  });

  // Convert StatusUpdateModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'updateId': updateId,
      'orderId': orderId,
      'status': status,
      'updatedAt': Timestamp.fromDate(updatedAt),
      'notes': notes,
    };
  }

  // Create StatusUpdateModel from Firestore Document
  factory StatusUpdateModel.fromMap(Map<String, dynamic> map) {
    return StatusUpdateModel(
      updateId: map['updateId'] ?? '',
      orderId: map['orderId'] ?? '',
      status: map['status'] ?? '',
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      notes: map['notes'],
    );
  }

  // Create StatusUpdateModel from Firestore DocumentSnapshot
  factory StatusUpdateModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return StatusUpdateModel.fromMap(data);
  }
}
