import 'package:flutter/material.dart';
import '../models/rating_model.dart';
import '../services/rating_service.dart';

class RatingProvider with ChangeNotifier {
  final RatingService _ratingService = RatingService();

  List<Rating> _ratings = [];
  Map<String, dynamic> _farmerStats = {};
  bool _isLoading = false;
  String? _error;

  List<Rating> get ratings => _ratings;
  Map<String, dynamic> get farmerStats => _farmerStats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load farmer ratings
  void loadFarmerRatings(String farmerId) {
    _ratingService.getFarmerRatings(farmerId).listen(
      (ratings) {
        _ratings = ratings;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  // Load farmer stats
  Future<void> loadFarmerStats(String farmerId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _farmerStats = await _ratingService.getFarmerStats(farmerId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add rating
  Future<bool> addRating({
    required String orderId,
    required String customerId,
    required String customerName,
    required String farmerId,
    required double rating,
    String? review,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _ratingService.addRating(
        orderId: orderId,
        customerId: customerId,
        customerName: customerName,
        farmerId: farmerId,
        rating: rating,
        review: review,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get order rating
  Future<Rating?> getOrderRating(String orderId) async {
    try {
      return await _ratingService.getOrderRating(orderId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Check if can rate
  Future<bool> canRateOrder(String orderId, String customerId) async {
    try {
      return await _ratingService.canRateOrder(orderId, customerId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Get top rated farmers
  Future<List<Map<String, dynamic>>> getTopRatedFarmers({int limit = 10}) async {
    try {
      return await _ratingService.getTopRatedFarmers(limit: limit);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
