import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/disease_detection_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/farmer_services_hub.dart';
import '../../widgets/loading_widget.dart';

class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({super.key});

  @override
  State<DiseaseDetectionScreen> createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> with SingleTickerProviderStateMixin {
  final FarmerServicesHub _servicesHub = FarmerServicesHub();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final farmerId = authProvider.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Detection'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.camera_alt), text: 'Analyze'),
            Tab(icon: Icon(Icons.history), text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAnalyzeTab(),
          _buildHistoryTab(farmerId),
        ],
      ),
    );
  }

  Widget _buildAnalyzeTab() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Upload Area
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 2, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade50,
              ),
              child: Column(
                children: [
                  Icon(Icons.cloud_upload_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text('Upload crop photo for AI analysis', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('We\'ll detect diseases and suggest treatments', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Upload Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Pick Photo'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Info Cards
            _buildInfoCard(
              Icons.info_outline,
              'How it works',
              'Upload a clear photo of the affected crop area. Our AI model will analyze it and provide:\n• Disease name\n• Confidence level\n• Suggested medicines\n• Prevention tips',
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              Icons.camera_outlined,
              'Photo tips',
              '• Take photos in natural light\n• Ensure affected area is clearly visible\n• Multiple angles for better accuracy\n• Clean the camera lens',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab(String farmerId) {
    return StreamBuilder<List<DiseaseDetection>>(
      stream: _servicesHub.getFarmerDiseaseDetections(farmerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        }

        final detections = snapshot.data ?? [];

        if (detections.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_outlined, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text('No analysis history', style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: detections.length,
          itemBuilder: (context, index) => _buildDetectionCard(detections[index]),
        );
      },
    );
  }

  Widget _buildDetectionCard(DiseaseDetection detection) {
    final confidenceColor = detection.confidenceScore > 0.8
        ? Colors.green
        : detection.confidenceScore > 0.5
            ? Colors.orange
            : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(detection.detectedDisease, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: confidenceColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(detection.confidenceScore * 100).toStringAsFixed(0)}%',
                    style: TextStyle(color: confidenceColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(detection.status).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                detection.status.toUpperCase(),
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _getStatusColor(detection.status)),
              ),
            ),
            const SizedBox(height: 12),

            // Suggested Medicine
            if (detection.suggestedMedicine.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💊 Suggested Treatment', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 6),
                  Text(detection.suggestedMedicine, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 12),
                ],
              ),

            // Prevention Tips
            if (detection.preventionTips.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🛡️ Prevention Tips', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 6),
                  ...detection.preventionTips.map((tip) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('•', style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 8),
                          Expanded(child: Text(tip, style: const TextStyle(fontSize: 11))),
                        ],
                      ),
                    );
                  }),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String content) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(12),
        color: Colors.blue.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 12, color: Colors.blue, height: 1.5)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'treated':
        return Colors.green;
      case 'monitoring':
        return Colors.orange;
      case 'severe':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
