# Firebase Cloud Messaging (FCM) - Push Notifications Guide

## Overview

Firebase Cloud Messaging (FCM) enables your Farm2Home app to receive push notifications across all device states: foreground, background, and terminated. This guide covers complete FCM integration, testing, and deployment.

## Architecture

```
Firebase Console
      ↓
  Cloud Messaging Service
      ↓
Firebase Cloud Functions
      ↓
Device FCM Token
      ↓
Flutter App
      ↓
NotificationService (listener)
      ↓
Three States:
  • Foreground → In-app + System notification
  • Background → System notification only
  • Terminated → System notification (tap to launch)
```

## Components

### 1. NotificationService
**File**: `lib/services/notification_service.dart`  
**Lines**: 400+  
**Status**: ✅ Production-ready

**Key Methods**:
```dart
initializeNotifications()          // Setup FCM & permissions
getToken()                         // Retrieve device FCM token
subscribeToTopic(topic)           // Subscribe to topic
unsubscribeFromTopic(topic)       // Unsubscribe from topic
clearHistory()                    // Clear notification history
```

**Notification Streams**:
```dart
foregroundMessages                // Notifications while app open
allMessages                        // All notifications
tokenUpdates                       // FCM token changes
```

**State Handling**:
- **Foreground**: `FirebaseMessaging.onMessage`
- **Background**: `FirebaseMessaging.onMessageOpenedApp`
- **Terminated**: `getInitialMessage()`

### 2. FCM Demo Screen
**File**: `lib/screens/fcm_demo_screen.dart`  
**Lines**: 500+  
**Status**: ✅ Production-ready

**Features**:
- Display current app lifecycle state (foreground/background/terminated)
- Show device FCM token with copy-to-clipboard
- Step-by-step testing instructions
- Real-time notification history with source indicator
- Clear history functionality
- Responsive design for all screen sizes

**UI Components**:
```
┌─ App State Indicator ─────────────────────┐
│ Shows: Foreground/Background/Terminated   │
│ With description of notification behavior │
└───────────────────────────────────────────┘

┌─ FCM Token Card ──────────────────────────┐
│ Device token (copyable)                   │
│ Instructions for Firebase Console         │
└───────────────────────────────────────────┘

┌─ Testing Steps ───────────────────────────┐
│ 1. Copy token                             │
│ 2. Open Firebase Console                  │
│ 3. Send test message                      │
│ 4. Observe notification                   │
└───────────────────────────────────────────┘

┌─ Notification History ────────────────────┐
│ • Timestamp                               │
│ • Source (Foreground/Background/Termed)  │
│ • Title and Body                          │
│ • Additional data                         │
└───────────────────────────────────────────┘
```

## Setup Instructions

### 1. Firebase Project Configuration

#### Enable Cloud Messaging
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Navigate to **Project Settings** → **Cloud Messaging**
4. Get your Server API Key (required for backend)

#### Android Setup
1. Go to **Project Settings** → **General**
2. Download `google-services.json` if not already present
3. Place it in `android/app/` directory
4. Verify `android/build.gradle` includes:
   ```gradle
   classpath 'com.google.gms:google-services:4.3.10'
   ```
5. Verify `android/app/build.gradle` includes:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

#### iOS Setup
1. Enable **Apple Push Notification** capability in Xcode
2. Upload APNs certificate in Firebase Console
3. Configure signing team
4. For development, use sandbox APNs certificate

### 2. Flutter Dependencies

Already added to `pubspec.yaml`:
```yaml
firebase_messaging: ^15.0.0
flutter_local_notifications: ^17.0.0
```

Run to install:
```bash
flutter pub get
```

### 3. Initialize in App

In `lib/main.dart`, initialize FCM:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Farm2HomeApp());
}
```

In your home screen or app initialization:
```dart
final notificationService = NotificationService();
await notificationService.initializeNotifications();
```

## Testing Push Notifications

### Scenario: Hospital "Shift Update" Alert

#### Step 1: Get Device Token
1. Open FCM Demo Screen in app
2. Find the "Device FCM Token" section
3. Copy the token (use the copy button)

#### Step 2: Send Test Notification
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select project → **Cloud Messaging**
3. Click **Send your first message**
4. Enter:
   - **Title**: "Shift Update"
   - **Body**: "Urgent: Duty timing has changed."
5. Click **Send test message**
6. Paste the device token you copied
7. Click **Test**

#### Step 3: Test Each App State

**FOREGROUND STATE** (App is open)
- Keep app open to FCM Demo Screen
- Send notification from Firebase Console
- **Expected**: 
  - SnackBar appears at bottom of screen
  - System notification also appears
  - Added to notification history

**BACKGROUND STATE** (App in background)
- Minimize app (don't close)
- Send notification from Firebase Console
- **Expected**:
  - System notification appears
  - When tapped, opens app to FCM Demo Screen
  - Shows in notification history

**TERMINATED STATE** (App is closed)
- Close app completely (swipe away from recent apps)
- Send notification from Firebase Console
- **Expected**:
  - System notification appears
  - When tapped, launches app and shows notification in history

### Testing Checklist

```
FOREGROUND STATE:
- [ ] SnackBar notification appears
- [ ] System notification also shows
- [ ] Entry added to history with "FOREGROUND" badge
- [ ] Title and body match Firebase message
- [ ] Timestamp is correct

BACKGROUND STATE:
- [ ] System notification appears
- [ ] Tapping opens app at FCM screen
- [ ] Notification visible in history with "BACKGROUND" badge
- [ ] No SnackBar (app wasn't active)
- [ ] App state shows "Background" initially, then "Foreground"

TERMINATED STATE:
- [ ] System notification appears
- [ ] Tapping launches app (cold start)
- [ ] Notification in history with "TERMINATED" badge
- [ ] App loads and shows notification
- [ ] App state indicator updates

GENERAL:
- [ ] Token copies correctly to clipboard
- [ ] Clear history button works
- [ ] App doesn't crash on notification
- [ ] Notifications persist in history
- [ ] No permission errors in console
```

## Code Examples

### Initialize FCM
```dart
import 'services/notification_service.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late NotificationService _notificationService;

  @override
  void initState() {
    super.initState();
    _initFCM();
  }

  Future<void> _initFCM() async {
    _notificationService = NotificationService();
    await _notificationService.initializeNotifications();

    // Listen to foreground messages
    _notificationService.foregroundMessages.listen((message) {
      print('Notification received: ${message.title}');
      // Update UI, show dialog, etc.
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FCMDemoScreen(),
    );
  }
}
```

### Get FCM Token
```dart
final token = await NotificationService().getToken();
print('Device token: $token');
// Use this token to send targeted notifications
```

### Subscribe to Topic
```dart
// Subscribe device to hospital shift updates
await _notificationService.subscribeToTopic('shift_updates');

// Later, send to all devices subscribed to 'shift_updates'
// (via Firebase Cloud Functions or backend)
```

### Listen to Messages
```dart
// Listen to all messages
_notificationService.allMessages.listen((message) {
  print('Title: ${message.title}');
  print('Body: ${message.body}');
  print('Source: ${message.source}'); // foreground/background/terminated
  print('Time: ${message.receivedAt}');
});
```

## Advanced Topics

### Sending Notifications Programmatically

From Cloud Functions:
```javascript
const admin = require('firebase-admin');

exports.sendShiftUpdate = functions.firestore
  .document('shifts/{shiftId}')
  .onUpdate(async (change, context) => {
    const newData = change.after.data();

    // Send to specific user
    const message = {
      notification: {
        title: 'Shift Update',
        body: 'Urgent: Duty timing has changed.'
      },
      tokens: [userFCMToken]
    };

    await admin.messaging().sendMulticast(message);
  });
```

### Sending to Topics

```javascript
// Send to all subscribed devices
const message = {
  notification: {
    title: 'Shift Update',
    body: 'Urgent: Duty timing has changed.'
  },
  topic: 'shift_updates'
};

await admin.messaging().send(message);
```

### Handling Data Payloads

```dart
// In notification handler
void _handleForegroundMessage(RemoteMessage message) {
  // Notification data
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');

  // Custom data
  if (message.data.isNotEmpty) {
    final urgencyLevel = message.data['urgency'];
    final shiftId = message.data['shift_id'];
    // Handle custom data
  }
}
```

## Troubleshooting

### Token Not Generated
**Problem**: FCM token shows "Failed to get token"

**Solutions**:
1. Ensure Firebase project is initialized
2. Check internet connection
3. Verify `google-services.json` is in `android/app/`
4. Run `flutter clean` and `flutter pub get`
5. Check Firebase Console for errors

### Notifications Not Received
**Problem**: Test notification not appearing

**Solutions**:
1. Verify token is copied correctly (no spaces)
2. Check app has notification permissions
3. Verify Firebase Cloud Messaging is enabled
4. Check notification badge in Android Settings
5. On iOS, verify APNs certificate is uploaded
6. Run app first to establish connection

### App Crashes on Notification
**Problem**: App crashes when notification received

**Solutions**:
1. Check Dart errors in console
2. Verify all imports are present
3. Ensure NotificationService is initialized
4. Check for null pointer exceptions in handler

### Permissions Not Granted
**Problem**: "Permission denied" or notification not shown

**Solutions**:
1. For Android: App requests at runtime (handled by FCM)
2. For iOS: Enable notification capability in Xcode
3. Check device notification settings
4. Verify `flutter_local_notifications` is initialized

## Security Best Practices

1. **Validate Tokens**
   - Verify token format before using
   - Implement token refresh handling

2. **Secure Data**
   - Don't send sensitive info unencrypted
   - Use APNs certificate for iOS

3. **Rate Limiting**
   - Limit notifications per user per day
   - Implement exponential backoff for retries

4. **Token Management**
   - Store tokens securely
   - Remove tokens on logout
   - Refresh tokens periodically

## Performance Considerations

- **Cold Start**: First notification after app launch may take 2-5 seconds
- **Battery**: FCM uses minimal battery (handled by system)
- **Network**: Works over WiFi and mobile networks
- **Message Size**: Limited to 4KB for data payload

## Production Deployment

### Checklist
- [x] FCM initialized in main.dart
- [x] Notification handlers for all states
- [x] Error handling for permission denial
- [x] Token refresh handling
- [x] Local notifications configured
- [x] Logging for debugging
- [ ] Analytics integration (optional)
- [ ] Error reporting (Firebase Crashlytics)

### Monitoring

In Firebase Console:
1. **Cloud Messaging** → **Diagnostics**
   - View delivery rates
   - Monitor errors
   - Check message retention

2. **Analytics** → **Events**
   - Track notification opens
   - Monitor user engagement

## References

- [Firebase Cloud Messaging Docs](https://firebase.google.com/docs/cloud-messaging)
- [Flutter Firebase Messaging](https://pub.dev/packages/firebase_messaging)
- [Local Notifications](https://pub.dev/packages/flutter_local_notifications)
- [iOS APNs Configuration](https://firebase.google.com/docs/cloud-messaging/ios/certs)
- [Android FCM Setup](https://firebase.google.com/docs/cloud-messaging/android/client)

## Summary

✅ **What's Implemented**:
- Complete FCM integration for all app states
- Device token retrieval and display
- Notification history tracking
- Interactive demo screen
- Comprehensive error handling
- Local notification support

✅ **Ready for**:
- Production deployment
- User notifications
- Hospital shift alerts
- Marketing campaigns
- Real-time updates

---

**Status**: Production-ready  
**Last Updated**: 2024-01-15  
**Components**: NotificationService + FCM Demo Screen + Full Documentation
