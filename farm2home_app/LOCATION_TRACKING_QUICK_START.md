# Location Tracking - Quick Start ⚡

## 🚀 Setup (2 minutes)

### 1. Dependencies Already Added ✅
```yaml
geolocator: ^10.1.0
google_maps_flutter: ^2.5.0
location: ^5.0.0
```

### 2. Permissions Already Configured ✅
**Android** & **iOS** location permissions are set up.

### 3. Use the Screen
```dart
import 'package:farm2home_app/screens/location_tracking_screen.dart';

// Navigate to location tracking
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const LocationTrackingScreen(),
  ),
);
```

---

## 📱 Features at a Glance

| Feature | How to Use |
|---------|------------|
| **View Location** | Grant permission → See blue marker |
| **Live Tracking** | Tap ▶️ play button in app bar |
| **Stop Tracking** | Tap ⏸️ pause button |
| **Add Marker** | Tap anywhere on map |
| **View Details** | Tap any marker |
| **Center on You** | Tap 📍 location button |
| **Clear Markers** | Tap 🗑️ clear button |
| **Help** | Tap ℹ️ info button |

---

## 🎮 Controls

### App Bar
- **▶️ Play** - Start live tracking
- **⏸️ Pause** - Stop tracking
- **🔄 Refresh** - Update location

### Floating Buttons
- **📍 My Location** - Center map on you
- **🗑️ Clear All** - Remove custom markers
- **ℹ️ Info** - Show help

---

## 📊 What You'll See

### Status Bar (Top)
Shows current status:
- 🟢 "Live tracking enabled"
- ⏸️ "Live tracking disabled"
- 📍 "Location found"

### Info Card (Bottom)
Your current location:
```
Lat: 37.774900
Lng: -122.419400
Accuracy: 15.2m
```

### Markers
- 🔵 **Blue** - You are here
- 🟢 **Green** - Farm location
- 🟠 **Orange** - Market
- 🔴 **Red** - Delivery point
- 📍 **Custom** - Tap-added markers

---

## 🧪 Test It Out

### 1️⃣ First Launch
```
1. Open location tracking screen
2. Grant location permission
3. See your location on map
```

### 2️⃣ Try Live Tracking
```
1. Tap play button
2. Move around
3. Watch marker update
4. Tap pause to stop
```

### 3️⃣ Add Custom Markers
```
1. Tap anywhere on map
2. See new marker appear
3. Tap marker to view info
4. Tap clear to remove
```

---

## 💻 Code Examples

### Get Current Location
```dart
Position position = await Geolocator.getCurrentPosition(
  desiredAccuracy: LocationAccuracy.high,
);
```

### Start Live Tracking
```dart
Geolocator.getPositionStream(
  locationSettings: LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10, // Update every 10m
  ),
).listen((Position position) {
  // Update marker
});
```

### Calculate Distance
```dart
double distance = Geolocator.distanceBetween(
  startLat, startLng,
  endLat, endLng,
); // Returns meters
```

### Add Custom Marker
```dart
Marker(
  markerId: MarkerId('my_marker'),
  position: LatLng(lat, lng),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueGreen,
  ),
  infoWindow: InfoWindow(title: 'My Place'),
)
```

---

## ⚡ Quick Snippets

### Permission Check
```dart
bool hasPermission = await Geolocator.checkPermission() != 
  LocationPermission.denied;
```

### Service Check
```dart
bool enabled = await Geolocator.isLocationServiceEnabled();
```

### Move Camera to Location
```dart
_mapController?.animateCamera(
  CameraUpdate.newLatLng(LatLng(lat, lng)),
);
```

---

## 🔧 Common Issues

| Problem | Solution |
|---------|----------|
| No blue marker | Grant location permission |
| Not updating | Tap play button |
| Wrong location | Wait for better GPS signal |
| Battery drain | Use pause when not needed |

---

## 📚 Full Documentation

For complete details, see:
- 📄 [LOCATION_TRACKING_GUIDE.md](LOCATION_TRACKING_GUIDE.md) - Complete guide
- 📄 [GOOGLE_MAPS_INTEGRATION.md](GOOGLE_MAPS_INTEGRATION.md) - Maps setup
- 📄 [LOCATION_TRACKING_SUBMISSION.md](LOCATION_TRACKING_SUBMISSION.md) - Checklist

---

## 🎯 Real-World Uses

### Farm Finder
```dart
// Find farms within 5km
farms.where((farm) =>
  Geolocator.distanceBetween(
    userLat, userLng,
    farm.lat, farm.lng
  ) < 5000
);
```

### Delivery Alert
```dart
// Alert when delivery near
if (distance < 500) {
  showNotification('Delivery arriving!');
}
```

### Nearest Farm
```dart
// Sort by distance
farms.sort((a, b) =>
  distanceTo(a).compareTo(distanceTo(b))
);
```

---

## 🌟 Pro Tips

1. **Battery Saving**: Use `distanceFilter: 50` for less frequent updates
2. **Accuracy**: Test outdoors for best GPS signal
3. **Testing**: Use physical device, not emulator
4. **Permissions**: Handle all denial scenarios gracefully
5. **Cleanup**: Always cancel streams in `dispose()`

---

## 🎬 Try These

- [ ] Grant permission and see your location
- [ ] Start live tracking and walk around
- [ ] Add custom markers by tapping map
- [ ] Check distance to sample markers
- [ ] Use my location button to center
- [ ] Pause tracking to save battery
- [ ] Clear custom markers

---

**Ready to Track! 📍🚀**

For help, press the ℹ️ info button in the app.
