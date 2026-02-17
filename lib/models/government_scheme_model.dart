import 'package:cloud_firestore/cloud_firestore.dart';

class GovernmentScheme {
  final String schemeId;
  final String schemeName;
  final String description;
  final String department;
  final String eligibility;
  final List<String> requiredDocuments;
  final String applyLink;
  final DateTime startDate;
  final DateTime? endDate;
  final double? subsidyAmount;
  final String subsidyPercentage;
  final DateTime createdAt;

  GovernmentScheme({
    required this.schemeId,
    required this.schemeName,
    required this.description,
    required this.department,
    required this.eligibility,
    required this.requiredDocuments,
    required this.applyLink,
    required this.startDate,
    this.endDate,
    this.subsidyAmount,
    required this.subsidyPercentage,
    required this.createdAt,
  });

  factory GovernmentScheme.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return GovernmentScheme(
      schemeId: doc.id,
      schemeName: data['schemeName'] ?? '',
      description: data['description'] ?? '',
      department: data['department'] ?? '',
      eligibility: data['eligibility'] ?? '',
      requiredDocuments: List<String>.from(data['requiredDocuments'] ?? []),
      applyLink: data['applyLink'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: data['endDate'] != null 
          ? (data['endDate'] as Timestamp).toDate() 
          : null,
      subsidyAmount: data['subsidyAmount']?.toDouble(),
      subsidyPercentage: data['subsidyPercentage'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'schemeName': schemeName,
      'description': description,
      'department': department,
      'eligibility': eligibility,
      'requiredDocuments': requiredDocuments,
      'applyLink': applyLink,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'subsidyAmount': subsidyAmount,
      'subsidyPercentage': subsidyPercentage,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
