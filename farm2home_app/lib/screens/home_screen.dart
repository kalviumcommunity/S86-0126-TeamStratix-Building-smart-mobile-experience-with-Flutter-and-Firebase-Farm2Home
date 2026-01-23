import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import 'products_screen.dart';

/// Home screen for Farm2Home app
class HomeScreen extends StatelessWidget {
  final CartService cartService;

  const HomeScreen({super.key, required this.cartService});

  @override
  Widget build(BuildContext context) {
    return ProductsScreen(cartService: cartService);
  }
}
