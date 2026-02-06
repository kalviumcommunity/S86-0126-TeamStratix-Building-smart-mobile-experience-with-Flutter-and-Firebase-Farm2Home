# Google Maps Integration - Quick Reference

## 🚀 Quick Start

### 1️⃣ Get API Key (5 minutes)
```
1. Go to console.cloud.google.com
2. Create project "Farm2Home Maps"
3. Enable "Maps SDK for Android"
4. Enable "Maps SDK for iOS"
5. Create API Key (Credentials → Create Credentials)
6. Copy the key
```

### 2️⃣ Configure Android (2 minutes)
**File**: `android/app/src/main/AndroidManifest.xml`
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_KEY_HERE" />
```

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

### 5️⃣ Run App
```bash
flutter clean
flutter pub get
flutter run
```

---

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
