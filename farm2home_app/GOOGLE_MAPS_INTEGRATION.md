# Google Maps Integration Guide

## Overview

Location-based applications such as delivery tracking, cab booking, navigation services, and real-time monitoring heavily rely on interactive map views. Flutter provides seamless integration with the Google Maps SDK, allowing developers to embed maps, display markers, respond to gestures, and customize UI layers.

This guide walks you through enabling Google Maps for Android and iOS, acquiring API keys, configuring permissions, and rendering a functional map widget inside a Flutter screen.

## Why Google Maps Integration Is Important

- **Enables navigation, routing, and geolocation features** for delivery and tracking apps
- **Forms the foundation** for apps like cab booking (Uber), delivery tracking (Swiggy), and map-based dashboards
- **Allows overlaying** markers, polygons, heatmaps, and custom UI layers
- **Works smoothly** with device GPS for real-time updates

---

## Setup Steps

### Step 1: Add Dependencies

The following dependencies have been added to `pubspec.yaml`:

```yaml
dependencies:
  google_maps_flutter: ^2.5.0  # Google Maps integration
  location: ^5.0.0              # Location services
  geolocator: ^10.1.0           # Advanced location tracking
```

Run to install:
```bash
flutter pub get
```

### Step 2: Get a Google Maps API Key

1. Go to [Google Cloud Console](https://console.cloud.google.com/) → **APIs & Services** → **Credentials**

2. **Enable the following APIs:**
   - Maps SDK for Android
   - Maps SDK for iOS
   - Geocoding API (optional)
   - Places API (optional)

3. **Create an API Key** and copy it

4. **Important Security Note:**
   - For production, restrict your API key by:
     - Application restrictions (Android package name / iOS bundle ID)
     - API restrictions (only enable needed APIs)

---

## Platform Configuration

### Android Setup

#### 1. Add API Key

File: `android/app/src/main/AndroidManifest.xml`

```xml
<application>
    <!-- ... other config ... -->
    
    <!-- Google Maps API Key -->
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="YOUR_GOOGLE_MAPS_API_KEY_HERE"/>
</application>
```

#### 2. Add Location Permissions

File: `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Location permissions for Google Maps -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <uses-permission android:name="android.permission.INTERNET"/>
    
    <application>
        <!-- ... -->
    </application>
</manifest>
```

#### 3. Update Build Configuration

Ensure your `android/app/build.gradle` has minSdkVersion >= 21:

```gradle
android {
    defaultConfig {
        minSdkVersion 21  // Minimum for Google Maps
    }
}
```

---

### iOS Setup

#### 1. Add API Key to AppDelegate

File: `ios/Runner/AppDelegate.swift`

```swift
import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Provide Google Maps API Key
    GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY_HERE")
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

#### 2. Add Location Permissions

File: `ios/Runner/Info.plist`

```xml
<dict>
    <!-- ... other config ... -->
    
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>This app requires location access to display maps and provide location-based services.</string>
    
    <key>NSLocationAlwaysUsageDescription</key>
    <string>This app requires location access to display maps and provide location-based services.</string>
</dict>
```

#### 3. Update iOS Deployment Target

Ensure `ios/Podfile` has iOS 14.0 or higher:

```ruby
platform :ios, '14.0'
```

---

## Usage Examples

### Basic Map Display

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BasicMapScreen extends StatelessWidget {
  const BasicMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Basic Map")),
      body: const GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194), // San Francisco
          zoom: 12,
        ),
      ),
    );
  }
}
```

### Map with User Location

```dart
GoogleMap(
  initialCameraPosition: const CameraPosition(
    target: LatLng(0, 0),
    zoom: 2,
  ),
  myLocationEnabled: true,
  myLocationButtonEnabled: true,
)
```

**Note:** Requires runtime permission on both platforms.

### Adding Markers

```dart
GoogleMap(
  initialCameraPosition: const CameraPosition(
    target: LatLng(28.6139, 77.2090), // New Delhi
    zoom: 12,
  ),
  markers: {
    const Marker(
      markerId: MarkerId("delhi"),
      position: LatLng(28.6139, 77.2090),
      infoWindow: InfoWindow(title: "New Delhi"),
    ),
  },
)
```

### Full-Featured Map Screen

See `lib/screens/map_screen.dart` for a complete implementation with:
- Interactive map controls
- User location tracking
- Dynamic marker placement
- Camera animations
- Custom UI controls

---

## Common Issues & Solutions

| Issue | Reason | Fix |
|-------|--------|-----|
| Blank screen on Android | API key missing or incorrect | Add key to `AndroidManifest.xml` metadata |
| "For development only" watermark | Billing not enabled | Enable billing in Google Cloud Console |
| iOS crash on launch | API key missing in AppDelegate | Add `GMSServices.provideAPIKey()` |
| Location not showing | Permission missing or denied | Add platform permissions and request at runtime |
| Red screen: "API key blocked" | Restricted or incorrect key | Remove restrictions or use correct SHA certificate |
| Android build fails | minSdkVersion too low | Set minSdkVersion to 21 or higher |
| iOS build fails | Deployment target too low | Set iOS deployment target to 14.0+ |

---

## Testing Your Implementation

### 1. Run the App

```bash
flutter run
```

### 2. Navigate to Map Screen

Add navigation to your app:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const MapScreen()),
);
```

### 3. Verify Features

- ✅ Map loads and displays correctly
- ✅ Can pan and zoom with gestures
- ✅ Markers appear and show info on tap
- ✅ Location button works (if permission granted)
- ✅ Can tap to add new markers

---

## Best Practices

### 1. **Security**
- Never commit API keys to version control
- Use environment variables or secure key management
- Restrict API keys for production

### 2. **Performance**
- Limit the number of markers (use clustering for many markers)
- Dispose of map controllers properly
- Cache map tiles when possible

### 3. **User Experience**
- Always request location permission with clear explanation
- Handle permission denial gracefully
- Show loading states while map initializes
- Provide fallback for devices without location services

### 4. **Error Handling**
```dart
try {
  final locationData = await location.getLocation();
  // Use location
} catch (e) {
  // Handle location error
  print('Error getting location: $e');
}
```

---

## Advanced Features

### Custom Map Styling

```dart
GoogleMap(
  onMapCreated: (controller) {
    controller.setMapStyle(yourCustomJsonStyle);
  },
)
```

### Polylines (Routes)

```dart
Set<Polyline> polylines = {
  Polyline(
    polylineId: PolylineId('route'),
    points: [
      LatLng(37.7749, -122.4194),
      LatLng(37.8049, -122.4294),
    ],
    color: Colors.blue,
    width: 5,
  ),
};
```

### Circles and Polygons

```dart
Set<Circle> circles = {
  Circle(
    circleId: CircleId('area'),
    center: LatLng(37.7749, -122.4194),
    radius: 1000, // meters
    fillColor: Colors.blue.withOpacity(0.3),
  ),
};
```

---

## User Location & Live Tracking

### Enhanced Location Features

The app now includes advanced location tracking capabilities using the `geolocator` package. See the complete implementation in `lib/screens/location_tracking_screen.dart`.

### New Dependencies

```yaml
dependencies:
  geolocator: ^10.1.0  # Advanced location tracking
```

### Key Features

#### 1. **Real-Time Location Tracking**
```dart
Geolocator.getPositionStream(
  locationSettings: LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10, // Update every 10 meters
  ),
).listen((Position position) {
  // Update user position on map
});
```

#### 2. **Permission Handling**
```dart
LocationPermission permission = await Geolocator.checkPermission();
if (permission == LocationPermission.denied) {
  permission = await Geolocator.requestPermission();
}
```

#### 3. **Get Current Position**
```dart
Position position = await Geolocator.getCurrentPosition(
  desiredAccuracy: LocationAccuracy.high,
);
```

#### 4. **Distance Calculations**
```dart
double distance = Geolocator.distanceBetween(
  startLat, startLng,
  endLat, endLng,
); // Returns distance in meters
```

#### 5. **Custom Markers**
```dart
// Load custom icon from assets
BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
  const ImageConfiguration(size: Size(48, 48)),
  'assets/icons/custom_pin.png',
);

Marker(
  markerId: MarkerId('custom'),
  position: LatLng(lat, lng),
  icon: customIcon,
)
```

### Location Tracking Screen Features

✅ Real-time GPS position updates  
✅ Live tracking with play/pause controls  
✅ User location marker (blue)  
✅ Custom markers for farms, markets, delivery points  
✅ Distance calculation to any marker  
✅ Tap map to add custom markers  
✅ Status indicators  
✅ Location accuracy display  
✅ Battery-optimized tracking  

### Complete Guide

For detailed implementation and examples, see:
📄 **[LOCATION_TRACKING_GUIDE.md](LOCATION_TRACKING_GUIDE.md)**

---

## Additional Resources

- 📦 [google_maps_flutter Package](https://pub.dev/packages/google_maps_flutter)
- 📦 [geolocator Package](https://pub.dev/packages/geolocator)
- 🌐 [Google Maps Platform Docs](https://developers.google.com/maps)
- 🔑 [Google Cloud Console](https://console.cloud.google.com)
- 📖 [Flutter Location Services Guide](https://flutter.dev/docs/development/data-and-backend/location)
- 📄 [Location Tracking Guide](LOCATION_TRACKING_GUIDE.md
- 📖 [Flutter Location Services Guide](https://flutter.dev/docs/development/data-and-backend/location)

---

## Next Steps

1. **Replace placeholder API keys** with your actual Google Maps API keys
2. **Test on physical devices** to verify location features
3. **Implement custom markers** for farm locations, delivery 
6. **Try the location tracking screen** for advanced features (`location_tracking_screen.dart`)
7. **Add custom marker icons** to the assets folderpoints, etc.
4. **Add route tracking** for delivery personnel
5. **Integrate with Firebase** for real-time location updates

---

## Support

For issues with Google Maps integration:
1. Check the troubleshooting section above
2. Verify API key configuration
3. Review platform-specific logs (Logcat for Android, Xcode console for iOS)
4. Ensure billing is enabled in Google Cloud Console

Happy mapping! 🗺️
