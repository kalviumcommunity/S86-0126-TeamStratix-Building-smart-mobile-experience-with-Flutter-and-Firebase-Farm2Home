# Farm2Home App 🌱

A Flutter-based e-commerce application connecting consumers with fresh, organic produce from local farms, powered by Firebase for authentication and real-time data storage.

## 📱 Features

### Core Functionality
- **Firebase Authentication**: Secure user signup and login
- **Product Catalog**: Browse 8 fresh farm products
- **Shopping Cart**: Add items, manage quantities, and checkout
- **Real-time Database**: Firestore integration for user data and orders
- **User Profile**: View account details and logout

### Firebase Integration
- ✅ Email/Password Authentication
- ✅ Firestore Database for user data
- ✅ Real-time order management
- ✅ User favorites tracking
- ✅ Automatic data persistence

## 🔥 Firebase Setup

### Prerequisites
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Authentication (Email/Password)
3. Create a Firestore Database

### Installation Steps

#### 1. Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

#### 2. Configure Firebase
```bash
cd farm2home_app
flutterfire configure
```

Follow the prompts to:
- Select your Firebase project
- Choose platforms (Android, iOS, Web)
- Generate `firebase_options.dart`

#### 3. Add Configuration Files

**For Android:**
1. Download `google-services.json` from Firebase Console
2. Place it in `android/app/`

**For iOS:**
1. Download `GoogleService-Info.plist` from Firebase Console
2. Place it in `ios/Runner/`

#### 4. Install Dependencies
```bash
flutter pub get
```

### Required Packages
```yaml
dependencies:
  firebase_core: ^3.0.0
  firebase_auth: ^5.0.0
  cloud_firestore: ^5.0.0
```

## 🏗️ Project Structure

```
lib/
├── main.dart                          # App entry point with Firebase init
├── firebase_options.dart              # Firebase configuration
├── models/
│   ├── product.dart                   # Product data model
│   └── cart_item.dart                 # Cart item model
├── services/
│   ├── auth_service.dart              # Firebase Authentication
│   ├── firestore_service.dart         # Firestore CRUD operations
│   └── cart_service.dart              # Cart state management
└── screens/
    ├── login_screen.dart              # User login
    ├── signup_screen.dart             # User registration
    ├── products_screen.dart           # Product catalog
    └── cart_screen.dart               # Shopping cart
```

## 🔐 Authentication Service

### Sign Up
```dart
Future<User?> signUp(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  } on FirebaseAuthException catch (e) {
    throw _handleAuthException(e);
  }
}
```

### Login
```dart
Future<User?> login(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  } on FirebaseAuthException catch (e) {
    throw _handleAuthException(e);
  }
}
```

### Logout
```dart
Future<void> logout() async {
  await FirebaseAuth.instance.signOut();
}
```

## 💾 Firestore Service

### Create - Add User Data
```dart
Future<void> addUserData(String uid, Map<String, dynamic> data) async {
  await FirebaseFirestore.instance.collection('users').doc(uid).set({
    ...data,
    'createdAt': FieldValue.serverTimestamp(),
  });
}
```

### Read - Get User Data
```dart
Future<Map<String, dynamic>?> getUserData(String uid) async {
  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get();
  return doc.data();
}
```

### Update - Modify User Data
```dart
Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
  await FirebaseFirestore.instance.collection('users').doc(uid).update({
    ...data,
    'updatedAt': FieldValue.serverTimestamp(),
  });
}
```

### Delete - Remove User Data
```dart
Future<void> deleteUserData(String uid) async {
  await FirebaseFirestore.instance.collection('users').doc(uid).delete();
}
```

### Real-time Data Streaming
```dart
Stream<DocumentSnapshot<Map<String, dynamic>>> streamUserData(String uid) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .snapshots();
}
```

## 🚀 Running the App

### Web (Chrome)
```bash
cd farm2home_app
flutter run -d chrome --release
```

### Android
```bash
flutter run -d android
```

### iOS (macOS only)
```bash
flutter run -d ios
```

## 📊 Firestore Database Structure

### Users Collection
```
users/
  └── {userId}/
      ├── name: string
      ├── email: string
      ├── favorites: array
      ├── createdAt: timestamp
      └── updatedAt: timestamp
```

### Orders Collection
```
orders/
  └── {orderId}/
      ├── userId: string
      ├── items: array
      ├── totalPrice: number
      ├── status: string
      ├── createdAt: timestamp
      └── updatedAt: timestamp
```

## 🧪 Testing

### Test Authentication
1. Run the app
2. Navigate to Sign Up screen
3. Create a new account with email/password
4. Verify user appears in Firebase Console > Authentication

### Test Firestore
1. Login with created account
2. Add products to cart
3. Complete checkout
4. Verify order data in Firebase Console > Firestore Database

## 📸 Screenshots

### Authentication
![Login Screen](screenshots/login_screen.png)
![Signup Screen](screenshots/signup_screen.png)

### User Dashboard
![Products Screen](screenshots/products_screen.png)
![Cart Screen](screenshots/cart_screen.png)

### Firebase Console
![Firebase Authentication](screenshots/firebase_auth.png)
![Firestore Database](screenshots/firestore_data.png)

## 🤔 Reflection

### Challenges Faced
1. **Firebase Configuration**: Initial setup required understanding of platform-specific configuration files and proper placement
2. **Authentication State Management**: Implementing proper auth state persistence and navigation flow
3. **Firestore Security Rules**: Learning to structure data securely while maintaining real-time capabilities
4. **Error Handling**: Creating user-friendly error messages from Firebase exceptions

### How Firebase Improves the App
1. **Scalability**: Cloud-based infrastructure handles growing user base automatically
2. **Real-time Sync**: Firestore enables instant data updates across devices
3. **Security**: Built-in authentication and security rules protect user data
4. **Offline Support**: Firestore caching provides offline functionality
5. **Cost-Effective**: Pay-as-you-go pricing model suitable for startups
6. **Cross-Platform**: Single codebase works across web, mobile, and desktop

### Future Enhancements
- Google Sign-In integration
- Push notifications for order updates
- Image storage using Firebase Storage
- Analytics for user behavior tracking
- Cloud Functions for backend logic

## 🛠️ Technologies Used

- **Flutter**: UI framework
- **Firebase Authentication**: User management
- **Cloud Firestore**: NoSQL database
- **Material Design 3**: UI components
- **Dart**: Programming language

## 📝 License

This project is part of the Farm2Home educational initiative.

## 👥 Team

**Team Stratix** - S86-0126
Building Smart Mobile Experience with Flutter and Firebase

## 📞 Support

For issues or questions:
- Check Firebase Console for authentication/database errors
- Review `flutter doctor` for environment setup
- Ensure all configuration files are properly placed

---

**Note**: Replace placeholder values in `firebase_options.dart` with your actual Firebase project credentials after running `flutterfire configure`.
