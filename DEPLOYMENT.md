# Farm2Home - Quick Deployment Guide

## 🚀 Quick Deployment Steps

### 1. Firebase Setup (5 minutes)

```bash
# Install Firebase CLI
npm install -g firebase-tools
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
cd farm2home_demo
flutterfire configure
```

### 2. Update main.dart (2 minutes)

Replace the Firebase initialization in `lib/main.dart`:

```dart
import 'firebase_options.dart';

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### 3. Deploy Firestore Rules (2 minutes)

```bash
firebase init firestore
# Use existing files: firestore.rules and firestore.indexes.json

firebase deploy --only firestore:rules
firebase deploy --only firestore:indexes
```

### 4. Enable Firebase Services

Go to Firebase Console:
1. **Authentication** → Enable Email/Password
2. **Firestore Database** → Create database (Production mode)

### 5. Build & Deploy

#### Android APK
```bash
flutter build apk --release
```
Find APK at: `build/app/outputs/flutter-apk/app-release.apk`

#### Web Deployment
```bash
flutter build web --release
firebase deploy --only hosting
```

Access at: `https://YOUR-PROJECT-ID.web.app`

---

## 📱 Testing Credentials

Create these test accounts after deployment:

**Customer:**
- Email: customer@test.com
- Password: test123
- Role: Customer

**Farmer:**
- Email: farmer@test.com
- Password: test123
- Role: Farmer

---

## ✅ Pre-Launch Checklist

- [ ] Firebase project created
- [ ] Authentication enabled
- [ ] Firestore database created
- [ ] Security rules deployed
- [ ] App tested on Android
- [ ] App tested on iOS (if applicable)
- [ ] App tested on Web
- [ ] Test accounts created
- [ ] Order flow tested end-to-end

---

## 🔧 Production Checklist

- [ ] Update app name in `pubspec.yaml`
- [ ] Update package name in `android/app/build.gradle`
- [ ] Update bundle ID in `ios/Runner.xcodeproj`
- [ ] Add app icons
- [ ] Add splash screen
- [ ] Configure app signing (Android)
- [ ] Configure provisioning profiles (iOS)
- [ ] Set up Firebase App Check
- [ ] Enable Firebase Analytics
- [ ] Test on real devices
- [ ] Submit to app stores

---

## 📊 Firebase Console Monitoring

After deployment, monitor:
1. **Authentication** → Active users
2. **Firestore** → Usage metrics
3. **Hosting** → Traffic (for web)
4. **Crashlytics** → App crashes (optional)

---

## 🆘 Quick Troubleshooting

**Firebase not initialized?**
```bash
flutterfire configure
```

**Permission denied in Firestore?**
```bash
firebase deploy --only firestore:rules
```

**App won't build?**
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📚 Documentation

For detailed setup: See [SETUP_GUIDE.md](SETUP_GUIDE.md)

---

**Deployment Time: ~15 minutes** ⚡
