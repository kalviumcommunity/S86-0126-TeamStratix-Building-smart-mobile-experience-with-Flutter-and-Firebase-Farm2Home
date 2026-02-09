import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

/// LocationTrackingScreen demonstrates advanced location tracking
/// Features:
/// - Real-time user location tracking
/// - Custom markers with icons
/// - Live position updates
/// - Permission handling
/// - Distance calculations
class LocationTrackingScreen extends StatefulWidget {
  const LocationTrackingScreen({super.key});

  @override
  State<LocationTrackingScreen> createState() => _LocationTrackingScreenState();
}

class _LocationTrackingScreenState extends State<LocationTrackingScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStreamSubscription;
  
  // Initial camera position (will be updated to user location)
  CameraPosition _cameraPosition = const CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 14.0,
  );

  // Set of markers
  final Set<Marker> _markers = {};
  
  // Custom marker icons
  BitmapDescriptor? _customMarkerIcon;
  BitmapDescriptor? _userLocationIcon;
  
  bool _isLoading = true;
  bool _trackingEnabled = false;
  String _statusMessage = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  /// Initialize location services and get current position
  Future<void> _initializeLocation() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Checking location permissions...';
    });

    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _statusMessage = 'Location services are disabled';
        _isLoading = false;
      });
      _showErrorDialog('Location services are disabled. Please enable them.');
      return;
    }

    // Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _statusMessage = 'Location permission denied';
          _isLoading = false;
        });
        _showErrorDialog('Location permission is required for this feature.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _statusMessage = 'Location permission permanently denied';
        _isLoading = false;
      });
      _showErrorDialog(
        'Location permissions are permanently denied. Please enable them in app settings.',
      );
      return;
    }

    // Load custom marker icons
    await _loadCustomMarkers();

    // Get current position
    await _getCurrentLocation();

    setState(() {
      _isLoading = false;
      _statusMessage = 'Location access granted';
    });
  }

  /// Load custom marker icons from assets
  Future<void> _loadCustomMarkers() async {
    // Note: Add actual PNG files to assets/icons/ folder
    // For now, using default markers with different colors
    _customMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueOrange,
    );
    
    _userLocationIcon = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueBlue,
    );
    
    // Uncomment below when you add custom PNG files:
    /*
    _customMarkerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/icons/custom_pin.png',
    );
    
    _userLocationIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/icons/user_location.png',
    );
    */
  }

  /// Get current user location
  Future<void> _getCurrentLocation() async {
    try {
      setState(() {
        _statusMessage = 'Getting your location...';
      });

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _cameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15.0,
        );
        _statusMessage = 'Location found';
      });

      // Add marker at current location
      _addUserMarker(position);

      // Move camera to current location
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(_cameraPosition),
      );

      // Add sample markers nearby
      _addSampleMarkers(position);
    } catch (e) {
      setState(() {
        _statusMessage = 'Error getting location: $e';
      });
      _showErrorDialog('Failed to get location: $e');
    }
  }

  /// Add user location marker
  void _addUserMarker(Position position) {
    setState(() {
      _markers.removeWhere((m) => m.markerId.value == 'user_location');
      _markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: LatLng(position.latitude, position.longitude),
          icon: _userLocationIcon ?? BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: 'You are here',
            snippet: 'Lat: ${position.latitude.toStringAsFixed(6)}, '
                'Lng: ${position.longitude.toStringAsFixed(6)}',
          ),
        ),
      );
    });
  }

  /// Add sample markers around user location
  void _addSampleMarkers(Position userPosition) {
    // Farm location (0.01 degrees ~= 1km)
    final farmLocation = LatLng(
      userPosition.latitude + 0.01,
      userPosition.longitude + 0.01,
    );
    
    // Market location
    final marketLocation = LatLng(
      userPosition.latitude - 0.01,
      userPosition.longitude + 0.015,
    );
    
    // Delivery point
    final deliveryLocation = LatLng(
      userPosition.latitude + 0.005,
      userPosition.longitude - 0.01,
    );

    setState(() {
      _markers.addAll({
        Marker(
          markerId: const MarkerId('farm'),
          position: farmLocation,
          icon: _customMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow: const InfoWindow(
            title: 'Fresh Farm',
            snippet: 'Organic vegetables available',
          ),
        ),
        Marker(
          markerId: const MarkerId('market'),
          position: marketLocation,
          icon: _customMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
          infoWindow: const InfoWindow(
            title: 'Local Market',
            snippet: 'Farmers market every Saturday',
          ),
        ),
        Marker(
          markerId: const MarkerId('delivery'),
          position: deliveryLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueYellow,
          ),
          infoWindow: const InfoWindow(
            title: 'Delivery Point',
            snippet: 'Next delivery in 15 mins',
          ),
        ),
      });
    });
  }

  /// Start live location tracking
  void _startLiveTracking() {
    if (_trackingEnabled) return;

    setState(() {
      _trackingEnabled = true;
      _statusMessage = 'Live tracking enabled';
    });

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      setState(() {
        _currentPosition = position;
        _statusMessage = 'Location updated: ${DateTime.now().toString().substring(11, 19)}';
      });

      // Update user marker
      _addUserMarker(position);

      // Optionally move camera to follow user
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude),
        ),
      );
    }, onError: (error) {
      setState(() {
        _statusMessage = 'Tracking error: $error';
      });
    });
  }

  /// Stop live location tracking
  void _stopLiveTracking() {
    _positionStreamSubscription?.cancel();
    setState(() {
      _trackingEnabled = false;
      _statusMessage = 'Live tracking disabled';
    });
  }

  /// Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Tracking'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_trackingEnabled ? Icons.pause : Icons.play_arrow),
            tooltip: _trackingEnabled ? 'Stop Tracking' : 'Start Tracking',
            onPressed: () {
              if (_trackingEnabled) {
                _stopLiveTracking();
              } else {
                _startLiveTracking();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Location',
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(_statusMessage),
                ],
              ),
            )
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: _cameraPosition,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  compassEnabled: true,
                  mapType: MapType.normal,
                  zoomControlsEnabled: false,
                  onTap: (LatLng position) {
                    // Add custom marker on tap
                    setState(() {
                      _markers.add(
                        Marker(
                          markerId: MarkerId('custom_${_markers.length}'),
                          position: position,
                          icon: _customMarkerIcon ?? 
                              BitmapDescriptor.defaultMarker,
                          infoWindow: InfoWindow(
                            title: 'Custom Marker',
                            snippet: 'Lat: ${position.latitude.toStringAsFixed(4)}, '
                                'Lng: ${position.longitude.toStringAsFixed(4)}',
                          ),
                        ),
                      );
                    });
                  },
                ),
                
                // Status bar at top
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _trackingEnabled ? Icons.gps_fixed : Icons.gps_not_fixed,
                          color: _trackingEnabled ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _statusMessage,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Location info card at bottom
                if (_currentPosition != null)
                  Positioned(
                    bottom: 80,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Current Location',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            'Lng: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            'Accuracy: ${_currentPosition!.accuracy.toStringAsFixed(1)}m',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // My location button
          FloatingActionButton(
            heroTag: 'my_location',
            onPressed: () {
              if (_currentPosition != null) {
                _mapController?.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      zoom: 15.0,
                    ),
                  ),
                );
              }
            },
            backgroundColor: Colors.white,
            child: const Icon(Icons.my_location, color: Colors.blue),
          ),
          const SizedBox(height: 16),
          // Clear markers button
          FloatingActionButton(
            heroTag: 'clear',
            onPressed: () {
              setState(() {
                _markers.removeWhere(
                  (m) => m.markerId.value.startsWith('custom_'),
                );
              });
            },
            backgroundColor: Colors.white,
            child: const Icon(Icons.clear_all, color: Colors.red),
          ),
          const SizedBox(height: 16),
          // Info button
          FloatingActionButton(
            heroTag: 'info',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Location Tracking Features'),
                  content: const SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('• Blue marker = Your location'),
                        Text('• Tap map to add custom markers'),
                        Text('• Tap markers to see details'),
                        Text('• Use play button for live tracking'),
                        Text('• Refresh button updates location'),
                        Text('• My location button centers on you'),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
            backgroundColor: Colors.white,
            child: const Icon(Icons.info_outline, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
