

# Farm2Home App 🌱

---

## � Local UI State Management with setState() (Sprint 2)

### Overview
This section demonstrates how Flutter manages local UI state using the `setState()` method within Stateful widgets. State management is fundamental to creating interactive applications that respond dynamically to user input.

### Features
- ✅ **Stateful Widget Implementation** - Counter that updates in real-time
- ✅ **setState() Method** - Triggers UI rebuilds efficiently
- ✅ **Increment/Decrement Logic** - Demonstrates state mutations
- ✅ **Conditional UI Updates** - Background gradient changes based on counter value
- ✅ **Button State Management** - Enable/disable based on conditions
- ✅ **Visual Feedback** - Dynamic status messages and colors

### Implementation Details

#### 1. Understanding Stateless vs Stateful Widgets

**StatelessWidget:**
- Does not change once built
- Use case: Static text, logos, splash screens
- Example: App icons, headers, labels

**StatefulWidget:**
- Can change based on internal data or user interaction
- Use case: Interactive buttons, forms, counters
- Maintains a separate `State` object that rebuilds when data changes

#### 2. How setState() Works

```dart
class _StateManagementDemoState extends State<StateManagementDemo> {
  int _counter = 0;  // Local state variable

  void _incrementCounter() {
    setState(() {
      _counter++;  // Update state inside setState()
    });
  }
}
```

**Key Points:**
- `setState()` notifies Flutter that internal data has changed
- Flutter rebuilds only the affected widget tree
- Keeps performance efficient by avoiding full app rebuilds
- Must wrap state changes inside `setState(() { ... })`

#### 3. Counter Implementation with setState()

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        Text('$_counter', style: TextStyle(fontSize: 72)),
        ElevatedButton(
          onPressed: _incrementCounter,
          child: Text('Increment'),
        ),
        ElevatedButton(
          onPressed: _decrementCounter,
          child: Text('Decrement'),
        ),
      ],
    ),
  );
}
```

#### 4. Conditional Logic and UI Reactions

**Dynamic Background Gradient:**
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: _counter >= 10
          ? [Colors.green.shade100, Colors.green.shade300]
          : _counter >= 5
              ? [Colors.blue.shade100, Colors.blue.shade300]
              : [Colors.grey.shade100, Colors.grey.shade200],
    ),
  ),
)
```

**Conditional Button States:**
```dart
ElevatedButton(
  onPressed: _counter > 0 ? _decrementCounter : null,
  child: Text('Decrement'),
)
```

**Status Messages:**
```dart
String getMessage() {
  if (_counter >= 10) return '🎉 Excellent! You\'re on fire!';
  if (_counter >= 5) return '👍 Great job! Keep going!';
  if (_counter > 0) return '✨ Good start!';
  return 'Press a button to start';
}
```

### Code Snippets

#### Full Stateful Widget Structure

```dart
class StateManagementDemo extends StatefulWidget {
  const StateManagementDemo({super.key});

  @override
  State<StateManagementDemo> createState() => _StateManagementDemoState();
}

class _StateManagementDemoState extends State<StateManagementDemo> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) _counter--;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('State Management Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Button pressed:', style: TextStyle(fontSize: 20)),
            Text('$_counter', style: TextStyle(fontSize: 72)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _counter > 0 ? _decrementCounter : null,
                  child: Text('Decrement'),
                ),
                SizedBox(width: 15),
                ElevatedButton(
                  onPressed: _incrementCounter,
                  child: Text('Increment'),
                ),
              ],
            ),
            OutlinedButton(
              onPressed: _counter > 0 ? _resetCounter : null,
              child: Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Screenshots

#### Initial State (Counter = 0)
![Initial State](screenshots/state_management_0.png)
*The app starts with counter at 0, showing neutral grey gradient*

#### Counter at 5
![Counter at 5](screenshots/state_management_5.png)
*Background changes to blue gradient, status shows "Great job!"*

#### Counter at 10+
![Counter at 10](screenshots/state_management_10.png)
*Background changes to green gradient, status shows "Excellent!"*

### Common Mistakes to Avoid

❌ **Updating variables outside setState():**
```dart
void _incrementCounter() {
  _counter++;  // Won't update UI!
}
```

✅ **Correct approach:**
```dart
void _incrementCounter() {
  setState(() {
    _counter++;  // UI updates!
  });
}
```

❌ **Calling setState() inside build():**
```dart
@override
Widget build(BuildContext context) {
  setState(() { /* ... */ });  // Causes infinite rebuild loop!
  return Scaffold(...);
}
```

❌ **Overusing Stateful widgets:**
- Use `setState()` only for local UI-level changes
- For complex app-wide state, consider Provider, Riverpod, or Bloc

### Reflection

**How is setState() different from rebuilding the entire app?**
- `setState()` only rebuilds the affected widget and its children
- Full app rebuild would be expensive and slow
- Flutter's smart diffing algorithm updates only what changed
- This keeps animations smooth and performance optimal

**Why is managing state locally important for performance?**
- Reduces unnecessary widget rebuilds
- Keeps state changes isolated to specific components
- Prevents cascading updates across unrelated parts of the app
- Makes debugging easier by limiting scope of state changes

**What kinds of features in this project could use local state management?**
- **Cart badge counter** - Updates when items are added/removed
- **Product quantity selector** - Increment/decrement product amounts
- **Search filter toggle** - Show/hide filters
- **Theme switcher** - Light/dark mode toggle
- **Favorite button** - Toggle liked products
- **Form validation indicators** - Real-time input validation feedback

### Key Takeaways

🎯 **setState() is the foundation of Flutter interactivity**
- Simple to use for local widget state
- Efficient - only rebuilds necessary widgets
- Perfect for counters, toggles, and form inputs

🎯 **State determines UI appearance**
- When state changes, UI automatically updates
- Conditional rendering based on state values
- Data-driven design approach

🎯 **Keep state management appropriate to scope**
- Local state → Use setState()
- Shared state → Use inherited widgets or state management solutions
- Global state → Use Provider, Riverpod, or Bloc

---

## �📝 User Input Form with Validation (Sprint 2)

### Overview
A comprehensive user input form demonstrating form handling, validation, and user feedback in Flutter.

### Features
- ✅ **TextFormField widgets** for name and email input
- ✅ **Real-time validation** with specific error messages
- ✅ **Form state management** using GlobalKey<FormState>
- ✅ **User feedback** via SnackBar (success/error) and AlertDialog
- ✅ **Material Design 3** styling with green theme
- ✅ **Form reset** functionality

### Implementation Details

#### 1. TextField Widgets
The form uses `TextFormField` for controlled input with built-in validation:

```dart
TextFormField(
  controller: _nameController,
  decoration: InputDecoration(
    labelText: 'Full Name',
    hintText: 'Enter your full name',
    prefixIcon: Icon(Icons.person, color: Colors.green[700]),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    return null;
  },
)
```

#### 2. Button Widgets

**Submit Button:**
```dart
ElevatedButton(
  onPressed: _submitForm,
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green[700],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: const Text('Submit'),
)
```

**Clear Button:**
```dart
OutlinedButton(
  onPressed: () {
    _formKey.currentState!.reset();
    _nameController.clear();
    _emailController.clear();
  },
  child: const Text('Clear Form'),
)
```

#### 3. Form Widget & Validation

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(
    children: [
      // TextFormField widgets
    ],
  ),
)

// Validation logic
void _submitForm() {
  if (_formKey.currentState!.validate()) {
    // Form is valid
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Form Submitted Successfully!'),
        backgroundColor: Colors.green[700],
      ),
    );
    
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submission Confirmed'),
        content: Column(
          children: [
            Text('Name: ${_nameController.text}'),
            Text('Email: ${_emailController.text}'),
          ],
        ),
      ),
    );
  }
}
```

### Validation Rules

#### Name Field
- ❌ Cannot be empty: "Please enter your name"
- ❌ Must be at least 2 characters: "Name must be at least 2 characters long"
- ✅ Valid examples: "John Doe", "Alice", "Bob"

#### Email Field
- ❌ Cannot be empty: "Please enter your email"
- ❌ Must contain '@': "Enter a valid email address"
- ❌ Must match email format: "Please enter a valid email format"
- ✅ Valid examples: "john@example.com", "alice.doe@company.co.uk"

### Testing Guide

#### Test Case 1: Valid Submission
**Steps:**
1. Enter Name: "John Doe"
2. Enter Email: "john@example.com"
3. Click Submit

**Expected:**
- ✅ Green SnackBar: "Form Submitted Successfully!"
- ✅ Confirmation dialog shows submitted data
- ✅ Form auto-resets after 1 second

#### Test Case 2: Empty Fields
**Steps:**
1. Leave fields empty
2. Click Submit

**Expected:**
- ❌ Error messages appear below fields
- ❌ Red SnackBar: "Please fix the errors in the form"

#### Test Case 3: Invalid Email
**Steps:**
1. Enter Name: "John Doe"
2. Enter Email: "invalidemail"
3. Click Submit

**Expected:**
- ❌ Error below email field
- ❌ Form does not submit

#### Test Case 4: Form Reset
**Steps:**
1. Enter data in fields
2. Click "Clear Form"

**Expected:**
- ✅ All fields cleared
- ✅ Form ready for new input

### Screenshots Required

Capture these 4 states:
1. **Empty Form** - Initial state with clean fields
2. **Validation Errors** - Error messages displayed
3. **Success SnackBar** - Green notification after submission
4. **Confirmation Dialog** - Popup showing submitted data

### Navigation
```dart
Navigator.pushNamed(context, '/user-input-form');
```

### Code Location
**File**: `lib/screens/user_input_form.dart` (240 lines)  
**Route**: `/user-input-form`

### Reflection

#### Why is input validation important in mobile apps?

Input validation is crucial for several reasons:

1. **Data Integrity**: Ensures data is in the correct format before processing
2. **User Experience**: Provides immediate feedback, helping users correct mistakes quickly
3. **Security**: Prevents malicious input and injection attacks
4. **Error Prevention**: Catches issues before they reach the backend
5. **Professional Polish**: Shows attention to detail and builds user trust
6. **Cost Reduction**: Reduces support tickets from invalid data

#### What's the difference between TextField and TextFormField?

| Feature | TextField | TextFormField |
|---------|-----------|---------------|
| **Form Integration** | Standalone widget | Works within Form widget |
| **Validation** | Manual validation needed | Built-in validator property |
| **State Management** | Manual controller management | Integrated with FormState |
| **Error Display** | Manual error handling | Automatic error display |
| **Reset Capability** | Manual clearing required | Can reset via Form.reset() |
| **Best Use Case** | Simple inputs | Complex forms with multiple fields |

**Example:**
```dart
// TextField - Manual validation
TextField(
  onChanged: (value) {
    // Manual validation logic
  },
)

// TextFormField - Built-in validation
TextFormField(
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  },
)
```

#### How does form state management simplify validation?

Form state management using `GlobalKey<FormState>` provides:

1. **Centralized Control**: Validate all fields with one method call
   ```dart
   if (_formKey.currentState!.validate()) {
     // All fields valid
   }
   ```

2. **Automatic Error Handling**: Each field's validator called automatically

3. **Consistent Behavior**: All fields follow same validation pattern

4. **Easy Reset**: Clear all fields with one command
   ```dart
   _formKey.currentState!.reset();
   ```

5. **Scalability**: Adding new fields requires minimal changes

6. **Clean Code**: Reduces boilerplate validation code

### Submission Checklist

#### Before Creating PR:
- [ ] Code compiles: `flutter analyze`
- [ ] App runs successfully: `flutter run`
- [ ] Form validates correctly (test all cases)
- [ ] Screenshots captured (4 states)
- [ ] Video recorded (1-2 minutes)

#### Video Demo (1-2 minutes):
**Content to show:**
1. Valid submission with success feedback
2. Validation errors (empty fields, invalid email)
3. Form reset functionality
4. Brief code explanation

**Upload to:**
- Google Drive (set to "Anyone with link" + Edit access)
- YouTube (unlisted)
- Loom

#### Pull Request Template:

**Title:** `[Sprint-2] Handling User Input with Forms – [Team Name]`

**Description:**
```markdown
## Summary
Implemented user input form with validation demonstrating TextField, Button, and Form widgets.

## Features
✅ Name and email validation
✅ SnackBar feedback (success/error)
✅ Confirmation dialog
✅ Form reset functionality
✅ Material Design 3 styling

## Testing
All validation scenarios tested and working correctly.

## Screenshots
[Attach 4 screenshots]

## Video Demo
[Link to video]

## Reflection
[Include answers to 3 reflection questions]
```

#### Commit Message:
```bash
git add lib/screens/user_input_form.dart lib/main.dart README.md
git commit -m "feat: implemented user input form with validation

- Created UserInputForm with name and email validation
- Added SnackBar and AlertDialog feedback
- Integrated with app routing
- Updated README with documentation"
```

---

## 🏗️ Stateless vs Stateful Widgets Demo

### Project Description
This demo showcases the difference between Stateless and Stateful widgets in Flutter. The header is a StatelessWidget, while the counter and theme toggle are managed by a StatefulWidget.

### What are Stateless and Stateful Widgets?
**StatelessWidget:**
- Does not store mutable state. Used for static UI elements.

**StatefulWidget:**
- Maintains internal state. Used for interactive or dynamic UI elements.

### Code Snippets
#### StatelessWidget Example
```dart
class DemoHeader extends StatelessWidget {
  final String title;
  const DemoHeader({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}
```

#### StatefulWidget Example
```dart
class DemoCounter extends StatefulWidget {
  @override
  State<DemoCounter> createState() => _DemoCounterState();
}

class _DemoCounterState extends State<DemoCounter> {
  int count = 0;
  void increment() {
    setState(() { count++; });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Counter: $count'),
        ElevatedButton(onPressed: increment, child: Text('Increase')),
      ],
    );
  }
}
```

### Screenshots
#### Initial State
![StatelessStatefulDemo - Initial](screenshots/stateless_stateful_initial.png)

#### After Interaction
![StatelessStatefulDemo - Updated](screenshots/stateless_stateful_updated.png)

### Reflection
**How do Stateful widgets make Flutter apps dynamic?**
> They allow the UI to update in response to user actions or data changes, making apps interactive and responsive.

**Why is it important to separate static and reactive parts of the UI?**
> It improves code clarity, performance, and maintainability by ensuring only necessary widgets rebuild when state changes.

---

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
