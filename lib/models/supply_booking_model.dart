import 'package:cloud_firestore/cloud_firestore.dart';

class SupplyBookingModel {
  final String bookingId;
  final String farmerId;
  final String farmerName;
  final String supplyType; // 'pesticide', 'fertilizer', 'hybrid_seed'
  final String productName;
  final String description;
  final double quantity;
  final String unit;
  final double estimatedPrice;
  final String urgency; // 'low', 'medium', 'high'
  final String status; // 'pending', 'approved', 'fulfilled', 'cancelled'
  final String? notes;
  final DateTime requestedDate;
  final DateTime? requiredByDate;
  final DateTime? fulfilledDate;
  final DateTime createdAt;

  SupplyBookingModel({
    required this.bookingId,
    required this.farmerId,
    required this.farmerName,
    required this.supplyType,
    required this.productName,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.estimatedPrice,
    required this.urgency,
    required this.status,
    this.notes,
    required this.requestedDate,
    this.requiredByDate,
    this.fulfilledDate,
    required this.createdAt,
  });

  // From Firestore
  factory SupplyBookingModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SupplyBookingModel(
      bookingId: doc.id,
      farmerId: data['farmerId'] ?? '',
      farmerName: data['farmerName'] ?? 'Unknown',
      supplyType: data['supplyType'] ?? 'pesticide',
      productName: data['productName'] ?? '',
      description: data['description'] ?? '',
      quantity: (data['quantity'] ?? 0).toDouble(),
      unit: data['unit'] ?? 'kg',
      estimatedPrice: (data['estimatedPrice'] ?? 0).toDouble(),
      urgency: data['urgency'] ?? 'medium',
      status: data['status'] ?? 'pending',
      notes: data['notes'],
      requestedDate: (data['requestedDate'] as Timestamp).toDate(),
      requiredByDate: data['requiredByDate'] != null
          ? (data['requiredByDate'] as Timestamp).toDate()
          : null,
      fulfilledDate: data['fulfilledDate'] != null
          ? (data['fulfilledDate'] as Timestamp).toDate()
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // To Firestore
  Map<String, dynamic> toMap() {
    return {
      'farmerId': farmerId,
      'farmerName': farmerName,
      'supplyType': supplyType,
      'productName': productName,
      'description': description,
      'quantity': quantity,
      'unit': unit,
      'estimatedPrice': estimatedPrice,
      'urgency': urgency,
      'status': status,
      'notes': notes,
      'requestedDate': Timestamp.fromDate(requestedDate),
      'requiredByDate': requiredByDate != null
          ? Timestamp.fromDate(requiredByDate!)
          : null,
      'fulfilledDate': fulfilledDate != null
          ? Timestamp.fromDate(fulfilledDate!)
          : null,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Copy with
  SupplyBookingModel copyWith({
    String? bookingId,
    String? farmerId,
    String? farmerName,
    String? supplyType,
    String? productName,
    String? description,
    double? quantity,
    String? unit,
    double? estimatedPrice,
    String? urgency,
    String? status,
    String? notes,
    DateTime? requestedDate,
    DateTime? requiredByDate,
    DateTime? fulfilledDate,
    DateTime? createdAt,
  }) {
    return SupplyBookingModel(
      bookingId: bookingId ?? this.bookingId,
      farmerId: farmerId ?? this.farmerId,
      farmerName: farmerName ?? this.farmerName,
      supplyType: supplyType ?? this.supplyType,
      productName: productName ?? this.productName,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      urgency: urgency ?? this.urgency,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      requestedDate: requestedDate ?? this.requestedDate,
      requiredByDate: requiredByDate ?? this.requiredByDate,
      fulfilledDate: fulfilledDate ?? this.fulfilledDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}