# 🔥 FIREBASE SETUP - QUICK START

## Step 1: Install Required Tools

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli
```

## Step 2: Create Firebase Project

1. Go to https://console.firebase.google.com/
2. Click "Add project"
3. Enter name: **farm2home**
4. Continue through the wizard
5. Click "Create project"

## Step 3: Enable Firebase Services

### Enable Authentication
1. In Firebase Console, click **Authentication**
2. Click **Get started**
3. Click **Email/Password** → **Enable** → **Save**

### Enable Firestore
1. Click **Firestore Database**
2. Click **Create database**
3. Select **Production mode**
4. Choose location closest to you
5. Click **Enable**

## Step 4: Configure Firebase in Your App

### Run FlutterFire Configure

```bash
cd d:\sprint2\farm2home_demo
flutterfire configure
```

This command will:
- Prompt you to select your Firebase project
- Automatically register your app
- Generate `lib/firebase_options.dart`
- Configure Android, iOS, and Web

## Step 5: Update main.dart

Open `lib/main.dart` and replace these lines:

**Replace this:**
```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  ),
);
```

**With this:**
```dart
import 'firebase_options.dart';

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

## Step 6: Deploy Firestore Rules

```bash
# Initialize Firestore (if not done)
firebase init firestore
# Select your project
# Use existing files: firestore.rules and firestore.indexes.json

# Deploy rules
firebase deploy --only firestore:rules
firebase deploy --only firestore:indexes
```

## Step 7: Run the App

```bash
# Install dependencies
flutter pub get

# Run on Android
flutter run

# Or run on Web
flutter run -d chrome
```

## ✅ Verification Checklist

- [ ] Firebase project created
- [ ] Authentication enabled (Email/Password)
- [ ] Firestore database created
- [ ] `flutterfire configure` completed
- [ ] `firebase_options.dart` generated
- [ ] main.dart updated with Firebase options
- [ ] Firestore rules deployed
- [ ] App runs without errors

## 🎉 You're Ready!

Test the app:
1. Click "Sign Up"
2. Create a Customer account
3. Create a Farmer account (in a new browser/device)
4. Place an order as Customer
5. Update order status as Farmer

---

## 🆘 Troubleshooting

**Error: Firebase not initialized**
- Make sure you ran `flutterfire configure`
- Check that `firebase_options.dart` exists
- Verify imports in main.dart

**Error: Permission denied**
- Deploy Firestore rules: `firebase deploy --only firestore:rules`

**Error: No Firebase project found**
- Run `firebase login` and select correct account
- Create project in Firebase Console first

---

For detailed documentation, see:
- [SETUP_GUIDE.md](SETUP_GUIDE.md)
- [DEPLOYMENT.md](DEPLOYMENT.md)
- [API_REFERENCE.md](API_REFERENCE.md)
