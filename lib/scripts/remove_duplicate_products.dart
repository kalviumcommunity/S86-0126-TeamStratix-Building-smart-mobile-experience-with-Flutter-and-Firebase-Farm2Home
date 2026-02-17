import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Script to remove duplicate products from Firestore
/// Run this ONCE to clean up any duplicate documents
///
/// Usage: Call removeDuplicateProducts() from admin screen or run as script
Future<Map<String, dynamic>> removeDuplicateProducts() async {
  try {
    debugPrint('🔍 Scanning for duplicate products...');

    // Get all products
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .get();

    debugPrint('📊 Found ${snapshot.docs.length} total documents');

    // Map to track unique products by productId
    final Map<String, DocumentSnapshot> uniqueProducts = {};
    final List<String> duplicatesToDelete = [];

    for (var doc in snapshot.docs) {
      final productId = doc.id; // Document ID is the productId

      if (uniqueProducts.containsKey(productId)) {
        // This is a duplicate! Mark for deletion
        duplicatesToDelete.add(doc.id);
        debugPrint(
          '⚠️  Duplicate found: ${doc.data()['name']} (ID: $productId)',
        );
      } else {
        // First occurrence, keep it
        uniqueProducts[productId] = doc;
      }
    }

    if (duplicatesToDelete.isEmpty) {
      debugPrint('✅ No duplicates found! Database is clean.');
      return {
        'success': true,
        'message': 'No duplicates found',
        'deletedCount': 0,
        'uniqueCount': uniqueProducts.length,
      };
    }

    // Delete duplicates
    debugPrint(
      '🗱️  Deleting ${duplicatesToDelete.length} duplicate documents...',
    );

    final batch = FirebaseFirestore.instance.batch();
    for (var docId in duplicatesToDelete) {
      batch.delete(
        FirebaseFirestore.instance.collection('products').doc(docId),
      );
    }

    await batch.commit();

    debugPrint(
      '✅ Successfully deleted ${duplicatesToDelete.length} duplicates',
    );
    debugPrint('📦 ${uniqueProducts.length} unique products remain');

    return {
      'success': true,
      'message': 'Duplicates removed successfully',
      'deletedCount': duplicatesToDelete.length,
      'uniqueCount': uniqueProducts.length,
    };
  } catch (e) {
    debugPrint('❌ Error removing duplicates: $e');
    return {
      'success': false,
      'message': 'Error: $e',
      'deletedCount': 0,
      'uniqueCount': 0,
    };
  }
}

/// Alternative: Remove products with same name (if productId is different)
Future<Map<String, dynamic>> removeDuplicateProductsByName() async {
  try {
    debugPrint('🔍 Scanning for products with duplicate names...');

    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .get();

    debugPrint('📊 Found ${snapshot.docs.length} total documents');

    // Map to track unique products by name
    final Map<String, DocumentSnapshot> uniqueProducts = {};
    final List<String> duplicatesToDelete = [];

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>?;
      final productName = data?['name'] as String? ?? 'Unknown';

      if (uniqueProducts.containsKey(productName)) {
        // Duplicate name found! Keep the newer one
        final existing = uniqueProducts[productName]!;
        final existingData = existing.data() as Map<String, dynamic>?;
        final existingTimestamp = existingData?['createdAt'] as Timestamp?;
        final currentTimestamp = data?['createdAt'] as Timestamp?;

        // Compare timestamps (keep newer, delete older)
        if (currentTimestamp != null && existingTimestamp != null) {
          if (currentTimestamp.compareTo(existingTimestamp) > 0) {
            // Current is newer, delete existing
            duplicatesToDelete.add(existing.id);
            uniqueProducts[productName] = doc;
            debugPrint(
              '⚠️  Duplicate name: $productName - Keeping newer (${doc.id})',
            );
          } else {
            // Existing is newer, delete current
            duplicatesToDelete.add(doc.id);
            debugPrint(
              '⚠️  Duplicate name: $productName - Keeping newer (${existing.id})',
            );
          }
        } else {
          // No timestamp, just keep first and delete rest
          duplicatesToDelete.add(doc.id);
          debugPrint(
            '⚠️  Duplicate name: $productName - Keeping first occurrence',
          );
        }
      } else {
        // First occurrence
        uniqueProducts[productName] = doc;
      }
    }

    if (duplicatesToDelete.isEmpty) {
      debugPrint('✅ No duplicate names found! Database is clean.');
      return {
        'success': true,
        'message': 'No duplicate names found',
        'deletedCount': 0,
        'uniqueCount': uniqueProducts.length,
      };
    }

    // Delete duplicates
    debugPrint(
      '🗑️  Deleting ${duplicatesToDelete.length} duplicate documents...',
    );

    final batch = FirebaseFirestore.instance.batch();
    for (var docId in duplicatesToDelete) {
      batch.delete(
        FirebaseFirestore.instance.collection('products').doc(docId),
      );
    }

    await batch.commit();

    debugPrint(
      '✅ Successfully deleted ${duplicatesToDelete.length} duplicates',
    );
    debugPrint('📦 ${uniqueProducts.length} unique products remain');

    return {
      'success': true,
      'message': 'Duplicates removed successfully',
      'deletedCount': duplicatesToDelete.length,
      'uniqueCount': uniqueProducts.length,
    };
  } catch (e) {
    debugPrint('❌ Error removing duplicates: $e');
    return {
      'success': false,
      'message': 'Error: $e',
      'deletedCount': 0,
      'uniqueCount': 0,
    };
  }
}

/// Get product statistics
Future<void> printProductStatistics() async {
  debugPrint('📊 Product Statistics:');
  debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

  final snapshot = await FirebaseFirestore.instance
      .collection('products')
      .get();

  final Map<String, int> categoryCounts = {};
  final Map<String, int> nameCounts = {};

  for (var doc in snapshot.docs) {
    final data = doc.data() as Map<String, dynamic>?;
    final category = data?['category'] as String? ?? 'Unknown';
    final name = data?['name'] as String? ?? 'Unknown';

    categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
    nameCounts[name] = (nameCounts[name] ?? 0) + 1;
  }

  debugPrint('Total Products: ${snapshot.docs.length}');
  debugPrint('\\nBy Category:');
  categoryCounts.forEach((category, itemCount) {
    debugPrint('  • $category: $itemCount');
  });

  debugPrint('\\nDuplicate Names:');
  final duplicateNames = nameCounts.entries.where((e) => e.value > 1).toList();
  if (duplicateNames.isEmpty) {
    debugPrint('  ✅ No duplicate names found');
  } else {
    for (var entry in duplicateNames) {
      debugPrint('  ⚠️  ${entry.key}: ${entry.value} occurrences');
    }
  }

  debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
}
