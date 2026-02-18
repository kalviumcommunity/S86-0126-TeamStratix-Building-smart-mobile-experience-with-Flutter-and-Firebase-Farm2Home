import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expert_consultation_model.dart';
import '../models/agro_product_model.dart';
import '../models/equipment_rental_model.dart';
import '../models/weather_model.dart';
import '../models/disease_detection_model.dart';
import '../models/farm_diary_model.dart';
import '../models/crop_listing_model.dart';
import '../models/government_scheme_model.dart';
import '../models/irrigation_schedule_model.dart';
import '../models/community_model.dart';

class FarmerServicesHub {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // EXPERT CONSULTATION SERVICE
  Future<void> bookConsultation(ExpertConsultation consultation) async {
    try {
      print('Booking consultation: ${consultation.toMap()}');
      final docRef = await _firestore
          .collection('expert_consultations')
          .add(consultation.toMap());
      print('Consultation booked with ID: ${docRef.id}');
    } catch (e) {
      print('Error booking consultation: $e');
      throw Exception('Failed to book consultation: $e');
    }
  }

  Stream<List<ExpertConsultation>> getFarmerConsultations(String farmerId) {
    print('Getting consultations for farmer: $farmerId');
    return _firestore
        .collection('expert_consultations')
        .where('farmerId', isEqualTo: farmerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      print('Received ${snapshot.docs.length} consultations');
      final consultations = snapshot.docs
          .map((doc) {
        try {
          return ExpertConsultation.fromFirestore(doc);
        } catch (e) {
          print('Error parsing consultation doc ${doc.id}: $e');
          return null;
        }
      })
          .where((consultation) => consultation != null)
          .cast<ExpertConsultation>()
          .toList();
      print('Successfully parsed ${consultations.length} consultations');
      return consultations;
    });
  }

  Future<void> updateConsultation(ExpertConsultation consultation) async {
    try {
      await _firestore
          .collection('expert_consultations')
          .doc(consultation.consultationId)
          .update(consultation.toMap());
    } catch (e) {
      throw Exception('Failed to update consultation: $e');
    }
  }

  // AGRO STORE SERVICE
  Stream<List<AgroProduct>> getProducts({String? category}) {
    Query query = _firestore.collection('agro_products');
    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => AgroProduct.fromFirestore(doc)).toList();
    });
  }

  Future<void> createAgroOrder(AgroOrder order) async {
    try {
      await _firestore.collection('agro_orders').add(order.toMap());
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Stream<List<AgroOrder>> getFarmerOrders(String farmerId) {
    return _firestore
        .collection('agro_orders')
        .where('farmerId', isEqualTo: farmerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => AgroOrder.fromFirestore(doc)).toList();
    });
  }

  // EQUIPMENT RENTAL SERVICE
  Future<void> rentEquipment(EquipmentRental rental) async {
    try {
      await _firestore.collection('equipment_rentals').add(rental.toMap());
      // Mark equipment as unavailable
      await _firestore
          .collection('equipment')
          .doc(rental.equipmentId)
          .update({'available': false});
    } catch (e) {
      throw Exception('Failed to rent equipment: $e');
    }
  }

  Stream<List<Equipment>> getEquipmentByType(String type) {
    return _firestore
        .collection('equipment')
        .where('type', isEqualTo: type)
        .where('available', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Equipment.fromFirestore(doc)).toList();
    });
  }

  Stream<List<EquipmentRental>> getFarmerRentals(String farmerId) {
    return _firestore
        .collection('equipment_rentals')
        .where('farmerId', isEqualTo: farmerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => EquipmentRental.fromFirestore(doc))
          .toList();
    });
  }

  // WEATHER SERVICE
  Future<WeatherData?> getWeatherForLocation(String location) async {
    try {
      final snapshot = await _firestore
          .collection('weather')
          .where('location', isEqualTo: location)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return WeatherData.fromFirestore(snapshot.docs.first);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get weather: $e');
    }
  }

  Stream<List<WeatherAlert>> getWeatherAlerts(String farmerId) {
    return _firestore
        .collection('weather_alerts')
        .where('farmerId', isEqualTo: farmerId)
        .orderBy('alertTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => WeatherAlert.fromFirestore(doc)).toList();
    });
  }

  // DISEASE DETECTION SERVICE
  Future<void> reportDiseaseDetection(DiseaseDetection detection) async {
    try {
      await _firestore.collection('disease_detections').add(detection.toMap());
    } catch (e) {
      throw Exception('Failed to report disease: $e');
    }
  }

  Stream<List<DiseaseDetection>> getFarmerDiseaseDetections(String farmerId) {
    return _firestore
        .collection('disease_detections')
        .where('farmerId', isEqualTo: farmerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => DiseaseDetection.fromFirestore(doc))
          .toList();
    });
  }

  // FARM DIARY SERVICE
  Future<void> addDiaryEntry(FarmDiaryEntry entry) async {
    try {
      await _firestore.collection('farm_diary').add(entry.toMap());
    } catch (e) {
      throw Exception('Failed to add diary entry: $e');
    }
  }

  Stream<List<FarmDiaryEntry>> getFarmerDiaryEntries(String farmerId) {
    return _firestore
        .collection('farm_diary')
        .where('farmerId', isEqualTo: farmerId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FarmDiaryEntry.fromFirestore(doc))
          .toList();
    });
  }

  Future<Map<String, double>> getFarmStats(String farmerId) async {
    try {
      final snapshot = await _firestore
          .collection('farm_diary')
          .where('farmerId', isEqualTo: farmerId)
          .get();

      double totalIncome = 0;
      double totalExpense = 0;

      for (var doc in snapshot.docs) {
        final entry = FarmDiaryEntry.fromFirestore(doc);
        if (entry.activityType == 'income' && entry.amount != null) {
          totalIncome += entry.amount!;
        } else if (entry.activityType == 'expense' && entry.amount != null) {
          totalExpense += entry.amount!;
        }
      }

      return {
        'totalIncome': totalIncome,
        'totalExpense': totalExpense,
        'profit': totalIncome - totalExpense,
      };
    } catch (e) {
      throw Exception('Failed to get farm stats: $e');
    }
  }

  // MARKETPLACE SERVICE
  Future<void> postCropListing(CropListing listing) async {
    try {
      await _firestore.collection('crop_listings').add(listing.toMap());
    } catch (e) {
      throw Exception('Failed to post listing: $e');
    }
  }

  Stream<List<CropListing>> getActiveCropListings() {
    return _firestore
        .collection('crop_listings')
        .where('status', isEqualTo: 'available')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => CropListing.fromFirestore(doc)).toList();
    });
  }

  Stream<List<CropListing>> getFarmerListings(String farmerId) {
    return _firestore
        .collection('crop_listings')
        .where('farmerId', isEqualTo: farmerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => CropListing.fromFirestore(doc)).toList();
    });
  }

  Future<void> updateListingStatus(String listingId, String status) async {
    try {
      await _firestore
          .collection('crop_listings')
          .doc(listingId)
          .update({'status': status});
    } catch (e) {
      throw Exception('Failed to update listing: $e');
    }
  }

  // GOVERNMENT SCHEMES SERVICE
  Stream<List<GovernmentScheme>> getAllSchemes() {
    return _firestore
        .collection('government_schemes')
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => GovernmentScheme.fromFirestore(doc))
          .toList();
    });
  }

  // IRRIGATION SCHEDULER SERVICE
  Future<void> createIrrigationSchedule(IrrigationSchedule schedule) async {
    try {
      await _firestore.collection('irrigation_schedules').add(schedule.toMap());
    } catch (e) {
      throw Exception('Failed to create schedule: $e');
    }
  }

  Stream<List<IrrigationSchedule>> getFarmerSchedules(String farmerId) {
    return _firestore
        .collection('irrigation_schedules')
        .where('farmerId', isEqualTo: farmerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => IrrigationSchedule.fromFirestore(doc))
          .toList();
    });
  }

  // COMMUNITY SERVICE
  Future<void> createPost(CommunityPost post) async {
    try {
      await _firestore.collection('community_posts').add(post.toMap());
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  Stream<List<CommunityPost>> getCommunityPosts({String? category}) {
    Query query = _firestore.collection('community_posts');
    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }
    return query
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => CommunityPost.fromFirestore(doc)).toList();
    });
  }

  Future<void> addComment(CommunityComment comment) async {
    try {
      await _firestore
          .collection('community_posts')
          .doc(comment.postId)
          .collection('comments')
          .add(comment.toMap());

      // Update comment count
      final postDoc =
          await _firestore.collection('community_posts').doc(comment.postId).get();
      final currentCount = (postDoc['commentCount'] ?? 0) as int;
      await _firestore
          .collection('community_posts')
          .doc(comment.postId)
          .update({'commentCount': currentCount + 1});
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  Stream<List<CommunityComment>> getPostComments(String postId) {
    return _firestore
        .collection('community_posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => CommunityComment.fromFirestore(doc)).toList();
    });
  }
}
