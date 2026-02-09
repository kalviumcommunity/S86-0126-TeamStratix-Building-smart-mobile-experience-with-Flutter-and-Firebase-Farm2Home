import 'package:flutter/foundation.dart';

/// Service to manage user's favorite products
/// Uses ChangeNotifier for reactive state management with Provider
class FavoritesService extends ChangeNotifier {
  final List<String> _favoriteProductIds = [];

  /// Get immutable list of favorite product IDs
  List<String> get favoriteProductIds => List.unmodifiable(_favoriteProductIds);

  /// Get count of favorite items
  int get favoriteCount => _favoriteProductIds.length;

  /// Check if a product is favorited
  bool isFavorite(String productId) {
    return _favoriteProductIds.contains(productId);
  }

  /// Add a product to favorites
  void addFavorite(String productId) {
    if (!_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.add(productId);
      notifyListeners(); // Notify all listening widgets to rebuild
      debugPrint('Added to favorites: $productId');
    }
  }

  /// Remove a product from favorites
  void removeFavorite(String productId) {
    if (_favoriteProductIds.remove(productId)) {
      notifyListeners(); // Notify all listening widgets to rebuild
      debugPrint('Removed from favorites: $productId');
    }
  }

  /// Toggle favorite status
  void toggleFavorite(String productId) {
    if (isFavorite(productId)) {
      removeFavorite(productId);
    } else {
      addFavorite(productId);
    }
  }

  /// Clear all favorites
  void clearFavorites() {
    _favoriteProductIds.clear();
    notifyListeners();
    debugPrint('Cleared all favorites');
  }
}
