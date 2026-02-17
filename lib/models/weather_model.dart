import 'package:cloud_firestore/cloud_firestore.dart';

class WeatherData {
  final String locationId;
  final String location;
  final double latitude;
  final double longitude;
  final String currentCondition;
  final double temperature;
  final double humidity;
  final double windSpeed;
  final int rainChance;
  final DateTime timestamp;
  final List<Map<String, dynamic>> forecast; // 7 days

  WeatherData({
    required this.locationId,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.currentCondition,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.rainChance,
    required this.timestamp,
    required this.forecast,
  });

  factory WeatherData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return WeatherData(
      locationId: doc.id,
      location: data['location'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
      currentCondition: data['currentCondition'] ?? '',
      temperature: (data['temperature'] ?? 0).toDouble(),
      humidity: (data['humidity'] ?? 0).toDouble(),
      windSpeed: (data['windSpeed'] ?? 0).toDouble(),
      rainChance: data['rainChance'] ?? 0,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      forecast: List<Map<String, dynamic>>.from(data['forecast'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'currentCondition': currentCondition,
      'temperature': temperature,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'rainChance': rainChance,
      'timestamp': Timestamp.fromDate(timestamp),
      'forecast': forecast,
    };
  }
}

class WeatherAlert {
  final String alertId;
  final String farmerId;
  final String alertType; // 'rain', 'temperature', 'wind'
  final String message;
  final String recommendation;
  final DateTime alertTime;
  final bool dismissed;

  WeatherAlert({
    required this.alertId,
    required this.farmerId,
    required this.alertType,
    required this.message,
    required this.recommendation,
    required this.alertTime,
    required this.dismissed,
  });

  factory WeatherAlert.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return WeatherAlert(
      alertId: doc.id,
      farmerId: data['farmerId'] ?? '',
      alertType: data['alertType'] ?? '',
      message: data['message'] ?? '',
      recommendation: data['recommendation'] ?? '',
      alertTime: (data['alertTime'] as Timestamp).toDate(),
      dismissed: data['dismissed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'farmerId': farmerId,
      'alertType': alertType,
      'message': message,
      'recommendation': recommendation,
      'alertTime': Timestamp.fromDate(alertTime),
      'dismissed': dismissed,
    };
  }
}
