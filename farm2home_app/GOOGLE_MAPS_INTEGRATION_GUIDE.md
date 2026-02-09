# Google Maps SDK for Flutter - Complete Integration Guide

## Overview

This document provides complete setup instructions for integrating Google Maps SDK into the Farm2Home Flutter application. It includes platform-specific configuration, API key setup, and implementation details.

---

## 📋 Table of Contents

1. [Google Cloud Console Setup](#google-cloud-console-setup)
2. [Android Configuration](#android-configuration)
3. [iOS Configuration](#ios-configuration)
4. [Flutter Implementation](#flutter-implementation)
5. [Testing & Troubleshooting](#testing--troubleshooting)
6. [Video Demo Instructions](#video-demo-instructions)

---

## 🔑 Google Cloud Console Setup

### Step 1: Create/Select Project
1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create a new project or select existing one
3. Name it: "Farm2Home Maps" (or similar)
4. Click Create

### Step 2: Enable Maps API
1. Click **APIs & Services**
2. Click **Enable APIs and Services**
3. Search for "Maps SDK for Android"
4. Click on it and click **ENABLE**
5. Repeat for "Maps SDK for iOS"

### Step 3: Create API Key
1. Go to **APIs & Services** → **Credentials**
2. Click **Create Credentials** → **API Key**
3. A popup will show your new API key
4. **COPY THIS KEY** - You'll need it for both Android and iOS
5. Click **Edit API Key**
6. Under **API restrictions**, select:
   - Maps SDK for Android
   - Maps SDK for iOS
7. Save the changes

### Step 4: Add Billing (Required)
1. Go to **Billing** in the left menu
2. Link a billing account
3. Maps API requires an active billing account
4. Use free tier with credits if needed

---

## 🤖 Android Configuration

### File: `android/app/src/main/AndroidManifest.xml`

Add the Google Maps API key inside the `<application>` tag:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

    <application
        android:label="Farm2Home"
        android:icon="@mipmap/ic_launcher">

        <!-- Google Maps API Key -->
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_GOOGLE_MAPS_API_KEY_HERE" />

        <!-- Other application tags... -->
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
</manifest>
```

### Key Points:
- Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual API key from Google Cloud Console
- Keep the `<uses-permission>` tags for internet and location access
- The `<meta-data>` tag must be inside `<application>`

---

## 🍎 iOS Configuration

### File: `ios/Runner/Info.plist`

Add the Google Maps API key inside the root `<dict>` tag:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- Existing configuration... -->

    <!-- Google Maps API Key -->
    <key>io.flutter.embedded_views_preview</key>
    <true/>

    <key>com.google.ios.maps.API_KEY</key>
    <string>YOUR_GOOGLE_MAPS_API_KEY_HERE</string>

    <!-- Location permissions -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>This app needs access to your location to show it on the map</string>

    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>This app needs access to your location to show it on the map</string>

    <!-- Other configuration... -->
</dict>
</plist>
```

### Key Points:
- Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual API key
- The `io.flutter.embedded_views_preview` flag is required for GoogleMap widget
- Location permission strings are shown to users when accessing location

---

## 💻 Flutter Implementation

### File: `lib/screens/location_preview_screen.dart`

The LocationPreviewScreen provides a complete Google Maps implementation:

```dart
GoogleMap(
  onMapCreated: (controller) {
    _mapController = controller;
  },
  initialCameraPosition: const CameraPosition(
    target: LatLng(37.7749, -122.4194),  // San Francisco
    zoom: 10.0,
  ),
  markers: _markers,
  myLocationButtonEnabled: true,
  myLocationEnabled: false,
  zoomControlsEnabled: true,
  compassEnabled: true,
  mapToolbarEnabled: true,
  trafficEnabled: false,
  buildingsEnabled: true,
  indoorViewEnabled: false,
)
```

### Key Features Implemented:
- **Camera Control**: Animate to different locations
- **Markers**: Multiple location markers with info windows
- **Zoom Controls**: Built-in zoom buttons
- **Navigation**: Jump between predefined locations
- **Responsive Design**: Works on tablets and phones

---

## 🧪 Testing & Troubleshooting

### Common Issues & Solutions

#### Issue 1: "MissingPluginException: No implementation found for method"
**Cause**: Plugin not properly initialized  
**Solution**: 
```bash
cd farm2home_app
flutter clean
flutter pub get
flutter run
```

#### Issue 2: "Google Play Services not available"
**Cause**: Device doesn't have Google Play Services  
**Solution**: 
- Use a physical device with Play Services
- Or create an emulator with Google Play

#### Issue 3: "API Key not valid"
**Cause**: Wrong API key or API not enabled  
**Solution**:
1. Verify key in Google Cloud Console
2. Confirm Maps SDK for Android/iOS is enabled
3. Check AndroidManifest.xml spelling
4. Check Info.plist format (case sensitive)

#### Issue 4: Map shows gray screen
**Cause**: API key not working or missing  
**Solution**:
1. Verify API key is correct
2. Check billing is enabled
3. Wait a few minutes (API key propagation)
4. Restart app and device

#### Issue 5: Permissions not working
**Cause**: Missing permission declarations  
**Solution**:
- Android: Check AndroidManifest.xml has `<uses-permission>` tags
- iOS: Check Info.plist has location descriptions

### Debugging Steps

1. **Check Flutter logs**:
   ```bash
   flutter logs
   ```

2. **Verify API key**:
   - Google Cloud Console → Credentials
   - Copy exact key value

3. **Verify permissions**:
   - Android: AndroidManifest.xml
   - iOS: Info.plist

4. **Test with emulator**:
   ```bash
   flutter run
   ```

5. **Test with physical device**:
   ```bash
   flutter run -d <device_id>
   ```

---

## 🎬 Video Demo Instructions

### What to Show (5-10 minutes)

#### Part 1: App Opening & Navigation (1 minute)
- Open the app
- Navigate to Location Preview from menu
- Show the menu entry and navigation

#### Part 2: Map Loading (1-2 minutes)
- Map appears with markers
- Point out the three markers:
  - Green: Farm2Home Hub (San Francisco)
  - Orange: Local Farm (Sacramento)
  - Red: Distribution Market (San Jose)
- Explain this is rendered by GoogleMap widget

#### Part 3: Interactive Testing (2-3 minutes)
- **Pinch Zoom**: Show zooming in and out
- **Drag**: Show panning the map
- **Marker Tap**: Click a marker to show info window
- **Navigation Buttons**: Show location switching
- **Zoom Controls**: Use +/- buttons

#### Part 4: Code Explanation (1-2 minutes)
- Show the LocationPreviewScreen code
- Explain GoogleMap widget usage
- Point out:
  - initialCameraPosition
  - markers set
  - onMapCreated callback
  - Various control flags

#### Part 5: Configuration (1-2 minutes)
- Show AndroidManifest.xml (blur API key)
- Show Info.plist (blur API key)
- Explain why both are needed
- Don't show actual API key on video

#### Part 6: Features Summary (1 minute)
- List what's working:
  - Map renders correctly
  - Markers display
  - Zooming works
  - Panning works
  - Navigation works
- Summary of integration success

### Recording Tips

**Before Recording**:
- [ ] Test map thoroughly beforehand
- [ ] Have both Android and iOS configurations ready
- [ ] Know your talking points
- [ ] Have the code ready to show

**While Recording**:
- [ ] Speak clearly and slowly
- [ ] Point to UI elements as you explain
- [ ] Show each feature working
- [ ] Use zoom/pan during demo
- [ ] Keep face visible on camera
- [ ] Don't rush through code

**After Recording**:
- [ ] Verify all features shown
- [ ] Check audio is clear
- [ ] Export as MP4
- [ ] Test video playback

### What NOT to Do

❌ Don't show raw API key  
❌ Don't skip the configuration explanation  
❌ Don't just show static screenshots  
❌ Don't rush through interactions  
❌ Don't record in poor lighting  
❌ Don't have background noise  

---

## 📱 Device Permissions

### Android Permissions
Add to `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### iOS Permissions
Add to `Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to your location</string>
```

---

## 🔒 Security Best Practices

### API Key Security
1. **Don't commit keys to GitHub**
   - Use environment variables
   - Store in `.env` file (gitignored)
   - Reference in code, not hardcoded

2. **Use API Key restrictions**
   - Restrict to Maps APIs only
   - Restrict to your app's bundle ID
   - Set HTTP referrers if using web

3. **Monitor usage**
   - Google Cloud Console → Quotas
   - Set up billing alerts
   - Review API key usage regularly

4. **Rotate keys regularly**
   - Create new keys periodically
   - Delete old unused keys
   - Update apps with new keys

---

## 📊 API Quotas & Pricing

### Free Tier Limits
- Maps SDK for Android: $7 per 1000 requests (after free credits)
- Maps SDK for iOS: $7 per 1000 requests (after free credits)
- Free monthly credit: Usually $300

### Cost Estimation
- Small app: $0-50/month
- Medium app: $50-200/month
- Large app: $200+/month

### Monitoring Quotas
1. Google Cloud Console → Quotas
2. Set up billing alerts
3. Monitor daily usage

---

## ✅ Implementation Checklist

- [ ] Google Cloud project created
- [ ] Maps SDK for Android enabled
- [ ] Maps SDK for iOS enabled
- [ ] API key created and copied
- [ ] AndroidManifest.xml updated with API key
- [ ] Info.plist updated with API key
- [ ] google_maps_flutter dependency added
- [ ] flutter pub get executed
- [ ] LocationPreviewScreen created
- [ ] Routes added to main.dart
- [ ] Navigation button added
- [ ] App compiles without errors
- [ ] Map renders on startup
- [ ] Markers display correctly
- [ ] Zoom works
- [ ] Pan works
- [ ] Tap markers shows info window
- [ ] Navigation buttons work
- [ ] Video recorded
- [ ] Video uploaded to Google Drive
- [ ] GitHub PR created

---

## 📚 Additional Resources

- [Google Maps Flutter Package](https://pub.dev/packages/google_maps_flutter)
- [Google Cloud Console](https://console.cloud.google.com)
- [Maps API Documentation](https://developers.google.com/maps)
- [Flutter Widgets Guide](https://flutter.dev/docs/development/ui/widgets)

---

## 📞 Support & Troubleshooting

**For API Issues**:
→ Go to [Google Maps Support](https://support.google.com/maps)

**For Flutter Issues**:
→ Check [Flutter Community Issues](https://github.com/flutter/flutter/issues)

**For Package Issues**:
→ Check [google_maps_flutter on pub.dev](https://pub.dev/packages/google_maps_flutter/issues)

---

**Last Updated**: February 6, 2026  
**Status**: Complete & Ready for Implementation
