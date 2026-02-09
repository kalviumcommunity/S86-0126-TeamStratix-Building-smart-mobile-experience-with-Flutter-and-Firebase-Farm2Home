import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

/// Model class for uploaded media
class UploadedMedia {
  final String fileName;
  final String downloadUrl;
  final DateTime uploadedAt;
  final String fileSize;
  final String fileType;

  UploadedMedia({
    required this.fileName,
    required this.downloadUrl,
    required this.uploadedAt,
    required this.fileSize,
    required this.fileType,
  });
}

/// Service for handling media uploads to Firebase Storage
class MediaUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  /// Pick an image from device gallery
  Future<XFile?> pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxHeight: 1920,
        maxWidth: 1080,
      );
      return image;
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }

  /// Pick multiple images from device gallery
  Future<List<XFile>> pickMultipleImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        imageQuality: 85,
        maxHeight: 1920,
        maxWidth: 1080,
      );
      return images;
    } catch (e) {
      throw Exception('Failed to pick images: $e');
    }
  }

  /// Upload a single image to Firebase Storage
  /// Returns the download URL of the uploaded image
  Future<String> uploadImage(XFile imageFile) async {
    try {
      final File file = File(imageFile.path);

      // Create unique filename with timestamp
      final String fileName =
          'images/${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}';

      // Upload file to Firebase Storage
      final TaskSnapshot uploadTask =
          await _storage.ref(fileName).putFile(file);

      // Get and return download URL
      final String downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Upload multiple images to Firebase Storage
  /// Returns list of download URLs
  Future<List<String>> uploadMultipleImages(List<XFile> imageFiles) async {
    try {
      final List<String> downloadUrls = [];

      for (final imageFile in imageFiles) {
        final String url = await uploadImage(imageFile);
        downloadUrls.add(url);
      }

      return downloadUrls;
    } catch (e) {
      throw Exception('Failed to upload images: $e');
    }
  }

  /// Upload image with progress tracking
  /// Useful for showing upload progress to user
  Future<String> uploadImageWithProgress(
    XFile imageFile,
    Function(double) onProgress,
  ) async {
    try {
      final File file = File(imageFile.path);

      // Create unique filename
      final String fileName =
          'images/${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}';

      // Upload with progress monitoring
      final UploadTask uploadTask = _storage.ref(fileName).putFile(file);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = (snapshot.bytesTransferred / snapshot.totalBytes);
        onProgress(progress);
      });

      final TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image with progress: $e');
    }
  }

  /// Delete image from Firebase Storage
  Future<void> deleteImage(String downloadUrl) async {
    try {
      // Extract file path from download URL
      final String filePath = Uri.parse(downloadUrl)
          .pathSegments
          .where((segment) => segment.isNotEmpty)
          .join('/');

      await _storage.ref(filePath).delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  /// Delete image by file name/path
  Future<void> deleteImageByPath(String storagePath) async {
    try {
      await _storage.ref(storagePath).delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  /// Get file size in human readable format
  String getFileSizeString(int bytes) {
    const int kb = 1024;
    const int mb = kb * 1024;

    if (bytes < kb) {
      return '$bytes B';
    } else if (bytes < mb) {
      return '${(bytes / kb).toStringAsFixed(2)} KB';
    } else {
      return '${(bytes / mb).toStringAsFixed(2)} MB';
    }
  }

  /// Get file extension from file path
  String getFileExtension(String filePath) {
    return filePath.split('.').last.toUpperCase();
  }

  /// Validate image file
  bool isValidImageFile(XFile file) {
    final String extension = file.name.split('.').last.toLowerCase();
    const List<String> validExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];

    return validExtensions.contains(extension);
  }

  /// Create uploaded media object with metadata
  Future<UploadedMedia> createUploadedMediaFromFile(
    XFile file,
    String downloadUrl,
  ) async {
    final int fileSize = await File(file.path).length();
    final String fileType = getFileExtension(file.name);
    final String fileSizeString = getFileSizeString(fileSize);

    return UploadedMedia(
      fileName: file.name,
      downloadUrl: downloadUrl,
      uploadedAt: DateTime.now(),
      fileSize: fileSizeString,
      fileType: fileType,
    );
  }

  /// List all images in a specific folder in Storage
  Future<List<Reference>> listImagesInFolder(String folderPath) async {
    try {
      final ListResult result = await _storage.ref(folderPath).listAll();
      return result.items;
    } catch (e) {
      throw Exception('Failed to list images: $e');
    }
  }

  /// Get metadata for a file in Storage
  Future<FullMetadata?> getFileMetadata(String storagePath) async {
    try {
      final FullMetadata metadata = await _storage.ref(storagePath).getMetadata();
      return metadata;
    } catch (e) {
      throw Exception('Failed to get metadata: $e');
    }
  }
}
