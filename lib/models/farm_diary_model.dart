import 'package:cloud_firestore/cloud_firestore.dart';

class FarmDiaryEntry {
  final String entryId;
  final String farmerId;
  final String activityType; // 'activity', 'expense', 'income', 'fertilizer', 'harvest'
  final String description;
  final double? amount;
  final String? details;
  final String? cropName;
  final DateTime date;
  final DateTime createdAt;

  FarmDiaryEntry({
    required this.entryId,
    required this.farmerId,
    required this.activityType,
    required this.description,
    this.amount,
    this.details,
    this.cropName,
    required this.date,
    required this.createdAt,
  });

  factory FarmDiaryEntry.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FarmDiaryEntry(
      entryId: doc.id,
      farmerId: data['farmerId'] ?? '',
      activityType: data['activityType'] ?? '',
      description: data['description'] ?? '',
      amount: data['amount']?.toDouble(),
      details: data['details'],
      cropName: data['cropName'],
      date: (data['date'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'farmerId': farmerId,
      'activityType': activityType,
      'description': description,
      'amount': amount,
      'details': details,
      'cropName': cropName,
      'date': Timestamp.fromDate(date),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
