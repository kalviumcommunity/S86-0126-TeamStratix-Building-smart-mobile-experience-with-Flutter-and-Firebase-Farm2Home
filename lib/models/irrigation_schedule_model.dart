import 'package:cloud_firestore/cloud_firestore.dart';

class IrrigationSchedule {
  final String scheduleId;
  final String farmerId;
  final String cropName;
  final double fieldArea; // acres
  final String soilType;
  final String irrigationType; // 'drip', 'sprinkler', 'flood'
  final DateTime lastWatered;
  final DateTime nextWaterReminder;
  final double waterRequired; // in liters
  final String frequency; // 'daily', 'alternate', 'weekly'
  final String? notes;
  final DateTime createdAt;

  IrrigationSchedule({
    required this.scheduleId,
    required this.farmerId,
    required this.cropName,
    required this.fieldArea,
    required this.soilType,
    required this.irrigationType,
    required this.lastWatered,
    required this.nextWaterReminder,
    required this.waterRequired,
    required this.frequency,
    this.notes,
    required this.createdAt,
  });

  factory IrrigationSchedule.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return IrrigationSchedule(
      scheduleId: doc.id,
      farmerId: data['farmerId'] ?? '',
      cropName: data['cropName'] ?? '',
      fieldArea: (data['fieldArea'] ?? 0).toDouble(),
      soilType: data['soilType'] ?? '',
      irrigationType: data['irrigationType'] ?? '',
      lastWatered: (data['lastWatered'] as Timestamp).toDate(),
      nextWaterReminder: (data['nextWaterReminder'] as Timestamp).toDate(),
      waterRequired: (data['waterRequired'] ?? 0).toDouble(),
      frequency: data['frequency'] ?? 'daily',
      notes: data['notes'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'farmerId': farmerId,
      'cropName': cropName,
      'fieldArea': fieldArea,
      'soilType': soilType,
      'irrigationType': irrigationType,
      'lastWatered': Timestamp.fromDate(lastWatered),
      'nextWaterReminder': Timestamp.fromDate(nextWaterReminder),
      'waterRequired': waterRequired,
      'frequency': frequency,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
