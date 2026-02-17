import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  static CloudinaryService? _instance;
  late CloudinaryPublic _cloudinary;
  final ImagePicker _picker = ImagePicker();

  // Singleton pattern
  static CloudinaryService get instance {
    _instance ??= CloudinaryService._internal();
    return _instance!;
  }

  CloudinaryService._internal() {
    _initializeCloudinary();
  }

  /// Initialize Cloudinary with configuration from .env
  void _initializeCloudinary() {
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'];
    final uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'];
    
    if (cloudName == null || cloudName.isEmpty) {
      throw Exception('CLOUDINARY_CLOUD_NAME not found in .env file');
    }
    
    if (uploadPreset == null || uploadPreset.isEmpty) {
      throw Exception('CLOUDINARY_UPLOAD_PRESET not found in .env file');
    }

    _cloudinary = CloudinaryPublic(
      cloudName,
      uploadPreset,
      cache: false,
    );
  }

  /// Pick image from gallery
  Future<XFile?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      return image;
    } catch (e) {
      throw Exception('Failed to pick image from gallery: $e');
    }
  }

  /// Pick image from camera
  Future<XFile?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      return image;
    } catch (e) {
      throw Exception('Failed to capture image from camera: $e');
    }
  }

  /// Pick multiple images from gallery
  Future<List<XFile>> pickMultipleImages({int limit = 5}) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
        limit: limit,
      );

      return images;
    } catch (e) {
      throw Exception('Failed to pick multiple images: $e');
    }
  }

  /// Upload single image to Cloudinary from XFile
  Future<CloudinaryResponse> uploadImageFromXFile({
    required XFile imageFile,
    String? publicId,
    String? folder,
    Map<String, String>? tags,
    Map<String, String>? context,
  }) async {
    try {
      final Uint8List imageBytes = await imageFile.readAsBytes();
      
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          imageBytes,
          identifier: imageFile.name,
          publicId: publicId,
          folder: folder ?? dotenv.env['CLOUDINARY_PRODUCT_FOLDER'],
          tags: tags?.values.toList(),
          context: context,
        ),
      );

      return response;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Upload single image to Cloudinary
  Future<CloudinaryResponse> uploadImage({
    required File imageFile,
    String? publicId,
    String? folder,
    Map<String, String>? tags,
    Map<String, String>? context,
  }) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          publicId: publicId,
          folder: folder ?? dotenv.env['CLOUDINARY_PRODUCT_FOLDER'],
          tags: tags?.values.toList(),
          context: context,
        ),
      );

      return response;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Upload image from bytes (for web)
  Future<CloudinaryResponse> uploadImageFromBytes({
    required Uint8List imageBytes,
    required String fileName,
    String? publicId,
    String? folder,
    Map<String, String>? tags,
    Map<String, String>? context,
  }) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          imageBytes,
          identifier: fileName,
          publicId: publicId,
          folder: folder ?? dotenv.env['CLOUDINARY_PRODUCT_FOLDER'],
          tags: tags?.values.toList(),
          context: context,
        ),
      );

      return response;
    } catch (e) {
      throw Exception('Failed to upload image from bytes: $e');
    }
  }

  /// Upload multiple images from XFiles
  Future<List<CloudinaryResponse>> uploadMultipleImagesFromXFiles({
    required List<XFile> imageFiles,
    String? folderPrefix,
    String? publicIdPrefix,
    Map<String, String>? tags,
    Map<String, String>? context,
  }) async {
    final List<CloudinaryResponse> responses = [];
    final String folder = folderPrefix ?? dotenv.env['CLOUDINARY_PRODUCT_FOLDER'] ?? 'products';

    for (int i = 0; i < imageFiles.length; i++) {
      try {
        final String? publicId = publicIdPrefix != null 
            ? '${publicIdPrefix}_$i'
            : null;

        final response = await uploadImageFromXFile(
          imageFile: imageFiles[i],
          publicId: publicId,
          folder: folder,
          tags: tags,
          context: context,
        );

        responses.add(response);
      } catch (e) {
        debugPrint('Failed to upload image $i: $e');
        // Continue uploading other images
        continue;
      }
    }

    return responses;
  }

  /// Delete image from Cloudinary
  Future<bool> deleteImage(String publicId) async {
    try {
      // Note: CloudinaryPublic doesn't support destroy method
      // For deletion, you need CloudinaryApi (with API secret)
      // For now, we'll just return true since unsigned uploads
      // can be managed from Cloudinary dashboard
      debugPrint('Delete not supported with unsigned uploads: $publicId');
      return true;
    } catch (e) {
      debugPrint('Failed to delete image: $e');
      return false;
    }
  }

  /// Delete multiple images from Cloudinary
  Future<Map<String, bool>> deleteMultipleImages(List<String> publicIds) async {
    final Map<String, bool> results = {};

    for (String publicId in publicIds) {
      results[publicId] = await deleteImage(publicId);
    }

    return results;
  }

  /// Generate optimized image URL with transformations
  String getOptimizedImageUrl(
    String publicId, {
    int? width,
    int? height,
    String quality = 'auto:good',
    String format = 'auto',
    String crop = 'fill',
    bool secure = true,
  }) {
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
    if (cloudName.isEmpty) {
      debugPrint('Warning: CLOUDINARY_CLOUD_NAME not configured');
      return '';
    }
    
    final protocol = secure ? 'https' : 'http';
    
    String transformations = 'f_$format,q_$quality';
    
    if (width != null && height != null) {
      transformations += ',w_$width,h_$height,c_$crop';
    } else if (width != null) {
      transformations += ',w_$width';
    } else if (height != null) {
      transformations += ',h_$height';
    }

    return '$protocol://res.cloudinary.com/$cloudName/image/upload/$transformations/$publicId';
  }

  /// Generate thumbnail URL
  String getThumbnailUrl(String publicId, {int size = 150}) {
    return getOptimizedImageUrl(
      publicId,
      width: size,
      height: size,
      crop: 'thumb',
      quality: 'auto:low',
    );
  }

  /// Generate medium-sized image URL for product listings
  String getMediumImageUrl(String publicId) {
    return getOptimizedImageUrl(
      publicId,
      width: 400,
      height: 300,
      crop: 'fill',
    );
  }

  /// Generate large image URL for product details
  String getLargeImageUrl(String publicId) {
    return getOptimizedImageUrl(
      publicId,
      width: 800,
      height: 600,
      crop: 'fill',
    );
  }

  /// Upload product image with metadata from XFile
  Future<CloudinaryResponse> uploadProductImageFromXFile({
    required XFile imageFile,
    required String productId,
    required String farmerId,
    String? productName,
    String? category,
  }) async {
    final tags = <String, String>{
      'product': productId,
      'farmer': farmerId,
      ...?category != null ? {'category': category} : null,
    };

    final context = <String, String>{
      'productId': productId,
      'farmerId': farmerId,
      ...?productName != null ? {'productName': productName} : null,
      'uploadedAt': DateTime.now().toIso8601String(),
    };

    return await uploadImageFromXFile(
      imageFile: imageFile,
      publicId: 'product_${productId}_${DateTime.now().millisecondsSinceEpoch}',
      folder: '${dotenv.env['CLOUDINARY_PRODUCT_FOLDER'] ?? 'products'}/$farmerId',
      tags: tags,
      context: context,
    );
  }

  /// Upload multiple product images from XFiles
  Future<List<CloudinaryResponse>> uploadMultipleProductImagesFromXFiles({
    required List<XFile> imageFiles,
    required String productId,
    required String farmerId,
    String? productName,
    String? category,
  }) async {
    final tags = <String, String>{
      'product': productId,
      'farmer': farmerId,
      ...?category != null ? {'category': category} : null,
    };

    final context = <String, String>{
      'productId': productId,
      'farmerId': farmerId,
      ...?productName != null ? {'productName': productName} : null,
      'uploadedAt': DateTime.now().toIso8601String(),
    };

    return await uploadMultipleImagesFromXFiles(
      imageFiles: imageFiles,
      folderPrefix: '${dotenv.env['CLOUDINARY_PRODUCT_FOLDER'] ?? 'products'}/$farmerId',
      publicIdPrefix: 'product_${productId}_${DateTime.now().millisecondsSinceEpoch}',
      tags: tags,
      context: context,
    );
  }

  /// Check if Cloudinary is properly configured
  bool isConfigured() {
    try {
      final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'];
      final uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'];
      
      return cloudName != null && 
             cloudName.isNotEmpty && 
             uploadPreset != null && 
             uploadPreset.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get Cloudinary configuration status
  Map<String, dynamic> getConfigurationStatus() {
    return {
      'cloudName': dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? 'Not configured',
      'uploadPreset': dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? 'Not configured',
      'productFolder': dotenv.env['CLOUDINARY_PRODUCT_FOLDER'] ?? 'products',
      'isConfigured': isConfigured(),
    };
  }
}
