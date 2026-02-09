# User Location & Custom Markers Guide

## Overview

Location-aware applications rely on retrieving the user's real-time position and placing informative markers on the map. These features power essential experiences such as live delivery tracking, navigation, ride-booking apps, and geofencing systems.

This guide covers how to fetch user location, update camera positions dynamically, add custom markers, and enable live tracking in your Flutter Google Maps application.

---

## Why User Location & Markers Are Important

- **Enables real-time navigation and tracking** for delivery and transportation apps
- **Lets users see their current position** on a map with a custom marker
- **Allows apps to highlight important places** with markers (farms, stores, destinations, checkpoints)
- **Forms the base** for route drawing, distance calculations, and area monitoring
- **Powers geofencing** and proximity-based notifications

---

## Dependencies

The following packages have been added to `pubspec.yaml`:

```yaml
dependencies:
  google_maps_flutter: ^2.5.0  # Google Maps integration
  location: ^5.0.0              # Location services
  geolocator: ^10.1.0           # Advanced location tracking
```

Run:
```bash
flutter pub get
```

---

## Requesting Location Permissions

### Android Setup

File: `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Location permissions -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <uses-permission android:name="android.permission.INTERNET"/>
    
    <application>
        <!-- ... -->
    </application>
</manifest>
```

### iOS Setup

File: `ios/Runner/Info.plist`

```xml
<dict>
    <!-- ... other keys ... -->
    
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>This app requires location access to show your current position.</string>
    
    <key>NSLocationAlwaysUsageDescription</key>
    <string>This app requires location access to provide location-based services.</string>
</dict>
```

---

## Getting User's Current Location

### Using Geolocator (Recommended)

```dart
import 'package:geolocator/geolocator.dart';

// Check permissions
LocationPermission permission = await Geolocator.checkPermission();
if (permission == LocationPermission.denied) {
  permission = await Geolocator.requestPermission();
}

// Get current position
Position position = await Geolocator.getCurrentPosition(
  desiredAccuracy: LocationAccuracy.high,
);

print("User location: ${position.latitude}, ${position.longitude}");
```

### Check if Location Services are Enabled

```dart
bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
if (!serviceEnabled) {
  // Location services are disabled
  return;
}
```

---

## Displaying User Location on Map

### Center Map on User Location

```dart
GoogleMap(
  initialCameraPosition: CameraPosition(
    target: LatLng(position.latitude, position.longitude),
    zoom: 15,
  ),
  myLocationEnabled: true,           // Show blue dot
  myLocationButtonEnabled: true,     // Show location button
)
```

### Move Camera to User Location

```dart
_mapController?.animateCamera(
  CameraUpdate.newCameraPosition(
    CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 15.0,
    ),
  ),
);
```

---

## Adding Markers

### Simple Marker Example

```dart
Set<Marker> markers = {
  Marker(
    markerId: const MarkerId("currentLocation"),
    position: LatLng(position.latitude, position.longitude),
    infoWindow: const InfoWindow(title: "You are here"),
  ),
};

GoogleMap(
  initialCameraPosition: _cameraPosition,
  markers: markers,
)
```

### Marker with Custom Color

```dart
Marker(
  markerId: const MarkerId("farm"),
  position: LatLng(37.7749, -122.4194),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueGreen,
  ),
  infoWindow: const InfoWindow(
    title: "Fresh Farm",
    snippet: "Organic vegetables available",
  ),
)
```

---

## Custom Marker Icons

### Step 1: Add PNG to assets

Place your custom marker image in the assets folder:
```
assets/
  icons/
    custom_pin.png
    user_location.png
```

### Step 2: Update pubspec.yaml

```yaml
flutter:
  assets:
    - assets/icons/
```

### Step 3: Create BitmapDescriptor

```dart
final customIcon = await BitmapDescriptor.fromAssetImage(
  const ImageConfiguration(size: Size(48, 48)),
  'assets/icons/custom_pin.png',
);
```

### Step 4: Use Custom Icon in Marker

```dart
Marker(
  markerId: const MarkerId("customPin"),
  position: LatLng(position.latitude, position.longitude),
  icon: customIcon,
  infoWindow: const InfoWindow(title: "Custom Location"),
)
```

---

## Live Location Tracking

### Real-Time Position Updates

```dart
import 'package:geolocator/geolocator.dart';

StreamSubscription<Position>? _positionStreamSubscription;

void _startLiveTracking() {
  const locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10, // Update every 10 meters
  );

  _positionStreamSubscription = Geolocator.getPositionStream(
    locationSettings: locationSettings,
  ).listen((Position position) {
    setState(() {
      // Update user marker
      _markers.removeWhere((m) => m.markerId.value == 'user_location');
      _markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: const InfoWindow(title: 'You are here'),
        ),
      );
    });
    
    // Update camera to follow user
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(position.latitude, position.longitude),
      ),
    );
  });
}

void _stopLiveTracking() {
  _positionStreamSubscription?.cancel();
}
```

### Dispose Properly

```dart
@override
void dispose() {
  _positionStreamSubscription?.cancel();
  super.dispose();
}
```

---

## Calculate Distance

### Distance Between Two Points

```dart
double distanceInMeters = Geolocator.distanceBetween(
  startLatitude,
  startLongitude,
  endLatitude,
  endLongitude,
);

// Convert to kilometers
double distanceInKm = distanceInMeters / 1000;
```

### Example: Distance to Marker

```dart
Future<void> calculateDistanceToFarm() async {
  if (_currentPosition == null) return;
  
  double distance = Geolocator.distanceBetween(
    _currentPosition!.latitude,
    _currentPosition!.longitude,
    farmLat,
    farmLng,
  );
  
  print('Distance to farm: ${(distance / 1000).toStringAsFixed(2)} km');
}
```

---

## Complete Implementation

See `lib/screens/location_tracking_screen.dart` for a full-featured implementation with:

- ✅ Permission handling
- ✅ Real-time location tracking
- ✅ Custom markers with different colors
- ✅ Live position updates
- ✅ Distance calculations
- ✅ Camera animations
- ✅ User location display
- ✅ Tap to add markers
- ✅ Status indicators

---

## Common Issues & Solutions

| Issue | Cause | Fix |
|-------|-------|-----|
| Map not centering on user | Location fetched after map load | Use `setState()` after fetching location |
| Location permissions denied | User tapped "Deny" | Request permissions again & add fallback |
| Marker not showing | Incorrect marker set or missing rebuild | Use `setState()` after marker update |
| Custom marker appears too big | Wrong icon dimension | Resize PNG to 64×64 or use `ImageConfiguration` |
| Map crashes on iOS | Missing permission text | Add `NSLocation` usage descriptions |
| Location not updating | Stream not properly set up | Check `LocationSettings` configuration |
| High battery drain | Too frequent updates | Increase `distanceFilter` value |

---

## Best Practices

### 1. Permission Handling
```dart
// Always check permissions before accessing location
LocationPermission permission = await Geolocator.checkPermission();
if (permission == LocationPermission.denied) {
  permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.denied) {
    // Handle denial
    return;
  }
}
```

### 2. Battery Optimization
```dart
// Use appropriate accuracy level
const locationSettings = LocationSettings(
  accuracy: LocationAccuracy.medium,  // Not always high
  distanceFilter: 50,                 // Update every 50 meters
);
```

### 3. Error Handling
```dart
try {
  Position position = await Geolocator.getCurrentPosition();
} catch (e) {
  // Handle errors gracefully
  print('Error getting location: $e');
}
```

### 4. Cleanup Resources
```dart
@override
void dispose() {
  _positionStreamSubscription?.cancel();
  _mapController?.dispose();
  super.dispose();
}
```

---

## Use Cases for Farm2Home

### 1. Farm Location Markers
Display all registered farms with custom green markers:
```dart
Marker(
  markerId: MarkerId('farm_$id'),
  position: LatLng(farmLat, farmLng),
  icon: greenFarmIcon,
  infoWindow: InfoWindow(title: farmName),
)
```

### 2. Delivery Tracking
Track delivery personnel in real-time:
```dart
Geolocator.getPositionStream().listen((position) {
  // Update delivery person marker
  updateDeliveryMarker(position);
});
```

### 3. Geofencing
Notify when user approaches farm:
```dart
double distance = Geolocator.distanceBetween(
  userLat, userLng, farmLat, farmLng,
);

if (distance < 500) {  // Within 500 meters
  showNotification('You are near Fresh Farm!');
}
```

### 4. Route Planning
Show route from user to farm:
```dart
// Calculate and display polyline
Polyline(
  polylineId: PolylineId('route'),
  points: [
    LatLng(userLat, userLng),
    LatLng(farmLat, farmLng),
  ],
  color: Colors.blue,
  width: 5,
)
```

---

## Testing Checklist

- [ ] Location permission dialog appears
- [ ] After granting permission, user location is displayed
- [ ] Blue dot shows on map at user location
- [ ] My location button works
- [ ] Custom markers appear correctly
- [ ] Tap marker shows info window
- [ ] Live tracking updates position smoothly
- [ ] Distance calculations are accurate
- [ ] App handles permission denial gracefully
- [ ] Location services disabled is handled
- [ ] Battery usage is reasonable during tracking

---

## Additional Resources

- 📦 [geolocator Package](https://pub.dev/packages/geolocator)
- 📦 [google_maps_flutter Package](https://pub.dev/packages/google_maps_flutter)
- 📦 [location Package](https://pub.dev/packages/location)
- 🌐 [Google Maps Platform](https://developers.google.com/maps)
- 📖 [Location Permissions on Android](https://developer.android.com/training/location/permissions)
- 📖 [iOS Location Services](https://developer.apple.com/documentation/corelocation)

---

## Next Steps

1. **Add custom marker images** to assets folder
2. **Integrate with Firebase** to store and sync locations
3. **Implement route drawing** between points
4. **Add geofencing** for proximity alerts
5. **Enable offline maps** for areas without connectivity
6. **Optimize battery usage** for long tracking sessions

---

**Happy Location Tracking! 📍**
