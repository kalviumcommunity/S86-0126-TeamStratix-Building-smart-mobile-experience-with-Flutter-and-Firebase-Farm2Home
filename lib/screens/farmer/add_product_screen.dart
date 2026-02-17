import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/auth_provider.dart';
import '../../services/image_storage_service.dart';
import '../../models/product_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _unitController = TextEditingController(text: 'kg');
  final _ingredientsController = TextEditingController();
  final _stockController = TextEditingController(text: '100');

  final ImageStorageService _imageService = ImageStorageService();

  String _selectedCategory = 'Vegetables';
  final List<String> _categories = [
    'Vegetables',
    'Fruits',
    'Dairy & Eggs',
    'Grains',
    'Seeds',
    'Flower Plants',
    'Others',
  ];

  File? _selectedImage;
  Uint8List? _webImage;
  bool _isLoading = false;
  bool _isUploading = false;
  final double _uploadProgress = 0.0;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _unitController.dispose();
    _ingredientsController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          // For web platform, read as bytes
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _webImage = bytes;
            _selectedImage = null;
          });
        } else {
          // For mobile/desktop, use File
          setState(() {
            _selectedImage = File(pickedFile.path);
            _webImage = null;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (!kIsWeb) ...[
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Generate product ID
      final productId = DateTime.now().millisecondsSinceEpoch.toString();

      // Upload image if selected
      String? imageUrl;
      if (_selectedImage != null || _webImage != null) {
        setState(() {
          _isUploading = true;
        });

        try {
          imageUrl = await _imageService.uploadProductImage(
            imageFile: _selectedImage,
            imageBytes: _webImage,
            productId: productId,
            farmerId: currentUser.uid,
          );
        } catch (uploadError) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Image upload failed: $uploadError\n'
                  'CORS issue? Run: .\\setup-cors.ps1',
                ),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 5),
              ),
            );
          }
          // Continue without image
          imageUrl = null;
        } finally {
          setState(() {
            _isUploading = false;
          });
        }
      }

      // Create product
      final product = ProductModel(
        productId: productId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        unit: _unitController.text.trim(),
        category: _selectedCategory,
        farmerId: currentUser.uid,
        farmerName: currentUser.name,
        imageUrl: imageUrl,
        isAvailable: true,
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .set(product.toMap());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form
        _formKey.currentState!.reset();
        _nameController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _unitController.text = 'kg';
        _ingredientsController.clear();
        _stockController.text = '100';
        setState(() {
          _selectedImage = null;
          _webImage = null;
          _selectedCategory = 'Vegetables';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add product: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CORS Warning for Web Platform
              if (kIsWeb) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    border: Border.all(color: Colors.blue.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Web Platform: If image upload fails, run setup-cors.ps1 to fix CORS.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              // Image Picker
              Center(
                child: GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: _selectedImage != null || _webImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: kIsWeb
                                ? Image.memory(
                                    _webImage!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  )
                                : Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap to add product image',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              if (_isUploading) ...[
                const SizedBox(height: 16),
                LinearProgressIndicator(value: _uploadProgress),
                const SizedBox(height: 8),
                const Center(
                  child: Text('Uploading image...'),
                ),
              ],

              const SizedBox(height: 24),

              // Product Name
              CustomTextField(
                controller: _nameController,
                label: 'Product Name',
                hint: 'e.g., Fresh Tomatoes',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Price and Unit
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomTextField(
                      controller: _priceController,
                      label: 'Price',
                      hint: '0.00',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _unitController,
                      label: 'Unit',
                      hint: 'kg',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Description
              CustomTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Describe your product...',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Ingredients (comma-separated)
              CustomTextField(
                controller: _ingredientsController,
                label: 'Ingredients (comma-separated)',
                hint: 'e.g., Tomatoes, Fresh produce, No preservatives',
                maxLines: 2,
              ),

              const SizedBox(height: 16),

              // Stock
              CustomTextField(
                controller: _stockController,
                label: 'Available Stock (kg/units)',
                hint: '100',
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 32),

              // Add Product Button
              CustomButton(
                text: 'Add Product',
                onPressed: _addProduct,
                isLoading: _isLoading,
                icon: Icons.add_circle,
              ),

              const SizedBox(height: 16),

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
                          'Tips',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Add a clear product image for better visibility\n'
                      '• Write detailed descriptions\n'
                      '• Use comma-separated values for ingredients\n'
                      '• Keep prices competitive',
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
