import 'package:flutter/material.dart';

class AgroStoreScreen extends StatefulWidget {
  const AgroStoreScreen({super.key});

  @override
  State<AgroStoreScreen> createState() => _AgroStoreScreenState();
}

class _AgroStoreScreenState extends State<AgroStoreScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Fertilizer', 'Seed', 'Pesticide'];

  // Sample products
  final List<Map<String, dynamic>> _sampleProducts = [
    {'name': 'NPK Fertilizer 10:10:10', 'category': 'fertilizer', 'price': 450, 'unit': 'kg', 'rating': 4.5},
    {'name': 'Urea Fertilizer Premium', 'category': 'fertilizer', 'price': 350, 'unit': 'kg', 'rating': 4.3},
    {'name': 'Micronutrient Mix', 'category': 'fertilizer', 'price': 580, 'unit': 'kg', 'rating': 4.7},
    {'name': 'DAP Fertilizer', 'category': 'fertilizer', 'price': 520, 'unit': 'kg', 'rating': 4.4},
    {'name': 'Hybrid Corn Seeds', 'category': 'seed', 'price': 650, 'unit': 'packet', 'rating': 4.6},
    {'name': 'Paddy Seeds Premium', 'category': 'seed', 'price': 420, 'unit': 'kg', 'rating': 4.5},
    {'name': 'Wheat Seeds HYV', 'category': 'seed', 'price': 380, 'unit': 'kg', 'rating': 4.4},
    {'name': 'Cotton Seeds Bt', 'category': 'seed', 'price': 2500, 'unit': 'packet', 'rating': 4.8},
    {'name': 'Insecticide Spray', 'category': 'pesticide', 'price': 320, 'unit': 'liter', 'rating': 4.5},
    {'name': 'Fungicide Solution', 'category': 'pesticide', 'price': 280, 'unit': 'liter', 'rating': 4.3},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Shop'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quality Farm Products',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                // Category Filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      bool isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() => _selectedCategory = category);
                          },
                          backgroundColor: Colors.white,
                          selectedColor: Theme.of(context).primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          // Products Grid
          Expanded(
            child: _buildProductsGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid() {
    // Filter sample products based on selected category
    final filteredProducts = _selectedCategory == 'All'
        ? _sampleProducts
        : _sampleProducts.where((p) => p['category'] == _selectedCategory.toLowerCase()).toList();

    if (filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text('No products in this category', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return _buildSampleProductCard(product);
      },
    );
  }

  Widget _buildSampleProductCard(Map<String, dynamic> product) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              gradient: LinearGradient(
                colors: [Colors.green.shade300, Colors.green.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Icon(Icons.local_florist, color: Colors.white, size: 40),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] as String,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('${product['rating']}', style: const TextStyle(fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₹${product['price']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('/${product['unit']}', style: const TextStyle(fontSize: 9, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product['name']} added to cart!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                    ),
                    child: const Text('Add to Cart', style: TextStyle(fontSize: 11)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
