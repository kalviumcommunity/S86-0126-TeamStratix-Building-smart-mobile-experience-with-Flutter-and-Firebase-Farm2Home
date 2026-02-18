import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/soil_testing_slot_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/soil_testing_service.dart';
import '../../widgets/custom_button.dart';

class BookSoilTestingScreen extends StatefulWidget {
  const BookSoilTestingScreen({super.key});

  @override
  State<BookSoilTestingScreen> createState() => _BookSoilTestingScreenState();
}

class _BookSoilTestingScreenState extends State<BookSoilTestingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _landAreaController = TextEditingController();
  final _soilTypeController = TextEditingController();
  final _cropHistoryController = TextEditingController();
  final _requirementsController = TextEditingController();

  final SoilTestingService _soilTestingService = SoilTestingService();

  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  String _selectedTestType = 'Basic';
  List<String> _availableSlots = [];
  bool _isLoading = false;
  bool _isCheckingAvailability = false;

  @override
  void dispose() {
    _locationController.dispose();
    _phoneController.dispose();
    _landAreaController.dispose();
    _soilTypeController.dispose();
    _cropHistoryController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _selectedTimeSlot = null;
        _availableSlots = [];
        _isCheckingAvailability = true;
      });

      try {
        final availableSlots = await _soilTestingService.getAvailableSlots(picked);
        setState(() {
          _availableSlots = availableSlots;
          _isCheckingAvailability = false;
        });
      } catch (e) {
        setState(() {
          _isCheckingAvailability = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error checking availability: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _bookSlot() async {
    if (!_formKey.currentState!.validate() || 
        _selectedDate == null || 
        _selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      final slot = SoilTestingSlot(
        slotId: '',
        farmerId: user.uid,
        farmerName: user.name,
        farmerPhone: _phoneController.text.trim(),
        farmLocation: _locationController.text.trim(),
        scheduledDate: _selectedDate!,
        timeSlot: _selectedTimeSlot!,
        testType: _selectedTestType,
        status: 'pending',
        soilType: _soilTypeController.text.trim().isNotEmpty 
            ? _soilTypeController.text.trim() : null,
        cropHistory: _cropHistoryController.text.trim().isNotEmpty 
            ? _cropHistoryController.text.trim() : null,
        specificRequirements: _requirementsController.text.trim().isNotEmpty 
            ? _requirementsController.text.trim() : null,
        createdAt: DateTime.now(),
      );

      await _soilTestingService.bookSlot(slot);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Soil testing slot booked successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error booking slot: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Soil Testing'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Info
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.science,
                        size: 48,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Professional Soil Testing',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Get detailed analysis of your soil\'s nutrient content, pH levels, and recommendations for optimal crop growth.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Farm Location
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Farm Location *',
                  hintText: 'Enter your farm address or location',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter farm location';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Phone Number
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Contact Phone *',
                  hintText: 'Enter your phone number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter phone number';
                  }
                  if (value.trim().length < 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Soil Information Section
              Text(
                '2. Soil Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 12),

              // Land Area
              TextFormField(
                controller: _landAreaController,
                decoration: const InputDecoration(
                  labelText: 'Land Area (Acres)',
                  hintText: 'Enter your farm area in acres',
                  prefixIcon: Icon(Icons.landscape),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),

              // Soil Type
              TextFormField(
                controller: _soilTypeController,
                decoration: const InputDecoration(
                  labelText: 'Soil Type *',
                  hintText: 'e.g., Red Soil, Clay, Sandy, Loam',
                  prefixIcon: Icon(Icons.terrain),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter soil type';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Test Type Selection
              Text(
                '3. Appointment Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 12),
              
              // Test Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedTestType,
                decoration: const InputDecoration(
                  labelText: 'Test Type *',
                  prefixIcon: Icon(Icons.science),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Basic', child: Text('Basic - pH Level & Basic Nutrients')),
                  DropdownMenuItem(value: 'Advanced', child: Text('Advanced - Complete Analysis')),
                  DropdownMenuItem(value: 'Premium', child: Text('Premium - Full Report & Recommendations')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedTestType = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Date Selection
              Text(
                'Date *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),

              // Date Picker
              Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(
                    _selectedDate == null
                        ? 'Select Date'
                        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  ),
                  subtitle: const Text('Choose a date for soil testing'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: _selectDate,
                ),
              ),

              const SizedBox(height: 12),

              // Time Slot Selection
              if (_selectedDate != null) ...[
                Text(
                  'Time Slot *',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                if (_isCheckingAvailability)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 10),
                          Text('Checking availability...'),
                        ],
                      ),
                    ),
                  )
                else if (_availableSlots.isEmpty)
                  Card(
                    color: Colors.red.shade50,
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'No available slots for this date. Try another date.',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: SingleChildScrollView(
                      child: Column(
                        children: _availableSlots.map((slot) {
                          final isSelected = _selectedTimeSlot == slot;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Card(
                              color: isSelected ? Colors.green.shade100 : null,
                              elevation: isSelected ? 2 : 1,
                              child: ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                leading: Icon(
                                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                  color: Colors.green,
                                ),
                                title: Text(
                                  slot,
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedTimeSlot = slot;
                                  });
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
              ],

              const SizedBox(height: 20),

              // Additional Information
              Text(
                '4. Additional Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _cropHistoryController,
                decoration: const InputDecoration(
                  labelText: 'Previous Crop History',
                  hintText: 'What crops were grown previously?',
                  prefixIcon: Icon(Icons.grass),
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _requirementsController,
                decoration: const InputDecoration(
                  labelText: 'Notes / Comments (Optional)',
                  hintText: 'Any specific tests or concerns?',
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),

              const SizedBox(height: 40),

              // Book Button
              CustomButton(
                text: 'Book Soil Testing Slot',
                onPressed: _bookSlot,
                icon: Icons.science,
                isLoading: _isLoading,
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}