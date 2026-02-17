import 'package:cloud_firestore/cloud_firestore.dart';

class ExpertConsultation {
  final String consultationId;
  final String farmerId;
  final String farmerName;
  final String cropName;
  final String problemDescription;
  final String? photoUrl;
  final String consultationType; // 'call', 'chat', 'video'
  final String preferredTime;
  final String? assignedExpertId;
  final String? assignedExpertName;
  final DateTime scheduledTime;
  final String status; // 'pending', 'scheduled', 'completed', 'cancelled'
  final String? fertiliserSuggestion;
  final String? weatherAdvice;
  final String? generalAdvice;
  final DateTime createdAt;
  final DateTime? completedAt;

  ExpertConsultation({
    required this.consultationId,
    required this.farmerId,
    required this.farmerName,
    required this.cropName,
    required this.problemDescription,
    this.photoUrl,
    required this.consultationType,
    required this.preferredTime,
    this.assignedExpertId,
    this.assignedExpertName,
    required this.scheduledTime,
    required this.status,
    this.fertiliserSuggestion,
    this.weatherAdvice,
    this.generalAdvice,
    required this.createdAt,
    this.completedAt,
  });

  factory ExpertConsultation.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ExpertConsultation(
      consultationId: doc.id,
      farmerId: data['farmerId'] ?? '',
      farmerName: data['farmerName'] ?? '',
      cropName: data['cropName'] ?? '',
      problemDescription: data['problemDescription'] ?? '',
      photoUrl: data['photoUrl'],
      consultationType: data['consultationType'] ?? 'chat',
      preferredTime: data['preferredTime'] ?? '',
      assignedExpertId: data['assignedExpertId'],
      assignedExpertName: data['assignedExpertName'],
      scheduledTime: (data['scheduledTime'] as Timestamp).toDate(),
      status: data['status'] ?? 'pending',
      fertiliserSuggestion: data['fertiliserSuggestion'],
      weatherAdvice: data['weatherAdvice'],
      generalAdvice: data['generalAdvice'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      completedAt: data['completedAt'] != null 
          ? (data['completedAt'] as Timestamp).toDate() 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'farmerId': farmerId,
      'farmerName': farmerName,
      'cropName': cropName,
      'problemDescription': problemDescription,
      'photoUrl': photoUrl,
      'consultationType': consultationType,
      'preferredTime': preferredTime,
      'assignedExpertId': assignedExpertId,
      'assignedExpertName': assignedExpertName,
      'scheduledTime': Timestamp.fromDate(scheduledTime),
      'status': status,
      'fertiliserSuggestion': fertiliserSuggestion,
      'weatherAdvice': weatherAdvice,
      'generalAdvice': generalAdvice,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }
}
