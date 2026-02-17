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

              const SizedBox(height: 24),

              // Date Selection
              Text(
                'Select Date & Time *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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

              const SizedBox(height: 16),

              // Time Slot Selection
              if (_selectedDate != null) ...[
                if (_isCheckingAvailability)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
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
                              'No available time slots for this date. Please select another date.',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  Text(
                    'Available Time Slots',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._availableSlots.map((slot) {
                    final isSelected = _selectedTimeSlot == slot;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
                        color: isSelected
                            ? Colors.green.shade100
                            : null,
                        child: ListTile(
                          leading: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          title: Text(
                            slot,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : null,
                            ),
                          ),
                          subtitle: const Text(
                            'Available',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                            ),
                          ),
                          trailing: isSelected 
                              ? const Icon(Icons.radio_button_checked, color: Colors.green)
                              : const Icon(Icons.radio_button_unchecked),
                          onTap: () {
                            setState(() {
                              _selectedTimeSlot = slot;
                            });
                          },
                        ),
                      ),
                    );
                  }),
                ],
              ],

              const SizedBox(height: 24),

              // Optional Fields
              Text(
                'Additional Information (Optional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _soilTypeController,
                decoration: const InputDecoration(
                  labelText: 'Current Soil Type',
                  hintText: 'e.g., Clay, Sandy, Loam',
                  prefixIcon: Icon(Icons.terrain),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

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
                  labelText: 'Specific Requirements',
                  hintText: 'Any specific tests or concerns?',
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 32),

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