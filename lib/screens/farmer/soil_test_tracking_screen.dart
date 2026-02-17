import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/soil_testing_slot_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/soil_testing_service.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state_widget.dart';

class SoilTestTrackingScreen extends StatefulWidget {
  const SoilTestTrackingScreen({super.key});

  @override
  State<SoilTestTrackingScreen> createState() => _SoilTestTrackingScreenState();
}

class _SoilTestTrackingScreenState extends State<SoilTestTrackingScreen> {
  final SoilTestingService _soilTestingService = SoilTestingService();

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'sample_collected':
        return Colors.blue;
      case 'testing':
        return Colors.purple;
      case 'completed':
        return Colors.teal;
      case 'report_ready':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.pending_actions;
      case 'sample_collected':
        return Icons.science;
      case 'testing':
        return Icons.biotech;
      case 'completed':
        return Icons.check_circle;
      case 'report_ready':
        return Icons.file_download;
      default:
        return Icons.info;
    }
  }

  String _getStatusDisplay(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'sample_collected':
        return 'Sample Collected';
      case 'testing':
        return 'Testing';
      case 'completed':
        return 'Completed';
      case 'report_ready':
        return 'Report Ready';
      default:
        return status;
    }
  }

  String _getStatusMessage(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Waiting for technician assignment';
      case 'sample_collected':
        return 'Soil sample has been collected';
      case 'testing':
        return 'Analysis in progress';
      case 'completed':
        return 'Testing complete';
      case 'report_ready':
        return 'Your report is ready to download';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      return const Center(
        child: Text('Please login to view your soil tests'),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          // Header Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
                ],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Soil Test Bookings',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Track your soil analysis status',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bookings List
          Expanded(
            child: StreamBuilder<List<SoilTestingSlot>>(
              stream: _soilTestingService.getFarmerSlots(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget();
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Error loading bookings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                final bookings = snapshot.data ?? [];

                if (bookings.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.science_outlined,
                    message: 'No Soil Tests Yet\nBook your first soil testing appointment',
                    actionText: 'Book Now',
                    onAction: () {
                      Navigator.of(context).pushNamed('/book-soil-testing');
                    },
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return _buildBookingCard(booking);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed('/book-soil-testing');
        },
        icon: const Icon(Icons.add),
        label: const Text('New Booking'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildBookingCard(SoilTestingSlot booking) {
    final statusColor = _getStatusColor(booking.status);
    final statusIcon = _getStatusIcon(booking.status);
    final statusDisplay = _getStatusDisplay(booking.status);
    final statusMessage = _getStatusMessage(booking.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Status Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    statusIcon,
                    color: statusColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statusDisplay,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        statusMessage,
                        style: TextStyle(
                          fontSize: 12,
                          color: statusColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusDisplay.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Booking Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date & Time
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        Icons.calendar_today,
                        'Date',
                        DateFormat('MMM d, y').format(booking.scheduledDate),
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        Icons.access_time,
                        'Time',
                        booking.timeSlot,
                      ),
                    ),
                  ],
                ),

                const Divider(height: 24),

                // Test Type & Soil Type
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        Icons.science,
                        'Test Type',
                        booking.testType,
                      ),
                    ),
                    if (booking.soilType != null)
                      Expanded(
                        child: _buildDetailItem(
                          Icons.grass,
                          'Soil Type',
                          booking.soilType!,
                        ),
                      ),
                  ],
                ),

                // Location
                if (booking.village != null || booking.farmLocation.isNotEmpty) ...[
                  const Divider(height: 24),
                  _buildDetailItem(
                    Icons.location_on,
                    'Location',
                    booking.village != null
                        ? '${booking.village}, ${booking.farmLocation}'
                        : booking.farmLocation,
                  ),
                ],

                // Land Area
                if (booking.landArea != null) ...[
                  const SizedBox(height: 12),
                  _buildDetailItem(
                    Icons.landscape,
                    'Land Area',
                    '${booking.landArea} acres',
                  ),
                ],

                // Technician
                if (booking.technicianName != null) ...[
                  const Divider(height: 24),
                  _buildDetailItem(
                    Icons.person,
                    'Technician',
                    booking.technicianName!,
                  ),
                ],

                // Report Download Button
                if (booking.reportUrl != null) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Download report
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Downloading report...'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Download Report'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Timeline/Progress Indicator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: _buildProgressTimeline(booking.status),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressTimeline(String currentStatus) {
    final steps = [
      {'status': 'pending', 'label': 'Pending'},
      {'status': 'sample_collected', 'label': 'Sample Collected'},
      {'status': 'testing', 'label': 'Testing'},
      {'status': 'completed', 'label': 'Completed'},
      {'status': 'report_ready', 'label': 'Report Ready'},
    ];

    int currentIndex = steps.indexWhere((s) => s['status'] == currentStatus.toLowerCase());
    if (currentIndex == -1) currentIndex = 0;

    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isEven) {
          // Step indicator
          final stepIndex = index ~/ 2;
          final step = steps[stepIndex];
          final isCompleted = stepIndex <= currentIndex;
          final isCurrent = stepIndex == currentIndex;

          return Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? _getStatusColor(step['status']!)
                      : Colors.grey.shade300,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCurrent ? _getStatusColor(step['status']!) : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: Icon(
                  isCompleted ? Icons.check : Icons.circle,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 60,
                child: Text(
                  step['label']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9,
                    color: isCompleted ? Colors.black87 : Colors.grey,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        } else {
          // Connector line
          final stepIndex = index ~/ 2;
          final isCompleted = stepIndex < currentIndex;

          return Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.only(bottom: 40),
              color: isCompleted ? Colors.green : Colors.grey.shade300,
            ),
          );
        }
      }),
    );
  }
}
