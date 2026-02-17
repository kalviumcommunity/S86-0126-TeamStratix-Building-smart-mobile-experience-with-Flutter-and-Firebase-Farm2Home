import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/status_update_model.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class OrderProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  final List<OrderModel> _orders = [];
  List<UserModel> _farmers = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<OrderModel> get orders => _orders;
  List<UserModel> get farmers => _farmers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load farmers
  Future<void> loadFarmers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _farmers = await _firestoreService.getFarmers();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create order
  Future<bool> createOrder(OrderModel order) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestoreService.createOrder(order);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update order status
  Future<bool> updateOrderStatus({
    required String orderId,
    required String status,
    String? notes,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestoreService.updateOrderStatus(
        orderId: orderId,
        status: status,
        notes: notes,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get order by ID
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      return await _firestoreService.getOrderById(orderId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Stream orders by customer
  Stream<List<OrderModel>> streamCustomerOrders(String customerId) {
    return _firestoreService.getOrdersByCustomer(customerId);
  }

  // Stream orders by farmer
  Stream<List<OrderModel>> streamFarmerOrders(String farmerId) {
    return _firestoreService.getOrdersByFarmer(farmerId);
  }

  // Stream pending orders by farmer
  Stream<List<OrderModel>> streamPendingOrders(String farmerId) {
    return _firestoreService.getPendingOrdersByFarmer(farmerId);
  }

  // Stream delivered orders by farmer
  Stream<List<OrderModel>> streamDeliveredOrders(String farmerId) {
    return _firestoreService.getDeliveredOrdersByFarmer(farmerId);
  }

  // Stream single order
  Stream<OrderModel?> streamOrder(String orderId) {
    return _firestoreService.streamOrder(orderId);
  }

  // Get status updates
  Stream<List<StatusUpdateModel>> getStatusUpdates(String orderId) {
    return _firestoreService.getStatusUpdates(orderId);
  }

  // Get order statistics
  Future<Map<String, int>> getCustomerStats(String customerId) async {
    try {
      final totalOrders = await _firestoreService.getCustomerOrderCount(
        customerId,
      );
      return {'totalOrders': totalOrders};
    } catch (e) {
      return {'totalOrders': 0};
    }
  }

  Future<Map<String, int>> getFarmerStats(String farmerId) async {
    try {
      final totalOrders = await _firestoreService.getFarmerOrderCount(farmerId);
      final pendingOrders = await _firestoreService.getPendingOrderCount(
        farmerId,
      );
      final deliveredOrders = await _firestoreService.getDeliveredOrderCount(
        farmerId,
      );
      return {
        'totalOrders': totalOrders, 
        'pendingOrders': pendingOrders,
        'deliveredOrders': deliveredOrders,
      };
    } catch (e) {
      return {'totalOrders': 0, 'pendingOrders': 0, 'deliveredOrders': 0};
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
