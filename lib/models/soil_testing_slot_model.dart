import 'package:cloud_firestore/cloud_firestore.dart';

class SoilTestingSlot {
  final String slotId;
  final String farmerId;
  final String farmerName;
  final String farmerPhone;
  final String farmLocation;
  final DateTime scheduledDate;
  final String timeSlot; // e.g., "09:00 AM - 11:00 AM"
  final String status; // 'pending', 'confirmed', 'completed', 'cancelled'
  final String? soilType;
  final String? cropHistory;
  final String? specificRequirements;
  final Map<String, dynamic>? testResults;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? notes;

  SoilTestingSlot({
    required this.slotId,
    required this.farmerId,
    required this.farmerName,
    required this.farmerPhone,
    required this.farmLocation,
    required this.scheduledDate,
    required this.timeSlot,
    required this.status,
    this.soilType,
    this.cropHistory,
    this.specificRequirements,
    this.testResults,
    required this.createdAt,
    this.completedAt,
    this.notes,
  });

  // From Firestore
  factory SoilTestingSlot.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SoilTestingSlot(
      slotId: doc.id,
      farmerId: data['farmerId'] ?? '',
      farmerName: data['farmerName'] ?? '',
      farmerPhone: data['farmerPhone'] ?? '',
      farmLocation: data['farmLocation'] ?? '',
      scheduledDate: (data['scheduledDate'] as Timestamp).toDate(),
      timeSlot: data['timeSlot'] ?? '',
      status: data['status'] ?? 'pending',
      soilType: data['soilType'],
      cropHistory: data['cropHistory'],
      specificRequirements: data['specificRequirements'],
      testResults: data['testResults'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      completedAt: data['completedAt'] != null 
          ? (data['completedAt'] as Timestamp).toDate() 
          : null,
      notes: data['notes'],
    );
  }

  // To Firestore
  Map<String, dynamic> toMap() {
    return {
      'farmerId': farmerId,
      'farmerName': farmerName,
      'farmerPhone': farmerPhone,
      'farmLocation': farmLocation,
      'scheduledDate': Timestamp.fromDate(scheduledDate),
      'timeSlot': timeSlot,
      'status': status,
      'soilType': soilType,
      'cropHistory': cropHistory,
      'specificRequirements': specificRequirements,
      'testResults': testResults,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedAt': completedAt != null 
          ? Timestamp.fromDate(completedAt!) 
          : null,
      'notes': notes,
    };
  }

  // Copy with
  SoilTestingSlot copyWith({
    String? slotId,
    String? farmerId,
    String? farmerName,
    String? farmerPhone,
    String? farmLocation,
    DateTime? scheduledDate,
    String? timeSlot,
    String? status,
    String? soilType,
    String? cropHistory,
    String? specificRequirements,
    Map<String, dynamic>? testResults,
    DateTime? createdAt,
    DateTime? completedAt,
    String? notes,
  }) {
    return SoilTestingSlot(
      slotId: slotId ?? this.slotId,
      farmerId: farmerId ?? this.farmerId,
      farmerName: farmerName ?? this.farmerName,
      farmerPhone: farmerPhone ?? this.farmerPhone,
      farmLocation: farmLocation ?? this.farmLocation,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
      soilType: soilType ?? this.soilType,
      cropHistory: cropHistory ?? this.cropHistory,
      specificRequirements: specificRequirements ?? this.specificRequirements,
      testResults: testResults ?? this.testResults,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
    );
  }
}