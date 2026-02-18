import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/expert_consultation_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/farmer_services_hub.dart';

class AskAgronomiScreen extends StatefulWidget {
  const AskAgronomiScreen({super.key});

  @override
  State<AskAgronomiScreen> createState() => _AskAgronomiScreenState();
}

class _AskAgronomiScreenState extends State<AskAgronomiScreen> {
  final FarmerServicesHub _servicesHub = FarmerServicesHub();
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  final _cropNameController = TextEditingController();
  final _problemController = TextEditingController();
  final _contactController = TextEditingController();

  String _selectedConsultationType = 'chat';
  String _selectedPreferredTime = 'Morning (8-12 AM)';
  int? _selectedAgronomistIndex;
  String? _selectedSlot;

  final List<String> _consultationTypes = ['Chat', 'Call', 'Video'];
  final List<String> _timeSlots = ['Morning (8-12 AM)', 'Afternoon (12-4 PM)', 'Evening (4-8 PM)'];

  // Sample Agronomists with availability
  final List<Map<String, dynamic>> _agronomists = [
    {
      'name': 'Dr. Rajesh Kumar',
      'specialization': 'Crop Disease & Pest Management',
      'experience': '15 years',
      'rating': 4.8,
      'available_slots': ['9:00 AM', '10:00 AM', '2:00 PM', '3:00 PM'],
    },
    {
      'name': 'Ms. Priya Sharma',
      'specialization': 'Soil Health & Fertilization',
      'experience': '12 years',
      'rating': 4.7,
      'available_slots': ['10:30 AM', '11:30 AM', '3:30 PM', '4:30 PM'],
    },
    {
      'name': 'Dr. Amit Singh',
      'specialization': 'Irrigation & Water Management',
      'experience': '18 years',
      'rating': 4.9,
      'available_slots': ['8:00 AM', '11:00 AM', '1:00 PM', '4:00 PM'],
    },
    {
      'name': 'Ms. Neha Patel',
      'specialization': 'Organic Farming & Yield Optimization',
      'experience': '10 years',
      'rating': 4.6,
      'available_slots': ['9:30 AM', '12:00 PM', '2:30 PM', '5:00 PM'],
    },
  ];

  // Expert topics for quick consultation
  final List<Map<String, dynamic>> _expertTopics = [
    {'icon': Icons.bug_report, 'title': 'Pest Management', 'color': Colors.red},
    {'icon': Icons.cloud_queue, 'title': 'Crop Disease', 'color': Colors.orange},
    {'icon': Icons.water_drop, 'title': 'Irrigation Guide', 'color': Colors.blue},
    {'icon': Icons.grass, 'title': 'Soil Health', 'color': Colors.green},
    {'icon': Icons.grain, 'title': 'Fertilizer & Nutrients', 'color': Colors.amber},
    {'icon': Icons.thermostat, 'title': 'Weather Impact', 'color': Colors.cyan},
    {'icon': Icons.agriculture, 'title': 'Crop Planning', 'color': Colors.teal},
    {'icon': Icons.trending_up, 'title': 'Yield Optimization', 'color': Colors.purple},
    {'icon': Icons.eco, 'title': 'Organic Farming', 'color': Colors.lightGreen},
    {'icon': Icons.price_change, 'title': 'Market Trends', 'color': Colors.indigo},
  ];

  @override
  void dispose() {
    _cropNameController.dispose();
    _problemController.dispose();
    _contactController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToConsultations() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      // Scroll to near the bottom but leave some space
      final targetPosition = maxScroll > 200 ? maxScroll - 100 : maxScroll;
      
      _scrollController.animateTo(
        targetPosition,
        duration: const Duration(milliseconds: 1200),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _submitConsultation() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    if (user == null) return;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Submitting consultation request...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final consultation = ExpertConsultation(
        consultationId: '',
        farmerId: user.uid,
        farmerName: user.name,
        cropName: _cropNameController.text.trim(),
        problemDescription: _problemController.text.trim(),
        consultationType: _selectedConsultationType.toLowerCase(),
        preferredTime: _selectedPreferredTime,
        scheduledTime: DateTime.now().add(const Duration(days: 1)),
        status: 'pending',
        createdAt: DateTime.now(),
      );

      await _servicesHub.bookConsultation(consultation);

      // Force refresh of consultations by waiting a moment
      await Future.delayed(const Duration(milliseconds: 300));

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      if (mounted) {
        // Clear form
        _cropNameController.clear();
        _problemController.clear();
        
        // Reset form state
        setState(() {
          _selectedConsultationType = 'chat';
          _selectedPreferredTime = 'Morning (8-12 AM)';
        });

        // Show success message with auto-dismiss
        final snackBar = ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 24),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Consultation Request Submitted!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Your request is now visible below. Tap to view.',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            action: SnackBarAction(
              label: 'View',
              textColor: Colors.white,
              backgroundColor: Colors.green.shade700,
              onPressed: () {
                // Force scroll to consultations
                _scrollToConsultations();
                // Dismiss the snackbar
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
        
        // Auto-scroll after snackbar appears with longer delay to ensure data loads
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            _scrollToConsultations();
          }
        });
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.pop(context);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('❌ Error: $e')),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _bookAgronomist() {
    if (_selectedAgronomistIndex == null || _selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Please select an agronomist and time slot'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final agronomist = _agronomists[_selectedAgronomistIndex!];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '✅ Booking confirmed with ${agronomist['name']} at $_selectedSlot',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );

    // Reset selection
    setState(() {
      _selectedAgronomistIndex = null;
      _selectedSlot = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask Agronomist'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                          child: const Icon(Icons.support_agent, color: Colors.white, size: 32),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Expert Advice',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Get personalized farming solutions',
                                style: TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Expert Topics Grid
                Text(
                  'Popular Topics',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.8,
                  ),
                  itemCount: _expertTopics.length,
                  itemBuilder: (context, index) {
                    final topic = _expertTopics[index];
                    return _buildTopicCard(topic);
                  },
                ),

                const SizedBox(height: 24),
                // ===== BOOK AN AGRONOMIST SECTION =====
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.indigo.withOpacity(0.8),
                          Colors.indigo.withOpacity(0.5),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.person_add, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Book an Agronomist',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Available Agronomists
                Text(
                  'Select an Agronomist',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_agronomists.length, (index) {
                      final agronomist = _agronomists[index];
                      final isSelected = _selectedAgronomistIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _selectedAgronomistIndex = index;
                            _selectedSlot = null; // Reset slot when agronomist changes
                          }),
                          child: Container(
                            width: 160,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? Colors.indigo : Colors.grey.shade300,
                                width: isSelected ? 3 : 1,
                              ),
                              color: isSelected ? Colors.indigo.withOpacity(0.1) : Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Agronomist Icon
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected ? Colors.indigo : Colors.blue.shade100,
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  agronomist['name'],
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  agronomist['specialization'],
                                  style: const TextStyle(fontSize: 9, color: Colors.grey),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.star, size: 12, color: Colors.amber),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${agronomist['rating']}',
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 20),

                // Available Slots
                if (_selectedAgronomistIndex != null) ...[
                  Text(
                    'Select Time Slot',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _agronomists[_selectedAgronomistIndex!]['available_slots']
                        .map<Widget>((slot) {
                      final isSlotSelected = _selectedSlot == slot;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedSlot = slot),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSlotSelected ? Colors.green : Colors.grey.shade300,
                              width: isSlotSelected ? 2 : 1,
                            ),
                            color: isSlotSelected ? Colors.green.withOpacity(0.1) : Colors.white,
                          ),
                          child: Text(
                            slot,
                            style: TextStyle(
                              fontWeight: isSlotSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSlotSelected ? Colors.green : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton.icon(
                      onPressed: _bookAgronomist,
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Confirm Booking'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Divider with Text
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Request Custom Consultation',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 24),
                TextFormField(
                  controller: _cropNameController,
                  decoration: InputDecoration(
                    labelText: 'Crop Name *',
                    hintText: 'e.g., Wheat, Rice, Cotton',
                    prefixIcon: const Icon(Icons.grass),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter crop name';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Problem Description
                TextFormField(
                  controller: _problemController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Problem Description *',
                    hintText: 'Describe the issue you\'re facing',
                    prefixIcon: const Icon(Icons.description),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please describe the problem';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Consultation Type
                DropdownButtonFormField<String>(
                  value: _selectedConsultationType,
                  decoration: InputDecoration(
                    labelText: 'Consultation Type *',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  items: _consultationTypes.map((type) {
                    return DropdownMenuItem(
                      value: type.toLowerCase(),
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedConsultationType = value!),
                ),

                const SizedBox(height: 16),

                // Preferred Time
                DropdownButtonFormField<String>(
                  value: _selectedPreferredTime,
                  decoration: InputDecoration(
                    labelText: 'Preferred Time *',
                    prefixIcon: const Icon(Icons.access_time),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  items: _timeSlots.map((time) {
                    return DropdownMenuItem(value: time, child: Text(time));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedPreferredTime = value!),
                ),

                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _submitConsultation,
                    icon: const Icon(Icons.send),
                    label: const Text('Request Consultation'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Consultations Section Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(0.1),
                        Theme.of(context).primaryColor.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.history,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Consultations',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Track status and view expert advice',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      StreamBuilder<List<ExpertConsultation>>(
                        stream: _servicesHub.getFarmerConsultations(
                          Provider.of<AuthProvider>(context).currentUser!.uid,
                        ),
                        builder: (context, snapshot) {
                          final consultations = snapshot.data ?? [];
                          if (consultations.isNotEmpty) {
                            final pendingCount = consultations.where((c) => c.status == 'pending').length;
                            final scheduledCount = consultations.where((c) => c.status == 'scheduled').length;
                            
                            if (pendingCount > 0 || scheduledCount > 0) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${pendingCount + scheduledCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            }
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                StreamBuilder<List<ExpertConsultation>>(
                  stream: _servicesHub.getFarmerConsultations(
                    Provider.of<AuthProvider>(context, listen: false).currentUser!.uid,
                  ),
                  builder: (context, snapshot) {
                    // Add debugging info
                    print('StreamBuilder state: ${snapshot.connectionState}');
                    print('Has data: ${snapshot.hasData}');
                    print('Data length: ${snapshot.data?.length ?? 0}');
                    if (snapshot.hasError) {
                      print('Stream error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Card(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              SizedBox(width: 12),
                              Text('Loading consultations...'),
                            ],
                          ),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Card(
                        color: Colors.red.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Icon(Icons.error, color: Colors.red, size: 48),
                              const SizedBox(height: 8),
                              Text(
                                'Error loading consultations',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${snapshot.error}',
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final consultations = snapshot.data ?? [];

                    if (consultations.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.chat_bubble_outline,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No consultation requests yet',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Submit your first consultation request above.\nIt will appear here with status updates.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Status flow: Pending → Scheduled → Completed',
                                      style: TextStyle(
                                        color: Colors.blue.shade700,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: consultations.length,
                      itemBuilder: (context, index) {
                        final consultation = consultations[index];
                        return _buildConsultationCard(consultation);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopicCard(Map<String, dynamic> topic) {
    return GestureDetector(
      onTap: () {
        // Pre-fill the form with topic
        _cropNameController.text = topic['title'];
        _problemController.text = 'I need advice on ${topic['title'].toLowerCase()}...';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Topic: ${topic['title']} selected. Fill remaining details below.'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                (topic['color'] as Color).withOpacity(0.8),
                (topic['color'] as Color).withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                topic['icon'] as IconData,
                size: 24,
                color: topic['color'] as Color,
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  topic['title'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsultationCard(ExpertConsultation consultation) {
    Color statusColor = Colors.grey;
    String statusIcon = '';
    String statusDescription = '';

    switch (consultation.status) {
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = '⏳';
        statusDescription = 'Waiting for expert assignment';
        break;
      case 'scheduled':
        statusColor = Colors.blue;
        statusIcon = '📅';
        statusDescription = 'Consultation scheduled';
        break;
      case 'completed':
        statusColor = Colors.green;
        statusIcon = '✅';
        statusDescription = 'Consultation completed';
        break;
      case 'cancelled':
        statusColor = Colors.red;  
        statusIcon = '❌';
        statusDescription = 'Consultation cancelled';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = '❓';
        statusDescription = 'Status unknown';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                statusIcon,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    consultation.cropName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    statusDescription,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                consultation.problemDescription,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'Created: ${DateFormat('MMM d, y - h:mm a').format(consultation.createdAt)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        children: [
          const Divider(),
          const SizedBox(height: 8),
          
          // Full Details Section
          _buildDetailRow('Consultation Type', consultation.consultationType.toUpperCase()),
          _buildDetailRow('Preferred Time', consultation.preferredTime),
          if (consultation.assignedExpertName != null)
            _buildDetailRow('Assigned Expert', consultation.assignedExpertName!),
          if (consultation.scheduledTime.isAfter(DateTime.now()))
            _buildDetailRow(
              'Scheduled For', 
              DateFormat('MMM d, y - h:mm a').format(consultation.scheduledTime),
            ),
          
          const SizedBox(height: 16),
          
          // Problem Description (Full)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Problem Description',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  consultation.problemDescription,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          
          // Expert Advice Section (if available)
          if (consultation.status == 'completed') ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.green.shade700, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Expert Advice',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (consultation.generalAdvice != null) ...[
                    Text(
                      'General Advice:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(consultation.generalAdvice!),
                    const SizedBox(height: 12),
                  ],
                  if (consultation.fertiliserSuggestion != null) ...[
                    Text(
                      'Fertilizer Recommendation:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(consultation.fertiliserSuggestion!),
                    const SizedBox(height: 12),
                  ],
                  if (consultation.weatherAdvice != null) ...[
                    Text(
                      'Weather Considerations:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(consultation.weatherAdvice!),
                  ],
                ],
              ),
            ),
          ],
          
          // Action Buttons
          const SizedBox(height: 16),
          Row(
            children: [
              if (consultation.status == 'pending') ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _cancelConsultation(consultation),
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Cancel'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              if (consultation.status == 'scheduled') ...[
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _joinConsultation(consultation),
                    icon: const Icon(Icons.video_call),
                    label: Text('Join ${consultation.consultationType}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
              if (consultation.status == 'completed')
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _rateConsultation(consultation),
                    icon: const Icon(Icons.star_border),
                    label: const Text('Rate & Review'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.amber.shade700,
                      side: BorderSide(color: Colors.amber.shade700),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _cancelConsultation(ExpertConsultation consultation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Consultation'),
        content: const Text('Are you sure you want to cancel this consultation request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final updatedConsultation = consultation.copyWith(status: 'cancelled');
                await _servicesHub.updateConsultation(updatedConsultation);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Consultation cancelled successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❌ Error cancelling consultation: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _joinConsultation(ExpertConsultation consultation) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${consultation.consultationType} consultation...'),
        backgroundColor: Colors.blue,
      ),
    );
    // Here you would integrate with your video calling solution
  }

  void _rateConsultation(ExpertConsultation consultation) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening rating and review form...'),
        backgroundColor: Colors.amber,
      ),
    );
    // Here you would open a rating and review dialog
  }
}