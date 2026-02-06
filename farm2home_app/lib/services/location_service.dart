import 'package:geolocator/geolocator.dart';

/// Location Service
/// Handles user location permissions and GPS coordinate fetching
class LocationService {
  /// Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      print('Error checking location service: $e');
      return false;
    }
  }

  /// Request location permissions
  /// Returns the permission status
  static Future<LocationPermission> requestLocationPermission() async {
    try {
      final permission = await Geolocator.requestPermission();
      return permission;
    } catch (e) {
      print('Error requesting permission: $e');
      return LocationPermission.denied;
    }
  }

  /// Check current location permission status
  static Future<LocationPermission> checkLocationPermission() async {
    try {
      return await Geolocator.checkPermission();
    } catch (e) {
      print('Error checking permission: $e');
      return LocationPermission.denied;
    }
  }

  /// Get user's current GPS position
  /// Requests permission if not already granted
  /// Returns the Position object containing latitude and longitude
  static Future<Position?> getUserLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return null;
      }

      // Check current permission status
      LocationPermission permission = await checkLocationPermission();

      // Request permission if denied
      if (permission == LocationPermission.denied) {
        permission = await requestLocationPermission();
      }

      // Handle denial cases
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return null;
      }

      if (permission == LocationPermission.deniedForever) {
        print(
            'Location permissions are permanently denied, we cannot request permissions.');
        // Optionally open app settings
        await Geolocator.openLocationSettings();
        return null;
      }

      // Permission granted, fetch position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 10),
      );

      return position;
    } catch (e) {
      print('Error getting user location: $e');
      return null;
    }
  }

  /// Get a stream of location updates
  /// Useful for real-time location tracking
  static Stream<Position> getLocationUpdates({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10, // Minimum distance change before update (in meters)
  }) {
    return Geolocator.getPositionStream(
      accuracyFilter: accuracy,
      distanceFilter: distanceFilter,
      timeInterval: 1000, // Update every 1 second
    );
  }

  /// Calculate distance between two coordinates in meters
  static double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// Open app settings for location permission
  static Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  /// Open location settings
  static Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }
}
