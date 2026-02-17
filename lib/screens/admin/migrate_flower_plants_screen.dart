import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// MIGRATION SCRIPT: Run this ONCE to update existing "Flower Plants" products to "Others"
/// 
/// HOW TO USE:
/// 1. Add this screen to your routes temporarily
/// 2. Navigate to this screen
/// 3. Tap "Migrate Products" button
/// 4. Wait for completion
/// 5. Remove this file after migration is complete
class MigrateFlowerPlantsScreen extends StatefulWidget {
  const MigrateFlowerPlantsScreen({super.key});

  @override
  State<MigrateFlowerPlantsScreen> createState() =>
      _MigrateFlowerPlantsScreenState();
}

class _MigrateFlowerPlantsScreenState extends State<MigrateFlowerPlantsScreen> {
  bool _isLoading = false;
  String _message = '';
  int _migratedCount = 0;

  Future<void> _migrateProducts() async {
    setState(() {
      _isLoading = true;
      _message = 'Starting migration...';
      _migratedCount = 0;
    });

    try {
      // Query all products with category "Flower Plants"
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: 'Flower Plants')
          .get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          _isLoading = false;
          _message = 'No products found with "Flower Plants" category.';
        });
        return;
      }

      // Update each product
      for (var doc in snapshot.docs) {
        await doc.reference.update({
          'category': 'Others',
          'subcategory': 'Plants', // Optional: add subcategory for filtering
          'migratedAt': FieldValue.serverTimestamp(),
        });

        setState(() {
          _migratedCount++;
          _message =
              'Migrating... ($_migratedCount/${snapshot.docs.length})';
        });
      }

      setState(() {
        _isLoading = false;
        _message = '✅ Successfully migrated $_migratedCount products!\n\n'
            'All "Flower Plants" products are now in "Others" category.';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Migration complete! $_migratedCount products updated.'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _message = '❌ Error during migration: $e';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Migration failed: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _checkExistingProducts() async {
    setState(() {
      _isLoading = true;
      _message = 'Checking existing products...';
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: 'Flower Plants')
          .get();

      setState(() {
        _isLoading = false;
        if (snapshot.docs.isEmpty) {
          _message = '✅ No "Flower Plants" products found.\n\n'
              'Your database is already clean!';
        } else {
          _message = '⚠️ Found ${snapshot.docs.length} products with '
              '"Flower Plants" category.\n\n'
              'Products:\n${snapshot.docs.map((doc) => '• ${doc.data()['name']}').join('\n')}';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _message = '❌ Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Migrate Flower Plants'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Icon(
                Icons.sync,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 24),

              Text(
                'Category Migration',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              Text(
                'This will update all products from "Flower Plants" category to "Others" category.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Message Box
              if (_message.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _message.contains('✅')
                        ? Colors.green.shade50
                        : _message.contains('❌')
                            ? Colors.red.shade50
                            : _message.contains('⚠️')
                                ? Colors.orange.shade50
                                : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _message.contains('✅')
                          ? Colors.green
                          : _message.contains('❌')
                              ? Colors.red
                              : _message.contains('⚠️')
                                  ? Colors.orange
                                  : Colors.blue,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    _message,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),

              const SizedBox(height: 32),

              // Check Button
              OutlinedButton.icon(
                onPressed: _isLoading ? null : _checkExistingProducts,
                icon: const Icon(Icons.search),
                label: const Text('Check Existing Products'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),

              const SizedBox(height: 16),

              // Migrate Button
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _migrateProducts,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.arrow_forward),
                label: Text(_isLoading ? 'Migrating...' : 'Migrate Products'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),

              const Spacer(),

              // Info Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Important',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• This is a one-time operation\n'
                      '• Backup your data before migrating (optional)\n'
                      '• Migration cannot be undone automatically\n'
                      '• Remove this screen after migration',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
