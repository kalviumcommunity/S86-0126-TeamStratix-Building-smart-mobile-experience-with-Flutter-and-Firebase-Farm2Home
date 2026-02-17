import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/supply_booking_model.dart';

class SupplyBookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new supply booking request
  Future<String> createBooking(SupplyBookingModel booking) async {
    try {
      final docRef = _firestore.collection('supply_bookings').doc();
      
      final bookingData = booking.toMap();
      bookingData['bookingId'] = docRef.id;
      
      await docRef.set(bookingData);
      
      return docRef.id;
    } catch (e) {
      throw 'Failed to create booking: ${e.toString()}';
    }
  }

  // Get bookings by farmer ID
  Stream<List<SupplyBookingModel>> getFarmerBookings(String farmerId) {
    return _firestore
        .collection('supply_bookings')
        .where('farmerId', isEqualTo: farmerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SupplyBookingModel.fromSnapshot(doc))
            .toList());
  }

  // Get all bookings (for admin)
  Stream<List<SupplyBookingModel>> getAllBookings() {
    return _firestore
        .collection('supply_bookings')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SupplyBookingModel.fromSnapshot(doc))
            .toList());
  }

  // Update booking status
  Future<void> updateBookingStatus(String bookingId, String status, String? notes) async {
    try {
      final updateData = {
        'status': status,
        'fulfilledDate': status == 'fulfilled' ? Timestamp.fromDate(DateTime.now()) : null,
      };
      
      if (notes != null) {
        updateData['notes'] = notes;
      }
      
      await _firestore
          .collection('supply_bookings')
          .doc(bookingId)
          .update(updateData);
    } catch (e) {
      throw 'Failed to update booking: ${e.toString()}';
    }
  }

  // Delete booking
  Future<void> deleteBooking(String bookingId) async {
    try {
      await _firestore.collection('supply_bookings').doc(bookingId).delete();
    } catch (e) {
      throw 'Failed to delete booking: ${e.toString()}';
    }
  }

  // Get booking statistics
  Future<Map<String, int>> getBookingStats(String farmerId) async {
    try {
      final snapshot = await _firestore
          .collection('supply_bookings')
          .where('farmerId', isEqualTo: farmerId)
          .get();

      int pending = 0;
      int approved = 0;
      int fulfilled = 0;
      int cancelled = 0;

      for (var doc in snapshot.docs) {
        final status = doc.data()['status'] as String;
        switch (status) {
          case 'pending':
            pending++;
            break;
          case 'approved':
            approved++;
            break;
          case 'fulfilled':
            fulfilled++;
            break;
          case 'cancelled':
            cancelled++;
            break;
        }
      }

      return {
        'total': snapshot.docs.length,
        'pending': pending,
        'approved': approved,
        'fulfilled': fulfilled,
        'cancelled': cancelled,
      };
    } catch (e) {
      throw 'Failed to get booking statistics: ${e.toString()}';
    }
  }
}