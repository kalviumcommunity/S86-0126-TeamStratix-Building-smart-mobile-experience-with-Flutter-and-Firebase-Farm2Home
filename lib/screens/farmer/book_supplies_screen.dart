import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/supply_booking_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/supply_booking_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_widget.dart';

class BookSuppliesScreen extends StatefulWidget {
  const BookSuppliesScreen({super.key});

  @override
  State<BookSuppliesScreen> createState() => _BookSuppliesScreenState();
}

class _BookSuppliesScreenState extends State<BookSuppliesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _estimatedPriceController = TextEditingController();
  final _notesController = TextEditingController();
  
  final SupplyBookingService _bookingService = SupplyBookingService();
  
  String _selectedSupplyType = 'pesticide';
  String _selectedUnit = 'kg';
  String _selectedUrgency = 'medium';
  DateTime _requestedDate = DateTime.now();
  DateTime? _requiredByDate;
  
  bool _isLoading = false;

  final List<String> _supplyTypes = [
    'pesticide',
    'fertilizer',
    'hybrid_seed',
  ];

  final List<String> _units = [
    'kg',
    'grams',
    'liters',
    'packets',
    'bags',
    'bottles',
  ];

  final List<String> _urgencyLevels = [
    'low',
    'medium',
    'high',
  ];

  @override
  void dispose() {
    _productNameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _estimatedPriceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _getSupplyTypeDisplay(String type) {
    switch (type) {
      case 'pesticide':
        return 'Pesticides';
      case 'fertilizer':
        return 'Fertilizers';
      case 'hybrid_seed':
        return 'Hybrid Seeds';
      default:
        return type;
    }
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Future<void> _selectDate(BuildContext context, bool isRequiredDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isRequiredDate 
          ? (_requiredByDate ?? DateTime.now().add(const Duration(days: 7)))
          : _requestedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    
    if (picked != null) {
      setState(() {
        if (isRequiredDate) {
          _requiredByDate = picked;
        } else {
          _requestedDate = picked;
        }
      });
    }
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      final booking = SupplyBookingModel(
        bookingId: '',
        farmerId: user.uid,
        farmerName: user.name,
        supplyType: _selectedSupplyType,
        productName: _productNameController.text.trim(),
        description: _descriptionController.text.trim(),
        quantity: double.parse(_quantityController.text),
        unit: _selectedUnit,
        estimatedPrice: double.parse(_estimatedPriceController.text),
        urgency: _selectedUrgency,
        status: 'pending',
        notes: _notesController.text.trim().isEmpty 
            ? null 
            : _notesController.text.trim(),
        requestedDate: _requestedDate,
        requiredByDate: _requiredByDate,
        createdAt: DateTime.now(),
      );

      await _bookingService.createBooking(booking);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Supply booking request submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit booking: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: LoadingWidget(message: 'Submitting booking request...'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Supplies'),
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
              // Supply Type Selection
              Text(
                'Supply Type',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedSupplyType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: _supplyTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_getSupplyTypeDisplay(type)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSupplyType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Product Name
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_bag_outlined),
                  hintText: 'e.g., NPK Fertilizer, Hybrid Corn Seeds',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description_outlined),
                  hintText: 'Detailed description of requirements',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Quantity and Unit
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.straighten_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter quantity';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedUnit,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Unit',
                      ),
                      items: _units.map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedUnit = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Estimated Price
              TextFormField(
                controller: _estimatedPriceController,
                decoration: const InputDecoration(
                  labelText: 'Estimated Price (\$)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter estimated price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Urgency
              Text(
                'Urgency Level',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedUrgency,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.priority_high_outlined),
                ),
                items: _urgencyLevels.map((urgency) {
                  return DropdownMenuItem(
                    value: urgency,
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _getUrgencyColor(urgency),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(urgency.toUpperCase()),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedUrgency = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Date Selection
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Requested Date',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        InkWell(
                          onTap: () => _selectDate(context, false),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today),
                                const SizedBox(width: 8),
                                Text(
                                  '${_requestedDate.day}/${_requestedDate.month}/${_requestedDate.year}',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Required By (Optional)',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        InkWell(
                          onTap: () => _selectDate(context, true),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today),
                                const SizedBox(width: 8),
                                Text(
                                  _requiredByDate != null
                                      ? '${_requiredByDate!.day}/${_requiredByDate!.month}/${_requiredByDate!.year}'
                                      : 'Select date',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Additional Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Additional Notes (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note_outlined),
                  hintText: 'Any special requirements or additional information',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              // Submit Button
              CustomButton(
                text: 'Submit Booking Request',
                onPressed: _submitBooking,
                icon: Icons.send,
              ),
            ],
          ),
        ),
      ),
    );
  }
}