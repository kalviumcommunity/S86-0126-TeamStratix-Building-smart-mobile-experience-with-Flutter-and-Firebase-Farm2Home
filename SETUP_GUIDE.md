# Farm2Home - Complete Setup Guide

## 📱 Overview

Farm2Home is a production-ready Flutter application that connects Customers with Farmers for farm-to-home delivery with complete order tracking transparency.

### Tech Stack
- **Frontend**: Flutter 3.x (Material 3)
- **Backend**: Firebase (Auth, Firestore)
- **State Management**: Provider
- **Platforms**: Android, iOS, Web

---

## 🚀 Quick Start

### Prerequisites

Before you begin, ensure you have the following installed:

1. **Flutter SDK** (3.10.7 or higher)
   ```bash
   flutter doctor
   ```

2. **Firebase CLI**
   ```bash
   npm install -g firebase-tools
   firebase login
   ```

3. **FlutterFire CLI**
   ```bash
   dart pub global activate flutterfire_cli
   ```

---

## 📦 Step 1: Install Dependencies

Navigate to the project directory and run:

```bash
cd farm2home_demo
flutter pub get
```

---

## 🔥 Step 2: Firebase Setup

### A. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project"
3. Enter project name: **farm2home** (or your choice)
4. Enable Google Analytics (optional)
5. Click "Create Project"

### B. Enable Firebase Services

#### 1. Enable Authentication
- In Firebase Console, go to **Authentication** → **Sign-in method**
- Enable **Email/Password** authentication
- Click **Save**

#### 2. Enable Firestore Database
- Go to **Firestore Database** → **Create database**
- Start in **Production mode**
- Choose a location closest to your users
- Click **Enable**

### C. Configure Firebase for Your App

#### Option 1: Using FlutterFire CLI (Recommended)

Run the following command in your project root:

```bash
flutterfire configure
```

This will:
- Create a Firebase project (or select existing)
- Register your Flutter app with Firebase
- Generate `firebase_options.dart` file automatically
- Configure all platforms (Android, iOS, Web)

#### Option 2: Manual Configuration

If you prefer manual setup:

1. **For Android:**
   - In Firebase Console, click **Add app** → Select **Android**
   - Package name: `com.example.farm2home_demo`
   - Download `google-services.json`
   - Place it in: `android/app/google-services.json`

2. **For iOS:**
   - Click **Add app** → Select **iOS**
   - Bundle ID: `com.example.farm2homDemo`
   - Download `GoogleService-Info.plist`
   - Place it in: `ios/Runner/GoogleService-Info.plist`

3. **For Web:**
   - Click **Add app** → Select **Web**
   - Copy the Firebase configuration
   - Update `lib/main.dart` with your Firebase options

### D. Update Firebase Options in main.dart

After running `flutterfire configure`, import the generated file:

Replace in `lib/main.dart`:

```dart
// Remove the placeholder:
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  ),
);

// With the generated import:
import 'firebase_options.dart';

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

---

## 🔒 Step 3: Deploy Firestore Security Rules

Deploy the security rules to Firebase:

```bash
firebase init firestore
# Select existing project
# Use existing firestore.rules and firestore.indexes.json

firebase deploy --only firestore:rules
firebase deploy --only firestore:indexes
```

---

## 🏃 Step 4: Run the App

### Run on Android Emulator
```bash
flutter run
```

### Run on iOS Simulator (Mac only)
```bash
flutter run -d ios
```

### Run on Web
```bash
flutter run -d chrome
```

### Run on Physical Device
```bash
flutter devices  # List connected devices
flutter run -d <device-id>
```

---

## 📱 Step 5: Build for Production

### Android APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS (Mac only)
```bash
flutter build ios --release
```
Then open `ios/Runner.xcworkspace` in Xcode to archive and upload

### Web
```bash
flutter build web --release
```
Output: `build/web/`

---

## 🌐 Step 6: Deploy Web App to Firebase Hosting

1. **Initialize Firebase Hosting:**
   ```bash
   firebase init hosting
   ```
   - Select your Firebase project
   - Public directory: **build/web**
   - Configure as single-page app: **Yes**
   - Overwrite index.html: **No**

2. **Build and Deploy:**
   ```bash
   flutter build web --release
   firebase deploy --only hosting
   ```

3. **Access your app:**
   ```
   https://your-project-id.web.app
   ```

---

## 🧪 Step 7: Test the Application

### Test Accounts

Create test accounts for both roles:

1. **Customer Account:**
   - Open app → Sign Up
   - Name: John Customer
   - Email: customer@test.com
   - Password: test123
   - Role: Customer

2. **Farmer Account:**
   - Open app → Sign Up
   - Name: Jane Farmer
   - Email: farmer@test.com
   - Password: test123
   - Role: Farmer

### Test User Flow

**As Customer:**
1. Login with customer account
2. Click "Place Order"
3. Select a farmer
4. Add delivery address and phone
5. Add order items (e.g., Tomatoes, 5 kg, $10)
6. Place order
7. View order status with timeline

**As Farmer:**
1. Login with farmer account
2. View pending orders
3. Click on an order
4. Update status through the workflow:
   - Received → Harvesting → Packed → Out for Delivery → Delivered
5. Add optional notes with each status update

---

## 🗂️ Project Structure

```
lib/
├── main.dart                      # App entry point & routing
├── core/
│   └── constants.dart             # App constants
├── theme/
│   └── app_theme.dart             # Material 3 theme
├── models/
│   ├── user_model.dart            # User data model
│   ├── order_model.dart           # Order data model
│   └── status_update_model.dart   # Status update model
├── services/
│   ├── auth_service.dart          # Firebase Auth service
│   └── firestore_service.dart     # Firestore CRUD service
├── providers/
│   ├── auth_provider.dart         # Auth state management
│   └── order_provider.dart        # Order state management
├── widgets/
│   ├── custom_button.dart         # Reusable button
│   ├── custom_text_field.dart     # Reusable text field
│   ├── loading_widget.dart        # Loading indicator
│   ├── empty_state_widget.dart    # Empty state UI
│   ├── order_card.dart            # Order list item
│   └── status_timeline.dart       # Status timeline UI
└── screens/
    ├── auth/
    │   ├── splash_screen.dart     # Splash screen
    │   ├── login_screen.dart      # Login screen
    │   └── signup_screen.dart     # Signup with role selection
    ├── shared/
    │   └── profile_screen.dart    # User profile
    ├── customer/
    │   ├── customer_home_screen.dart    # Customer dashboard
    │   ├── place_order_screen.dart      # Place new order
    │   └── order_status_screen.dart     # Track order
    └── farmer/
        ├── farmer_home_screen.dart           # Farmer dashboard
        └── update_order_status_screen.dart   # Update order status
```

---

## 🔥 Firestore Data Structure

### Collections

#### `users` Collection
```json
{
  "uid": "user123",
  "name": "John Doe",
  "email": "john@example.com",
  "role": "customer",  // or "farmer"
  "createdAt": "2024-01-01T00:00:00Z"
}
```

#### `orders` Collection
```json
{
  "orderId": "order123",
  "customerId": "user123",
  "customerName": "John Doe",
  "farmerId": "farmer456",
  "farmerName": "Jane Farmer",
  "items": [
    {
      "name": "Tomatoes",
      "quantity": 5,
      "unit": "kg",
      "price": 10.00
    }
  ],
  "status": "Received",
  "timestamp": "2024-01-01T00:00:00Z",
  "deliveryAddress": "123 Main St",
  "phoneNumber": "+1234567890"
}
```

#### `statusUpdates` Collection
```json
{
  "updateId": "update123",
  "orderId": "order123",
  "status": "Harvesting",
  "updatedAt": "2024-01-01T01:00:00Z",
  "notes": "Started harvesting fresh tomatoes"
}
```

---

## 🎨 Features Implemented

### Authentication
- ✅ Email/Password authentication
- ✅ Role-based signup (Customer/Farmer)
- ✅ Auto-login and session management
- ✅ Profile management
- ✅ Sign out

### Customer Features
- ✅ Dashboard with order statistics
- ✅ Place order with multiple items
- ✅ Select farmer from list
- ✅ Real-time order tracking
- ✅ Status timeline visualization
- ✅ Order history

### Farmer Features
- ✅ Dashboard with pending orders
- ✅ View all orders (pending & completed)
- ✅ Update order status in real-time
- ✅ Add notes to status updates
- ✅ Order statistics

### UI/UX
- ✅ Material 3 design
- ✅ Green/White theme
- ✅ Responsive layouts
- ✅ Loading states
- ✅ Empty states
- ✅ Error handling
- ✅ Form validation
- ✅ Smooth navigation

---

## 🛠️ Troubleshooting

### Common Issues

**1. Firebase Not Initialized**
```
Error: [core/no-app] No Firebase App '[DEFAULT]' has been created
```
**Solution:** Run `flutterfire configure` and update main.dart with generated options

**2. Firestore Permission Denied**
```
Error: PERMISSION_DENIED: Missing or insufficient permissions
```
**Solution:** Deploy Firestore rules with `firebase deploy --only firestore:rules`

**3. Build Errors on Android**
```
Error: Execution failed for task ':app:processDebugGoogleServices'
```
**Solution:** Ensure `google-services.json` is in `android/app/` directory

**4. iOS Build Issues**
```
Error: Could not find GoogleService-Info.plist
```
**Solution:** Add `GoogleService-Info.plist` to `ios/Runner/` directory

**5. Web CORS Issues**
```
Error: Access to XMLHttpRequest has been blocked by CORS policy
```
**Solution:** This is normal in development. Deploy to Firebase Hosting for production

---

## 📊 Performance Tips

1. **Enable Firestore Offline Persistence:**
   ```dart
   FirebaseFirestore.instance.settings = const Settings(
     persistenceEnabled: true,
     cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
   );
   ```

2. **Optimize Images:** Use compressed images for better performance

3. **Use Lazy Loading:** Implement pagination for large lists

4. **Enable Code Shrinking:** Already configured in release builds

---

## 🔐 Security Best Practices

1. **Never commit API keys:** Already in .gitignore
2. **Use environment variables:** For sensitive configs
3. **Keep Firestore rules restrictive:** Deployed rules follow best practices
4. **Enable App Check:** For production apps
5. **Regular security audits:** Monitor Firebase console

---

## 📈 Next Steps / Future Enhancements

- [ ] Push notifications for order updates
- [ ] In-app messaging between customers and farmers
- [ ] Rating and review system
- [ ] Payment integration (Stripe, PayPal)
- [ ] Google Maps integration for delivery tracking
- [ ] Admin panel for managing users and orders
- [ ] Analytics dashboard
- [ ] Multi-language support
- [ ] Dark mode
- [ ] Offline mode with sync

---

## 📝 License

This project is for educational and commercial use.

---

## 🤝 Support

For issues or questions:
1. Check the troubleshooting section
2. Review Firebase documentation
3. Check Flutter documentation

---

## 🎉 Congratulations!

You now have a fully functional Farm2Home delivery application running on Android, iOS, and Web with Firebase backend!

**Happy Coding! 🚀**
