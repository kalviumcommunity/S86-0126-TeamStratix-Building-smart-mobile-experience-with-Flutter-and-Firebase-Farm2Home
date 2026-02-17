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
    super.dispose();
  }

  void _submitConsultation() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    if (user == null) return;

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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Consultation request submitted! Expert will contact soon.'),
            backgroundColor: Colors.green,
          ),
        );
        _cropNameController.clear();
        _problemController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
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

                const SizedBox(height: 24),

                // Previous Consultations
                Text(
                  'Your Consultations',
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 12),

                StreamBuilder<List<ExpertConsultation>>(
                  stream: _servicesHub.getFarmerConsultations(
                    Provider.of<AuthProvider>(context).currentUser!.uid,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final consultations = snapshot.data ?? [];

                    if (consultations.isEmpty) {
                      return Center(
                        child: Column(
                          children: [
                            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade300),
                            const SizedBox(height: 12),
                            Text('No consultations yet', style: Theme.of(context).textTheme.bodyLarge),
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

    if (consultation.status == 'pending') {
      statusColor = Colors.orange;
      statusIcon = '⏳';
    } else if (consultation.status == 'scheduled') {
      statusColor = Colors.blue;
      statusIcon = '📅';
    } else if (consultation.status == 'completed') {
      statusColor = Colors.green;
      statusIcon = '✅';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(consultation.cropName, style: Theme.of(context).textTheme.titleMedium),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$statusIcon ${consultation.status.toUpperCase()}',
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(consultation.problemDescription, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(DateFormat('MMM d, y').format(consultation.createdAt)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
