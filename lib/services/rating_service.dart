import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/rating_model.dart';
import 'notification_service.dart';

class RatingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService _notificationService = NotificationService();

  // Add or update rating
  Future<void> addRating({
    required String orderId,
    required String customerId,
    required String customerName,
    required String farmerId,
    required double rating,
    String? review,
  }) async {
    // Check if rating already exists
    final existingRating = await _firestore
        .collection('ratings')
        .where('orderId', isEqualTo: orderId)
        .limit(1)
        .get();

    final ratingData = Rating(
      ratingId: '',
      orderId: orderId,
      customerId: customerId,
      customerName: customerName,
      farmerId: farmerId,
      rating: rating,
      review: review,
      createdAt: DateTime.now(),
    );

    if (existingRating.docs.isEmpty) {
      // Create new rating
      await _firestore.collection('ratings').add(ratingData.toMap());
    } else {
      // Update existing rating
      await _firestore
          .collection('ratings')
          .doc(existingRating.docs.first.id)
          .update(ratingData.toMap());
    }

    // Update farmer's average rating
    await _updateFarmerAverageRating(farmerId);

    // Send notification to farmer
    await _notificationService.sendRatingNotification(
      farmerId: farmerId,
      customerName: customerName,
      rating: rating,
    );
  }

  // Get ratings for a farmer
  Stream<List<Rating>> getFarmerRatings(String farmerId) {
    return _firestore
        .collection('ratings')
        .where('farmerId', isEqualTo: farmerId)
        .snapshots()
        .map((snapshot) {
          final ratings = snapshot.docs.map((doc) => Rating.fromFirestore(doc)).toList();
          ratings.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Sort by createdAt desc
          return ratings;
        });
  }

  // Get rating for an order
  Future<Rating?> getOrderRating(String orderId) async {
    final snapshot = await _firestore
        .collection('ratings')
        .where('orderId', isEqualTo: orderId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return Rating.fromFirestore(snapshot.docs.first);
  }

  // Get farmer's average rating
  Future<Map<String, dynamic>> getFarmerStats(String farmerId) async {
    final snapshot = await _firestore
        .collection('ratings')
        .where('farmerId', isEqualTo: farmerId)
        .get();

    if (snapshot.docs.isEmpty) {
      return {
        'averageRating': 0.0,
        'totalRatings': 0,
        'distribution': {5: 0, 4: 0, 3: 0, 2: 0, 1: 0},
      };
    }

    double totalRating = 0;
    Map<int, int> distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

    for (var doc in snapshot.docs) {
      final rating = Rating.fromFirestore(doc);
      totalRating += rating.rating;
      final roundedRating = rating.rating.round();
      distribution[roundedRating] = (distribution[roundedRating] ?? 0) + 1;
    }

    return {
      'averageRating': totalRating / snapshot.docs.length,
      'totalRatings': snapshot.docs.length,
      'distribution': distribution,
    };
  }

  // Update farmer's average rating in user document
  Future<void> _updateFarmerAverageRating(String farmerId) async {
    final stats = await getFarmerStats(farmerId);
    await _firestore.collection('users').doc(farmerId).update({
      'averageRating': stats['averageRating'],
      'totalRatings': stats['totalRatings'],
    });
  }

  // Delete rating
  Future<void> deleteRating(String ratingId) async {
    final doc = await _firestore.collection('ratings').doc(ratingId).get();
    if (doc.exists) {
      final rating = Rating.fromFirestore(doc);
      await _firestore.collection('ratings').doc(ratingId).delete();
      await _updateFarmerAverageRating(rating.farmerId);
    }
  }

  // Check if user can rate order
  Future<bool> canRateOrder(String orderId, String customerId) async {
    // Check if order is delivered
    final orderDoc = await _firestore.collection('orders').doc(orderId).get();
    if (!orderDoc.exists) return false;

    final orderData = orderDoc.data() as Map<String, dynamic>;
    if (orderData['status'] != 'Delivered') return false;
    if (orderData['customerId'] != customerId) return false;

    // Check if already rated
    final ratingSnapshot = await _firestore
        .collection('ratings')
        .where('orderId', isEqualTo: orderId)
        .limit(1)
        .get();

    return ratingSnapshot.docs.isEmpty;
  }

  // Get top rated farmers
  Future<List<Map<String, dynamic>>> getTopRatedFarmers({int limit = 10}) async {
    final snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'farmer')
        .where('totalRatings', isGreaterThan: 0)
        .orderBy('totalRatings')
        .orderBy('averageRating', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => {
              'uid': doc.id,
              'name': doc['name'],
              'email': doc['email'],
              'averageRating': doc['averageRating'] ?? 0.0,
              'totalRatings': doc['totalRatings'] ?? 0,
            })
        .toList();
  }
}
