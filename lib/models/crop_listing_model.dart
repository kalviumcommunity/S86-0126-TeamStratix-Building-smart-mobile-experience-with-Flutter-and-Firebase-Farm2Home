import 'package:cloud_firestore/cloud_firestore.dart';

class CropListing {
  final String listingId;
  final String farmerId;
  final String farmerName;
  final String cropName;
  final String description;
  final double pricePerUnit;
  final double quantity;
  final String unit; // 'kg', 'ton', 'bags'
  final String qualityGrade; // 'A', 'B', 'C'
  final String? imageUrl;
  final String status; // 'available', 'sold', 'expired'
  final DateTime harvestDate;
  final DateTime createdAt;
  final String? buyerName;
  final String? buyerPhone;

  CropListing({
    required this.listingId,
    required this.farmerId,
    required this.farmerName,
    required this.cropName,
    required this.description,
    required this.pricePerUnit,
    required this.quantity,
    required this.unit,
    required this.qualityGrade,
    this.imageUrl,
    required this.status,
    required this.harvestDate,
    required this.createdAt,
    this.buyerName,
    this.buyerPhone,
  });

  factory CropListing.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CropListing(
      listingId: doc.id,
      farmerId: data['farmerId'] ?? '',
      farmerName: data['farmerName'] ?? '',
      cropName: data['cropName'] ?? '',
      description: data['description'] ?? '',
      pricePerUnit: (data['pricePerUnit'] ?? 0).toDouble(),
      quantity: (data['quantity'] ?? 0).toDouble(),
      unit: data['unit'] ?? 'kg',
      qualityGrade: data['qualityGrade'] ?? 'A',
      imageUrl: data['imageUrl'],
      status: data['status'] ?? 'available',
      harvestDate: (data['harvestDate'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      buyerName: data['buyerName'],
      buyerPhone: data['buyerPhone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'farmerId': farmerId,
      'farmerName': farmerName,
      'cropName': cropName,
      'description': description,
      'pricePerUnit': pricePerUnit,
      'quantity': quantity,
      'unit': unit,
      'qualityGrade': qualityGrade,
      'imageUrl': imageUrl,
      'status': status,
      'harvestDate': Timestamp.fromDate(harvestDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'buyerName': buyerName,
      'buyerPhone': buyerPhone,
    };
  }
}
