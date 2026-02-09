# Location Permissions Setup Guide

## Overview
This guide explains how to set up location permissions for the Farm2Home app to use Geolocator for GPS access and Google Maps integration.

## Dependencies Added
- **geolocator: ^10.1.0** - For accessing user's GPS location and handling permissions
- **google_maps_flutter: ^2.5.0** - For displaying maps and markers

## Android Configuration

### AndroidManifest.xml
The following permissions have been added to `android/app/src/main/AndroidManifest.xml`:

```xml
<!-- Location Permissions for GPS access -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

**Explanation:**
- `ACCESS_FINE_LOCATION`: Allows the app to access precise GPS location (required for accurate mapping)
- `ACCESS_COARSE_LOCATION`: Allows the app to access approximate location based on cell towers and WiFi (fallback)

### Android Runtime Permissions
For Android 6.0 (API level 23) and above, the app requests location permissions at runtime. The Geolocator plugin handles this automatically when you call:

```dart
Position? position = await LocationService.getUserLocation();
```

The permission request dialog will appear the first time the user taps the "Locate Me" button.

## iOS Configuration

### Info.plist
The following keys have been added to `ios/Runner/Info.plist`:

```xml
<!-- Location permissions for GPS access -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs to access your location to show it on the map and help you find nearby farms and markets.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs to access your location to show it on the map and help you find nearby farms and markets.</string>
```

**Explanation:**
- `NSLocationWhenInUseUsageDescription`: Message shown when requesting location permission while the app is in use
- `NSLocationAlwaysAndWhenInUseUsageDescription`: Message shown when requesting background location access

### iOS Build Requirements
For iOS 10 and above, the permission strings in `Info.plist` are mandatory. Without them, the app will crash when requesting location access.

## Google Maps Configuration

### API Key Setup
To use Google Maps, you need to:

1. **Get a Google Maps API Key** from Google Cloud Console
   - Go to https://console.cloud.google.com/
   - Create a new project or select existing one
   - Enable `Maps SDK for Android` and `Maps SDK for iOS`
   - Create an API key

2. **Android Setup** (`android/app/build.gradle`):
   ```gradle
   android {
       ...
       defaultConfig {
           ...
           resValue "string", "google_maps_key", "YOUR_API_KEY_HERE"
       }
   }
   ```

3. **iOS Setup** (`ios/Runner/Info.plist`):
   ```xml
   <key>com.google.ios.maps_app_version</key>
   <string>2.0</string>
   <key>io.flutter.embedded_views_preview</key>
   <true/>
   ```

**Note:** Replace `YOUR_API_KEY_HERE` with your actual API key.

## Location Service Implementation

The app includes a `LocationService` class (`lib/services/location_service.dart`) that handles:

1. **Permission Checking**: Verifies if location permissions are granted
2. **Permission Requesting**: Requests permissions from the user
3. **Location Fetching**: Gets the user's current GPS coordinates
4. **Location Streaming**: Provides real-time location updates

### Key Methods

```dart
// Get user's current position (one-time fetch)
Position? position = await LocationService.getUserLocation();

// Stream real-time location updates
Stream<Position> positions = LocationService.getLocationUpdates();

// Check if location services are enabled
bool enabled = await LocationService.isLocationServiceEnabled();
```

## Location Preview Screen

The app includes a `LocationPreviewScreen` that demonstrates:

1. **"Locate Me" Button**: Blue FAB that fetches user's current location
2. **User Location Marker**: Blue marker placed at user's position on the map
3. **Demo Markers**: Green (Hub), Orange (Farm), Red (Market)
4. **Map Controls**: Zoom, pan, and compass controls

### Features Demonstrated

- Location permission handling with user-friendly dialogs
- GPS coordinate fetching using Geolocator
- Map centering on user location
- Marker placement based on GPS coordinates
- Real-time camera animation to new location
- Error handling for permission denial or disabled location services

## Testing the Implementation

### Android Testing
1. Build and run on Android device/emulator
2. Navigate to Location Preview screen
3. Tap "Locate Me" button
4. Grant permission when prompted
5. Verify that:
   - Blue marker appears at your location
   - Map centers on your location
   - Coordinates are displayed in the status card

### iOS Testing
1. Build and run on iOS device/simulator
2. Navigate to Location Preview screen
3. Tap "Locate Me" button
4. Grant permission when prompted in system dialog
5. Verify same functionality as Android

## Troubleshooting

### Permission Dialog Not Appearing
- Ensure location permissions are declared in AndroidManifest.xml and Info.plist
- Clear app data and reinstall (for testing)
- Check that the app has location permissions granted in device Settings

### Location Not Fetching
- Verify location services are enabled on device
- Check that `ACCESS_FINE_LOCATION` permission is granted
- Ensure device has GPS signal (outdoors, clear sky preferred)
- Simulator may not have accurate location data

### Map Not Showing
- Verify Google Maps API key is correctly configured
- Check that `myLocationEnabled` is set appropriately on GoogleMap widget
- Ensure `buildingsEnabled` and other map features don't cause issues

### Marker Not Visible
- Confirm location coordinates are valid (latitude -90 to 90, longitude -180 to 180)
- Verify markers collection is updated before rebuilding widget
- Check that marker position is within visible map bounds

## Additional Resources

- [Geolocator Package Documentation](https://pub.dev/packages/geolocator)
- [Google Maps Flutter Documentation](https://pub.dev/packages/google_maps_flutter)
- [Android Location Permissions](https://developer.android.com/training/location)
- [iOS Location Services](https://developer.apple.com/documentation/corelocation)

## Implementation Checklist

- ✅ Added geolocator and google_maps_flutter dependencies
- ✅ Created LocationService with permission handling
- ✅ Updated LocationPreviewScreen with real location access
- ✅ Added Android permissions in AndroidManifest.xml
- ✅ Added iOS permissions in Info.plist
- ✅ Implemented "Locate Me" feature with FAB button
- ✅ Added user location marker (blue pin)
- ✅ Implemented error handling and user dialogs
- ✅ Route configured in main.dart

