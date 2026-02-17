import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];
  List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CartItem> get cartItems => _cartItems;
  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get cartItemCount => _cartItems.length;

  double get cartTotal {
    return _cartItems.fold(0.0, (total, item) => total + item.total);
  }

  // Load all available products from Firestore
  Future<void> loadProducts() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('isAvailable', isEqualTo: true)
          .orderBy('name')
          .get();

      _products = snapshot.docs
          .map((doc) => ProductModel.fromSnapshot(doc))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Stream products for real-time updates with hard deduplication
  Stream<List<ProductModel>> streamProducts() {
    return FirebaseFirestore.instance
        .collection('products')
        .where('isAvailable', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
          // HARD DEDUPLICATION: Convert list → Map(productId) → List
          // This ensures each productId appears exactly once
          final Map<String, ProductModel> uniqueProducts = {};

          for (var doc in snapshot.docs) {
            final product = ProductModel.fromSnapshot(doc);
            // Use productId as unique key - later entries overwrite duplicates
            uniqueProducts[product.productId] = product;
          }

          // Return deduplicated list
          return uniqueProducts.values.toList();
        });
  }

  // Add product to cart
  void addToCart(ProductModel product, double quantity) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.product.productId == product.productId,
    );

    if (existingIndex >= 0) {
      // Update quantity if product already in cart
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity + quantity,
      );
    } else {
      // Add new item to cart
      _cartItems.add(CartItem(product: product, quantity: quantity));
    }

    notifyListeners();
  }

  // Update cart item quantity
  void updateCartItemQuantity(String productId, double quantity) {
    final index = _cartItems.indexWhere(
      (item) => item.product.productId == productId,
    );

    if (index >= 0) {
      if (quantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index] = _cartItems[index].copyWith(quantity: quantity);
      }
      notifyListeners();
    }
  }

  // Remove item from cart
  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.product.productId == productId);
    notifyListeners();
  }

  // Clear cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Get cart item by product id
  CartItem? getCartItem(String productId) {
    try {
      return _cartItems.firstWhere(
        (item) => item.product.productId == productId,
      );
    } catch (e) {
      return null;
    }
  }

  // Check if product is in cart
  bool isInCart(String productId) {
    return _cartItems.any((item) => item.product.productId == productId);
  }

  // Get quantity of product in cart
  double getProductQuantity(String productId) {
    final cartItem = getCartItem(productId);
    return cartItem?.quantity ?? 0;
  }

  // Group cart items by farmer
  Map<String, List<CartItem>> getCartItemsByFarmer() {
    final Map<String, List<CartItem>> groupedItems = {};

    for (var item in _cartItems) {
      final farmerId = item.product.farmerId;
      if (!groupedItems.containsKey(farmerId)) {
        groupedItems[farmerId] = [];
      }
      groupedItems[farmerId]!.add(item);
    }

    return groupedItems;
  }
}
