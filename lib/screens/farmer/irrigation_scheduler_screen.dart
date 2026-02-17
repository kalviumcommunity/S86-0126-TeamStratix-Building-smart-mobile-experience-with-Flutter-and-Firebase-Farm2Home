import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/irrigation_schedule_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/farmer_services_hub.dart';
import '../../widgets/loading_widget.dart';

class IrrigationSchedulerScreen extends StatefulWidget {
  const IrrigationSchedulerScreen({super.key});

  @override
  State<IrrigationSchedulerScreen> createState() => _IrrigationSchedulerScreenState();
}

class _IrrigationSchedulerScreenState extends State<IrrigationSchedulerScreen> {
  final FarmerServicesHub _servicesHub = FarmerServicesHub();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final farmerId = authProvider.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Irrigation Scheduler'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<IrrigationSchedule>>(
        stream: _servicesHub.getFarmerSchedules(farmerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }

          final schedules = snapshot.data ?? [];

          return Column(
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Card(
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
                          child: const Icon(Icons.water_drop, color: Colors.white, size: 32),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Smart Irrigation',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Save water. Boost yield.',
                                style: TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Schedules List
              if (schedules.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.water_drop_outlined, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text('No schedules created', style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: schedules.length,
                    itemBuilder: (context, index) => _buildScheduleCard(schedules[index]),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateScheduleDialog(),
        icon: const Icon(Icons.add),
        label: const Text('New Schedule'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildScheduleCard(IrrigationSchedule schedule) {
    final daysUntilWater = schedule.nextWaterReminder.difference(DateTime.now()).inDays;

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
                Text(schedule.cropName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: daysUntilWater <= 1 ? Colors.red.shade200 : Colors.blue.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    daysUntilWater <= 0 ? 'Water Now!' : 'In $daysUntilWater days',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: daysUntilWater <= 1 ? Colors.red : Colors.blue,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildScheduleInfo('🌾', 'Field Area', '${schedule.fieldArea} acres'),
                _buildScheduleInfo('💧', 'Water', '${schedule.waterRequired.toStringAsFixed(0)}L'),
                _buildScheduleInfo('⏱️', 'Frequency', schedule.frequency),
              ],
            ),
            const SizedBox(height: 12),
            Text('Soil: ${schedule.soilType} • Type: ${schedule.irrigationType}',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            if (daysUntilWater <= 1)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.water_drop),
                  label: const Text('Mark As Watered'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleInfo(String emoji, String label, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }

  void _showCreateScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Schedule'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(decoration: InputDecoration(labelText: 'Crop Name', border: OutlineInputBorder())),
              SizedBox(height: 12),
              TextField(decoration: InputDecoration(labelText: 'Field Area (acres)', border: OutlineInputBorder())),
              SizedBox(height: 12),
              TextField(decoration: InputDecoration(labelText: 'Water Required (liters)', border: OutlineInputBorder())),
              SizedBox(height: 12),
              TextField(decoration: InputDecoration(labelText: 'Irrigation Type', border: OutlineInputBorder())),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Create')),
        ],
      ),
    );
  }
}
