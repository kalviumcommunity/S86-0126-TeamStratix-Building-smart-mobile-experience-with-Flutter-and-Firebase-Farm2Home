import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/auth_provider.dart';
import '../../models/product_model.dart';
import '../../widgets/custom_button.dart';

/// Admin screen to populate sample products
class AddSampleProductsScreen extends StatefulWidget {
  const AddSampleProductsScreen({super.key});

  @override
  State<AddSampleProductsScreen> createState() =>
      _AddSampleProductsScreenState();
}

class _AddSampleProductsScreenState extends State<AddSampleProductsScreen> {
  bool _isLoading = false;
  String _message = '';

  void _handleAddProducts() {
    _addSampleProducts();
  }

  Future<void> _clearAllProducts() async {
    setState(() {
      _isLoading = true;
      _message = 'Clearing existing products to fix images...';
    });

    try {
      final user = Provider.of<AuthProvider>(context, listen: false).currentUser!;
      
      // Get all products for this farmer
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('farmerId', isEqualTo: user.uid)
          .get();

      int deletedCount = 0;
      
      // Delete all products
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
        deletedCount++;
      }

      setState(() {
        _isLoading = false;
        _message = deletedCount > 0 
            ? '✅ Cleared $deletedCount products! Now add fresh products.'
            : '✅ No products found to clear.';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(deletedCount > 0 
                ? 'Cleared $deletedCount products' 
                : 'No products found'),
            backgroundColor: deletedCount > 0 ? Colors.green : Colors.blue,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _message = '❌ Error clearing products: $e';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error clearing products: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _removeDuplicateProducts() async {
    setState(() {
      _isLoading = true;
      _message = 'Removing duplicate products...';
    });

    try {
      final user = Provider.of<AuthProvider>(context, listen: false).currentUser!;
      
      // Get all products for this farmer
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('farmerId', isEqualTo: user.uid)
          .get();

      // Group products by name
      Map<String, List<QueryDocumentSnapshot>> productGroups = {};
      
      for (var doc in snapshot.docs) {
        final name = doc.data()['name'] as String;
        productGroups[name] = productGroups[name] ?? [];
        productGroups[name]!.add(doc);
      }

      int deletedCount = 0;
      
      // Keep only the first product of each name, delete the rest
      for (var group in productGroups.entries) {
        if (group.value.length > 1) {
          // Keep the first, delete the rest
          for (int i = 1; i < group.value.length; i++) {
            await group.value[i].reference.delete();
            deletedCount++;
          }
        }
      }

      setState(() {
        _isLoading = false;
        _message = deletedCount > 0 
            ? '✅ Removed $deletedCount duplicate products!'
            : '✅ No duplicate products found.';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(deletedCount > 0 
                ? 'Removed $deletedCount duplicate products' 
                : 'No duplicates found'),
            backgroundColor: deletedCount > 0 ? Colors.green : Colors.blue,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _message = '❌ Error removing duplicates: $e';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing duplicates: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _addSampleProducts() async {
    setState(() {
      _isLoading = true;
      _message = 'Adding sample products...';
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser!;

      // Sample products data
      final List<Map<String, dynamic>> sampleProducts = [
        // Fruits
        {
          'name': 'Fresh Apples',
          'description':
              'Crisp and juicy red apples, perfect for snacking or baking',
          'price': 4.99,
          'unit': 'kg',
          'category': 'Fruits',
          'imageUrl':
              'https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?w=400',
          'ingredients': 'Fresh Apples',
          'nutritionInfo': {
            'calories': '52 per 100g',
            'protein': '0.3g',
            'carbs': '14g',
            'fiber': '2.4g',
            'vitamins': 'Vitamin C, K',
          },
        },
        {
          'name': 'Organic Bananas',
          'description': 'Sweet and ripe organic bananas, rich in potassium',
          'price': 2.99,
          'unit': 'dozen',
          'category': 'Fruits',
          'imageUrl':
              'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400&q=80',
          'ingredients': 'Organic Bananas',
          'nutritionInfo': {
            'calories': '89 per 100g',
            'protein': '1.1g',
            'carbs': '23g',
            'fiber': '2.6g',
            'vitamins': 'Vitamin B6, C',
          },
        },
        {
          'name': 'Fresh Mangoes',
          'description':
              'Sweet and juicy mangoes, hand-picked from local farms',
          'price': 5.99,
          'unit': 'kg',
          'category': 'Fruits',
          'imageUrl':
              'https://images.unsplash.com/photo-1553279768-865429fa0078?w=400&q=80',
          'ingredients': 'Fresh Mangoes',
          'nutritionInfo': {
            'calories': '60 per 100g',
            'protein': '0.8g',
            'carbs': '15g',
            'fiber': '1.6g',
            'vitamins': 'Vitamin A, C',
          },
        },
        {
          'name': 'Strawberries',
          'description': 'Sweet and fresh strawberries, perfect for desserts',
          'price': 6.99,
          'unit': 'kg',
          'category': 'Fruits',
          'imageUrl':
              'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400&q=80',
          'ingredients': 'Fresh Strawberries',
          'nutritionInfo': {
            'calories': '32 per 100g',
            'protein': '0.7g',
            'carbs': '7.7g',
            'fiber': '2g',
            'vitamins': 'Vitamin C, Manganese',
          },
        },

        // Vegetables
        {
          'name': 'Fresh Tomatoes',
          'description':
              'Vine-ripened tomatoes, perfect for salads and cooking',
          'price': 3.99,
          'unit': 'kg',
          'category': 'Vegetables',
          'imageUrl':
              'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400&q=80',
          'ingredients': 'Fresh Tomatoes',
          'nutritionInfo': {
            'calories': '18 per 100g',
            'protein': '0.9g',
            'carbs': '3.9g',
            'fiber': '1.2g',
            'vitamins': 'Vitamin C, K, Potassium',
          },
        },
        {
          'name': 'Green Lettuce',
          'description': 'Crisp and fresh lettuce, ideal for salads',
          'price': 2.49,
          'unit': 'head',
          'category': 'Vegetables',
          'imageUrl':
              'https://images.unsplash.com/photo-1622206151226-18ca2c9ab4a1?w=400&q=80',
          'ingredients': 'Fresh Green Lettuce',
          'nutritionInfo': {
            'calories': '15 per 100g',
            'protein': '1.4g',
            'carbs': '2.9g',
            'fiber': '1.3g',
            'vitamins': 'Vitamin A, K',
          },
        },
        {
          'name': 'Organic Carrots',
          'description': 'Sweet orange carrots, rich in beta-carotene',
          'price': 2.49,
          'unit': 'kg',
          'category': 'Vegetables',
          'imageUrl':
              'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=400&q=80',
          'ingredients': 'Organic Carrots',
          'nutritionInfo': {
            'calories': '41 per 100g',
            'protein': '0.9g',
            'carbs': '10g',
            'fiber': '2.8g',
            'vitamins': 'Vitamin A, K1, B6',
          },
        },
        {
          'name': 'Fresh Spinach',
          'description': 'Nutritious green spinach, packed with iron',
          'price': 3.49,
          'unit': 'kg',
          'category': 'Vegetables',
          'imageUrl':
              'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400&q=80',
          'ingredients': 'Fresh Spinach',
          'nutritionInfo': {
            'calories': '23 per 100g',
            'protein': '2.9g',
            'carbs': '3.6g',
            'fiber': '2.2g',
            'vitamins': 'Vitamin A, C, K, Iron',
          },
        },
        {
          'name': 'Potatoes',
          'description': 'Fresh potatoes, perfect for frying or baking',
          'price': 1.99,
          'unit': 'kg',
          'category': 'Vegetables',
          'imageUrl':
              'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=400',
          'ingredients': 'Fresh Potatoes',
          'nutritionInfo': {
            'calories': '77 per 100g',
            'protein': '2g',
            'carbs': '17g',
            'fiber': '2.2g',
            'vitamins': 'Vitamin C, B6, Potassium',
          },
        },

        // Dairy & Eggs
        {
          'name': 'Farm Fresh Eggs',
          'description': 'Free-range chicken eggs from happy hens',
          'price': 5.99,
          'unit': 'dozen',
          'category': 'Dairy & Eggs',
          'imageUrl':
              'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=400',
          'ingredients': 'Free-range Chicken Eggs',
          'nutritionInfo': {
            'calories': '155 per 100g',
            'protein': '13g',
            'fat': '11g',
            'carbs': '1.1g',
            'vitamins': 'Vitamin A, D, B12',
          },
        },
        {
          'name': 'Whole Milk',
          'description': 'Fresh whole milk from grass-fed cows',
          'price': 4.49,
          'unit': 'liter',
          'category': 'Dairy & Eggs',
          'imageUrl':
              'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400&q=80',
          'ingredients': 'Whole Milk',
          'nutritionInfo': {
            'calories': '61 per 100ml',
            'protein': '3.2g',
            'fat': '3.3g',
            'carbs': '4.8g',
            'vitamins': 'Calcium, Vitamin D, B12',
          },
        },
        {
          'name': 'Greek Yogurt',
          'description': 'Creamy Greek yogurt, high in protein',
          'price': 6.99,
          'unit': 'kg',
          'category': 'Dairy & Eggs',
          'imageUrl':
              'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&q=80',
          'ingredients': 'Milk, Live Cultures',
          'nutritionInfo': {
            'calories': '59 per 100g',
            'protein': '10g',
            'fat': '0.4g',
            'carbs': '3.6g',
            'vitamins': 'Calcium, Probiotics',
          },
        },

        // Grains
        {
          'name': 'Brown Rice',
          'description': 'Nutritious whole grain brown rice',
          'price': 3.99,
          'unit': 'kg',
          'category': 'Grains',
          'imageUrl':
              'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400',
          'ingredients': 'Organic Brown Rice',
          'nutritionInfo': {
            'calories': '111 per 100g',
            'protein': '2.6g',
            'carbs': '23g',
            'fiber': '1.8g',
            'vitamins': 'Magnesium, Phosphorus',
          },
        },
        {
          'name': 'Whole Wheat Flour',
          'description': 'Stone-ground whole wheat flour',
          'price': 4.99,
          'unit': 'kg',
          'category': 'Grains',
          'imageUrl':
              'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400&q=80',
          'ingredients': 'Whole Wheat',
          'nutritionInfo': {
            'calories': '340 per 100g',
            'protein': '13g',
            'carbs': '72g',
            'fiber': '11g',
            'vitamins': 'Iron, B Vitamins',
          },
        },
        {
          'name': 'Organic Oats',
          'description': 'Rolled oats, perfect for breakfast',
          'price': 5.49,
          'unit': 'kg',
          'category': 'Grains',
          'imageUrl':
              'https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?w=400&q=80',
          'ingredients': 'Organic Rolled Oats',
          'nutritionInfo': {
            'calories': '389 per 100g',
            'protein': '17g',
            'carbs': '66g',
            'fiber': '11g',
            'vitamins': 'Iron, Magnesium, Zinc',
          },
        },

        // Seeds (moved to Others category)
        {
          'name': 'Tomato Seeds',
          'description': 'Premium hybrid tomato seeds for home gardening',
          'price': 3.99,
          'unit': 'pack',
          'category': 'Others',
          'imageUrl':
              'https://images.unsplash.com/photo-1592921870789-04563d55041c?w=400',
          'ingredients': 'Tomato Seeds',
          'nutritionInfo': {},
        },
        {
          'name': 'Carrot Seeds',
          'description': 'Organic carrot seeds, easy to grow',
          'price': 2.99,
          'unit': 'pack',
          'category': 'Others',
          'imageUrl':
              'https://images.unsplash.com/photo-1464226184884-fa280b87c399?w=400',
          'ingredients': 'Carrot Seeds',
          'nutritionInfo': {},
        },
        {
          'name': 'Lettuce Seeds',
          'description': 'Fast-growing lettuce seeds for fresh salads',
          'price': 2.49,
          'unit': 'pack',
          'category': 'Others',
          'imageUrl':
              'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400&q=80',
          'ingredients': 'Lettuce Seeds',
          'nutritionInfo': {},
        },

        // Plants (now in Others category)
        {
          'name': 'Rose Plant',
          'description': 'Beautiful red rose plant, perfect for gardens',
          'price': 12.99,
          'unit': 'plant',
          'category': 'Others',
          'imageUrl':
              'https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=400',
          'ingredients': 'Live Rose Plant',
          'nutritionInfo': {},
        },
        {
          'name': 'Marigold Plant',
          'description': 'Bright marigold plants, pest-resistant',
          'price': 5.99,
          'unit': 'plant',
          'category': 'Others',
          'imageUrl':
              'https://images.unsplash.com/photo-1469259943454-aa100abba749?w=400',
          'ingredients': 'Live Marigold Plant',
          'nutritionInfo': {},
        },
        {
          'name': 'Tulsi Plant (Holy Basil)',
          'description': 'Sacred tulsi plant with medicinal properties',
          'price': 8.99,
          'unit': 'plant',
          'category': 'Others',
          'imageUrl':
              'https://images.unsplash.com/photo-1550320219-2c2aa8fe8c31?w=400',
          'ingredients': 'Live Tulsi Plant',
          'nutritionInfo': {},
        },

        // Others (gardening tools + organic fertilizer)
        {
          'name': 'Organic Fertilizer',
          'description': 'Premium organic fertilizer for healthy plants',
          'price': 15.99,
          'unit': '5kg bag',
          'category': 'Others',
          'imageUrl':
              'https://images.unsplash.com/photo-1563514227147-6d2ff665a6a0?w=400',
          'ingredients': 'Compost, Natural Minerals',
          'nutritionInfo': {},
        },
        {
          'name': 'Garden Tool Set',
          'description': 'Complete set of essential gardening tools',
          'price': 29.99,
          'unit': 'set',
          'category': 'Others',
          'imageUrl':
              'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400',
          'ingredients': 'Metal tools with wooden handles',
          'nutritionInfo': {},
        },
        {
          'name': 'Plant Growth Spray',
          'description': 'Organic plant growth enhancer spray',
          'price': 9.99,
          'unit': 'bottle',
          'category': 'Others',
          'imageUrl':
              'https://images.unsplash.com/photo-1523348837708-15d4a09cfac2?w=400',
          'ingredients': 'Natural plant extracts',
          'nutritionInfo': {},
        },
      ];

      int successCount = 0;
      int skippedCount = 0;

      for (var productData in sampleProducts) {
        final productName = productData['name'] as String;
        
        // Check if product already exists
        final existingQuery = await FirebaseFirestore.instance
            .collection('products')
            .where('name', isEqualTo: productName)
            .where('farmerId', isEqualTo: user.uid)
            .limit(1)
            .get();
            
        if (existingQuery.docs.isNotEmpty) {
          skippedCount++;
          setState(() {
            _message = 'Processed $successCount added, $skippedCount skipped';
          });
          continue;
        }

        final docRef = FirebaseFirestore.instance.collection('products').doc();

        final product = ProductModel(
          productId: docRef.id,
          name: productName,
          description: productData['description'] as String,
          price: productData['price'] as double,
          unit: productData['unit'] as String,
          category: productData['category'] as String,
          farmerId: user.uid,
          farmerName: user.name,
          imageUrl: productData['imageUrl'] as String?,
          isAvailable: true,
          createdAt: DateTime.now(),
        );

        // Add product with additional fields
        await docRef.set({
          ...product.toMap(),
          'ingredients': productData['ingredients'],
          'nutritionInfo': productData['nutritionInfo'],
        });

        successCount++;

        setState(() {
          _message = 'Added $successCount of ${sampleProducts.length} products';
        });
      }

      setState(() {
        _isLoading = false;
        _message = '✅ Added $successCount new products! Skipped $skippedCount existing ones.';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added $successCount new products, skipped $skippedCount existing'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _message = '❌ Error: $e';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Sample Products')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 32),
            Text(
              'Populate Sample Products',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'This will add 25+ sample products across categories: Fruits, Vegetables, Dairy & Eggs, Grains, Seeds, and Others (plants, gardening tools & fertilizers) with images.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (_message.isNotEmpty)
              Card(
                color: _message.contains('✅')
                    ? Colors.green.shade50
                    : _message.contains('❌')
                    ? Colors.red.shade50
                    : Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Clear All Products',
              onPressed: _clearAllProducts,
              isLoading: _isLoading,
              icon: Icons.clear_all,
              backgroundColor: Colors.red,
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Remove Duplicate Products',
              onPressed: _removeDuplicateProducts,
              isLoading: _isLoading,
              icon: Icons.delete_sweep,
              backgroundColor: Colors.orange,
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Add Sample Products',
              onPressed: _handleAddProducts,
              isLoading: _isLoading,
              icon: Icons.add_circle,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
