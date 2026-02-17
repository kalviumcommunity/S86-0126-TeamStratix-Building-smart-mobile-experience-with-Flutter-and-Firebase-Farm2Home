import 'package:cloud_firestore/cloud_firestore.dart';

class SoilTestingSlot {
  final String slotId;
  final String farmerId;
  final String farmerName;
  final String farmerPhone;
  final String? farmerEmail;
  final String farmLocation;
  final String? village;
  final double? landArea; // in acres
  final String? soilType; // Red Soil, Black Soil, Sandy, Clay
  final String testType; // Basic, Advanced, Fertility, pH Level
  final DateTime scheduledDate;
  final String timeSlot; // Morning, Afternoon, Evening
  final String status; // 'pending', 'sample_collected', 'testing', 'completed', 'report_ready'
  final String? cropHistory;
  final String? specificRequirements;
  final String? soilImageUrl;
  final String? technicianId;
  final String? technicianName;
  final String? reportUrl;
  final Map<String, dynamic>? testResults;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? notes;

  SoilTestingSlot({
    required this.slotId,
    required this.farmerId,
    required this.farmerName,
    required this.farmerPhone,
    this.farmerEmail,
    required this.farmLocation,
    this.village,
    this.landArea,
    this.soilType,
    required this.testType,
    required this.scheduledDate,
    required this.timeSlot,
    required this.status,
    this.cropHistory,
    this.specificRequirements,
    this.soilImageUrl,
    this.technicianId,
    this.technicianName,
    this.reportUrl,
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
      farmerEmail: data['farmerEmail'],
      farmLocation: data['farmLocation'] ?? '',
      village: data['village'],
      landArea: data['landArea']?.toDouble(),
      soilType: data['soilType'],
      testType: data['testType'] ?? 'Basic',
      scheduledDate: (data['scheduledDate'] as Timestamp).toDate(),
      timeSlot: data['timeSlot'] ?? '',
      status: data['status'] ?? 'pending',
      cropHistory: data['cropHistory'],
      specificRequirements: data['specificRequirements'],
      soilImageUrl: data['soilImageUrl'],
      technicianId: data['technicianId'],
      technicianName: data['technicianName'],
      reportUrl: data['reportUrl'],
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
      'farmerEmail': farmerEmail,
      'farmLocation': farmLocation,
      'village': village,
      'landArea': landArea,
      'soilType': soilType,
      'testType': testType,
      'scheduledDate': Timestamp.fromDate(scheduledDate),
      'timeSlot': timeSlot,
      'status': status,
      'cropHistory': cropHistory,
      'specificRequirements': specificRequirements,
      'soilImageUrl': soilImageUrl,
      'technicianId': technicianId,
      'technicianName': technicianName,
      'reportUrl': reportUrl,
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
    String? farmerEmail,
    String? farmLocation,
    String? village,
    double? landArea,
    String? soilType,
    String? testType,
    DateTime? scheduledDate,
    String? timeSlot,
    String? status,
    String? cropHistory,
    String? specificRequirements,
    String? soilImageUrl,
    String? technicianId,
    String? technicianName,
    String? reportUrl,
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
      farmerEmail: farmerEmail ?? this.farmerEmail,
      farmLocation: farmLocation ?? this.farmLocation,
      village: village ?? this.village,
      landArea: landArea ?? this.landArea,
      soilType: soilType ?? this.soilType,
      testType: testType ?? this.testType,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
      cropHistory: cropHistory ?? this.cropHistory,
      specificRequirements: specificRequirements ?? this.specificRequirements,
      soilImageUrl: soilImageUrl ?? this.soilImageUrl,
      technicianId: technicianId ?? this.technicianId,
      technicianName: technicianName ?? this.technicianName,
      reportUrl: reportUrl ?? this.reportUrl,
      testResults: testResults ?? this.testResults,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
    );
  }
}