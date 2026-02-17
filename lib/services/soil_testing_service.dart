import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/soil_testing_slot_model.dart';

class SoilTestingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Available time slots
  static const List<String> availableTimeSlots = [
    '09:00 AM - 11:00 AM',
    '11:00 AM - 01:00 PM',
    '02:00 PM - 04:00 PM',
    '04:00 PM - 06:00 PM',
  ];

  // Book a new soil testing slot
  Future<String> bookSlot(SoilTestingSlot slot) async {
    try {
      // Check if the slot is already booked
      final existingBooking = await _firestore
          .collection('soil_testing_slots')
          .where('scheduledDate', isEqualTo: Timestamp.fromDate(slot.scheduledDate))
          .where('timeSlot', isEqualTo: slot.timeSlot)
          .where('status', whereIn: ['pending', 'confirmed'])
          .get();

      if (existingBooking.docs.isNotEmpty) {
        throw 'This time slot is already booked. Please choose another time.';
      }

      final docRef = _firestore.collection('soil_testing_slots').doc();
      final slotData = slot.copyWith(slotId: docRef.id);
      
      await docRef.set(slotData.toMap());
      return docRef.id;
    } catch (e) {
      throw 'Failed to book soil testing slot: ${e.toString()}';
    }
  }

  // Get slots for a farmer
  Stream<List<SoilTestingSlot>> getFarmerSlots(String farmerId) {
    return _firestore
        .collection('soil_testing_slots')
        .where('farmerId', isEqualTo: farmerId)
        .orderBy('scheduledDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => SoilTestingSlot.fromFirestore(doc))
          .toList();
    });
  }

  // Get all slots (for admin)
  Stream<List<SoilTestingSlot>> getAllSlots() {
    return _firestore
        .collection('soil_testing_slots')
        .orderBy('scheduledDate', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => SoilTestingSlot.fromFirestore(doc))
          .toList();
    });
  }

  // Update slot status
  Future<void> updateSlotStatus(String slotId, String status, {String? notes}) async {
    try {
      final updateData = {
        'status': status,
        if (notes != null) 'notes': notes,
        if (status == 'completed') 'completedAt': Timestamp.now(),
      };

      await _firestore
          .collection('soil_testing_slots')
          .doc(slotId)
          .update(updateData);
    } catch (e) {
      throw 'Failed to update slot status: ${e.toString()}';
    }
  }

  // Cancel a slot
  Future<void> cancelSlot(String slotId, String reason) async {
    try {
      await _firestore
          .collection('soil_testing_slots')
          .doc(slotId)
          .update({
        'status': 'cancelled',
        'notes': 'Cancelled: $reason',
      });
    } catch (e) {
      throw 'Failed to cancel slot: ${e.toString()}';
    }
  }

  // Add test results
  Future<void> addTestResults(String slotId, Map<String, dynamic> testResults) async {
    try {
      await _firestore
          .collection('soil_testing_slots')
          .doc(slotId)
          .update({
        'testResults': testResults,
        'status': 'completed',
        'completedAt': Timestamp.now(),
      });
    } catch (e) {
      throw 'Failed to add test results: ${e.toString()}';
    }
  }

  // Check availability for a date and time
  Future<bool> isSlotAvailable(DateTime date, String timeSlot) async {
    try {
      final existingBooking = await _firestore
          .collection('soil_testing_slots')
          .where('scheduledDate', isEqualTo: Timestamp.fromDate(date))
          .where('timeSlot', isEqualTo: timeSlot)
          .where('status', whereIn: ['pending', 'confirmed'])
          .get();

      return existingBooking.docs.isEmpty;
    } catch (e) {
      return false;
    }
  }

  // Get available slots for a specific date
  Future<List<String>> getAvailableSlots(DateTime date) async {
    try {
      final bookedSlots = await _firestore
          .collection('soil_testing_slots')
          .where('scheduledDate', isEqualTo: Timestamp.fromDate(date))
          .where('status', whereIn: ['pending', 'confirmed'])
          .get();

      final bookedTimeSlots = bookedSlots.docs
          .map((doc) => doc.data()['timeSlot'] as String)
          .toSet();

      return availableTimeSlots
          .where((slot) => !bookedTimeSlots.contains(slot))
          .toList();
    } catch (e) {
      return availableTimeSlots;
    }
  }
}