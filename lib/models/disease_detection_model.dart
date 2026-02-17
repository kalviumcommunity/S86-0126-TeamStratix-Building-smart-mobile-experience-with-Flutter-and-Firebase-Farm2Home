import 'package:cloud_firestore/cloud_firestore.dart';

class DiseaseDetection {
  final String detectionId;
  final String farmerId;
  final String cropName;
  final String? photoUrl;
  final String detectedDisease;
  final double confidenceScore; // 0.0 to 1.0
  final String suggestedMedicine;
  final List<String> preventionTips;
  final String status; // 'pending', 'analyzed', 'treated', 'monitoring', 'severe'
  final DateTime createdAt;
  final DateTime? analyzedAt;

  DiseaseDetection({
    required this.detectionId,
    required this.farmerId,
    required this.cropName,
    this.photoUrl,
    required this.detectedDisease,
    required this.confidenceScore,
    required this.suggestedMedicine,
    required this.preventionTips,
    required this.status,
    required this.createdAt,
    this.analyzedAt,
  });

  factory DiseaseDetection.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return DiseaseDetection(
      detectionId: doc.id,
      farmerId: data['farmerId'] ?? '',
      cropName: data['cropName'] ?? '',
      photoUrl: data['photoUrl'],
      detectedDisease: data['detectedDisease'] ?? 'Unknown Disease',
      confidenceScore: (data['confidenceScore'] ?? 0.0).toDouble(),
      suggestedMedicine: data['suggestedMedicine'] ?? '',
      preventionTips: List<String>.from(data['preventionTips'] ?? []),
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      analyzedAt: data['analyzedAt'] != null 
          ? (data['analyzedAt'] as Timestamp).toDate() 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'farmerId': farmerId,
      'cropName': cropName,
      'photoUrl': photoUrl,
      'detectedDisease': detectedDisease,
      'confidenceScore': confidenceScore,
      'suggestedMedicine': suggestedMedicine,
      'preventionTips': preventionTips,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'analyzedAt': analyzedAt != null ? Timestamp.fromDate(analyzedAt!) : null,
    };
  }
}
