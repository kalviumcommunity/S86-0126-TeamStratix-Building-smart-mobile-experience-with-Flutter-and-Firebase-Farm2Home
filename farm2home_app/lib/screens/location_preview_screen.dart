import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

/// Location Preview Screen
/// Demonstrates Google Maps SDK integration with user location access and map markers
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

  // User location
  LatLng? _userLocation;
  bool _isLoadingLocation = false;
  String _locationStatus = 'Tap "Locate Me" to fetch your location';

  // Map style data
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
  }

  /// Initialize map markers with demo locations
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

  /// Add or update user location marker
  void _updateUserLocationMarker(LatLng userLocation) {
    _markers.removeWhere(
      (marker) => marker.markerId.value == 'user_location',
    );

    _markers.add(
      Marker(
        markerId: const MarkerId('user_location'),
        position: userLocation,
        infoWindow: const InfoWindow(
          title: 'Your Location',
          snippet: 'Your current GPS position',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
  }

  /// Fetch user's current location using Geolocator
  /// This is the "Locate Me" feature
  Future<void> _locateUser() async {
    setState(() {
      _isLoadingLocation = true;
      _locationStatus = 'Requesting location permission...';
    });

    try {
      // Check if location services are enabled
      bool isServiceEnabled = await LocationService.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        setState(() {
          _locationStatus = 'Location services are disabled. Please enable them.';
          _isLoadingLocation = false;
        });
        _showPermissionDialog(
          'Location Services Disabled',
          'Location services are disabled. Please enable them in your settings.',
          onOpen: () => LocationService.openLocationSettings(),
        );
        return;
      }

      // Check permission
      LocationPermission permission = await LocationService.checkLocationPermission();

      if (permission == LocationPermission.denied) {
        setState(() {
          _locationStatus = 'Requesting location permission...';
        });
        permission = await LocationService.requestLocationPermission();
      }

      // Handle permission denial
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationStatus = 'Location permission denied.';
          _isLoadingLocation = false;
        });
        _showPermissionDialog(
          'Permission Denied',
          'Location permission is required to use this feature.',
        );
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationStatus = 'Location permission permanently denied. Open app settings.';
          _isLoadingLocation = false;
        });
        _showPermissionDialog(
          'Permission Denied Forever',
          'Location permission is permanently denied. Please enable it in app settings.',
          onOpen: () => LocationService.openAppSettings(),
        );
        return;
      }

      // Permission granted, fetch location
      setState(() {
        _locationStatus = 'Fetching your location...';
      });

      Position? position = await LocationService.getUserLocation();

      if (!mounted) return;

      if (position != null) {
        final userLocation = LatLng(position.latitude, position.longitude);
        setState(() {
          _userLocation = userLocation;
          _locationStatus =
              'Location: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
          _isLoadingLocation = false;
        });

        // Add user location marker
        _updateUserLocationMarker(userLocation);
        setState(() {});

        // Animate camera to user location
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: userLocation,
              zoom: 15.0,
            ),
          ),
        );

        _showSnackBar('Location fetched successfully!');
      } else {
        setState(() {
          _locationStatus = 'Could not fetch location. Please try again.';
          _isLoadingLocation = false;
        });
        _showSnackBar('Failed to fetch location.');
      }
    } catch (e) {
      setState(() {
        _locationStatus = 'Error: $e';
        _isLoadingLocation = false;
      });
      _showSnackBar('Error fetching location: $e');
    }
  }

  /// Show permission dialog
  void _showPermissionDialog(
    String title,
    String message, {
    VoidCallback? onOpen,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          if (onOpen != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onOpen();
              },
              child: const Text('Open Settings'),
            ),
        ],
      ),
    );
  }

  /// Show snack bar message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
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
        subtitle: const Text('User Location + Map Markers'),
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
                child: Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                      initialCameraPosition: const CameraPosition(
                        target: _defaultLocation,
                        zoom: 10.0,
                      ),
                      markers: _markers,
                      myLocationButtonEnabled: false,
                      myLocationEnabled: false,
                      zoomControlsEnabled: true,
                      compassEnabled: true,
                      mapToolbarEnabled: true,
                      trafficEnabled: false,
                      buildingsEnabled: true,
                      indoorViewEnabled: false,
                    ),
                    // "Locate Me" button
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: FloatingActionButton(
                        onPressed: _isLoadingLocation ? null : _locateUser,
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        child: _isLoadingLocation
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.my_location),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // User Location Status Card
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
                              Icons.my_location,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Your Location Status',
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
                          color: Colors.white,
                          border: Border.all(color: Colors.blue.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _locationStatus,
                          style: const TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_userLocation != null)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            border: Border.all(color: Colors.green.shade300),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '✓ User Location Marker: Blue pin on map',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (_userLocation == null)
                        ElevatedButton.icon(
                          onPressed: _isLoadingLocation ? null : _locateUser,
                          icon: const Icon(Icons.location_on),
                          label: const Text('Tap "Locate Me" Button'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Map Information Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
              child: Card(
                elevation: 2,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    border: Border.all(color: Colors.amber.shade300),
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
                              color: Colors.amber.shade700,
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
                      _buildFeaturePoint('Blue marker: Your current location'),
                      _buildFeaturePoint('Green marker: Farm2Home Hub'),
                      _buildFeaturePoint('Orange marker: Local Farm'),
                      _buildFeaturePoint('Red marker: Distribution Market'),
                      _buildFeaturePoint('Pinch to zoom in/out'),
                      _buildFeaturePoint('Drag to pan the map'),
                      _buildFeaturePoint('Tap markers for info windows'),
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
                              'Permissions & Dependencies',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildConfigItem('Dependencies', 'geolocator: ^10.1.0'),
                      _buildConfigItem('Dependencies', 'google_maps_flutter: ^2.5.0'),
                      _buildConfigItem('Android', 'android/app/src/main/AndroidManifest.xml'),
                      _buildConfigItem('iOS', 'ios/Runner/Info.plist'),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade100,
                          border: Border.all(color: Colors.yellow.shade700),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '⚠️ Note: Add location permissions to AndroidManifest.xml and Info.plist. See PERMISSIONS_SETUP.md',
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
