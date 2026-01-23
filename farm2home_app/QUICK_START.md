# 🚀 Quick Start Guide

## Run Firebase Configuration NOW

```bash
cd D:\Farm2Home\farm2home_app
dart pub global activate flutterfire_cli
flutterfire configure
```

**Follow the prompts:**
1. Select your Firebase project (or create new)
2. Choose platforms: Web, Android, iOS  
3. Wait for configuration to complete

This will automatically:
- Generate `lib/firebase_options.dart` with real credentials
- Create platform-specific config files
- Link your app to Firebase project

## Enable Firebase Services

### 1. Firebase Console → Authentication
- Go to: https://console.firebase.google.com/
- Select your project
- Click "Authentication" → "Sign-in method"
- Enable "Email/Password"
- Save

### 2. Firebase Console → Firestore
- Click "Firestore Database"
- Click "Create database"
- Select "Start in test mode"
- Choose location (closest to users)
- Click "Enable"

### 3. Add Security Rules
In Firestore → Rules tab, paste this:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /orders/{orderId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

Click "Publish"

## Run the App

```bash
flutter run -d chrome
```

## Test Flow

1. **Signup**: Create account with email/password
2. **Check Console**: Verify user in Authentication tab
3. **Login**: Login with those credentials
4. **Browse**: Add products to cart
5. **Checkout**: Complete order
6. **Verify**: Check Firestore for user data and orders

## ✅ You're Done!

All code is ready. Just configure Firebase and run!

## Need Help?

Check `FIREBASE_SETUP.md` for detailed instructions.
