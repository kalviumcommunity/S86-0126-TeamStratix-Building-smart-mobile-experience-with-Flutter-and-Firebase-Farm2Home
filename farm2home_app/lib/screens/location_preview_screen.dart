import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Location Preview Screen
/// Demonstrates Google Maps SDK integration with interactive map display
class LocationPreviewScreen extends StatefulWidget {
  const LocationPreviewScreen({super.key});

  @override
  State<LocationPreviewScreen> createState() => _LocationPreviewScreenState();
}

class _LocationPreviewScreenState extends State<LocationPreviewScreen> {
  // Google Maps Controller
  late GoogleMapController _mapController;

  // Default location: San Francisco (agriculture/farm-related area)
  static const LatLng _defaultLocation = LatLng(37.7749, -122.4194);

  // Alternative demo locations
  static const LatLng _farmLocation = LatLng(38.5816, -121.4944); // Sacramento area
  static const LatLng _marketLocation = LatLng(37.3382, -121.8863); // San Jose area

  // Map markers
  final Set<Marker> _markers = {};

  // Map style data
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
  }

  /// Initialize map markers
  void _initializeMarkers() {
    _markers.clear();

    // Main marker at default location
    _markers.add(
      const Marker(
        markerId: MarkerId('default_location'),
        position: _defaultLocation,
        infoWindow: InfoWindow(
          title: 'Farm2Home Hub',
          snippet: 'San Francisco Distribution Center',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

    // Farm location marker
    _markers.add(
      const Marker(
        markerId: MarkerId('farm_location'),
        position: _farmLocation,
        infoWindow: InfoWindow(
          title: 'Local Farm',
          snippet: 'Sacramento Region - Produce Source',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
    );

    // Market location marker
    _markers.add(
      const Marker(
        markerId: MarkerId('market_location'),
        position: _marketLocation,
        infoWindow: InfoWindow(
          title: 'Distribution Market',
          snippet: 'San Jose Area - Customer Hub',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
  }

  /// Navigate to a specific location
  void _navigateToLocation(LatLng location, String label) {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: 14.0,
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigated to $label'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Reset to default location
  void _resetToDefaultLocation() {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(
          target: _defaultLocation,
          zoom: 10.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Location Preview'),
        subtitle: const Text('Google Maps Integration Demo'),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Map Container
            Container(
              height: 400,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green.shade700, width: 2),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GoogleMap(
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  initialCameraPosition: const CameraPosition(
                    target: _defaultLocation,
                    zoom: 10.0,
                  ),
                  markers: _markers,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: false,
                  zoomControlsEnabled: true,
                  compassEnabled: true,
                  mapToolbarEnabled: true,
                  trafficEnabled: false,
                  buildingsEnabled: true,
                  indoorViewEnabled: false,
                ),
              ),
            ),

            // Information Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
              child: Card(
                elevation: 2,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    border: Border.all(color: Colors.blue.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade700,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.info,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Map Information',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Interactive Map Features:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildFeaturePoint('Pinch to zoom in/out'),
                      _buildFeaturePoint('Drag to pan the map'),
                      _buildFeaturePoint('Tap markers for info windows'),
                      _buildFeaturePoint('Use zoom controls'),
                      _buildFeaturePoint('Rotate with two-finger twist'),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          border: Border.all(color: Colors.green.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Default Location: San Francisco (37.7749°N, 122.4194°W)',
                          style: TextStyle(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Navigation Buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
              child: Card(
                elevation: 2,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    border: Border.all(color: Colors.orange.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade700,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Navigation Shortcuts',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildNavigationButton(
                            'Hub',
                            _defaultLocation,
                            Colors.green,
                          ),
                          _buildNavigationButton(
                            'Farm',
                            _farmLocation,
                            Colors.orange,
                          ),
                          _buildNavigationButton(
                            'Market',
                            _marketLocation,
                            Colors.red,
                          ),
                          _buildResetButton(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Code Example Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
              child: Card(
                elevation: 2,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade700,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.code,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'GoogleMap Widget Code',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(4),
                          fontFamily: 'monospace',
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            '''GoogleMap(
  onMapCreated: (controller) => _mapController = controller,
  initialCameraPosition: CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 10.0,
  ),
  markers: _markers,
  myLocationButtonEnabled: true,
  zoomControlsEnabled: true,
)''',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 10,
                              color: Colors.green.shade300,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Configuration Info
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
              child: Card(
                elevation: 2,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    border: Border.all(color: Colors.purple.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade700,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.settings,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Configuration Required',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildConfigItem('Android', 'AndroidManifest.xml'),
                      _buildConfigItem('iOS', 'ios/Runner/Info.plist'),
                      _buildConfigItem('API Key', 'Google Cloud Console'),
                      _buildConfigItem('Dependencies', 'google_maps_flutter: ^2.5.0'),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade100,
                          border: Border.all(color: Colors.yellow.shade700),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '⚠️ Note: Replace YOUR_API_KEY in manifest/plist with your actual key from Google Cloud Console',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Build feature point text
  Widget _buildFeaturePoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 14, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  /// Build navigation button
  Widget _buildNavigationButton(
    String label,
    LatLng location,
    Color color,
  ) {
    return ElevatedButton.icon(
      onPressed: () => _navigateToLocation(location, label),
      icon: const Icon(Icons.my_location, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  /// Build reset button
  Widget _buildResetButton() {
    return OutlinedButton.icon(
      onPressed: _resetToDefaultLocation,
      icon: const Icon(Icons.refresh, size: 16),
      label: const Text('Reset'),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  /// Build configuration item
  Widget _buildConfigItem(String platform, String location) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.purple.shade700,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$platform: $location',
              style: const TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
