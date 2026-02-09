# FCM Quick Reference & Testing Setup

## 🚀 Quick Start

### 1. Run the App
```bash
cd farm2home_app
flutter pub get
flutter run
```

### 2. Open FCM Demo Screen
- Menu → Push Notifications (FCM)
- Copy your device FCM token

### 3. Send Test Notification
1. Go to [Firebase Console](https://console.firebase.google.com)
2. **Cloud Messaging** → **Send your first message**
3. Enter:
   - **Title**: "Shift Update"
   - **Body**: "Urgent: Duty timing has changed."
4. Click **Next** → **Send to device**
5. Paste token → **Test**

### 4. Observe Notification
- **Foreground**: SnackBar + System notification
- **Background**: System notification only
- **Terminated**: Tap notification to open app

---

## 📱 Testing Each State

### FOREGROUND (App Open) ✅
```
Setup:
1. App open to FCM Demo Screen
2. App state shows GREEN "Foreground"

Send notification:
→ SnackBar appears at bottom
→ System notification in center
→ Entry in history with [FOREGROUND] badge

Code:
FirebaseMessaging.onMessage.listen(...)
```

### BACKGROUND (App Minimized) ✅
```
Setup:
1. Minimize app (don't close)
2. Keep running in background

Send notification:
→ System notification appears
→ Tap to open app
→ Entry in history with [BACKGROUND] badge

Code:
FirebaseMessaging.onMessageOpenedApp.listen(...)
```

### TERMINATED (App Closed) ✅
```
Setup:
1. Close app completely (swipe away)
2. App not running at all

Send notification:
→ System notification appears
→ Tap to launch cold start
→ Entry in history with [TERMINATED] badge

Code:
final initialMessage = await _messaging.getInitialMessage();
```

---

## 🎬 Recording Video Tips

### What to Show
- ✅ Your face on camera (clearly visible)
- ✅ Device screen (app + notification)
- ✅ Firebase Console
- ✅ All three app states
- ✅ Notification appearing in real-time

### Recording Order
1. Introduce yourself (30 sec)
2. Show FCM token in app (30 sec)
3. Explain Foreground state (30 sec)
4. Test Foreground (2 min)
5. Explain Background state (30 sec)
6. Test Background (2 min)
7. Explain Terminated state (30 sec)
8. Test Terminated (2 min)
9. Show code (2 min)
10. Summary (1 min)

**Total**: ~12 minutes

### Recording Tools
- **Device Screen**: Android Studio emulator or physical device
- **Face Camera**: Webcam or phone camera
- **Screen Recorder**: 
  - Windows: OBS Studio (free)
  - Mac: QuickTime + face camera overlay
  - Linux: OBS Studio

### Google Drive Upload
```
1. File → Upload
2. Select video
3. Right-click → Share
4. Change to "Editor" access
5. Change to "Anyone with the link"
6. Copy link for submission
```

---

## 📋 Code Reference

### NotificationService Methods

```dart
// Initialize FCM
await NotificationService().initializeNotifications();

// Get token
final token = await NotificationService().getToken();

// Listen to notifications
NotificationService().foregroundMessages.listen((msg) {
  print('Title: ${msg.title}');
  print('Body: ${msg.body}');
  print('Source: ${msg.source}'); // foreground/background/terminated
});

// Subscribe to topic
await NotificationService().subscribeToTopic('shift_updates');

// Clear history
NotificationService().clearHistory();
```

### Notification Model

```dart
class NotificationMessage {
  final String title;           // "Shift Update"
  final String body;            // "Urgent: Duty timing..."
  final DateTime receivedAt;    // When received
  final String source;          // foreground/background/terminated
  final Map<String, dynamic>? data; // Custom data
}
```

---

## 🔧 Troubleshooting

### Token Not Showing
- Run `flutter clean`
- Run `flutter pub get`
- Check Firebase project is initialized
- Verify internet connection

### Notification Not Arriving
- Double-check token copied correctly (no spaces)
- Verify token in Firebase Console
- Check notification permissions on device
- On iOS: Verify APNs certificate uploaded
- On Android: Check notification channel enabled

### App Crashes
- Check Dart console for errors
- Verify all imports are correct
- Run `flutter analyze`
- Check NotificationService initialization

---

## 📁 File Structure

```
farm2home_app/
├── lib/
│   ├── services/
│   │   └── notification_service.dart      (400+ lines)
│   ├── screens/
│   │   └── fcm_demo_screen.dart          (500+ lines)
│   └── main.dart                          (modified)
├── FCM_DOCUMENTATION.md                   (complete guide)
├── FCM_VIDEO_INSTRUCTIONS.md              (video script)
└── pubspec.yaml                           (firebase_messaging added)
```

---

## ✅ Checklist

### Implementation
- [x] firebase_messaging dependency added
- [x] NotificationService created
- [x] All three states handled
- [x] FCM Demo Screen created
- [x] Routes and navigation added
- [x] Documentation complete
- [x] Video instructions provided

### Testing
- [ ] Record Foreground state demo
- [ ] Record Background state demo
- [ ] Record Terminated state demo
- [ ] Upload video to Google Drive
- [ ] Set Google Drive to "Anyone with link" access
- [ ] Get shareable video link

### Submission
- [ ] GitHub PR created
- [ ] Video URL added to PR
- [ ] PR description includes
  - What was implemented
  - How to test
  - Video link with edit access
- [ ] PR link is active

---

## 🎯 Success Criteria

**Code**:
- ✅ Handles foreground notifications
- ✅ Handles background notifications
- ✅ Handles terminated state notifications
- ✅ Shows device FCM token
- ✅ Zero compilation errors
- ✅ Proper error handling

**Video**:
- ✅ Shows your face clearly
- ✅ Demonstrates all three states
- ✅ Shows exact notification moment
- ✅ Explains code and behavior
- ✅ Clear audio narration
- ✅ At least 720p quality

**Documentation**:
- ✅ Setup instructions
- ✅ Testing guide
- ✅ Code examples
- ✅ Troubleshooting

---

## 🔗 Quick Links

- [Firebase Console](https://console.firebase.google.com)
- [Cloud Messaging Docs](https://firebase.google.com/docs/cloud-messaging)
- [Firebase Messaging Pub](https://pub.dev/packages/firebase_messaging)
- [Local Notifications Pub](https://pub.dev/packages/flutter_local_notifications)

---

**Ready to test?** Start with "FOREGROUND" state, then "BACKGROUND", then "TERMINATED". Good luck! 🚀
