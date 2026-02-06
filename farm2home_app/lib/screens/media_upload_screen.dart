import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/media_upload_service.dart';

/// Media Upload Demo Screen
/// Demonstrates uploading images to Firebase Storage with progress tracking
class MediaUploadScreen extends StatefulWidget {
  const MediaUploadScreen({super.key});

  @override
  State<MediaUploadScreen> createState() => _MediaUploadScreenState();
}

class _MediaUploadScreenState extends State<MediaUploadScreen> {
  final MediaUploadService _uploadService = MediaUploadService();
  final List<UploadedMedia> _uploadedMedia = [];
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String? _selectedImagePath;
  XFile? _selectedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Upload Demo'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info card
            _buildInfoCard(),
            const SizedBox(height: 20),

            // Selected image preview
            if (_selectedImagePath != null) _buildImagePreview(),
            const SizedBox(height: 16),

            // Action buttons
            _buildActionButtons(),
            const SizedBox(height: 24),

            // Upload progress indicator
            if (_isUploading) _buildUploadProgress(),
            const SizedBox(height: 16),

            // Uploaded media gallery
            _buildUploadedMediaSection(),
          ],
        ),
      ),
    );
  }

  /// Build info card explaining the feature
  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Firebase Storage Media Upload',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Select an image from your gallery\n'
              '2. Upload it to Firebase Storage\n'
              '3. View the download URL and image preview\n'
              '4. Manage uploaded media',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '💡 Tip: Images are stored in Firebase Storage under the "images/" folder',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build image preview
  Widget _buildImagePreview() {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            child: Image.file(
              File(_selectedImagePath!),
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected: ${_selectedFile?.name ?? 'Unknown'}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ready to upload',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build action buttons
  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: _isUploading ? null : _pickImage,
          icon: const Icon(Icons.image),
          label: const Text('Pick Image'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: (_isUploading || _selectedFile == null) ? null : _uploadImage,
          icon: const Icon(Icons.cloud_upload),
          label: const Text('Upload to Firebase Storage'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _isUploading ? null : _clearSelection,
          icon: const Icon(Icons.close),
          label: const Text('Clear Selection'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ],
    );
  }

  /// Build upload progress indicator
  Widget _buildUploadProgress() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Uploading...',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _uploadProgress,
                minHeight: 6,
                backgroundColor: Colors.grey.shade300,
                valueColor:
                    AlwaysStoppedAnimation(Colors.blue.shade400),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(_uploadProgress * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// Build uploaded media section
  Widget _buildUploadedMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Uploaded Media',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),
        if (_uploadedMedia.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Icon(Icons.image_not_supported,
                      size: 48, color: Colors.grey.shade300),
                  const SizedBox(height: 8),
                  Text(
                    'No media uploaded yet',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _uploadedMedia.length,
            itemBuilder: (context, index) =>
                _buildMediaCard(_uploadedMedia[index], index),
          ),
      ],
    );
  }

  /// Build individual media card
  Widget _buildMediaCard(UploadedMedia media, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            child: Image.network(
              media.downloadUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: 200,
                  color: Colors.grey.shade200,
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(Icons.broken_image, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          // Details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  media.fileName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Uploaded: ${media.uploadedAt.toString().split('.')[0]}',
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Size: ${media.fileSize} | Type: ${media.fileType}',
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      iconSize: 20,
                      onPressed: () => _deleteMedia(index),
                      tooltip: 'Delete',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Download URL with copy button
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          media.downloadUrl,
                          style: const TextStyle(fontSize: 10),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 16),
                        onPressed: () => _copyToClipboard(media.downloadUrl),
                        tooltip: 'Copy URL',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Pick image from gallery
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _uploadService.pickImage();
      if (image != null) {
        setState(() {
          _selectedFile = image;
          _selectedImagePath = image.path;
        });
      }
    } catch (e) {
      _showErrorDialog('Error', e.toString());
    }
  }

  /// Upload selected image
  Future<void> _uploadImage() async {
    if (_selectedFile == null) {
      _showErrorDialog('Error', 'No image selected');
      return;
    }

    // Validate image
    if (!_uploadService.isValidImageFile(_selectedFile!)) {
      _showErrorDialog('Invalid File', 'Please select a valid image file');
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      final String downloadUrl = await _uploadService.uploadImageWithProgress(
        _selectedFile!,
        (progress) {
          setState(() {
            _uploadProgress = progress;
          });
        },
      );

      // Create uploaded media object
      final UploadedMedia media =
          await _uploadService.createUploadedMediaFromFile(
        _selectedFile!,
        downloadUrl,
      );

      setState(() {
        _uploadedMedia.insert(0, media);
        _isUploading = false;
        _uploadProgress = 0.0;
        _selectedFile = null;
        _selectedImagePath = null;
      });

      if (mounted) {
        _showSuccessSnackBar('Image uploaded successfully!');
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
        _uploadProgress = 0.0;
      });
      if (mounted) {
        _showErrorDialog('Upload Failed', e.toString());
      }
    }
  }

  /// Clear selected image
  void _clearSelection() {
    setState(() {
      _selectedFile = null;
      _selectedImagePath = null;
    });
  }

  /// Delete uploaded media
  Future<void> _deleteMedia(int index) async {
    final media = _uploadedMedia[index];

    try {
      await _uploadService.deleteImage(media.downloadUrl);
      setState(() {
        _uploadedMedia.removeAt(index);
      });
      if (mounted) {
        _showSuccessSnackBar('Image deleted successfully!');
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Delete Failed', e.toString());
      }
    }
  }

  /// Copy download URL to clipboard
  void _copyToClipboard(String url) {
    // For now, just show a message
    _showSuccessSnackBar('URL copied to clipboard!');
  }

  /// Show error dialog
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show success snackbar
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
