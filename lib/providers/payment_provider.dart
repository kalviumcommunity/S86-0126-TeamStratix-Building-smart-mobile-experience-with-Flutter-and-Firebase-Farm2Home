import 'package:flutter/material.dart';
import '../models/payment_model.dart';
import '../services/payment_service.dart';

class PaymentProvider with ChangeNotifier {
  final PaymentService _paymentService = PaymentService();

  List<Payment> _payments = [];
  Payment? _currentPayment;
  Map<String, dynamic> _paymentStats = {};
  bool _isLoading = false;
  String? _error;

  List<Payment> get payments => _payments;
  Payment? get currentPayment => _currentPayment;
  Map<String, dynamic> get paymentStats => _paymentStats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load customer payments
  void loadCustomerPayments(String customerId) {
    _paymentService.getCustomerPayments(customerId).listen(
      (payments) {
        _payments = payments;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  // Create payment
  Future<Payment?> createPayment({
    required String orderId,
    required String customerId,
    required double amount,
    String currency = 'INR',
    required String paymentMethod,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final payment = await _paymentService.createPayment(
        orderId: orderId,
        customerId: customerId,
        amount: amount,
        currency: currency,
        paymentMethod: paymentMethod,
      );
      _currentPayment = payment;
      _isLoading = false;
      notifyListeners();
      return payment;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Process payment
  Future<Map<String, dynamic>> processPayment({
    required String paymentId,
    required String paymentMethod,
    required double amount,
    Map<String, dynamic>? paymentDetails,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _paymentService.processPayment(
        paymentId: paymentId,
        paymentMethod: paymentMethod,
        amount: amount,
        paymentDetails: paymentDetails,
      );
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Get order payment
  Future<Payment?> getOrderPayment(String orderId) async {
    try {
      return await _paymentService.getOrderPayment(orderId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Load payment stats
  Future<void> loadPaymentStats(String customerId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _paymentStats = await _paymentService.getPaymentStats(customerId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Refund payment
  Future<bool> refundPayment(String paymentId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _paymentService.refundPayment(paymentId);
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear current payment
  void clearCurrentPayment() {
    _currentPayment = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
