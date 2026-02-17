import 'package:cloud_firestore/cloud_firestore.dart';

class Equipment {
  final String equipmentId;
  final String name;
  final String type; // 'tractor', 'sprayer', 'harvester', 'pump', 'thresher'
  final String description;
  final double hourlyRate;
  final double dailyRate;
  final String owner;
  final String location;
  final String? imageUrl;
  final bool available;
  final DateTime createdAt;

  Equipment({
    required this.equipmentId,
    required this.name,
    required this.type,
    required this.description,
    required this.hourlyRate,
    required this.dailyRate,
    required this.owner,
    required this.location,
    this.imageUrl,
    required this.available,
    required this.createdAt,
  });

  factory Equipment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Equipment(
      equipmentId: doc.id,
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      description: data['description'] ?? '',
      hourlyRate: (data['hourlyRate'] ?? 0).toDouble(),
      dailyRate: (data['dailyRate'] ?? 0).toDouble(),
      owner: data['owner'] ?? '',
      location: data['location'] ?? '',
      imageUrl: data['imageUrl'],
      available: data['available'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'description': description,
      'hourlyRate': hourlyRate,
      'dailyRate': dailyRate,
      'owner': owner,
      'location': location,
      'imageUrl': imageUrl,
      'available': available,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class EquipmentRental {
  final String rentalId;
  final String farmerId;
  final String equipmentId;
  final String equipmentName;
  final DateTime startDate;
  final DateTime endDate;
  final String rentalType; // 'hourly', 'daily'
  final double totalCost;
  final String location;
  final String status; // 'pending', 'active', 'completed'
  final DateTime createdAt;

  EquipmentRental({
    required this.rentalId,
    required this.farmerId,
    required this.equipmentId,
    required this.equipmentName,
    required this.startDate,
    required this.endDate,
    required this.rentalType,
    required this.totalCost,
    required this.location,
    required this.status,
    required this.createdAt,
  });

  factory EquipmentRental.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return EquipmentRental(
      rentalId: doc.id,
      farmerId: data['farmerId'] ?? '',
      equipmentId: data['equipmentId'] ?? '',
      equipmentName: data['equipmentName'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      rentalType: data['rentalType'] ?? 'daily',
      totalCost: (data['totalCost'] ?? 0).toDouble(),
      location: data['location'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'farmerId': farmerId,
      'equipmentId': equipmentId,
      'equipmentName': equipmentName,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'rentalType': rentalType,
      'totalCost': totalCost,
      'location': location,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
