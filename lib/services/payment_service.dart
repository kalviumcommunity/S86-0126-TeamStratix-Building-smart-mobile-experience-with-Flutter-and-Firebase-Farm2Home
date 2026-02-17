import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/payment_model.dart';

class PaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create payment record
  Future<Payment> createPayment({
    required String orderId,
    required String customerId,
    required double amount,
    String currency = 'INR',
    required String paymentMethod,
  }) async {
    final payment = Payment(
      paymentId: '',
      orderId: orderId,
      customerId: customerId,
      amount: amount,
      currency: currency,
      status: 'pending',
      paymentMethod: paymentMethod,
      createdAt: DateTime.now(),
    );

    final docRef =
        await _firestore.collection('payments').add(payment.toMap());
    return payment.copyWith(paymentId: docRef.id);
  }

  // Update payment status
  Future<void> updatePaymentStatus({
    required String paymentId,
    required String status,
    String? transactionId,
    Map<String, dynamic>? metadata,
  }) async {
    final updates = <String, dynamic>{
      'status': status,
      ...?transactionId != null ? {'transactionId': transactionId} : null,
      ...?status == 'completed' ? {'completedAt': FieldValue.serverTimestamp()} : null,
      ...?metadata,
    };

    await _firestore.collection('payments').doc(paymentId).update(updates);

    // Update order payment status
    final paymentDoc =
        await _firestore.collection('payments').doc(paymentId).get();
    if (paymentDoc.exists) {
      final payment = Payment.fromFirestore(paymentDoc);
      await _firestore.collection('orders').doc(payment.orderId).update({
        'paymentStatus': status,
        'paymentId': paymentId,
      });
    }
  }

  // Get payment by ID
  Future<Payment?> getPayment(String paymentId) async {
    final doc = await _firestore.collection('payments').doc(paymentId).get();
    if (!doc.exists) return null;
    return Payment.fromFirestore(doc);
  }

  // Get payment for order
  Future<Payment?> getOrderPayment(String orderId) async {
    final snapshot = await _firestore
        .collection('payments')
        .where('orderId', isEqualTo: orderId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return Payment.fromFirestore(snapshot.docs.first);
  }

  // Get customer payments
  Stream<List<Payment>> getCustomerPayments(String customerId) {
    return _firestore
        .collection('payments')
        .where('customerId', isEqualTo: customerId)
        .snapshots()
        .map((snapshot) {
          final payments = snapshot.docs.map((doc) => Payment.fromFirestore(doc)).toList();
          payments.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Sort by createdAt desc
          return payments;
        });
  }

  // Process payment (placeholder for actual payment gateway integration)
  Future<Map<String, dynamic>> processPayment({
    required String paymentId,
    required String paymentMethod,
    required double amount,
    Map<String, dynamic>? paymentDetails,
  }) async {
    // In a real app, integrate with Stripe, Razorpay, etc.
    // For demo purposes, we'll simulate a payment

    try {
      if (paymentMethod == 'cash_on_delivery') {
        // COD doesn't need processing, just mark as pending
        await updatePaymentStatus(
          paymentId: paymentId,
          status: 'pending',
          metadata: {'method': 'cash_on_delivery'},
        );

        return {
          'success': true,
          'message': 'Cash on Delivery order placed successfully',
        };
      }

      // Simulate payment processing delay
      await Future.delayed(const Duration(seconds: 2));

      // Simulate success (90% success rate)
      final success = DateTime.now().millisecond % 10 != 0;

      if (success) {
        final transactionId = 'TXN${DateTime.now().millisecondsSinceEpoch}';
        await updatePaymentStatus(
          paymentId: paymentId,
          status: 'completed',
          transactionId: transactionId,
          metadata: {
            'method': paymentMethod,
            'processedAt': DateTime.now().toIso8601String(),
          },
        );

        return {
          'success': true,
          'transactionId': transactionId,
          'message': 'Payment processed successfully',
        };
      } else {
        await updatePaymentStatus(
          paymentId: paymentId,
          status: 'failed',
          metadata: {
            'method': paymentMethod,
            'error': 'Payment declined',
          },
        );

        return {
          'success': false,
          'message': 'Payment failed. Please try again.',
        };
      }
    } catch (e) {
      await updatePaymentStatus(
        paymentId: paymentId,
        status: 'failed',
        metadata: {
          'error': e.toString(),
        },
      );

      return {
        'success': false,
        'message': 'Payment processing error: ${e.toString()}',
      };
    }
  }

  // Refund payment
  Future<bool> refundPayment(String paymentId) async {
    try {
      await updatePaymentStatus(
        paymentId: paymentId,
        status: 'refunded',
        metadata: {
          'refundedAt': DateTime.now().toIso8601String(),
        },
      );
      return true;
    } catch (e) {
      debugPrint('Refund error: $e');
      return false;
    }
  }

  // Get payment statistics
  Future<Map<String, dynamic>> getPaymentStats(String customerId) async {
    final snapshot = await _firestore
        .collection('payments')
        .where('customerId', isEqualTo: customerId)
        .get();

    double totalSpent = 0;
    int successfulPayments = 0;
    int failedPayments = 0;
    int pendingPayments = 0;

    for (var doc in snapshot.docs) {
      final payment = Payment.fromFirestore(doc);
      if (payment.status == 'completed') {
        totalSpent += payment.amount;
        successfulPayments++;
      } else if (payment.status == 'failed') {
        failedPayments++;
      } else if (payment.status == 'pending') {
        pendingPayments++;
      }
    }

    return {
      'totalSpent': totalSpent,
      'successfulPayments': successfulPayments,
      'failedPayments': failedPayments,
      'pendingPayments': pendingPayments,
      'totalTransactions': snapshot.docs.length,
    };
  }
}
