import 'package:flutter/material.dart';

class EquipmentRentalScreen extends StatefulWidget {
  const EquipmentRentalScreen({super.key});

  @override
  State<EquipmentRentalScreen> createState() => _EquipmentRentalScreenState();
}

class _EquipmentRentalScreenState extends State<EquipmentRentalScreen> {
  String _selectedEquipmentType = 'tractor';

  final List<Map<String, String>> _equipmentTypes = [
    {'name': 'Tractor', 'icon': '🚜'},
    {'name': 'Sprayer', 'icon': '💨'},
    {'name': 'Harvester', 'icon': '🌾'},
  ];

  // Sample equipment
  final List<Map<String, dynamic>> _sampleEquipment = [
    {'name': 'Mahindra Tractor 45HP', 'type': 'tractor', 'rate': 1200, 'unit': 'day', 'condition': 'Excellent'},
    {'name': 'Swaraj Tractor 35HP', 'type': 'tractor', 'rate': 900, 'unit': 'day', 'condition': 'Good'},
    {'name': 'Sonalika Tractor 42HP', 'type': 'tractor', 'rate': 1100, 'unit': 'day', 'condition': 'Excellent'},
    {'name': 'Mini Tractor 20HP', 'type': 'tractor', 'rate': 600, 'unit': 'day', 'condition': 'Good'},
    {'name': 'Power Sprayer 16L', 'type': 'sprayer', 'rate': 150, 'unit': 'day', 'condition': 'Excellent'},
    {'name': 'Electric Knapsack Sprayer 16L', 'type': 'sprayer', 'rate': 200, 'unit': 'day', 'condition': 'New'},
    {'name': 'Boom Sprayer 20L', 'type': 'sprayer', 'rate': 250, 'unit': 'day', 'condition': 'Excellent'},
    {'name': 'Combine Harvester Self Propelled', 'type': 'harvester', 'rate': 2500, 'unit': 'day', 'condition': 'Excellent'},
    {'name': 'Wheat Combine Harvester', 'type': 'harvester', 'rate': 2000, 'unit': 'day', 'condition': 'Good'},
    {'name': 'Rice Harvester', 'type': 'harvester', 'rate': 1800, 'unit': 'day', 'condition': 'Excellent'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipment Rental'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rent Farm Equipment',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                // Equipment Type Filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _equipmentTypes.map((equipment) {
                      bool isSelected = _selectedEquipmentType == equipment['name']!.toLowerCase();
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          avatar: Text(equipment['icon']!),
                          label: Text(equipment['name']!),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() =>
                                _selectedEquipmentType = equipment['name']!.toLowerCase());
                          },
                          backgroundColor: Colors.white,
                          selectedColor: Theme.of(context).primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          // Equipment List
          Expanded(
            child: _buildEquipmentList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentList() {
    // Filter sample equipment based on selected type
    final filteredEquipment = _sampleEquipment
        .where((e) => e['type'] == _selectedEquipmentType)
        .toList();

    if (filteredEquipment.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.agriculture_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text('No equipment available', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredEquipment.length,
      itemBuilder: (context, index) {
        return _buildSampleEquipmentCard(filteredEquipment[index]);
      },
    );
  }

  Widget _buildSampleEquipmentCard(Map<String, dynamic> equipment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        equipment['name'] as String,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Condition: ${equipment['condition']}',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Book',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Rate: ', style: TextStyle(color: Colors.grey)),
                Text(
                  '₹${equipment['rate']}/${equipment['unit']}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
