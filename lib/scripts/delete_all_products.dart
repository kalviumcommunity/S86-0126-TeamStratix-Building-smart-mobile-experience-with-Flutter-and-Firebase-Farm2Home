import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../firebase_options.dart';

/// Script to delete ALL products from Firestore
/// 
/// WARNING: This will permanently delete all products!
/// Run this script with: flutter run lib/scripts/delete_all_products.dart
Future<void> main() async {
  debugPrint('🔥 Initializing Firebase...');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint('📦 Connecting to Firestore...');
  final firestore = FirebaseFirestore.instance;
  final productsRef = firestore.collection('products');

  try {
    debugPrint('🔍 Fetching all products...');
    final snapshot = await productsRef.get();
    final totalCount = snapshot.docs.length;

    if (totalCount == 0) {
      debugPrint('✅ No products found. Database is already clean!');
      return;
    }

    debugPrint('⚠️  Found $totalCount products to delete');
    debugPrint('🗑️  Starting deletion process...');

    int deletedCount = 0;
    
    // Delete in batches (Firestore batch limit is 500)
    final batchSize = 500;
    for (int i = 0; i < snapshot.docs.length; i += batchSize) {
      final batch = firestore.batch();
      final end = (i + batchSize < snapshot.docs.length) 
          ? i + batchSize 
          : snapshot.docs.length;
      
      for (int j = i; j < end; j++) {
        batch.delete(snapshot.docs[j].reference);
        deletedCount++;
      }
      
      await batch.commit();
      debugPrint('   Deleted $deletedCount / $totalCount products...');
    }

    debugPrint('✅ Successfully deleted $deletedCount products!');
    debugPrint('🎉 Database is now clean!');
    
  } catch (e) {
    debugPrint('❌ Error deleting products: $e');
    rethrow;
  }
}
