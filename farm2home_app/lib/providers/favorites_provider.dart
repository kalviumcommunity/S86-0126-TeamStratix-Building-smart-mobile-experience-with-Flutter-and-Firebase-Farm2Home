import 'package:flutter/foundation.dart';
import '../models/favorite_item.dart';

/// Favorites Provider
/// Manages the global state of favorite items across the application
/// Uses ChangeNotifier for reactive state management
/// All screens that listen to this provider will automatically update when favorites change
class FavoritesProvider extends ChangeNotifier {
  /// List of favorite items
  List<FavoriteItem> _favorites = [];

  /// Getter to access favorites list
  List<FavoriteItem> get favorites => List.unmodifiable(_favorites);

  /// Get count of favorites
  int get favoriteCount => _favorites.length;

  /// Check if item is already in favorites
  bool isFavorited(String itemId) {
    return _favorites.any((item) => item.id == itemId);
  }

  /// Add item to favorites
  /// Triggers notifyListeners() to update all listening widgets
  void addToFavorites(FavoriteItem item) {
    if (!isFavorited(item.id)) {
      _favorites.add(item);
      // Sort by most recently added (newest first)
      _favorites.sort((a, b) => b.addedAt.compareTo(a.addedAt));
      // Notify all listeners about the change
      notifyListeners();
    }
  }

  /// Remove item from favorites by ID
  /// Triggers notifyListeners() to update all listening widgets
  void removeFromFavorites(String itemId) {
    _favorites.removeWhere((item) => item.id == itemId);
    // Notify all listeners about the change
    notifyListeners();
  }

  /// Remove items by IDs (batch operation)
  void removeMultipleFavorites(List<String> itemIds) {
    for (final id in itemIds) {
      _favorites.removeWhere((item) => item.id == id);
    }
    notifyListeners();
  }

  /// Clear all favorites
  void clearAllFavorites() {
    _favorites.clear();
    notifyListeners();
  }

  /// Toggle favorite status (add if not exists, remove if exists)
  void toggleFavorite(FavoriteItem item) {
    if (isFavorited(item.id)) {
      removeFromFavorites(item.id);
    } else {
      addToFavorites(item);
    }
  }

  /// Get favorite by ID
  FavoriteItem? getFavoriteById(String itemId) {
    try {
      return _favorites.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }

  /// Get all favorites for a specific category
  List<FavoriteItem> getFavoritesByCategory(String category) {
    return _favorites
        .where((item) => item.description.contains(category))
        .toList();
  }

  /// Search favorites by name
  List<FavoriteItem> searchFavorites(String query) {
    if (query.isEmpty) {
      return _favorites;
    }
    final lowerQuery = query.toLowerCase();
    return _favorites
        .where((item) =>
            item.name.toLowerCase().contains(lowerQuery) ||
            item.description.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Get total price of all favorites
  double getTotalPrice() {
    return _favorites.fold(0.0, (sum, item) => sum + item.price);
  }

  /// Export favorites as JSON list
  List<Map<String, dynamic>> exportAsJson() {
    return _favorites.map((item) => item.toJson()).toList();
  }

  /// Import favorites from JSON list
  void importFromJson(List<Map<String, dynamic>> jsonList) {
    _favorites = jsonList.map((json) => FavoriteItem.fromJson(json)).toList();
    _favorites.sort((a, b) => b.addedAt.compareTo(a.addedAt));
    notifyListeners();
  }

  /// Sort favorites by name
  void sortByName() {
    _favorites.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  /// Sort favorites by price (low to high)
  void sortByPrice() {
    _favorites.sort((a, b) => a.price.compareTo(b.price));
    notifyListeners();
  }

  /// Sort favorites by price (high to low)
  void sortByPriceDesc() {
    _favorites.sort((a, b) => b.price.compareTo(a.price));
    notifyListeners();
  }

  /// Sort favorites by date added (newest first)
  void sortByDateAdded() {
    _favorites.sort((a, b) => b.addedAt.compareTo(a.addedAt));
    notifyListeners();
  }

  @override
  String toString() =>
      'FavoritesProvider(count: $favoriteCount, total: ${getTotalPrice().toStringAsFixed(2)})';
}
