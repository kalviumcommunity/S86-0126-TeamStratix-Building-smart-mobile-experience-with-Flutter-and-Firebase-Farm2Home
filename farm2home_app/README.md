
# Farm2Home App 🌱

---

## 🧩 Flutter Widget Tree & Reactive UI Demo

### Widget Tree Concept
In Flutter, everything is a widget—text, buttons, containers, and layouts. Widgets are arranged in a tree structure, where each node represents a part of the UI. The root is usually a `MaterialApp` or `CupertinoApp`, followed by nested child widgets.

#### Example Widget Tree (WelcomeScreen)

```
MaterialApp
 ┗ Scaffold
   ┣ AppBar
   ┗ Body (Center)
     ┗ Padding
       ┗ Column
         ┣ Icon
         ┣ Text (Title)
         ┣ Text (Subtitle)
         ┣ ElevatedButton
         ┗ (if welcomed) Container (Status Row)
```

### Reactive UI Model
Flutter’s UI is reactive: when data (state) changes, the framework automatically rebuilds the affected widgets. For example, in `WelcomeScreen`, pressing the button toggles `_isWelcomed` and changes the background color, title, subtitle, and shows a status indicator. This is achieved using `setState()`:

```dart
setState(() {
  _isWelcomed = !_isWelcomed;
  _backgroundColor = _isWelcomed ? Colors.green.shade100 : Colors.green.shade50;
});
```

Only the widgets that depend on this state are rebuilt, making updates efficient.

### Visual Demo: WelcomeScreen

#### Initial State
![Welcome Screen - Initial](screenshots/welcome_initial.png)

#### After State Change
![Welcome Screen - Welcomed](screenshots/welcome_welcomed.png)

### Explanation

**What is a widget tree?**
> A hierarchical structure where each node is a widget, representing the UI layout and elements. Parent widgets contain and organize child widgets.

**How does the reactive model work in Flutter?**
> When state changes (e.g., via `setState()`), Flutter rebuilds only the widgets affected by that state, not the entire UI. This ensures efficient updates and smooth user experiences.

**Why does Flutter rebuild only parts of the tree?**
> Flutter’s framework tracks which widgets depend on which pieces of state. When state changes, only those widgets are rebuilt, minimizing unnecessary work and improving performance.

---

A Flutter-based e-commerce application connecting consumers with fresh, organic produce from local farms, powered by Firebase for authentication and real-time data storage.

## Flutter Environment Setup and First App Run

### Steps Followed

#### 1. Install Flutter SDK
- Downloaded Flutter SDK from the [official site](https://docs.flutter.dev/get-started/install)
- Extracted to `C:/src/flutter`
- Added `flutter/bin` to system PATH
- Verified installation with:

```bash
flutter doctor
```

#### 2. Set Up Android Studio (or VS Code)
- Installed Android Studio
- Installed Flutter and Dart plugins
- Installed Android SDK, Platform Tools, and AVD Manager
- Alternatively, installed Flutter and Dart extensions in VS Code

#### 3. Configure Emulator
- Opened AVD Manager in Android Studio
- Created a Pixel 6 emulator with Android 13
- Launched emulator and verified with:

```bash
flutter devices
```

#### 4. Create and Run First Flutter App
- Ran:

```bash
flutter create first_flutter_app
cd first_flutter_app
flutter run
```
- Saw the default Flutter counter app on the emulator

#### 5. Setup Verification

##### Flutter Doctor Output
![Flutter Doctor Output](screenshots/flutter_doctor.png)

##### Running App on Emulator
![Running App](screenshots/flutter_emulator.png)

### Reflection

**Challenges:**
- Understanding PATH setup and environment variables
- Downloading and configuring Android SDK/AVD
- Ensuring all dependencies are installed (Java, Android Studio, etc.)

**How this helps:**
- Ensures a working Flutter environment for building and testing real mobile apps
- Emulator setup allows for rapid development and debugging
- Foundation for integrating advanced features (Firebase, APIs, etc.)

---

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

# Project Structure Overview

This project follows the standard Flutter folder structure for scalability and teamwork. See [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) for a detailed breakdown.

## Folder Hierarchy Example

```
farm2home_app/
├── android/
├── assets/
├── ios/
├── lib/
│   ├── main.dart
│   ├── screens/
│   ├── widgets/
│   ├── services/
│   └── models/
├── test/
├── pubspec.yaml
├── .gitignore
├── README.md
└── build/
```

## Folder/Files Purpose (Summary)
- **lib/**: Main Dart code (screens, widgets, services, models)
- **android/**: Android build/config files
- **ios/**: iOS build/config files
- **assets/**: Images, fonts, static files
- **test/**: Automated tests
- **pubspec.yaml**: Project dependencies/config
- **.gitignore**: Files to ignore in git
- **README.md**: Project documentation
- **build/**: Auto-generated build outputs

## Screenshot: Project Structure in IDE

![Project Structure](screenshots/project_structure.png)

## Reflection
- **Why understand the structure?**
  - Makes it easy to find, debug, and extend code
  - Onboards new team members quickly
- **How does it help teamwork?**
  - Allows parallel development on screens, widgets, and services
  - Reduces merge conflicts and improves code quality

---

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
