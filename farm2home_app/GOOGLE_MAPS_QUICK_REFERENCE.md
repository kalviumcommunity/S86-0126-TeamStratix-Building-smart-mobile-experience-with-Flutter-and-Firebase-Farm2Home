# Google Maps Integration - Quick Reference

 Integrating-Google-Maps-SDK
## 🚀 Quick Start (10 minutes)

## 🚀 Quick Start
main

### 1️⃣ Get API Key (5 minutes)
```
1. Go to console.cloud.google.com
2. Create project "Farm2Home Maps"
3. Enable "Maps SDK for Android"
4. Enable "Maps SDK for iOS"
5. Create API Key (Credentials → Create Credentials)
6. Copy the key
```
 Integrating-Google-Maps-SDK
### 2️⃣ Configure Platforms

#### Android (2 minutes)
=======
### 2️⃣ Configure Android (2 minutes)
 main
**File**: `android/app/src/main/AndroidManifest.xml`
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_KEY_HERE" />
```

 Integrating-Google-Maps-SDK
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
=======
### 3️⃣ Configure iOS (2 minutes)
**File**: `ios/Runner/Info.plist`
```xml
<key>com.google.ios.maps.API_KEY</key>
<string>YOUR_KEY_HERE</string>

<key>io.flutter.embedded_views_preview</key>
<true/>
```

### 4️⃣ Add Dependency (1 minute)
```bash
# Already in pubspec.yaml:
google_maps_flutter: ^2.5.0
```

### 5️⃣ Run App main
```bash
flutter clean
flutter pub get
flutter run
```

---

Integrating-Google-Maps-SDK
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

## 📍 Key Locations (Pre-configured)

| Location | Latitude | Longitude | Color |
|----------|----------|-----------|-------|
| **Hub** (San Francisco) | 37.7749 | -122.4194 | 🟢 Green |
| **Farm** (Sacramento) | 38.5816 | -121.4944 | 🟠 Orange |
| **Market** (San Jose) | 37.3382 | -121.8863 | 🔴 Red |

---

## 🎮 User Interactions

| Action | How |
|--------|-----|
| **Zoom In** | Pinch inward with two fingers |
| **Zoom Out** | Pinch outward with two fingers |
| **Pan** | Drag map with one finger |
| **Tap Marker** | Tap any marker to show location info |
| **Jump to Location** | Click Hub/Farm/Market button |
| **Reset View** | Click Reset button |

---

## 📁 Modified Files

### `pubspec.yaml`
- Added `google_maps_flutter: ^2.5.0`

### `lib/main.dart`
- Added import: `import 'screens/location_preview_screen.dart';`
- Added route: `'/location-preview': (context) => const LocationPreviewScreen()`

### `lib/screens/home_screen.dart`
- Added menu item: "Location Preview"

### New Files Created
- `lib/screens/location_preview_screen.dart` (800+ lines)

---

## 🔧 Configuration Files

### Android: `android/app/src/main/AndroidManifest.xml`
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY_HERE" />
```

### iOS: `ios/Runner/Info.plist`
```xml
<key>com.google.ios.maps.API_KEY</key>
<string>YOUR_GOOGLE_MAPS_API_KEY_HERE</string>

<key>io.flutter.embedded_views_preview</key>
<true/>

<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to your location to show it on the map</string>
```

---

## 🐛 Troubleshooting

| Problem | Solution |
|---------|----------|
| **Gray map** | Check API key, verify billing enabled, wait 5 min |
| **Map won't load** | Run `flutter clean`, then `flutter pub get` |
| **Plugin error** | Ensure `google_maps_flutter` in pubspec.yaml |
| **Permission denied** | Add permissions to AndroidManifest.xml |
| **iOS build fails** | Run `cd ios && pod install && cd ..` |

---

## 📲 Testing Checklist

- [ ] App launches without errors
- [ ] Location Preview menu item appears
- [ ] Tapping menu item navigates to map
- [ ] Map loads with three markers visible
- [ ] Green marker at San Francisco
- [ ] Orange marker at Sacramento  
- [ ] Red marker at San Jose
- [ ] Pinch-zoom works
- [ ] Drag/pan works
- [ ] Marker tap shows info
- [ ] Hub/Farm/Market buttons navigate
- [ ] Reset button returns to starting view
- [ ] Zoom controls (+/-) work
- [ ] Compass rose appears

---

## 🎬 Recording Checklist

- [ ] Test map fully beforehand
- [ ] Document current position (start from home screen)
- [ ] Explain why using Google Maps
- [ ] Navigate to Location Preview
- [ ] Test pinch zoom (2-3 times)
- [ ] Test drag/pan (move map around)
- [ ] Tap each marker
- [ ] Test navigation buttons
- [ ] Show code (GoogleMap widget, markers setup)
- [ ] Explain key configuration pieces
- [ ] Show Android/iOS configuration (blur API key!)
- [ ] Don't expose actual API key

---

## 🔐 API Key Security

✅ **DO**:
- Store in AndroidManifest.xml
- Store in Info.plist
- Restrict to your app
- Monitor usage

❌ **DON'T**:
- Commit to GitHub
- Share publicly
- Hardcode in Dart code
- Print in logs

---

## 💰 Billing

- **Free monthly credit**: ~$300
- **Cost per 1000 requests**: ~$7
- **Estimate**: Small app = free, Medium = $50-100/mo

Monitor at: [Google Cloud Console → Billing](https://console.cloud.google.com/billing)

---

## 📚 References

- [google_maps_flutter Package](https://pub.dev/packages/google_maps_flutter)
- [GoogleMap Widget API](https://pub.dev/documentation/google_maps_flutter/latest/google_maps_flutter/GoogleMap-class.html)
- [Google Cloud Console](https://console.cloud.google.com)
- [Maps API Docs](https://developers.google.com/maps/documentation)

---

## 🎯 Features Implemented

✅ GoogleMap widget with 3 markers  
✅ Camera animation to locations  
✅ Zoom controls (+/-)  
✅ Compass rose  
✅ Drag/pan capability  
✅ Pinch zoom capability  
✅ My Location button  
✅ Building layer rendering  
✅ Info windows on markers  
✅ Responsive design  
✅ Feature explanation UI  
✅ Code examples in app  
✅ Configuration reference  

---

**Last Updated**: February 6, 2026  
**Version**: 1.0 Complete
 main
