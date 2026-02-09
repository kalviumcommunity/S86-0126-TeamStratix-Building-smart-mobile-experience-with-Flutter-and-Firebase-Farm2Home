import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

/// MapScreen demonstrates Google Maps integration with Flutter
/// Features:
/// - Interactive map with pan and zoom
/// - User location tracking
/// - Custom markers
/// - Camera position controls
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  final Location _location = Location();
  
  // Initial camera position (Example: San Francisco)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 12.0,
  );

  // Set of markers to display on the map
  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('sf_marker'),
      position: LatLng(37.7749, -122.4194),
      infoWindow: InfoWindow(
        title: 'San Francisco',
        snippet: 'Welcome to SF!',
      ),
    ),
    const Marker(
      markerId: MarkerId('golden_gate'),
      position: LatLng(37.8199, -122.4783),
      infoWindow: InfoWindow(
        title: 'Golden Gate Bridge',
        snippet: 'Iconic landmark',
      ),
    ),
  };

  bool _locationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  /// Check and request location permission
  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _locationPermissionGranted = true;
    });
  }

  /// Move camera to user's current location
  Future<void> _goToCurrentLocation() async {
    if (!_locationPermissionGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission not granted')),
      );
      return;
    }

    try {
      final locationData = await _location.getLocation();
      final position = CameraPosition(
        target: LatLng(locationData.latitude!, locationData.longitude!),
        zoom: 15.0,
      );

      _mapController.animateCamera(CameraUpdate.newCameraPosition(position));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }
  }

  /// Add a marker at the tapped position
  void _onMapTapped(LatLng position) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('marker_${_markers.length}'),
          position: position,
          infoWindow: InfoWindow(
            title: 'New Marker',
            snippet: 'Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}',
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Demo'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.layers),
            tooltip: 'Map Type',
            onPressed: () {
              // Toggle map type (can be expanded with a dialog)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Map type options coming soon!')),
              );
            },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        markers: _markers,
        myLocationEnabled: _locationPermissionGranted,
        myLocationButtonEnabled: false, // Use custom button instead
        onTap: _onMapTapped,
        mapType: MapType.normal,
        zoomControlsEnabled: false, // Use custom controls
        compassEnabled: true,
        rotateGesturesEnabled: true,
        scrollGesturesEnabled: true,
        tiltGesturesEnabled: true,
        zoomGesturesEnabled: true,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Go to current location button
          FloatingActionButton(
            heroTag: 'location',
            onPressed: _goToCurrentLocation,
            backgroundColor: Colors.white,
            child: const Icon(Icons.my_location, color: Colors.green),
          ),
          const SizedBox(height: 16),
          // Clear markers button
          FloatingActionButton(
            heroTag: 'clear',
            onPressed: () {
              setState(() {
                _markers.clear();
              });
            },
            backgroundColor: Colors.white,
            child: const Icon(Icons.clear, color: Colors.red),
          ),
          const SizedBox(height: 16),
          // Info button
          FloatingActionButton(
            heroTag: 'info',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Map Info'),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• Tap anywhere to add a marker'),
                      Text('• Pinch to zoom'),
                      Text('• Drag to pan'),
                      Text('• Tap marker to see info'),
                    ],
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
