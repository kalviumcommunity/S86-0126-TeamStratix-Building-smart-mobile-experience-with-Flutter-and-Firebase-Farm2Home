# 🌾 Farm2Home - Farm-to-Home Delivery Transparency App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.10.7-02569B?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Latest-FFCA28?logo=firebase)
![Material 3](https://img.shields.io/badge/Material-3-757575?logo=material-design)
![License](https://img.shields.io/badge/License-MIT-green)

**A production-ready Flutter application connecting Customers with Farmers for transparent farm-to-home delivery.**

[Features](#-features) • [Screenshots](#-screenshots) • [Setup](#-quick-start) • [Documentation](#-documentation)

</div>

---

## 📋 Overview

Farm2Home is a complete mobile and web application that bridges the gap between farmers and customers, providing:
- **Direct Connection**: Customers can order directly from local farmers
- **Real-time Tracking**: Track your order from farm to doorstep
- **Transparency**: Complete visibility into order status
- **Multi-platform**: Works on Android, iOS, and Web

## 🎯 Key Features

### For Customers 👨‍💼
- ✅ Browse and select farmers
- ✅ Place orders with multiple items
- ✅ Real-time order tracking with timeline
- ✅ Order history and statistics
- ✅ Profile management
- ✅ In-app chat with farmers
- ✅ Rate and review farmers
- ✅ Multiple payment options
- ✅ Push notifications for updates

### For Farmers 👨‍🌾
- ✅ View pending and completed orders
- ✅ Update order status in real-time
- ✅ Add notes to status updates
- ✅ Dashboard with statistics
- ✅ Order management
- ✅ Chat with customers
- ✅ View ratings and reviews
- ✅ Product management

### For Admin 👨‍💼
- ✅ Comprehensive dashboard
- ✅ User management
- ✅ Order monitoring
- ✅ Product management
- ✅ Ratings overview
- ✅ Statistics and analytics

### Technical Features 🛠️
- ✅ Firebase Authentication (Email/Password)
- ✅ Cloud Firestore for real-time data
- ✅ Provider state management
- ✅ Material 3 design system
- ✅ Responsive UI for mobile and web
- ✅ Role-based access control
- ✅ Form validation and error handling
- ✅ Loading and empty states
- ✅ Push notifications (FCM)
- ✅ Real-time messaging
- ✅ Rating and review system
- ✅ Payment integration
- ✅ Admin dashboard

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│          User Interface Layer           │
│  (Screens, Widgets, Theme)             │
├─────────────────────────────────────────┤
│       State Management Layer            │
│  (Provider - Auth & Order)             │
├─────────────────────────────────────────┤
│         Business Logic Layer            │
│  (Services - Auth & Firestore)         │
├─────────────────────────────────────────┤
│           Data Layer                    │
│  (Models - User, Order, Status)        │
├─────────────────────────────────────────┤
│          Firebase Backend               │
│  (Authentication + Firestore)          │
└─────────────────────────────────────────┘
```

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.10.7+)
- Firebase CLI
- FlutterFire CLI
- Git

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd farm2home_demo
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase:**
   ```bash
   flutterfire configure
   ```

4. **Update Firebase options in main.dart:**
   ```dart
   import 'firebase_options.dart';
   
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   ```

5. **Deploy Firestore rules:**
   ```bash
   firebase deploy --only firestore:rules
   ```

6. **Run the app:**
   ```bash
   flutter run
   ```

For detailed setup instructions, see [SETUP_GUIDE.md](SETUP_GUIDE.md)

## 📱 Order Status Flow

```
Received → Harvesting → Packed → Out for Delivery → Delivered
```

Each status update is:
- Tracked in real-time
- Visible to both customer and farmer
- Stored with timestamp
- Can include optional notes

## 🎨 Design System

### Theme
- **Primary Color**: Green (#4CAF50)
- **Background**: White
- **Design**: Material 3
- **Typography**: Roboto

### UI Components
- Rounded cards with soft shadows
- Consistent 16dp padding
- Status-specific color coding
- Responsive layouts for all screen sizes

## 📦 Tech Stack

| Category | Technology |
|----------|-----------|
| **Frontend** | Flutter 3.x |
| **UI Framework** | Material 3 |
| **Backend** | Firebase |
| **Authentication** | Firebase Auth |
| **Database** | Cloud Firestore |
| **State Management** | Provider |
| **Date Formatting** | intl |
| **Platforms** | Android, iOS, Web |

## 📂 Project Structure

```
lib/
├── main.dart                 # App entry & routing
├── core/
│   └── constants.dart       # App-wide constants
├── theme/
│   └── app_theme.dart       # Material 3 theme
├── models/                  # Data models
├── services/                # Business logic
├── providers/               # State management
├── widgets/                 # Reusable widgets
└── screens/
    ├── auth/               # Authentication screens
    ├── shared/             # Shared screens
    ├── customer/           # Customer-specific
    └── farmer/             # Farmer-specific
```

## 🔥 Firebase Collections

### users
```json
{
  "uid": "unique_user_id",
  "name": "John Doe",
  "email": "john@example.com",
  "role": "customer",
  "createdAt": "timestamp"
}
```

### orders
```json
{
  "orderId": "unique_order_id",
  "customerId": "user_id",
  "farmerId": "farmer_id",
  "items": [ /* order items */ ],
  "status": "Received",
  "timestamp": "timestamp",
  "deliveryAddress": "123 Main St",
  "phoneNumber": "+1234567890"
}
```

### statusUpdates
```json
{
  "updateId": "unique_update_id",
  "orderId": "order_id",
  "status": "Harvesting",
  "updatedAt": "timestamp",
  "notes": "Optional notes"
}
```

## 🔒 Security

- Firebase Authentication for user management
- Firestore security rules for data protection
- Role-based access control
- Input validation and sanitization
- Secure password requirements

## 📊 Performance

- Lazy loading for large lists
- Efficient state management with Provider
- Optimized Firestore queries with indexes
- Caching for offline support
- Responsive UI with minimal rebuilds

## 🧪 Testing

Create test accounts for both roles:

**Customer:**
- Email: customer@test.com
- Password: test123
- Role: Customer

**Farmer:**
- Email: farmer@test.com
- Password: test123
- Role: Farmer

## 📱 Build Commands

### Android
```bash
# Debug
flutter run

# Release APK
flutter build apk --release

# App Bundle (Play Store)
flutter build appbundle --release
```

### iOS (Mac only)
```bash
# Debug
flutter run -d ios

# Release
flutter build ios --release
```

### Web
```bash
# Debug
flutter run -d chrome

# Release
flutter build web --release

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

## 📚 Documentation

- [Setup Guide](SETUP_GUIDE.md) - Detailed installation and configuration
- [Deployment Guide](DEPLOYMENT.md) - Quick deployment steps
- [Firestore Rules](firestore.rules) - Database security rules
- [Firebase Config](firebase.json) - Firebase configuration

## 🛣️ Roadmap

### Phase 1 (Current) ✅
- [x] User authentication
- [x] Role-based access
- [x] Order management
- [x] Real-time tracking
- [x] Material 3 UI

### Phase 2 (Completed) ✅
- [x] Push notifications
- [x] In-app messaging
- [x] Payment integration
- [x] Rating system
- [x] Admin panel

### Phase 3 (Planned)
- [ ] Google Maps integration
- [ ] Analytics dashboard
- [ ] Multi-language support
- [ ] Dark mode
- [ ] Offline mode

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for the backend infrastructure
- Material Design team for the design system

## 📞 Support

For support and questions:
- Create an issue on GitHub
- Check the [Setup Guide](SETUP_GUIDE.md)
- Review Firebase documentation

---

<div align="center">

**Built with ❤️ using Flutter and Firebase**

⭐ Star this repo if you find it helpful!

</div>

