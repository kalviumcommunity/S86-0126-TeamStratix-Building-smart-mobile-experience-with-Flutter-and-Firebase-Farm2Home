import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }

  /// Pick image from camera
  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to capture image: $e');
    }
  }

  /// Upload product image to Firebase Storage
  /// Returns the download URL
  Future<String> uploadProductImage({
    File? imageFile,
    Uint8List? imageBytes,
    required String productId,
    String? farmerId,
  }) async {
    try {
      // Validate that at least one image source is provided
      if (imageFile == null && imageBytes == null) {
        throw Exception('Either imageFile or imageBytes must be provided');
      }

      // Create a unique filename
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = 'product_${productId}_$timestamp.jpg';

      // Define the storage path
      final String path = farmerId != null
          ? 'products/$farmerId/$fileName'
          : 'products/general/$fileName';

      // Upload the file
      final Reference ref = _storage.ref().child(path);
      final UploadTask uploadTask;
      
      if (kIsWeb || imageBytes != null) {
        // For web or when bytes are provided
        uploadTask = ref.putData(
          imageBytes!,
          SettableMetadata(
            contentType: 'image/jpeg',
            customMetadata: {
              'productId': productId,
              ...?farmerId != null ? {'farmerId': farmerId} : null,
              'uploadedAt': DateTime.now().toIso8601String(),
            },
          ),
        );
      } else {
        // For mobile/desktop with File
        uploadTask = ref.putFile(
          imageFile!,
          SettableMetadata(
            contentType: 'image/jpeg',
            customMetadata: {
              'productId': productId,
              ...?farmerId != null ? {'farmerId': farmerId} : null,
              'uploadedAt': DateTime.now().toIso8601String(),
            },
          ),
        );
      }

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get and return the download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Delete product image from Firebase Storage
  Future<void> deleteProductImage(String imageUrl) async {
    try {
      // Extract the path from the download URL
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  /// Upload multiple product images
  Future<List<String>> uploadMultipleProductImages({
    required List<File> imageFiles,
    required String productId,
    String? farmerId,
  }) async {
    final List<String> downloadUrls = [];

    for (int i = 0; i < imageFiles.length; i++) {
      try {
        final String url = await uploadProductImage(
          imageFile: imageFiles[i],
          productId: '${productId}_$i',
          farmerId: farmerId,
        );
        downloadUrls.add(url);
      } catch (e) {
        // Continue with other images even if one fails
        continue;
      }
    }

    return downloadUrls;
  }

  /// Get upload progress stream
  Stream<TaskSnapshot> getUploadProgress({
    required File imageFile,
    required String productId,
    String? farmerId,
  }) {
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String fileName = 'product_${productId}_$timestamp.jpg';
    final String path = farmerId != null
        ? 'products/$farmerId/$fileName'
        : 'products/general/$fileName';

    final Reference ref = _storage.ref().child(path);
    final UploadTask uploadTask = ref.putFile(imageFile);

    return uploadTask.snapshotEvents;
  }
}
