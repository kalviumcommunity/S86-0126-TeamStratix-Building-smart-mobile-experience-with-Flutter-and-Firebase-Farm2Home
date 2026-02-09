# Google Maps Integration - Quick Reference

## 🚀 Quick Start (10 minutes)

### 1️⃣ Get API Key (5 minutes)
```
1. Go to console.cloud.google.com
2. Create project "Farm2Home Maps"
3. Enable "Maps SDK for Android"
4. Enable "Maps SDK for iOS"
5. Create API Key (Credentials → Create Credentials)
6. Copy the key
```

### 2️⃣ Configure Platforms

#### Android (2 minutes)
**File**: `android/app/src/main/AndroidManifest.xml`
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_KEY_HERE" />
```

#### iOS (2 minutes)
**File**: `ios/Runner/AppDelegate.swift`
```swift
GMSServices.provideAPIKey("YOUR_KEY_HERE")
```

**File**: `ios/Runner/Info.plist`
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to your location to show it on the map</string>
```

### 3️⃣ Install Dependencies (1 minute)
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📋 Essential Commands

```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Navigate to map screen
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const MapScreen()),
);
```

---

## 💡 Basic Usage

### Import
```dart
import 'package:google_maps_flutter/google_maps_flutter.dart';
```

### Simple Map
```dart
GoogleMap(
  initialCameraPosition: CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 12,
  ),
)
```

### With Location
```dart
GoogleMap(
  myLocationEnabled: true,
  myLocationButtonEnabled: true,
)
```

### With Marker
```dart
GoogleMap(
  markers: {
    Marker(
      markerId: MarkerId('id'),
      position: LatLng(37.7749, -122.4194),
      infoWindow: InfoWindow(title: 'Title'),
    ),
  },
)
```

## Map Controller

```dart
GoogleMapController? _controller;

GoogleMap(
  onMapCreated: (controller) {
    _controller = controller;
  },
)

// Move camera
_controller?.animateCamera(
  CameraUpdate.newCameraPosition(
    CameraPosition(target: LatLng(lat, lng), zoom: 15),
  ),
);
```

## Location Permission

```dart
import 'package:location/location.dart';

final Location location = Location();

// Check permission
PermissionStatus status = await location.hasPermission();

// Request permission
if (status == PermissionStatus.denied) {
  status = await location.requestPermission();
}

// Get location
LocationData locationData = await location.getLocation();
```

## Common Properties

```dart
GoogleMap(
  mapType: MapType.normal,          // normal, satellite, hybrid, terrain
  myLocationEnabled: true,          // Show user location
  myLocationButtonEnabled: true,    // Show location button
  zoomControlsEnabled: false,       // Show zoom controls
  compassEnabled: true,             // Show compass
  scrollGesturesEnabled: true,      // Enable pan
  zoomGesturesEnabled: true,        // Enable zoom
  tiltGesturesEnabled: true,        // Enable tilt
  rotateGesturesEnabled: true,      // Enable rotate
  onTap: (LatLng position) {},      // Handle tap
  onLongPress: (LatLng position) {}, // Handle long press
)
```

## Marker Customization

```dart
Marker(
  markerId: MarkerId('id'),
  position: LatLng(lat, lng),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueGreen,
  ),
  infoWindow: InfoWindow(
    title: 'Title',
    snippet: 'Description',
  ),
  onTap: () => print('Marker tapped'),
)
```

## Polyline (Route)

```dart
Polyline(
  polylineId: PolylineId('route'),
  points: [
    LatLng(37.7749, -122.4194),
    LatLng(37.8049, -122.4294),
  ],
  color: Colors.blue,
  width: 5,
)
```

## Circle

```dart
Circle(
  circleId: CircleId('area'),
  center: LatLng(37.7749, -122.4194),
  radius: 1000, // meters
  fillColor: Colors.blue.withOpacity(0.3),
  strokeColor: Colors.blue,
  strokeWidth: 2,
)
```

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Blank screen | Add API key |
| "Development only" | Enable billing |
| Location not working | Grant permissions |
| Build errors | Check minSdkVersion (21+) |

## Links

- 📦 [Package](https://pub.dev/packages/google_maps_flutter)
- 🔑 [Get API Key](https://console.cloud.google.com)
- 📖 [Full Guide](GOOGLE_MAPS_INTEGRATION.md)

## API Key Security

⚠️ **IMPORTANT**: Never commit API keys to version control!

**Production:**
```dart
// Use environment variables
const apiKey = String.fromEnvironment('MAPS_API_KEY');
```

**Development:**
```bash
# Run with key
flutter run --dart-define=MAPS_API_KEY=your_key_here
```

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapExample extends StatefulWidget {
  @override
  _MapExampleState createState() => _MapExampleState();
}

class _MapExampleState extends State<MapExample> {
  GoogleMapController? _controller;
  
  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId('home'),
      position: LatLng(37.7749, -122.4194),
      infoWindow: InfoWindow(title: 'Home'),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 12,
        ),
        onMapCreated: (controller) => _controller = controller,
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
```

---

For detailed documentation, see [GOOGLE_MAPS_INTEGRATION.md](GOOGLE_MAPS_INTEGRATION.md)
