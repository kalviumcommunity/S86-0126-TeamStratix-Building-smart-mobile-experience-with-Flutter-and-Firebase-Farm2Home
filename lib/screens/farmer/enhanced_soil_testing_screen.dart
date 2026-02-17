import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/soil_testing_slot_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/soil_testing_service.dart';
import '../../widgets/custom_button.dart';

class EnhancedSoilTestingScreen extends StatefulWidget {
  const EnhancedSoilTestingScreen({super.key});

  @override
  State<EnhancedSoilTestingScreen> createState() => _EnhancedSoilTestingScreenState();
}

class _EnhancedSoilTestingScreenState extends State<EnhancedSoilTestingScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Farmer Details Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  
  // Land / Soil Details Controllers
  final _villageController = TextEditingController();
  final _locationController = TextEditingController();
  final _landAreaController = TextEditingController();
  final _notesController = TextEditingController();

  final SoilTestingService _soilTestingService = SoilTestingService();

  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  String _selectedSoilType = 'Red Soil';
  String _selectedTestType = 'Basic';
  bool _isLoading = false;

  // Soil type options
  final List<String> _soilTypes = [
    'Red Soil',
    'Black Soil',
    'Sandy',
    'Clay',
    'Loam',
    'Other'
  ];

  // Test type options with descriptions
  final Map<String, String> _testTypes = {
    'Basic': 'pH Level & Basic Nutrients',
    'Advanced': 'Complete Nutrient Analysis',
    'Fertility': 'Soil Fertility Assessment',
    'pH Level': 'pH Testing Only',
  };

  // Time slot options
  final List<String> _timeSlots = [
    'Morning (8 AM - 12 PM)',
    'Afternoon (12 PM - 4 PM)',
    'Evening (4 PM - 7 PM)',
  ];

  @override
  void initState() {
    super.initState();
    _loadFarmerDetails();
  }

  void _loadFarmerDetails() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _phoneController.text = ''; // Phone not in user model
      _emailController.text = user.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _villageController.dispose();
    _locationController.dispose();
    _landAreaController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _selectedTimeSlot = null;
      });
    }
  }

  Future<void> _bookSlot() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a time slot'),
          backgroundColor: Colors.orange,
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
        farmerName: _nameController.text.trim(),
        farmerPhone: _phoneController.text.trim(),
        farmerEmail: _emailController.text.trim().isNotEmpty 
            ? _emailController.text.trim() 
            : null,
        farmLocation: _locationController.text.trim(),
        village: _villageController.text.trim().isNotEmpty 
            ? _villageController.text.trim() 
            : null,
        landArea: _landAreaController.text.trim().isNotEmpty 
            ? double.tryParse(_landAreaController.text.trim()) 
            : null,
        soilType: _selectedSoilType,
        testType: _selectedTestType,
        scheduledDate: _selectedDate!,
        timeSlot: _selectedTimeSlot!,
        status: 'pending',
        specificRequirements: _notesController.text.trim().isNotEmpty 
            ? _notesController.text.trim() 
            : null,
        createdAt: DateTime.now(),
      );

      await _soilTestingService.bookSlot(slot);

      if (mounted) {
        setState(() => _isLoading = false);
        
        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 32),
                const SizedBox(width: 12),
                const Text('Booking Confirmed!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your soil testing slot has been booked successfully.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        Icons.calendar_today,
                        'Date',
                        DateFormat('EEEE, MMM d, y').format(_selectedDate!),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.access_time,
                        'Time',
                        _selectedTimeSlot!,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.science,
                        'Test Type',
                        _selectedTestType,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'You will receive a notification when a technician is assigned.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Go back to previous screen
                },
                child: const Text('OK'),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.receipt_long, size: 18),
                label: const Text('View My Bookings'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pushReplacementNamed('/my-bookings');
                },
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error booking slot: $e'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _bookSlot,
            ),
          ),
        );
      }
    }
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blue.shade700),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Book Soil Testing'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.8),
                      Theme.of(context).primaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.science,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Soil Testing Service',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Get your soil analyzed by experts',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Section 1: Farmer Details
            _buildSectionHeader('1. Farmer Details', Icons.person),
            const SizedBox(height: 12),

            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name *',
                hintText: 'Enter your name',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number *',
                hintText: '10-digit mobile number',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter phone number';
                }
                if (value.trim().length < 10) {
                  return 'Please enter a valid 10-digit number';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email (Optional)',
                hintText: 'your.email@example.com',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 24),

            // Section 2: Land / Soil Details
            _buildSectionHeader('2. Land / Soil Details', Icons.terrain),
            const SizedBox(height: 12),

            TextFormField(
              controller: _villageController,
              decoration: InputDecoration(
                labelText: 'Village / Location *',
                hintText: 'Enter village name',
                prefixIcon: const Icon(Icons.location_city),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter village/location';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Farm Address *',
                hintText: 'Enter detailed farm address',
                prefixIcon: const Icon(Icons.home_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter farm address';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _landAreaController,
              decoration: InputDecoration(
                labelText: 'Land Area (Acres)',
                hintText: 'e.g., 2.5',
                prefixIcon: const Icon(Icons.landscape),
                suffixText: 'acres',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedSoilType,
              decoration: InputDecoration(
                labelText: 'Soil Type *',
                prefixIcon: const Icon(Icons.grass),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              items: _soilTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSoilType = value!;
                });
              },
            ),

            const SizedBox(height: 24),

            // Section 3: Appointment Details
            _buildSectionHeader('3. Appointment Details', Icons.event),
            const SizedBox(height: 12),

            // Test Type Selection
            DropdownButtonFormField<String>(
              value: _selectedTestType,
              decoration: InputDecoration(
                labelText: 'Test Type *',
                prefixIcon: const Icon(Icons.science_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              items: _testTypes.entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTestType = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            // Date Picker
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date *',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'Select date'
                          : DateFormat('EEEE, MMM d, y').format(_selectedDate!),
                      style: TextStyle(
                        color: _selectedDate == null 
                            ? Colors.grey.shade600 
                            : Colors.black87,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Time Slot Selection
            DropdownButtonFormField<String>(
              value: _selectedTimeSlot,
              decoration: InputDecoration(
                labelText: 'Time Slot *',
                prefixIcon: const Icon(Icons.access_time),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              hint: const Text('Select time slot'),
              items: _timeSlots.map((slot) {
                return DropdownMenuItem(
                  value: slot,
                  child: Text(slot),
                );
              }).toList(),
              onChanged: _selectedDate == null 
                  ? null 
                  : (value) {
                      setState(() {
                        _selectedTimeSlot = value;
                      });
                    },
            ),

            const SizedBox(height: 24),

            // Section 4: Extra
            _buildSectionHeader('4. Additional Information', Icons.note_alt),
            const SizedBox(height: 12),

            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Notes / Comments (Optional)',
                hintText: 'Any specific requirements or concerns?',
                prefixIcon: const Icon(Icons.notes),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              maxLines: 4,
            ),

            const SizedBox(height: 32),

            // Book Button
            CustomButton(
              text: 'Book Soil Testing Appointment',
              onPressed: _bookSlot,
              icon: Icons.check_circle_outline,
              isLoading: _isLoading,
            ),

            const SizedBox(height: 24),

            // Info Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'What happens next?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoStep('1', 'Booking Confirmed', 'You\'ll receive instant confirmation'),
                    _buildInfoStep('2', 'Technician Assigned', 'Expert will be assigned to your case'),
                    _buildInfoStep('3', 'Sample Collection', 'Technician visits your farm'),
                    _buildInfoStep('4', 'Testing', 'Soil analysis in progress'),
                    _buildInfoStep('5', 'Report Ready', 'Download your detailed report'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoStep(String number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
