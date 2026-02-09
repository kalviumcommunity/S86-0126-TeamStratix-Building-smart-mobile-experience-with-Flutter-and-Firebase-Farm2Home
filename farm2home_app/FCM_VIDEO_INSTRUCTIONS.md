# Firebase Cloud Messaging (FCM) - Video Testing Instructions

**Assignment**: Handling Push Notifications Using Firebase Cloud Messaging  
**Duration**: 02h 59m 55s  
**Scenario**: Hospital "Shift Update" Alert Notification

---

## 📹 Video Requirements

### What to Show in Video
You must demonstrate ALL THREE app states receiving the same notification with clear explanation:

1. **FOREGROUND STATE** (App Open)
2. **BACKGROUND STATE** (App Backgrounded)
3. **TERMINATED STATE** (App Closed)

### Video Format Requirements
- ✅ You must be **clearly visible** while explaining
- ✅ Show your **face** on camera during explanation
- ✅ Screen recording of the app **and** your explanation
- ✅ Clear and audible explanation of each state
- ✅ Show the exact moment notification is received
- ✅ Total video duration: 5-15 minutes recommended

---

## 🎬 Video Script & Demonstration Flow

### Introduction (30-60 seconds)
```
Hello, I'm [Your Name].

In this video, I'll demonstrate Firebase Cloud Messaging (FCM) 
integration in the Farm2Home Flutter application.

I'll show how the app receives push notifications in three different states:
1. When the app is open (Foreground)
2. When the app is backgrounded (Background)
3. When the app is completely closed (Terminated)

The scenario is a hospital admin sending an urgent "Shift Update" alert 
to all staff members about a duty timing change.

Let me start by showing the FCM implementation and then test each scenario.
```

---

## Part 1: FOREGROUND STATE Testing

### Setup (before recording)
1. **Build and run the app**
   ```bash
   flutter pub get
   flutter run
   ```

2. **Navigate to Push Notifications**
   - Open app
   - Menu → Push Notifications (FCM)
   - See the "Current App State" showing "Foreground" in GREEN

3. **Copy the Device Token**
   - Click "Copy Token" button
   - Token is now in clipboard

### Testing Steps

#### Step 1: Explain Foreground State (on camera)
```
We're now in FOREGROUND state. The app is open and active.

The device token shown here is used to send notifications to this specific device.
When a notification is received while the app is open:
- It will appear as a SnackBar at the bottom of the screen
- It will also show a system notification
- It will be recorded in the notification history below

Now I'll send a test notification from Firebase Console.
```

#### Step 2: Open Firebase Console (show on screen)
1. Open browser
2. Go to [Firebase Console](https://console.firebase.google.com)
3. Select your project
4. Navigate to **Cloud Messaging**
5. Click **Send your first message** or **Send test message**

#### Step 3: Create Test Message
Fill in:
- **Notification Title**: "Shift Update"
- **Notification Body**: "Urgent: Duty timing has changed."
- Don't set expiration time
- Click **Next**

#### Step 4: Send to Device
1. Select **Send to device**
2. Choose **FCM registration token**
3. Paste the token you copied from the app
4. Click **Test**

#### Step 5: Observe and Explain (on camera)
```
Watch closely - the notification is being sent now.

See how the notification appears:
1. First, a blue SnackBar appears at the bottom saying "Shift Update"
2. At the same time, a system notification appears in the notification center
3. The notification is automatically added to the history below

The history shows:
- [FOREGROUND] badge in green
- The exact time it was received
- The title and body text

This is perfect for alerts the user needs to see immediately while using the app.
```

**What to show**:
- ✅ Notification appears in SnackBar
- ✅ System notification appears
- ✅ Entry appears in notification history with "FOREGROUND" badge
- ✅ Time matches when notification was sent

---

## Part 2: BACKGROUND STATE Testing

### Setup (before recording)
1. Keep app running
2. Have Firebase Console ready in browser
3. Token already copied from previous test

### Testing Steps

#### Step 1: Explain Background State (on camera)
```
Now let's test BACKGROUND state. 

I'm going to minimize this app - it's still running in the background 
but not visible to the user.

When a notification is received in background:
- The app is still running but not in focus
- The notification appears as a SYSTEM notification ONLY
- No in-app SnackBar appears (app isn't visible)
- When the user taps the notification, the app opens

This is the most common state for notifications.
```

#### Step 2: Minimize the App
- Press home button or gesture to minimize
- Show that app is running in background
- Show app state should change

#### Step 3: Send Notification from Firebase
1. Go to Firebase Console (still open in browser)
2. Click **Send test message** again
3. Use the same token
4. Send another notification

#### Step 4: Observe Notification
```
The notification appears as a SYSTEM notification.
See how it shows in the notification center.
When I tap it, the app opens and shows that notification in the history.
```

#### Step 5: Reopen App and Verify
- Tap the notification (or open app from recent apps)
- Show the notification in history with "BACKGROUND" badge
- Show the app state indicator

**What to show**:
- ✅ Minimize app without closing it
- ✅ System notification appears (no SnackBar)
- ✅ Tap notification to open app
- ✅ Notification visible in history with "BACKGROUND" badge
- ✅ Timestamp and message content match

---

## Part 3: TERMINATED STATE Testing

### Setup (before recording)
1. Close the app completely (swipe away from recent apps)
2. Have Firebase Console ready
3. Token already copied

### Testing Steps

#### Step 1: Explain Terminated State (on camera)
```
Finally, let's test TERMINATED state - the most challenging scenario.

This is when the app is completely closed. The user killed it or 
the system terminated it to save resources.

Many developers think notifications won't work when app is closed, 
but FCM handles this beautifully:
- The notification still appears as a SYSTEM notification
- When the user taps it, the app launches from cold start
- The notification is captured and shown in the history
- The system passes the message to the app as the initial message

This is critical for urgent alerts that must reach users.
```

#### Step 2: Close App Completely
- Show app is running in recent apps
- Swipe to close it completely
- Confirm it's gone from recent apps
- Show app is no longer running (can check in settings)

#### Step 3: Send Notification from Firebase
1. Open/Activate Firebase Console
2. Click **Send test message**
3. Paste the same token
4. Send notification

#### Step 4: Wait and Observe
```
The notification is being sent now while the app is completely closed.
Watch the notification center...

There it is! The system notification appears.
The app is not running, but the notification came through.

Now when I tap this notification, the app will do a cold start 
and the notification will be available in the history.
```

#### Step 5: Tap Notification and Verify
- Tap the system notification
- Watch app launch
- Show the notification in history with "TERMINATED" badge
- Explain how this works in the code

**What to show**:
- ✅ Confirm app is completely closed
- ✅ System notification appears while app is closed
- ✅ Tap notification to launch app
- ✅ App opens with notification visible in history
- ✅ "TERMINATED" badge shows correct state
- ✅ No crashes or errors during cold start

---

## Part 4: Code Explanation (on camera)

### Show NotificationService Implementation
```dart
// NotificationService handles three states:

// 1. FOREGROUND
FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

// 2. BACKGROUND/TAP
FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

// 3. TERMINATED
final initialMessage = await _messaging.getInitialMessage();
if (initialMessage != null) {
  _handleTerminatedStateMessage(initialMessage);
}
```

**Explain**:
```
The NotificationService class manages three separate streams:

1. onMessage - Fires when app is in foreground
   Shows both SnackBar and system notification

2. onMessageOpenedApp - Fires when user taps notification from 
   background or terminated state
   App opens and shows the notification

3. getInitialMessage - Gets the notification that launched 
   the app from terminated state
   Essential for handling cold starts

Each handler receives a RemoteMessage with:
- Title and body
- Custom data payload
- Timestamp and source

The demo screen listens to these streams and updates the UI in real-time.
```

### Show Firebase Console Integration
```
Firebase Console → Cloud Messaging

Steps shown in video:
1. Send test message
2. Enter notification title and body
3. Select FCM registration token
4. Paste device token from app
5. Click Test

Firebase handles:
- Token validation
- Network routing
- Delivery confirmation
- Fallback for offline devices
```

---

## Part 5: Summary & Testing Checklist (on camera)

### Summary Checklist
```
We've successfully tested FCM in all three app states:

FOREGROUND ✅
- Notification appeared as SnackBar and system notification
- Recorded in history with [FOREGROUND] badge
- Perfect for alerts while user is active

BACKGROUND ✅
- Notification appeared as system notification only
- User tapped to open app
- Notification shown in history with [BACKGROUND] badge
- Common scenario for most use cases

TERMINATED ✅
- Notification appeared while app was completely closed
- User tapped to launch app from cold start
- Notification shown in history with [TERMINATED] badge
- Critical for urgent alerts like hospital shift updates

KEY FEATURES DEMONSTRATED:
✅ Device FCM token retrieval and display
✅ Firebase Console integration
✅ Real-time notification receiving
✅ Notification history tracking
✅ Proper error handling
✅ Permission management
✅ Local notifications for foreground
```

### Conclusion
```
This Firebase Cloud Messaging implementation is production-ready 
and handles all edge cases for reliable push notification delivery.

Key benefits:
- Works across iOS and Android
- Handles all app states
- Automatic retry on network failure
- Low battery impact
- Secure token management

Perfect for:
- Hospital shift updates
- Urgent alerts
- Marketing campaigns
- Real-time notifications
- User engagement

Thank you for watching!
```

---

## 📸 Screenshots/Recordings to Include

At minimum, record these moments:

1. **Initial Setup**
   - App opening with FCM Demo Screen
   - Token visible
   - All three buttons showing app state colors

2. **Foreground Test**
   - Blue SnackBar appearing
   - System notification in status bar
   - Entry added to history
   - Time correspondence

3. **Background Test**
   - App minimized
   - System notification appearing
   - Tapping notification to open app
   - History updated

4. **Terminated Test**
   - App closed (swipe confirmation)
   - System notification appearing
   - App launching from cold start
   - Notification in history

5. **Code Review**
   - NotificationService.dart shown
   - Key methods highlighted
   - Stream explanations

6. **Firebase Console**
   - Cloud Messaging page
   - Send test message form
   - Token pasting
   - Send confirmation

---

## ⏱️ Timing Guide

- **Introduction**: 1 minute
- **Foreground Demo**: 2-3 minutes
- **Background Demo**: 2-3 minutes
- **Terminated Demo**: 2-3 minutes
- **Code Explanation**: 2-3 minutes
- **Summary**: 1 minute

**Total**: 11-16 minutes (comfortable, not rushed)

---

## 🎥 Recording Tips

1. **Use Screen Recording + Face Camera**
   - Record device screen
   - Use picture-in-picture for your face
   - Show Firebase Console on monitor

2. **Audio Quality**
   - Speak clearly and at normal pace
   - No background noise
   - Good microphone quality

3. **Lighting**
   - Be clearly visible
   - Good lighting on your face
   - Screen brightness visible

4. **Don't Rush**
   - Give time for notifications to appear
   - Explain each step clearly
   - Wait for system to respond

5. **Edit if Needed**
   - Cut long pauses
   - Add captions for technical terms
   - Enhance audio if needed

---

## 📤 Uploading to Google Drive

### Requirements
- ✅ Share link has **edit access** enabled for all
- ✅ File is in MP4 or compatible format
- ✅ At least 720p resolution
- ✅ Audio is clear and audible
- ✅ You are visible on camera

### Upload Steps
1. Click **New** → **File upload**
2. Select your recorded video
3. Rename it: "FCM_PushNotifications_[YourName]"
4. Right-click → **Share**
5. Change to **Editor** access
6. Change to **Anyone with the link** can edit
7. Copy the shareable link

### Drive Link Format
Example: `https://drive.google.com/file/d/1a2b3c4d5e6f7g8h9/view?usp=sharing`

---

## ✅ Final Checklist Before Submission

- [ ] Video clearly shows you on camera
- [ ] All three app states demonstrated
- [ ] Notification appears in each state
- [ ] Code explanation included
- [ ] Firebase Console shown
- [ ] Audio is clear and audible
- [ ] Video is at least 720p
- [ ] No crashes or errors during demo
- [ ] Notification history tracking works
- [ ] Google Drive link has edit access
- [ ] Link is shareable to "Anyone with the link"
- [ ] GitHub PR link is active and accessible

---

## 🔗 Quick Links

- **Firebase Console**: https://console.firebase.google.com
- **Flutter Firebase Messaging**: https://pub.dev/packages/firebase_messaging
- **LocalNotifications Pub**: https://pub.dev/packages/flutter_local_notifications
- **FCM Documentation**: https://firebase.google.com/docs/cloud-messaging

---

**Status**: Ready for video recording  
**Implementation**: Production-grade FCM with all states  
**Test Scenario**: Hospital shift update notification  
**Output**: Video demonstration + GitHub PR + Documentation
