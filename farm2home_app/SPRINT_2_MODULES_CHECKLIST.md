# Sprint #2 Module Completion Checklist

## Complete Requirements Verification

This checklist ensures your Farm2Home app has all required Sprint #2 modules properly implemented and tested.

---

## 🎨 Module 1: UI & Navigation

### Requirements
- [ ] App has multiple screens (min 5 screens)
- [ ] BottomNavigationBar or TabBar for navigation
- [ ] Navigation between screens works smoothly
- [ ] Responsive layouts (works on phone & tablet)
- [ ] Proper Material Design (Scaffold, AppBar, etc.)
- [ ] Consistent color scheme throughout

### Screens to Verify
- [ ] **SplashScreen**: Shows logo, 2-3 sec delay
- [ ] **LoginScreen**: Email/password fields, login button
- [ ] **SignupScreen**: Form with validation, create account
- [ ] **HomeScreen**: Product list, search, filter
- [ ] **ProductDetailScreen**: Full product info + add to cart
- [ ] **CartScreen**: Show items, quantities, remove button
- [ ] **OrderScreen**: List of user orders
- [ ] **TrackingScreen**: Live map with delivery location
- [ ] **ProfileScreen**: User info, settings, theme toggle

### Navigation Testing
```
✓ Tap home → works
✓ Tap products → works
✓ Tap cart → works  
✓ Tap orders → works
✓ Tap profile → works
✓ Back button returns to previous screen
✓ Deep linking works from notifications
```

**Status**: ⚫ Not Started | 🟡 In Progress | ✅ Complete

---

## 🔐 Module 2: Firebase Authentication

### Requirements
- [ ] Firebase project created in Firebase Console
- [ ] google-services.json placed in `android/app/`
- [ ] FlutterFire CLI configured (`firebase configure` run)
- [ ] Email/Password authentication enabled in Firebase
- [ ] Google Sign-In enabled in Firebase

### Features to Test
- [ ] **Signup**: New user can register with email & password
- [ ] **Login**: Existing user can login
- [ ] **Session Persistence**: User stays logged in after app restart
- [ ] **Logout**: User can logout, redirects to login
- [ ] **Password Reset**: User can reset password via email
- [ ] **Google Sign-In**: Alternative login option works
- [ ] **Route Protection**: Non-auth users can't access protected screens

### Code Verification
```dart
// File: lib/services/firebase_auth_service.dart
✓ FirebaseAuthService class created
✓ signUp() method implemented
✓ login() method implemented
✓ logout() method implemented
✓ getCurrentUser() returns current user
✓ isUserLoggedIn() returns bool
✓ resetPassword() implemented
```

### Firebase Console Verification
```
✓ Go to Firebase Console
✓ Select your project
✓ Authentication → Users
✓ See at least one test user created
✓ Sign-In Methods shows Email/Password + Google enabled
```

**Status**: ⚫ Not Started | 🟡 In Progress | ✅ Complete

---

## 📦 Module 3: Firestore Database (CRUD + Real-time)

### Database Structure Required
```
✓ Firestore Collection: users/
   - Fields: email, name, phone, address, preferences
   
✓ Firestore Collection: products/
   - Fields: name, price, description, imageUrl, category, farmerId
   
✓ Firestore Collection: orders/
   - Fields: userId, items[], totalPrice, status, deliveryAddress, createdAt
   
✓ Firestore Collection: farmers/
   - Fields: name, email, location, rating, bio
```

### CRUD Operations Required

**CREATE Operations:**
- [ ] Can create new user document on signup
- [ ] Can create new order when user places order
- [ ] Can add product to cart (local storage)

**READ Operations:**
- [ ] Can fetch all products from Firestore
- [ ] Can fetch single product by ID
- [ ] Can fetch user's own orders
- [ ] Can fetch user profile data

**UPDATE Operations:**
- [ ] Can update user profile (name, phone, address)
- [ ] Can update order status (pending → confirmed → shipped → delivered)
- [ ] Can update product quantity

**DELETE Operations:**
- [ ] Can delete cart item
- [ ] Can cancel order

### Real-time Listeners
- [ ] Real-time listener setup for user orders
- [ ] Real-time listener for product updates
- [ ] Listener cleanup on screen dispose
- [ ] Updates UI when Firestore data changes

### Code Verification
```dart
// File: lib/services/firestore_service.dart
✓ FirestoreService class created
✓ createUser(User) implemented
✓ getUser(userId) implemented
✓ updateUser(userId, data) implemented
✓ createOrder(Order) implemented
✓ getUserOrders(userId) stream implemented
✓ getProducts() stream/future implemented
✓ deleteCartItem(cartItemId) implemented
```

### Firebase Console Verification
```
✓ Firestore → Data Storage
✓ Collections visible: users, products, orders, farmers
✓ At least 5 documents in products collection
✓ At least 1 document in orders collection
✓ Sample user data exists
```

**Status**: ⚫ Not Started | 🟡 In Progress | ✅ Complete

---

## 📱 Module 4: Firebase Security Rules

### Rules Requirements
- [ ] Users can only read/write their own data
- [ ] Products are readable by all, writable by admin only
- [ ] Orders are readable/writable only by owner
- [ ] Anonymous users can only read products

### Rules Template
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // Everyone can read products, only admin can write
    match /products/{document=**} {
      allow read: if true;
      allow write: if false;
    }
    
    // Users can read/write their own orders
    match /orders/{orderId} {
      allow read, write: if request.auth.uid == resource.data.userId;
    }
  }
}
```

### Testing Security Rules
```
✓ Logged-in user can read own user document
✓ User CANNOT read other user's data
✓ User CANNOT write to other user's collection
✓ All users can read products
✓ No user can write to products (as expected)
✓ User can create own order
✓ User CANNOT create order for another user
```

**Status**: ⚫ Not Started | 🟡 In Progress | ✅ Complete

---

## 🔔 Module 5: Push Notifications (Firebase Cloud Messaging)

### FCM Setup Required
- [ ] Firebase Cloud Messaging enabled in Firebase Console
- [ ] google-services.json includes FCM configuration
- [ ] flutter_local_notifications package added for display

### Features to Implement
- [ ] **Get FCM Token**: Retrieve device token on app start
- [ ] **Store Token**: Save token to Firestore user document
- [ ] **Foreground Handler**: Display notification when app open
- [ ] **Background Handler**: Handle notification in background
- [ ] **Terminated Handler**: App opens from notification tap
- [ ] **Deep Linking**: Notification tap navigates to correct screen
- [ ] **Custom Sound**: Notification plays custom sound

### Notification Tests
```
Test 1: Foreground Notification
✓ Send notification from Firebase Console
✓ App open → notification appears
✓ Show title, body, custom sound
✓ Tap notification → deep links to order details

Test 2: Background Notification  
✓ Enable developer mode, send notification
✓ App in background → notification in system tray
✓ Tap notification → app opens, navigates to order

Test 3: Terminated Notification
✓ Kill app completely
✓ Send notification from Firebase Console
✓ Notification appears in tray
✓ Tap notification → app launches, shows order details

Test 4: Badge Count
✓ New notification received → app badge increases
✓ Open notification → badge decreases
```

### Code Verification
```dart
// File: lib/services/fcm_service.dart
✓ FCMService class created
✓ initialize() method sets up listeners
✓ getToken() returns device token
✓ onMessage handler implemented for foreground
✓ onBackgroundMessage handler configured
✓ onMessageOpenedApp handler for taps
✓ Deep linking to order details from notification
```

### Firebase Console Verification
```
✓ Messaging → Send test message
✓ Select target: Single device
✓ Paste device FCM token
✓ Send test notification
✓ Verify received on device
```

**Status**: ⚫ Not Started | 🟡 In Progress | ✅ Complete

---

## 🗺️ Module 6: Google Maps & Location Services

### Setup Required
- [ ] Google Maps enabled in Google Cloud Console
- [ ] Android API key created and restricted
- [ ] google_maps_flutter package added
- [ ] Location permissions requested (onCreate + runtime)
- [ ] AndroidManifest.xml has API key metadata

### Features to Implement
- [ ] **Display Maps**: Show Google Maps widget
- [ ] **User Location Marker**: Show user's current location
- [ ] **Delivery Marker**: Show delivery address
- [ ] **Polyline**: Draw route from origin to destination
- [ ] **Real-time Updates**: Location updates as delivery progresses
- [ ] **Permissions**: Request location permissions properly
- [ ] **Geolocation**: Get lat/long of user position

### Map Testing
```
✓ Open tracking screen
✓ Map displays without errors
✓ Current location marked (blue dot)
✓ Delivery address marked (red pin)
✓ Route line shows path (green polyline)
✓ Zoom in/out works
✓ Pan around map works
✓ Real-time location updates visible
```

### Code Verification
```dart
// File: lib/services/location_service.dart
✓ LocationService class created
✓ getCurrentLocation() returns lat/long
✓ requestLocationPermissions() implemented
✓ startLocationUpdates() stream created
✓ stopLocationUpdates() cleanup

// File: lib/widgets/delivery_map_widget.dart
✓ GoogleMap widget renders
✓ Markers placed correctly
✓ Polylines drawn
✓ Live updates work
```

### Firebase Console Verification
```
✓ Google Cloud Console → APIs & Services
✓ Maps SDK for Android enabled
✓ API Key created
✓ API key statistics show usage
```

**Status**: ⚫ Not Started | 🟡 In Progress | ✅ Complete

---

## 🎨 Module 7: Theming (Light/Dark Mode)

### Theme Requirements
- [ ] Light theme implemented (Material Design colors)
- [ ] Dark theme implemented (OLED-optimized colors)
- [ ] Theme provider created with ChangeNotifier
- [ ] Theme toggle in settings screen
- [ ] Theme persists after app restart
- [ ] All screens respect theme (no hardcoded colors)
- [ ] Accessible color contrast (minimum 4.5:1 ratio)

### Colors to Define
- [ ] **Primary**: Used for main buttons, AppBar
- [ ] **Secondary**: Used for secondary buttons, accents
- [ ] **Background**: Body background color
- [ ] **Surface**: Card, dialog backgrounds
- [ ] **Error**: Error messages, delete actions
- [ ] **Text**: Primary text color
- [ ] **Hint**: Hint text, disabled state

### Theme Testing
```
✓ Open app → displays with light theme
✓ Go to Settings → toggle dark mode
✓ All screens update to dark theme
✓ Colors are properly contrasted
✓ Text readable in both themes
✓ Close app → reopen → theme persists
✓ No hardcoded colors (everything uses Theme)
✓ Cards, buttons, text update theme
```

### Code Verification
```dart
// File: lib/themes/app_theme.dart
✓ buildLightTheme() returns ThemeData
✓ buildDarkTheme() returns ThemeData

// File: lib/providers/theme_provider.dart
✓ ThemeProvider class extends ChangeNotifier
✓ toggleTheme() changes theme
✓ saveThemePreference() persists to SharedPreferences
✓ loadThemePreference() on app start

// File: lib/main.dart
✓ Consumer<ThemeProvider> wraps MaterialApp
✓ theme: switch based on provider state
```

**Status**: ⚫ Not Started | 🟡 In Progress | ✅ Complete

---

## ✅ Module 8: Form Validation

### Validation Requirements
- [ ] Email validation (format check)
- [ ] Password validation (min length, complexity)
- [ ] Phone number validation (format, length)
- [ ] Name validation (not empty)
- [ ] Address validation (not empty)
- [ ] Real-time field validation
- [ ] Visual error indicators (red text, icons)
- [ ] Submit button disabled until form valid

### Validators to Implement
```dart
✓ Validators.validateEmail(String?) → String?
✓ Validators.validatePassword(String?) → String?
✓ Validators.validatePhoneNumber(String?) → String?
✓ Validators.validateName(String?) → String?
✓ Validators.validateAddress(String?) → String?
✓ Validators.validateCardNumber(String?) → String?
```

### Form Testing
```
✓ Login Form:
  - Empty fields → button disabled
  - Invalid email → error shown
  - Valid email + password → button enabled
  
✓ Signup Form:
  - Password < 8 chars → error
  - Password no uppercase → error
  - Password no number → error
  - Passwords don't match → error
  - Valid form → button enabled
  
✓ Profile Form:
  - Empty name → error
  - Invalid phone → error
  - Valid form → save button enabled
```

### Code Verification
```dart
// File: lib/utils/validators.dart
✓ All validators implemented
✓ Clear error messages
✓ Regex patterns correct for validation

// File: lib/screens/auth/login_screen.dart
✓ TextFormField uses validator
✓ FormKey validates on submit
✓ Button disabled when form invalid
```

**Status**: ⚫ Not Started | 🟡 In Progress | ✅ Complete

---

## 🔄 Module 9: Error/Loader/Empty States

### Error Handling
- [ ] Try-catch blocks around Firebase calls
- [ ] User-friendly error messages (not raw exceptions)
- [ ] Error widget shows when operations fail
- [ ] Retry button available on error
- [ ] Network error handled gracefully

### Loading States
- [ ] Loader shown during:
  - [ ] Fetching products from Firestore
  - [ ] Creating order
  - [ ] Uploading image to Storage
  - [ ] Loading user profile
- [ ] Loader is smooth CircularProgressIndicator
- [ ] No unresponsive UI during loading

### Empty States
- [ ] Show empty widget when:
  - [ ] No products to display
  - [ ] Cart is empty
  - [ ] No orders placed yet
  - [ ] No search results
- [ ] Empty state has:
  - [ ] Icon/illustration
  - [ ] Clear message
  - [ ] Call-to-action button

### UX Testing
```
✓ Firestore call fails → error widget shown
✓ Tap retry → refetch and show result
✓ No products match filter → empty state shown
✓ Cart empty → show "Browse Products" button
✓ Network disconnected → show network error
✓ Loading products → spinner showing
✓ All loaders dismissible when complete
```

### Code Verification
```dart
// File: lib/widgets/common/app_loader.dart
✓ Loader widget created

// File: lib/widgets/common/error_widget.dart
✓ Error widget with retry button

// File: lib/widgets/common/empty_state_widget.dart
✓ Empty state widget with action

// File: lib/providers/product_provider.dart
✓ isLoading property tracks state
✓ error property stores error message
✓ isEmpty property checks for empty data
```

**Status**: ⚫ Not Started | 🟡 In Progress | ✅ Complete

---

## 📦 Module 10: Release Build & Production

### Requirements
- [ ] Keystore generated (RSA 2048-bit)
- [ ] Gradle configured for signing
- [ ] Release build APK created
- [ ] Release build AAB created
- [ ] No debug banner visible in release
- [ ] Firebase auth works with release signing key
- [ ] All features tested in release mode
- [ ] App installable on physical device

### Build Steps Completed
```
✓ Keystore generated: app-release-key.jks
✓ Key properties configured: key.properties
✓ build.gradle.kts updated with signing config
✓ flutter build apk --release : SUCCESS
✓ flutter build appbundle --release : SUCCESS
✓ APK size: < 100 MB
✓ AAB size: < 80 MB
```

### Release Testing
```
✓ APK installs on device: adb install app-release.apk
✓ No "Verify app" warning appears
✓ App launches without crashes
✓ No debug banner visible
✓ Firebase auth works
✓ Firestore queries work
✓ FCM notifications work
✓ Maps display correctly
✓ All UI/UX smooth at 60 FPS
✓ Performance better than debug mode
```

### Firebase Verification
```
✓ Keystore fingerprints obtained
✓ SHA-1 fingerprint: [YOUR_SHA1]
✓ SHA-256 fingerprint: [YOUR_SHA256]
✓ Fingerprints added to Firebase Console
✓ Firebase auth works with release key
```

### Code Verification
```
✓ no debug print statements in release
✓ no test data hardcoded
✓ no commented code
✓ production APIs configured
✓ Firebase rules deployed
```

**Status**: ⚫ Not Started | 🟡 In Progress | ✅ Complete

---

## 📊 Overall Completion Summary

### Module Status
```
Module 1: UI & Navigation           [⚫ ⚫ ⚫ ⚫ ⚫] 0/5 items
Module 2: Firebase Auth             [⚫ ⚫ ⚫ ⚫ ⚫] 0/5 items
Module 3: Firestore CRUD            [⚫ ⚫ ⚫ ⚫ ⚫] 0/5 items
Module 4: Security Rules            [⚫ ⚫ ⚫ ⚫ ⚫] 0/5 items
Module 5: Push Notifications        [⚫ ⚫ ⚫ ⚫ ⚫] 0/5 items
Module 6: Maps & Location           [⚫ ⚫ ⚫ ⚫ ⚫] 0/5 items
Module 7: Theming                   [⚫ ⚫ ⚫ ⚫ ⚫] 0/5 items
Module 8: Form Validation           [⚫ ⚫ ⚫ ⚫ ⚫] 0/5 items
Module 9: Error/Loader/Empty        [⚫ ⚫ ⚫ ⚫ ⚫] 0/5 items
Module 10: Release Build            [⚫ ⚫ ⚫ ⚫ ⚫] 0/5 items

Total Completion: 0/50 items (0%)
```

### Quality Gates
```
Functionality:          [⚫⚫⚫⚫⚫] Not Started
Code Quality:           [⚫⚫⚫⚫⚫] Not Started
Testing:                [⚫⚫⚫⚫⚫] Not Started
Documentation:          [⚫⚫⚫⚫⚫] Not Started
Production Readiness:   [⚫⚫⚫⚫⚫] Not Started

Overall: 0/5 (⚫⚫⚫⚫⚫) - Ready to Begin
```

---

## 🎯 Instructions for Use

1. **Print this checklist** or follow digitally
2. **Go through each module** in order
3. **Complete all checkboxes** for each item
4. **Update status** as you progress (⚫ → 🟡 → ✅)
5. **Test thoroughly** on both emulator and device
6. **Document findings** in a test report
7. **Create PR** once all items are complete

---

## 🚀 Final Gate: Ready for Submission?

Before submitting, ensure ALL checkboxes are ✅:

```
Final Checklist:
[ ] All 10 modules have every checkbox completed
[ ] App tested on minimum 2 devices
[ ] Firebase Console shows proper configuration
[ ] Release APK/AAB generated and tested
[ ] README documentation complete
[ ] Video demo recorded (2-3 minutes)
[ ] LinkedIn reflection post written
[ ] All code committed with clean history
[ ] No secrets in git repository
[ ] Ready to ship! 🚀
```

---

**Created**: February 16, 2026
**For**: Kalvium Sprint #2 Final Project
**Status**: Template - Ready for Use
