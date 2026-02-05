import 'package:flutter/material.dart';
import '../widgets/product_card.dart' as card_widget;

/// Responsive product grid screen demonstrating adaptive grid layouts
/// 
/// Uses LayoutBuilder to dynamically determine grid column count based on
/// available space, providing optimal viewing experience on mobile and tablet.
class ResponsiveProductGrid extends StatefulWidget {
  const ResponsiveProductGrid({super.key});

  @override
  State<ResponsiveProductGrid> createState() => _ResponsiveProductGridState();
}

class _ResponsiveProductGridState extends State<ResponsiveProductGrid> {
  // Product card data for display
  final List<Map<String, dynamic>> productDisplay = [
    {
      'title': 'Organic Tomatoes',
      'description': 'Fresh ripe tomatoes from local farms',
      'price': 45.00,
      'imageUrl': '🍅',
      'rating': 4.5,
      'reviewCount': 128,
    },
    {
      'title': 'Fresh Lettuce',
      'description': 'Crispy green lettuce perfect for salads',
      'price': 35.00,
      'imageUrl': '🥬',
      'rating': 4.3,
      'reviewCount': 95,
    },
    {
      'title': 'Carrots Bundle',
      'description': 'Sweet orange carrots in bundle',
      'price': 55.00,
      'imageUrl': '🥕',
      'rating': 4.8,
      'reviewCount': 156,
    },
    {
      'title': 'Organic Spinach',
      'description': 'Nutrient-rich spinach leaves',
      'price': 40.00,
      'imageUrl': '🥬',
      'rating': 4.6,
      'reviewCount': 112,
    },
    {
      'title': 'Bell Peppers',
      'description': 'Colorful bell peppers assortment',
      'price': 60.00,
      'imageUrl': '🫑',
      'rating': 4.4,
      'reviewCount': 87,
    },
    {
      'title': 'Fresh Cucumbers',
      'description': 'Crisp and juicy cucumbers',
      'price': 30.00,
      'imageUrl': '🥒',
      'rating': 4.7,
      'reviewCount': 143,
    },
    {
      'title': 'Broccoli',
      'description': 'Green broccoli florets',
      'price': 50.00,
      'imageUrl': '🥦',
      'rating': 4.5,
      'reviewCount': 98,
    },
    {
      'title': 'Potato Pack',
      'description': 'Pack of fresh potatoes',
      'price': 65.00,
      'imageUrl': '🥔',
      'rating': 4.6,
      'reviewCount': 167,
    },
    {
      'title': 'Onion Bunch',
      'description': 'Fresh onions bunch',
      'price': 25.00,
      'imageUrl': '🧅',
      'rating': 4.4,
      'reviewCount': 76,
    },
    {
      'title': 'Garlic Bunch',
      'description': 'Fresh garlic bulbs',
      'price': 35.00,
      'imageUrl': '🧄',
      'rating': 4.7,
      'reviewCount': 134,
    },
    {
      'title': 'Organic Radish',
      'description': 'Crisp radish vegetables',
      'price': 28.00,
      'imageUrl': '🌶️',
      'rating': 4.3,
      'reviewCount': 62,
    },
    {
      'title': 'Green Beans',
      'description': 'Fresh green beans bundle',
      'price': 45.00,
      'imageUrl': '🫘',
      'rating': 4.6,
      'reviewCount': 119,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Product Grid'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Header with responsive info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Grid Layout Info',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Screen: ${screenWidth.toStringAsFixed(0)} × ${screenHeight.toStringAsFixed(0)} px',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Grid adapts based on screen width (2 cols mobile, 3 cols tablet, 4 cols desktop)',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
          
          // Responsive grid
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Determine grid columns based on available width
                int columns;
                if (constraints.maxWidth < 500) {
                  columns = 2; // Mobile phones
                } else if (constraints.maxWidth < 800) {
                  columns = 3; // Tablets
                } else if (constraints.maxWidth < 1200) {
                  columns = 4; // Large tablets
                } else {
                  columns = 5; // Desktop
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: productDisplay.length,
                  itemBuilder: (context, index) {
                    final product = productDisplay[index];
                    return card_widget.ProductCard(
                      imageUrl: product['imageUrl'] as String,
                      title: product['title'] as String,
                      price: (product['price'] as num).toDouble(),
                      rating: (product['rating'] as num).toDouble(),
                      reviewCount: product['reviewCount'] as int,
                      onAddToCart: () {
                        _showSnackbar('Added ${product['title']} to cart');
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a snackbar message
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green.shade600,
      ),
    );
  }
}
