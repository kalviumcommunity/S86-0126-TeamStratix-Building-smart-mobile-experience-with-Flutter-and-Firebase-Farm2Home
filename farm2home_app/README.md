

# Farm2Home App 🌱

---

## �️ Firestore Database Schema Design (Sprint 2)

### Overview
Farm2Home uses Cloud Firestore as its backend database - a fully managed, scalable NoSQL database optimized for real-time mobile experiences. This section documents the complete database structure, including collections, documents, subcollections, and the design decisions behind the schema.

### Why This Schema Design Matters
- **Scalability**: Designed to handle thousands of products, users, and orders
- **Performance**: Optimized for common queries (browsing products, viewing orders)
- **Real-time Ready**: Structure supports live updates for orders and notifications
- **Maintainability**: Clear, logical organization easy for team to understand
- **Future-Proof**: Easy to extend with new features (chat, subscriptions, analytics)

---

### Data Requirements List

Farm2Home needs to store and manage:

1. **Users** - Customer profiles, contact info, account settings
2. **Farmers** - Vendor profiles, farm details, location, certifications
3. **Products** - Farm products with pricing, inventory, images, ratings
4. **Orders** - Purchase history, order status, delivery tracking
5. **Reviews** - Product ratings and customer feedback
6. **Addresses** - User delivery addresses (multiple per user)
7. **Categories** - Product categorization and browsing structure
8. **Notifications** - Order updates, promotions, system messages
9. **Order Updates** - Status tracking history and timeline

---

### Firestore Schema Structure

#### 📊 Schema Overview

```
Farm2Home Database
├── users/                    (Top-level collection)
│   └── {userId}/
│       ├── name, email, phone, favorites...
│       └── addresses/        (Subcollection)
│           └── {addressId}/
├── farmers/                  (Top-level collection)
│   └── {farmerId}/
│       ├── farmName, location, rating...
├── products/                 (Top-level collection)
│   └── {productId}/
│       ├── name, price, category, stock...
│       └── reviews/          (Subcollection)
│           └── {reviewId}/
├── orders/                   (Top-level collection)
│   └── {orderId}/
│       ├── userId, items, total, status...
│       └── updates/          (Subcollection)
│           └── {updateId}/
├── categories/               (Top-level collection)
│   └── {categoryId}/
└── notifications/            (Top-level collection)
    └── {notificationId}/
```

---

### Collection Details

#### 1. `users` Collection

**Purpose**: Store customer profiles and preferences

**Document Structure**:
```json
{
  "userId": "user_abc123",
  "name": "Sarah Johnson",
  "email": "sarah.johnson@example.com",
  "phoneNumber": "+1234567890",
  "profileImageUrl": "https://storage.googleapis.com/...",
  "accountType": "customer",
  "favorites": ["prod_001", "prod_045"],
  "createdAt": "2026-02-06T10:30:00Z",
  "updatedAt": "2026-02-06T10:30:00Z"
}
```

**Fields**:
- `name`: string - Full name
- `email`: string - Email address
- `phoneNumber`: string - Contact number
- `accountType`: string - "customer" or "farmer"
- `favorites`: array - Product IDs user has favorited
- `createdAt`: timestamp - Account creation
- `updatedAt`: timestamp - Last profile update

**Subcollection**: `users/{userId}/addresses` - Multiple delivery addresses

---

#### 2. `users/{userId}/addresses` Subcollection

**Purpose**: Store multiple delivery addresses per user

**Why Subcollection?**
- Users can have many addresses (home, work, vacation)
- Addresses don't need to load with every user profile fetch
- Keeps user document size manageable
- Easy to add/remove without affecting main profile

**Document Structure**:
```json
{
  "addressId": "addr_xyz789",
  "label": "Home",
  "street": "123 Oak Street",
  "city": "Springfield",
  "state": "IL",
  "zipCode": "62701",
  "country": "USA",
  "isDefault": true,
  "deliveryInstructions": "Leave at front door",
  "createdAt": "2026-02-06T10:35:00Z"
}
```

---

#### 3. `farmers` Collection

**Purpose**: Vendor/farmer profiles and farm information

**Document Structure**:
```json
{
  "farmerId": "farm_456",
  "userId": "user_farmer_001",
  "farmName": "Green Valley Organic Farm",
  "description": "Family-owned organic farm",
  "farmImageUrl": "https://storage.googleapis.com/...",
  "location": {"latitude": 39.7817, "longitude": -89.6501},
  "address": "456 Rural Route 1, Springfield, IL",
  "certifications": ["USDA Organic", "Non-GMO"],
  "rating": 4.8,
  "totalReviews": 127,
  "isVerified": true,
  "createdAt": "2026-01-15T08:00:00Z"
}
```

**Fields**:
- `userId`: string - Reference to users collection
- `farmName`: string - Business name
- `location`: geopoint - For map/distance queries
- `certifications`: array - Organic, Non-GMO, etc.
- `rating`: number - Average rating (0-5)
- `isVerified`: boolean - Admin verification status

---

#### 4. `products` Collection

**Purpose**: All farm products available for purchase

**Document Structure**:
```json
{
  "productId": "prod_001",
  "name": "Organic Tomatoes",
  "description": "Fresh, vine-ripened organic tomatoes",
  "farmerId": "farm_456",
  "category": "Vegetables",
  "subcategory": "Fruits",
  "price": 3.99,
  "unit": "lb",
  "stockQuantity": 150,
  "isAvailable": true,
  "imageUrls": ["https://storage.googleapis.com/..."],
  "tags": ["organic", "local", "seasonal"],
  "nutritionInfo": {"calories": 18, "protein": 0.9},
  "rating": 4.7,
  "totalReviews": 45,
  "totalSales": 523,
  "createdAt": "2026-01-20T09:00:00Z",
  "updatedAt": "2026-02-06T08:15:00Z"
}
```

**Key Fields**:
- `farmerId`: string - Which farm sells this
- `category`: string - Main category (Vegetables, Fruits, Dairy)
- `stockQuantity`: number - Current inventory
- `isAvailable`: boolean - In stock and active
- `tags`: array - Searchable keywords
- `rating`: number - Aggregate rating from reviews

**Subcollection**: `products/{productId}/reviews` - Customer reviews

---

#### 5. `products/{productId}/reviews` Subcollection

**Purpose**: Customer reviews and ratings for each product

**Why Subcollection?**
- Popular products may have thousands of reviews
- Don't want to load all reviews when browsing products
- Enables pagination ("Load more reviews")
- Better query performance

**Document Structure**:
```json
{
  "reviewId": "rev_abc123",
  "userId": "user_abc123",
  "userName": "Sarah Johnson",
  "rating": 5,
  "comment": "Best tomatoes I've ever tasted!",
  "isVerifiedPurchase": true,
  "helpfulCount": 12,
  "images": ["https://storage.googleapis.com/reviews/..."],
  "createdAt": "2026-02-01T16:45:00Z"
}
```

---

#### 6. `orders` Collection

**Purpose**: Customer purchase orders and history

**Why Top-Level Collection?**
- Admin needs to see all orders across users
- Farmers need orders containing their products
- Analytics and reporting require cross-user queries

**Document Structure**:
```json
{
  "orderId": "order_xyz789",
  "userId": "user_abc123",
  "orderNumber": "F2H-20260206-001",
  "status": "confirmed",
  "items": [
    {
      "productId": "prod_001",
      "productName": "Organic Tomatoes",
      "quantity": 2,
      "unit": "lb",
      "pricePerUnit": 3.99,
      "totalPrice": 7.98,
      "farmerId": "farm_456"
    }
  ],
  "subtotal": 10.47,
  "tax": 0.94,
  "deliveryFee": 3.99,
  "totalAmount": 15.40,
  "deliveryAddress": {
    "street": "123 Oak Street",
    "city": "Springfield",
    "state": "IL",
    "zipCode": "62701"
  },
  "paymentMethod": "credit_card",
  "paymentStatus": "completed",
  "estimatedDelivery": "2026-02-08T14:00:00Z",
  "trackingNumber": "TRACK123456",
  "createdAt": "2026-02-06T11:30:00Z",
  "updatedAt": "2026-02-06T11:35:00Z"
}
```

**Key Design Decision**: Product name stored in order items (denormalization) so order history remains accurate even if product name changes.

**Subcollection**: `orders/{orderId}/updates` - Status tracking timeline

---

#### 7. `orders/{orderId}/updates` Subcollection

**Purpose**: Track order status changes and delivery progress

**Document Structure**:
```json
{
  "updateId": "upd_001",
  "status": "confirmed",
  "message": "Order confirmed by Green Valley Farm",
  "location": "Farm Warehouse",
  "updatedBy": "farm_456",
  "timestamp": "2026-02-06T11:35:00Z"
}
```

---

#### 8. `categories` Collection

**Purpose**: Product categorization and browsing structure

**Document Structure**:
```json
{
  "categoryId": "cat_vegetables",
  "name": "Vegetables",
  "description": "Fresh vegetables from local farms",
  "imageUrl": "https://storage.googleapis.com/...",
  "icon": "🥬",
  "subcategories": ["Leafy Greens", "Root Vegetables"],
  "sortOrder": 1,
  "isActive": true,
  "createdAt": "2026-01-10T00:00:00Z"
}
```

---

#### 9. `notifications` Collection

**Purpose**: User notifications for orders, promotions, system messages

**Document Structure**:
```json
{
  "notificationId": "notif_123",
  "userId": "user_abc123",
  "type": "order",
  "title": "Order Confirmed! 🎉",
  "message": "Your order F2H-20260206-001 has been confirmed",
  "imageUrl": "https://storage.googleapis.com/...",
  "actionUrl": "farm2home://orders/order_xyz789",
  "isRead": false,
  "priority": "high",
  "createdAt": "2026-02-06T11:35:00Z"
}
```

---

### Schema Diagram

For a complete visual representation of the database structure, see:
- **[FIRESTORE_SCHEMA_DIAGRAM.md](FIRESTORE_SCHEMA_DIAGRAM.md)** - Mermaid diagrams, ER diagrams, and relationships

The diagram includes:
- All collections and subcollections
- Document fields and data types
- Reference relationships between collections
- Data flow patterns

---

### Key Design Decisions

#### 1. When We Used Subcollections

**✅ Reviews** (`products/{id}/reviews`)
- **Why**: Products can have hundreds/thousands of reviews
- **Benefit**: Don't load all reviews when browsing products
- **Performance**: Easy pagination, targeted queries

**✅ Addresses** (`users/{id}/addresses`)
- **Why**: Users have multiple addresses
- **Benefit**: Load only when needed, keeps user doc small
- **Performance**: Independent CRUD operations

**✅ Order Updates** (`orders/{id}/updates`)
- **Why**: Complete audit trail of status changes
- **Benefit**: Real-time tracking without re-fetching entire order
- **Performance**: Order doc stays small even with many updates

#### 2. When We Used Top-Level Collections

**✅ Orders** (not under users)
- **Why**: Admin needs cross-user queries
- **Need**: Farmers must see orders with their products
- **Analytics**: Sales reports, revenue tracking

**✅ Products** (not under farmers)
- **Why**: Centralized product browsing
- **Need**: Search across all farms
- **Performance**: Single query for "all vegetables"

**✅ Farmers** (separate from users)
- **Why**: Additional business-specific fields
- **Need**: Farm-specific queries (nearby farms, certified farms)
- **Flexibility**: User can be both customer and farmer

#### 3. Denormalization Choices

**✅ Product name in order items**
- **Trade-off**: Slight duplication for accuracy
- **Why**: Order history must remain accurate even if product renamed
- **Result**: No need to join products when displaying order history

**✅ User name in reviews**
- **Trade-off**: Name duplicated across reviews
- **Why**: Fast display without fetching user document
- **Result**: Reviews load instantly

**❌ NOT storing entire product in favorites**
- **Why**: Product details change (price, stock)
- **Solution**: Store only productId, fetch details when needed
- **Result**: Always show current product information

---

### Common Queries This Schema Supports

```dart
// Browse products by category
firestore.collection('products')
  .where('category', isEqualTo: 'Vegetables')
  .where('isAvailable', isEqualTo: true)
  .orderBy('rating', descending: true)
  .get();

// Get user's order history
firestore.collection('orders')
  .where('userId', isEqualTo: userId)
  .orderBy('createdAt', descending: true)
  .limit(20)
  .get();

// Stream product reviews (real-time)
firestore.collection('products')
  .doc(productId)
  .collection('reviews')
  .orderBy('createdAt', descending: true)
  .snapshots();

// Find products from specific farmer
firestore.collection('products')
  .where('farmerId', isEqualTo: farmerId)
  .where('isAvailable', isEqualTo: true)
  .get();

// Get unread notifications
firestore.collection('notifications')
  .where('userId', isEqualTo: userId)
  .where('isRead', isEqualTo: false)
  .orderBy('createdAt', descending: true)
  .get();
```

---

### Performance & Scalability

#### ✅ What Makes This Schema Scalable?

1. **Subcollections for Large Datasets**
   - Reviews, addresses, updates use subcollections
   - Prevents 1MB document size limit
   - Enables efficient pagination

2. **Indexed Fields**
   - `userId` in orders (user-specific queries)
   - `farmerId` in products (farmer dashboard)
   - `category` in products (browsing)
   - `status` in orders (filtering)

3. **Smart Denormalization**
   - Product names in orders (prevents extra reads)
   - User names in reviews (faster display)
   - Trade-off: Controlled duplication for performance

4. **Real-time Optimization**
   - Stream only what's needed
   - Subcollections enable targeted listeners
   - `isRead` boolean for efficient notification queries

5. **Avoiding Pitfalls**
   - ❌ No large arrays (reviews as subcollection, not array)
   - ❌ No deep nesting (max 2-3 levels)
   - ✅ Proper use of references vs embedding

---

### Sample Documents for Testing

For complete sample documents for each collection, see:
- **[FIRESTORE_SCHEMA.md](FIRESTORE_SCHEMA.md)** - Detailed schema with full examples

---

### Reflection

#### Why This Structure?

**1. Separation of Concerns**
- Users, products, orders, farmers are independent entities
- Each can be queried, updated, scaled independently
- Clear boundaries make code maintainable

**2. Query Efficiency**
- Structured to support app's most common operations
- Minimizes reads through denormalization
- Enables real-time features without performance hit

**3. Scalability First**
- Subcollections prevent document bloat
- Top-level collections enable cross-entity queries
- Can handle millions of documents

**4. Real-time Ready**
- Small, focused documents for live updates
- Subcollections for targeted listeners
- Efficient snapshot queries

**5. Developer Experience**
- Clear, logical naming (lowerCamelCase)
- Self-documenting structure
- Easy for new team members to understand

#### Challenges Faced

**1. Denormalization Trade-offs**
- **Challenge**: Deciding what to duplicate
- **Solution**: Duplicate only display names, not entire objects
- **Result**: Fast reads, manageable update complexity

**2. Subcollection vs Array Decision**
- **Challenge**: Reviews as array or subcollection?
- **Solution**: Subcollection (scalability wins)
- **Result**: Products can have unlimited reviews

**3. Order Structure**
- **Challenge**: Store product references or full details?
- **Solution**: Hybrid - store IDs + display names
- **Result**: Fast display + accurate history

**4. Firestore Query Limitations**
- **Challenge**: No OR queries, limited array queries
- **Solution**: Structure data to avoid complex queries
- **Result**: Simple, efficient query patterns

#### What I Learned

**NoSQL is Different**
- Denormalization is good (in moderation)
- Design schema around queries, not just entities
- Document size matters (1MB limit)

**Firestore-Specific Insights**
- Subcollections are powerful for scalability
- Timestamps should use `FieldValue.serverTimestamp()`
- Geopoints enable location-based queries
- Composite indexes needed for complex queries

**Performance Lessons**
- Fewer reads = lower costs
- Denormalize frequently-accessed data
- Use subcollections for large datasets
- Stream only what users actually need

**Best Practices Applied**
- ✅ Clear field naming conventions
- ✅ Consistent timestamp fields
- ✅ Boolean fields prefixed with `is`
- ✅ References stored as strings (IDs)
- ✅ Arrays limited to reasonable sizes

---

### Future Enhancements

This schema can easily support:

1. **Chat System**: Add `conversations` and `messages` subcollections
2. **Promotions**: Add `coupons` collection with redemption tracking
3. **Subscriptions**: Add `subscriptions` for recurring deliveries
4. **Inventory Management**: Add `inventory` subcollection for farmers
5. **Analytics**: Structure enables BigQuery export
6. **Admin Dashboard**: Top-level collections support comprehensive queries

---

### Resources & Documentation

- **Detailed Schema**: [FIRESTORE_SCHEMA.md](FIRESTORE_SCHEMA.md)
- **Visual Diagrams**: [FIRESTORE_SCHEMA_DIAGRAM.md](FIRESTORE_SCHEMA_DIAGRAM.md)
- [Firebase Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Firestore Data Modeling Best Practices](https://firebase.google.com/docs/firestore/manage-data/structure-data)
- [NoSQL Data Modeling](https://firebase.google.com/docs/firestore/data-model)

---

## �🔐 Persistent User Sessions with Firebase Auth (Sprint 2)

### Overview
Modern mobile apps keep users logged in even after closing the app or restarting their device. Firebase Authentication automatically manages session persistence using secure tokens stored on the device. This implementation demonstrates how to build a seamless auto-login flow that detects, stores, and restores user login states across app restarts.

### Why Persistent Login is Essential
- **Better User Experience**: Users don't have to log in every time they open the app
- **Session Continuity**: Firebase securely stores authentication tokens on the device
- **Automatic Token Refresh**: Firebase handles token expiration and refresh automatically
- **Industry Standard**: Expected behavior in all modern mobile applications
- **Secure by Default**: Firebase encryption ensures token security

### Features
- ✅ **Auto-Login Detection** - Automatically detects if user is already logged in
- ✅ **Session Persistence** - Login state maintained across app restarts
- ✅ **Smart Routing** - Redirects to appropriate screen based on auth state
- ✅ **Splash Screen** - Professional loading experience during auth check
- ✅ **Automatic Logout Handling** - Clean session termination and redirect
- ✅ **Token Management** - Firebase auto-refreshes authentication tokens

---

### How Firebase Session Persistence Works

Firebase Auth automatically persists user sessions using **secure tokens** stored on the device:

1. **User logs in** → Firebase creates authentication token
2. **Token stored securely** → Encrypted storage on device
3. **App closes** → Token remains in secure storage
4. **App reopens** → Firebase validates token automatically
5. **Token valid** → User stays logged in
6. **Token expired/invalid** → User redirected to login

**Key Benefits:**
- No manual storage (SharedPreferences, SQLite, etc.) required
- Tokens auto-refresh in the background
- Developers only handle screen routing based on auth state
- Firebase manages security and encryption

---

### Implementation: authStateChanges() Stream

The foundation of persistent sessions is Firebase's `authStateChanges()` stream, which notifies your app whenever:
- User logs in
- User logs out
- Session becomes invalid
- User reopens the app

#### Core Implementation in main.dart

```dart
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to Firebase Auth state changes
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show splash screen while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        
        // User is authenticated → Navigate to HomeScreen
        if (snapshot.hasData && snapshot.data != null) {
          return HomeScreen(cartService: CartService());
        }
        
        // No authenticated user → Show LoginScreen
        return const LoginScreen();
      },
    );
  }
}
```

**How it Works:**
1. `authStateChanges()` creates a continuous stream
2. `StreamBuilder` listens to this stream
3. When auth state changes, `StreamBuilder` rebuilds automatically
4. App redirects to appropriate screen based on user state

---

### Auto-Login Flow Diagram

```
App Starts
    ↓
AuthWrapper checks authStateChanges()
    ↓
ConnectionState.waiting? → Show SplashScreen
    ↓
snapshot.hasData?
    ↓
  YES → User is logged in → Navigate to HomeScreen
    ↓
   NO → No active session → Navigate to LoginScreen
```

---

### Splash Screen Implementation

A professional loading experience while Firebase checks session state:

```dart
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4EDD4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.agriculture, size: 100, color: Colors.green.shade700),
            const SizedBox(height: 24),
            Text('Farm2Home', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 48),
            CircularProgressIndicator(color: Colors.green.shade700),
            const SizedBox(height: 16),
            Text('Loading...', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
```

---

### Login & Sign Up Flow (No Manual Navigation Required)

**Before (Manual Navigation):**
```dart
// ❌ Old approach - manual navigation causes issues
final user = await _authService.login(email, password);
if (user != null) {
  Navigator.pushReplacement(context, HomeScreen());  // Unnecessary
}
```

**After (Automatic Navigation via AuthWrapper):**
```dart
// ✅ New approach - AuthWrapper handles navigation automatically
final user = await _authService.login(email, password);
if (user != null && mounted) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Login successful!')),
  );
  // AuthWrapper's StreamBuilder detects auth change and navigates automatically
}
```

**Why This is Better:**
- Eliminates duplicate navigation logic
- AuthWrapper centrally manages all auth-based routing
- Prevents navigation conflicts
- Works seamlessly with auto-login on app restart

---

### Logout Implementation

Clean session termination from HomeScreen:

```dart
IconButton(
  icon: const Icon(Icons.logout),
  onPressed: () async {
    try {
      await FirebaseAuth.instance.signOut();
      // AuthWrapper automatically redirects to LoginScreen
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged out successfully')),
        );
      }
    } catch (e) {
      // Handle error
    }
  },
)
```

**What Happens:**
1. `signOut()` clears authentication token
2. `authStateChanges()` stream emits `null`
3. AuthWrapper's StreamBuilder rebuilds
4. User automatically redirected to LoginScreen

---

### Testing Persistent Login

#### Test Scenario 1: Auto-Login After App Restart
1. **Login** → Enter credentials → Submit
2. **Verify** → HomeScreen appears with user email
3. **Close App** → Fully close the app (swipe away from recent apps)
4. **Reopen App** → Launch app again
5. **Expected Result** → App shows SplashScreen briefly, then automatically navigates to HomeScreen
6. **Success** ✅ User remained logged in without re-entering credentials

#### Test Scenario 2: Logout and Session Termination
1. **Navigate** → Open HomeScreen
2. **Logout** → Tap logout icon in AppBar
3. **Verify** → Redirected to LoginScreen
4. **Close App** → Fully close the app
5. **Reopen App** → Launch app again
6. **Expected Result** → App shows LoginScreen (session terminated)
7. **Success** ✅ Logout properly cleared session

#### Test Scenario 3: Multiple Restarts
1. **Login** → Authenticate user
2. **Restart 1** → Close and reopen → Should show HomeScreen
3. **Restart 2** → Close and reopen again → Should still show HomeScreen
4. **Restart 3** → Close and reopen once more → Should still show HomeScreen
5. **Success** ✅ Session persists indefinitely until logout

---

### Handling Token Expiry and Errors

Firebase handles token management automatically:

**Token Refresh:**
- Tokens auto-refresh in the background
- No developer intervention required
- Happens seamlessly without user awareness

**Token Invalidation (Automatic Logout):**
Tokens become invalid when:
- User changes password
- User account is deleted
- User clears app data
- Admin disables user account in Firebase Console

**Error Handling in AuthWrapper:**
```dart
if (snapshot.hasError) {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: ${snapshot.error}'),
          ElevatedButton(
            onPressed: () => (context as Element).reassemble(),
            child: const Text('Retry'),
          ),
        ],
      ),
    ),
  );
}
```

---

### Verifying Session in Firebase Console

**Optional Step** - Confirm session is managed by Firebase:

1. Open [Firebase Console](https://console.firebase.google.com/)
2. Navigate to **Authentication** → **Users**
3. Observe:
   - User account exists
   - **Last sign-in** timestamp updates when you login
   - **Created** timestamp shows account creation date

**Key Insight:**
- Session is tied to Firebase backend, not just local device storage
- Firebase manages token validation centrally
- User state syncs across all devices if logged in on multiple devices

---

### Code Architecture

```
main.dart
  └── AuthWrapper (Root Widget)
       └── StreamBuilder<User?>
            ├── stream: FirebaseAuth.instance.authStateChanges()
            ├── ConnectionState.waiting → SplashScreen
            ├── snapshot.hasData → HomeScreen
            └── No data → LoginScreen

LoginScreen / SignUpScreen
  ├── User enters credentials
  ├── AuthService.login() / AuthService.signUp()
  └── AuthWrapper automatically detects auth state change
       └── Navigates to HomeScreen

HomeScreen
  ├── Logout button → FirebaseAuth.instance.signOut()
  └── AuthWrapper detects auth state change
       └── Navigates to LoginScreen
```

---

### Screenshots

#### 1. Splash Screen (App Loading)
*Shows while Firebase checks authentication state*

#### 2. Login Screen (No Active Session)
*Displayed when user is not logged in*

#### 3. Home Screen (User Authenticated)
*Displays user email and logout button*

#### 4. Auto-Login After Restart
*User remains logged in after closing and reopening app*

#### 5. Logout Flow
*User clicks logout → Redirected to LoginScreen → Session cleared*

---

### Reflection: Why Firebase Makes Session Handling Easier

**Traditional Session Management (Without Firebase):**
- Manually store tokens in SharedPreferences/Keychain
- Implement token refresh logic
- Handle token expiration manually
- Write encryption for secure storage
- Manage session synchronization across app restarts
- Build complex state management for auth flow

**With Firebase Authentication:**
- ✅ Automatic token storage and encryption
- ✅ Built-in token refresh mechanism
- ✅ Cross-platform session persistence (iOS, Android, Web)
- ✅ Simple `authStateChanges()` stream for state detection
- ✅ No manual storage or encryption needed
- ✅ Enterprise-grade security out of the box

**Personal Insights:**
1. **Simplicity**: Firebase reduces hundreds of lines of boilerplate code to a single `StreamBuilder`
2. **Reliability**: Eliminates common bugs related to token expiration and storage
3. **Security**: Firebase handles encryption and secure storage automatically
4. **Scalability**: Works seamlessly as user base grows without performance concerns

**Challenges Faced:**
- Initially implemented manual navigation in LoginScreen, which conflicted with AuthWrapper's automatic navigation
- **Solution**: Removed all manual navigation logic from auth screens and let AuthWrapper handle routing centrally
- **Learning**: Centralizing navigation based on auth state creates cleaner, more maintainable code

**Best Practices Learned:**
1. Always use `authStateChanges()` as the single source of truth for auth state
2. Avoid manual navigation after login/logout - let StreamBuilder handle it
3. Show loading states (SplashScreen) for better UX during auth checks
4. Test auto-login thoroughly by fully closing and reopening the app

---

### Key Takeaways

1. **Firebase Automates Session Persistence** - No manual token storage required
2. **authStateChanges() is Essential** - Single stream for all auth state management
3. **StreamBuilder Drives Navigation** - Automatically redirects based on auth state
4. **SplashScreen Enhances UX** - Professional loading experience during auth check
5. **Centralized Auth Logic** - AuthWrapper manages all authentication-based routing
6. **Testing is Critical** - Always verify auto-login by fully closing and reopening app

---

## 📊 Local UI State Management with setState() (Sprint 2)

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
- **Google Maps Integration**: Interactive maps with farm locations
- **Location Tracking**: Real-time GPS tracking and user location services
- **CRUD Operations**: Complete Create, Read, Update, Delete functionality for user data
- **State Management**: Provider-based reactive state across the entire app

### Firebase Integration
- ✅ Email/Password Authentication
- ✅ Firestore Database for user data
- ✅ Real-time order management
- ✅ User favorites tracking
- ✅ Automatic data persistence
- ✅ User-specific CRUD operations with security rules

### Location Services
- ✅ Interactive Google Maps display
- ✅ Custom map markers for farms
- ✅ Real-time GPS location tracking
- ✅ User location permissions handling
- ✅ Map type controls (normal, satellite, terrain)

### State Management
- ✅ Provider for scalable state management
- ✅ Shopping cart state shared across screens
- ✅ Favorites management with automatic UI updates
- ✅ App-wide theme switching (light/dark mode)
- ✅ No prop-drilling with context.watch/read
- ✅ Reactive UI with ChangeNotifier pattern

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

---

## 🔄 Firestore Read Operations & Live Data Display (Sprint 3)

### Overview
Farm2Home now implements comprehensive Firestore read operations with real-time data streaming using `StreamBuilder`. Products are fetched directly from Cloud Firestore and updates automatically reflect in the UI without page refresh.

### Architecture Components

#### 1. **Enhanced Product Model** (`lib/models/product.dart`)
The Product model now includes Firestore serialization methods:

```dart
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String unit;
  final String category;
  final String imageIcon;
  final bool isAvailable;
  final int stock;
  final String farmerId;
  final double rating;
  final int reviewCount;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.category,
    required this.imageIcon,
    this.isAvailable = true,
    this.stock = 0,
    this.farmerId = '',
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  /// Create Product from Firestore document
  factory Product.fromFirestore(Map<String, dynamic> data) {
    return Product(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      unit: data['unit'] ?? '',
      category: data['category'] ?? '',
      imageIcon: data['imageIcon'] ?? '🌱',
      isAvailable: data['isAvailable'] ?? true,
      stock: data['stock'] ?? 0,
      farmerId: data['farmerId'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
    );
  }

  /// Convert Product to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'unit': unit,
      'category': category,
      'imageIcon': imageIcon,
      'isAvailable': isAvailable,
      'stock': stock,
      'farmerId': farmerId,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }
}
```

#### 2. **Firestore Service Extensions** (`lib/services/firestore_service.dart`)

##### Product Read Operations
```dart
// Get all products (one-time read)
Future<List<Map<String, dynamic>>> getAllProducts() async {
  final querySnapshot = await _firestore.collection('products').get();
  return querySnapshot.docs
      .map((doc) => {'id': doc.id, ...doc.data()})
      .toList();
}

// Stream all products (real-time updates)
Stream<QuerySnapshot<Map<String, dynamic>>> streamAllProducts() {
  return _firestore.collection('products').snapshots();
}

// Get single product by ID
Future<Map<String, dynamic>?> getProductById(String productId) async {
  final doc = await _firestore.collection('products').doc(productId).get();
  if (doc.exists) {
    return {'id': doc.id, ...doc.data()!};
  }
  return null;
}

// Stream single product (real-time)
Stream<DocumentSnapshot<Map<String, dynamic>>> streamProductById(String productId) {
  return _firestore.collection('products').doc(productId).snapshots();
}

// Get products by category
Future<List<Map<String, dynamic>>> getProductsByCategory(String category) async {
  final querySnapshot = await _firestore
      .collection('products')
      .where('category', isEqualTo: category)
      .get();
  return querySnapshot.docs
      .map((doc) => {'id': doc.id, ...doc.data()})
      .toList();
}

// Stream available products only
Stream<QuerySnapshot<Map<String, dynamic>>> streamAvailableProducts() {
  return _firestore
      .collection('products')
      .where('isAvailable', isEqualTo: true)
      .orderBy('name')
      .snapshots();
}

// Search products by name/category
Future<List<Map<String, dynamic>>> searchProducts(String searchTerm) async {
  final querySnapshot = await _firestore.collection('products').get();
  final searchLower = searchTerm.toLowerCase();

  return querySnapshot.docs
      .where((doc) {
        final data = doc.data();
        final name = (data['name'] ?? '').toString().toLowerCase();
        final category = (data['category'] ?? '').toString().toLowerCase();
        return name.contains(searchLower) || category.contains(searchLower);
      })
      .map((doc) => {'id': doc.id, ...doc.data()})
      .toList();
}
```

##### Category Read Operations
```dart
// Get all categories
Future<List<Map<String, dynamic>>> getAllCategories() async {
  final querySnapshot = await _firestore
      .collection('categories')
      .orderBy('sortOrder')
      .get();
  return querySnapshot.docs
      .map((doc) => {'id': doc.id, ...doc.data()})
      .toList();
}

// Stream active categories
Stream<QuerySnapshot<Map<String, dynamic>>> streamActiveCategories() {
  return _firestore
      .collection('categories')
      .where('isActive', isEqualTo: true)
      .orderBy('sortOrder')
      .snapshots();
}
```

##### Product Reviews
```dart
// Get reviews for a product
Future<List<Map<String, dynamic>>> getProductReviews(String productId) async {
  final querySnapshot = await _firestore
      .collection('products')
      .doc(productId)
      .collection('reviews')
      .orderBy('createdAt', descending: true)
      .get();
  return querySnapshot.docs
      .map((doc) => {'id': doc.id, ...doc.data()})
      .toList();
}

// Stream product reviews (real-time)
Stream<QuerySnapshot<Map<String, dynamic>>> streamProductReviews(String productId) {
  return _firestore
      .collection('products')
      .doc(productId)
      .collection('reviews')
      .orderBy('createdAt', descending: true)
      .snapshots();
}
```

#### 3. **StreamBuilder Implementation** (`lib/screens/products_screen.dart`)

The products screen now uses `StreamBuilder` to display live data:

```dart
class _ProductsScreenState extends State<ProductsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search bar
          _buildSearchBar(),
          
          // Products grid with StreamBuilder
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _firestoreService.streamAvailableProducts(),
              builder: (context, snapshot) {
                // Loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Error state
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                // No data state
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () => _showSeedDataDialog(context),
                      child: const Text('Seed Sample Data'),
                    ),
                  );
                }

                // Convert Firestore documents to Product objects
                List<Product> allProducts = snapshot.data!.docs
                    .map((doc) => Product.fromFirestore(doc.data()))
                    .toList();

                // Apply search filter
                List<Product> filteredProducts = _searchQuery.isEmpty
                    ? allProducts
                    : allProducts
                        .where((p) =>
                            p.name.toLowerCase().contains(_searchQuery) ||
                            p.category.toLowerCase().contains(_searchQuery))
                        .toList();

                // Display products grid
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return ProductCard(
                      product: product,
                      onAddToCart: () => widget.cartService.addToCart(product),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

#### 4. **Seed Data Helper** (`lib/services/seed_data.dart`)

Helper functions to populate Firestore with sample data:

```dart
/// Convert Product objects to Firestore-compatible maps
List<Map<String, dynamic>> productsToFirestoreData(List<Product> products) {
  return products.map((product) {
    return {
      'id': product.id,
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'unit': product.unit,
      'category': product.category,
      'imageIcon': product.imageIcon,
      'isAvailable': true,
      'stock': 100,
      'farmerId': 'seed_farmer_001',
      'rating': 4.5,
      'reviewCount': 0,
    };
  }).toList();
}

/// Seed Firestore with sample data
Future<void> seedFirestoreData() async {
  final firestoreService = FirestoreService();

  // Seed categories first
  final categories = getSampleCategories();
  await firestoreService.seedCategories(categories);

  // Seed products (55 items)
  final products = productsToFirestoreData(sampleProducts);
  await firestoreService.seedProducts(products);
}
```

### Usage Workflow

1. **First Launch**: When the app loads with empty database
   - StreamBuilder shows "No products available" message
   - User clicks "Seed Sample Data" button
   - System populates Firestore with 55 products and 4 categories
   - StreamBuilder automatically detects new data and displays products

2. **Subsequent Launches**: 
   - StreamBuilder listens to `streamAvailableProducts()`
   - Products load instantly from Firestore
   - Any changes (new products, price updates) reflect immediately
   - Search filter applies client-side on live data

3. **Real-time Updates**:
   - If admin adds product → appears in all user screens instantly
   - If farmer updates stock → reflected without page refresh
   - If product becomes unavailable → automatically hidden from view

### StreamBuilder vs FutureBuilder

#### Why StreamBuilder?
```dart
// StreamBuilder - Real-time updates
StreamBuilder<QuerySnapshot>(
  stream: _firestoreService.streamAvailableProducts(),
  builder: (context, snapshot) {
    // Rebuilds automatically when data changes
  },
)
```

#### When to use FutureBuilder?
```dart
// FutureBuilder - One-time fetch
FutureBuilder<List<Product>>(
  future: _firestoreService.getAllProducts(),
  builder: (context, snapshot) {
    // Fetches once, no auto-updates
  },
)
```

### Performance Considerations

1. **Query Optimization**
   - Use `.where('isAvailable', isEqualTo: true)` to filter server-side
   - Order by name for consistent display: `.orderBy('name')`
   - Limit results for pagination: `.limit(20)`

2. **Offline Support**
   - Firestore caches data automatically
   - App works offline with cached products
   - Changes sync when connection restored

3. **Real-time Listener Management**
   - StreamBuilder auto-manages subscription lifecycle
   - Listener attached when widget builds
   - Auto-detached when widget disposes

### Firestore Security Rules

Ensure your Firestore rules allow read access:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Products readable by all, writable by farmers only
    match /products/{productId} {
      allow read: if true;
      allow create, update, delete: if request.auth != null 
        && exists(/databases/$(database)/documents/farmers/$(request.auth.uid));
    }
    
    // Categories readable by all
    match /categories/{categoryId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

### Testing Checklist

- [x] Products load from Firestore on app launch
- [x] Empty state displays seed data button
- [x] Seed data populates 55 products successfully
- [x] Products display in grid layout
- [x] Search filters products by name and category
- [x] Home button clears search and shows all products
- [x] Real-time updates reflect immediately
- [x] Loading indicator shows during initial fetch
- [x] Error handling displays retry button
- [x] Cart functionality works with Firestore products

### Key Benefits Achieved

1. **✅ Real-time Data**: Products update across all devices instantly
2. **✅ Scalability**: Database handles thousands of products efficiently
3. **✅ Offline Support**: App works without internet using cache
4. **✅ Search Performance**: Client-side filtering on live stream
5. **✅ Developer Experience**: Clean service layer with clear separation
6. **✅ Type Safety**: Product.fromFirestore() ensures data integrity

### Next Steps

- Add pagination for large product catalogs (`.limit()` and `.startAfter()`)
- Implement category filtering with server-side queries
- Add product detail screen with reviews subcollection
- Create farmer dashboard for product management
- Add analytics tracking for product views
- Implement favoriting with user-specific streams

---

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

---

## ✍️ Firestore Write & Update Operations (Sprint 4)

### Overview
Farm2Home now implements comprehensive Firestore write operations to allow farmers to **create, update, and manage** their product listings. This implementation follows secure, structured practices with proper validation and error handling.

### Why Write Operations Matter

**Data Integrity**: Validation prevents corrupt or incomplete data from entering the database  
**Security**: User authentication ensures only authorized farmers can modify products  
**Scalability**: Batch operations handle multiple updates efficiently  
**Real-time Sync**: Changes appear instantly across all connected devices  
**Audit Trail**: Timestamps track when products are created and modified

---

### Understanding Firestore Write Operations

Firestore supports four main types of write operations:

#### 1. **Add** - Create with Auto-Generated ID
Creates a new document with a Firestore-generated unique ID.

```dart
Future<String> addProduct(Map<String, dynamic> productData) async {
  final docRef = await FirebaseFirestore.instance
      .collection('products')
      .add({
        ...productData,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
  
  return docRef.id; // Returns: "xK3mP9rQ2nL8jH5fD1wS"
}
```

**When to use:**
- Creating new products, orders, reviews
- When you don't need to control the document ID
- Most common for user-generated content

#### 2. **Set** - Write with Specific ID
Writes to a specific document ID, **overwriting** all existing data.

```dart
Future<void> setProduct(String productId, Map<String, dynamic> productData) async {
  await FirebaseFirestore.instance
      .collection('products')
      .doc(productId)
      .set({
        ...productData,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
}
```

**When to use:**
- Creating documents with specific IDs (e.g., user profiles with UID)
- Completely replacing document data
- Initializing known documents

**⚠️ Warning:** Overwrites all fields! Use with caution.

#### 3. **Set with Merge** - Partial Update Without Overwriting
Writes specific fields without removing existing data.

```dart
Future<void> setProductMerge(String productId, Map<String, dynamic> updates) async {
  await FirebaseFirestore.instance
      .collection('products')
      .doc(productId)
      .set({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // merge: true preserves existing fields
}
```

**When to use:**
- Updating only specific fields
- Safer than regular `set()`
- Creating or updating in one operation

#### 4. **Update** - Modify Specific Fields
Updates only the specified fields, **fails if document doesn't exist**.

```dart
Future<void> updateProduct(String productId, Map<String, dynamic> updates) async {
  await FirebaseFirestore.instance
      .collection('products')
      .doc(productId)
      .update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });
}
```

**When to use:**
- Modifying existing products
- Changing price, stock, availability
- Most common for edit operations

**⚠️ Error:** Throws exception if document doesn't exist!

---

### Comparison: Add vs Set vs Update

| Operation | Creates New? | Overwrites? | Needs ID? | Fails if Missing? |
|-----------|-------------|-------------|-----------|-------------------|
| **add()** | ✅ Yes | N/A | ❌ Auto | N/A |
| **set()** | ✅ Yes | ✅ Yes | ✅ Yes | ❌ No |
| **set(merge: true)** | ✅ Yes | ❌ No | ✅ Yes | ❌ No |
| **update()** | ❌ No | ❌ No | ✅ Yes | ✅ Yes |

---

### Implementation in Farm2Home

#### 1. **FirestoreService Write Methods** (`lib/services/firestore_service.dart`)

We've added **20+ write operations** to the service:

##### Product Write Operations

```dart
// Add new product (auto ID)
Future<String> addProduct(Map<String, dynamic> productData) async {
  // Validates: name, price, category required
  final docRef = await _firestore.collection('products').add({
    ...productData,
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  });
  return docRef.id;
}

// Set product with specific ID
Future<void> setProduct(String productId, Map<String, dynamic> productData) async {
  // Overwrites entire document
  await _firestore.collection('products').doc(productId).set({
    ...productData,
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  });
}

// Set with merge (partial update)
Future<void> setProductMerge(String productId, Map<String, dynamic> updates) async {
  // Updates only specified fields
  await _firestore.collection('products').doc(productId).set({
    ...updates,
    'updatedAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}

// Update specific fields
Future<void> updateProduct(String productId, Map<String, dynamic> updates) async {
  // Check if document exists
  final doc = await _firestore.collection('products').doc(productId).get();
  if (!doc.exists) throw 'Product not found';
  
  await _firestore.collection('products').doc(productId).update({
    ...updates,
    'updatedAt': FieldValue.serverTimestamp(),
  });
}

// Update specific operations
Future<void> updateProductStock(String productId, int newStock) async { ... }
Future<void> updateProductPrice(String productId, double newPrice) async { ... }
Future<void> updateProductAvailability(String productId, bool isAvailable) async { ... }

// Delete product
Future<void> deleteProduct(String productId) async {
  await _firestore.collection('products').doc(productId).delete();
}

// Batch update multiple products
Future<void> batchUpdateProducts(Map<String, Map<String, dynamic>> updates) async {
  final batch = _firestore.batch();
  updates.forEach((productId, updateData) {
    final docRef = _firestore.collection('products').doc(productId);
    batch.update(docRef, {
      ...updateData,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  });
  await batch.commit();
}
```

#### 2. **Product Management UI** (`lib/screens/product_management_screen.dart`)

Form with comprehensive validation:

```dart
class ProductManagementScreen extends StatefulWidget {
  final Product? productToEdit; // null = add mode, non-null = edit mode
  
  const ProductManagementScreen({super.key, this.productToEdit});
}

// Form Controllers
final TextEditingController _nameController = TextEditingController();
final TextEditingController _descriptionController = TextEditingController();
final TextEditingController _priceController = TextEditingController();
final TextEditingController _unitController = TextEditingController();
final TextEditingController _stockController = TextEditingController();

// Validation Example
TextFormField(
  controller: _nameController,
  decoration: const InputDecoration(
    labelText: 'Product Name *',
    hintText: 'e.g., Fresh Organic Tomatoes',
  ),
  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Product name is required';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  },
)

// Save Operation
Future<void> _saveProduct() async {
  if (!_formKey.currentState!.validate()) return;
  
  final productData = {
    'name': _nameController.text.trim(),
    'description': _descriptionController.text.trim(),
    'price': double.parse(_priceController.text.trim()),
    'unit': _unitController.text.trim(),
    'category': _selectedCategory,
    'imageIcon': _imageIconController.text.trim(),
    'isAvailable': _isAvailable,
    'stock': int.parse(_stockController.text.trim()),
    'farmerId': user.uid,
  };
  
  if (widget.productToEdit != null) {
    // Update existing product
    await _firestoreService.updateProduct(
      widget.productToEdit!.id, 
      productData
    );
  } else {
    // Add new product
    final productId = await _firestoreService.addProduct(productData);
  }
}
```

#### 3. **Farmer Dashboard** (`lib/screens/farmer_dashboard_screen.dart`)

Displays farmer's products with edit/delete capabilities:

```dart
StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('products')
      .where('farmerId', isEqualTo: user.uid)
      .snapshots(),
  builder: (context, snapshot) {
    final products = snapshot.data!.docs
        .map((doc) => Product.fromFirestore(doc.data()))
        .toList();
    
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          child: Row(
            children: [
              // Product info
              Text(product.name),
              Text('\$${product.price}'),
              
              // Action buttons
              TextButton.icon(
                onPressed: () => _navigateToEditProduct(product),
                icon: Icon(Icons.edit),
                label: Text('Edit'),
              ),
              TextButton.icon(
                onPressed: () => _toggleAvailability(product.id, product.isAvailable),
                icon: Icon(Icons.visibility),
                label: Text('Hide/Show'),
              ),
              TextButton.icon(
                onPressed: () => _deleteProduct(product.id),
                icon: Icon(Icons.delete),
                label: Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  },
)
```

---

### Data Validation

All write operations include validation to prevent data corruption:

#### 1. **Client-Side Validation** (Flutter Form)

```dart
// Name validation
validator: (value) {
  if (value == null || value.trim().isEmpty) {
    return 'Product name is required';
  }
  if (value.trim().length < 3) {
    return 'Name must be at least 3 characters';
  }
  return null;
}

// Price validation
validator: (value) {
  if (value == null || value.trim().isEmpty) {
    return 'Price is required';
  }
  final price = double.tryParse(value.trim());
  if (price == null || price <= 0) {
    return 'Invalid price';
  }
  return null;
}

// Stock validation
validator: (value) {
  if (value == null || value.trim().isEmpty) {
    return 'Stock is required';
  }
  final stock = int.tryParse(value.trim());
  if (stock == null || stock < 0) {
    return 'Invalid stock quantity';
  }
  return null;
}
```

#### 2. **Server-Side Validation** (FirestoreService)

```dart
Future<String> addProduct(Map<String, dynamic> productData) async {
  // Validate required fields
  if (productData['name'] == null || productData['name'].toString().trim().isEmpty) {
    throw 'Product name is required';
  }
  if (productData['price'] == null || productData['price'] <= 0) {
    throw 'Valid product price is required';
  }
  if (productData['category'] == null || productData['category'].toString().trim().isEmpty) {
    throw 'Product category is required';
  }
  
  // Proceed with write operation
  final docRef = await _firestore.collection('products').add(productData);
  return docRef.id;
}
```

#### 3. **Firestore Security Rules** (Backend)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /products/{productId} {
      // Anyone can read products
      allow read: if true;
      
      // Only authenticated farmers can create
      allow create: if request.auth != null
        && request.resource.data.name is string
        && request.resource.data.price is number
        && request.resource.data.price > 0
        && request.resource.data.category is string;
      
      // Only product owner can update/delete
      allow update, delete: if request.auth != null
        && resource.data.farmerId == request.auth.uid;
    }
  }
}
```

---

### Error Handling

All operations include try-catch blocks with user-friendly messages:

```dart
Future<void> _saveProduct() async {
  try {
    setState(() {
      _isLoading = true;
    });
    
    await _firestoreService.addProduct(productData);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Product added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
```

---

### Timestamps for Tracking

All write operations automatically add timestamps:

```dart
await _firestore.collection('products').add({
  ...productData,
  'createdAt': FieldValue.serverTimestamp(), // Set once on creation
  'updatedAt': FieldValue.serverTimestamp(), // Updated on every change
});

// On updates:
await _firestore.collection('products').doc(productId).update({
  ...updates,
  'updatedAt': FieldValue.serverTimestamp(), // New timestamp on each edit
});
```

**Benefits:**
- Track when products are created
- See last modification time
- Sort by newest/oldest
- Audit trail for changes

---

### Complete Write Operations Available

#### Products (10 operations)
```dart
addProduct(productData)              // Create with auto ID
setProduct(id, productData)          // Write with specific ID
setProductMerge(id, updates)         // Partial update without overwriting
updateProduct(id, updates)           // Update specific fields
updateProductStock(id, stock)        // Update stock only
updateProductPrice(id, price)        // Update price only
updateProductAvailability(id, bool)  // Toggle availability
deleteProduct(id)                    // Remove product
batchUpdateProducts(updates)         // Update multiple products at once
seedProducts(products)               // Batch insert for seeding
```

#### Categories (3 operations)
```dart
addCategory(categoryData)            // Create new category
updateCategory(id, updates)          // Modify category
deleteCategory(id)                   // Remove category
```

#### Reviews (3 operations)
```dart
addProductReview(productId, reviewData)       // Create review
updateProductReview(productId, reviewId, updates)  // Modify review
deleteProductReview(productId, reviewId)      // Remove review
```

#### Orders (1 operation)
```dart
updateOrderStatus(orderId, newStatus)  // Change order status + history
```

---

### Usage Workflow

#### For Farmers (Add Product)

1. **Navigate to Dashboard** → Click "Add Product" button
2. **Fill Form**:
   - Product Name: "Fresh Organic Tomatoes" ✅
   - Description: "Vine-ripened tomatoes from our farm" ✅
   - Price: 3.99 ✅
   - Unit: "per lb" ✅
   - Category: "Vegetables" ✅
   - Stock: 50 ✅
   - Icon: 🍅 ✅
   - Available: ON ✅
3. **Click "Add Product"** → Validation runs
4. **Success** → Product appears in dashboard immediately
5. **Firestore Console** → Verify document created with timestamps

#### For Farmers (Edit Product)

1. **Dashboard** → Find product → Click "Edit"
2. **Modify Fields** → Change price from $3.99 to $4.49
3. **Click "Update Product"** → `updateProduct()` called
4. **Success** → Changes appear across all devices instantly
5. **Check `updatedAt`** → Timestamp updated

#### For Farmers (Delete Product)

1. **Dashboard** → Find product → Click "Delete"
2. **Confirmation Dialog** → "Are you sure?"
3. **Confirm** → `deleteProduct()` called
4. **Success** → Product removed from all screens
5. **Firestore** → Document deleted

---

### Testing Checklist

Verify these scenarios:

**Add Operations:**
- [ ] Adding valid product succeeds
- [ ] Empty name shows validation error
- [ ] Invalid price (0 or negative) shows error
- [ ] Empty description shows error
- [ ] Product appears in Firestore console
- [ ] `createdAt` and `updatedAt` timestamps present
- [ ] Success message displays

**Update Operations:**
- [ ] Editing product updates fields correctly
- [ ] Updating price changes value in real-time
- [ ] Toggling availability hides/shows product
- [ ] `updatedAt` timestamp changes
- [ ] Changes appear in Firestore console
- [ ] Success message displays

**Delete Operations:**
- [ ] Delete confirmation dialog appears
- [ ] Confirming deletes product
- [ ] Canceling keeps product
- [ ] Product removed from Firestore
- [ ] Success message displays

**Error Handling:**
- [ ] Network error shows error message
- [ ] Invalid data blocked by validation
- [ ] Loading indicator appears during operations
- [ ] Error messages are user-friendly

---

### Screenshots & Verification

#### 1. Add Product Form
![Add Product Screen](screenshots/add-product-form.png)
- All input fields with validation
- Category dropdown
- Availability toggle
- Submit button with loading state

#### 2. Firestore Console - Before Add
![Firestore Before](screenshots/firestore-before-add.png)
- Empty or existing products collection

#### 3. Firestore Console - After Add
![Firestore After Add](screenshots/firestore-after-add.png)
- New document with auto-generated ID
- All fields populated
- `createdAt` and `updatedAt` timestamps

#### 4. Farmer Dashboard
![Farmer Dashboard](screenshots/farmer-dashboard.png)
- List of farmer's products
- Edit, Hide/Show, Delete buttons
- Real-time updates from Firestore

#### 5. Edit Product
![Edit Product](screenshots/edit-product.png)
- Pre-filled form with existing data
- Update button instead of Add

#### 6. Firestore Console - After Update
![Firestore After Update](screenshots/firestore-after-update.png)
- Updated fields visible
- `updatedAt` timestamp changed

---

### Reflection: Why Secure Writes Matter

#### 1. **Data Integrity**
Without validation, users could submit:
- Products with no name ❌
- Negative prices ❌
- Empty descriptions ❌

**Solution:** Client + server validation ensures only valid data enters the database.

#### 2. **Security Concerns**
Without authentication checks:
- Anyone could delete any product ❌
- Users could modify others' listings ❌
- Malicious data could be inserted ❌

**Solution:** Firestore Security Rules restrict write access to authenticated users and product owners only.

#### 3. **User Experience**
Without proper error handling:
- Silent failures confuse users ❌
- No feedback on success/failure ❌
- Loading states missing ❌

**Solution:** Try-catch blocks with SnackBar messages provide clear feedback and loading indicators.

#### 4. **Data Consistency**
Without timestamps:
- No audit trail ❌
- Can't sort by newest ❌
- No modification history ❌

**Solution:** `FieldValue.serverTimestamp()` automatically tracks when documents are created and updated.

#### 5. **Difference: Add vs Set vs Update**

**add()**: Best for user-generated content
- Auto-generates unique ID
- Never overwrites existing data
- Used: products, orders, reviews

**set()**: Best for known documents
- Requires explicit ID
- Overwrites ALL fields (dangerous!)
- Used: user profiles with UID

**set(merge: true)**: Safest option
- Updates only specified fields
- Creates if missing
- Used: partial updates, preferences

**update()**: Best for modifications
- Only changes specified fields
- Fails if document missing (safe)
- Used: edit operations, status changes

---

### Best Practices Implemented

✅ **Validate Before Writing** - All inputs validated client + server  
✅ **Use Correct Data Types** - Numbers as numbers, not strings  
✅ **Add Timestamps** - `createdAt` and `updatedAt` on all documents  
✅ **Never Overwrite Accidentally** - Use `update()` instead of `set()`  
✅ **Authenticate Users** - Check `user != null` before writes  
✅ **Handle Errors Gracefully** - Try-catch with user feedback  
✅ **Use Loading States** - Show spinner during operations  
✅ **Confirm Destructive Actions** - Dialog before delete  
✅ **Provide Feedback** - Success/error messages via SnackBar  
✅ **Structure Data Consistently** - Follow schema design

---

### Next Steps

- **Image Upload**: Add Firebase Storage for product photos
- **Batch Operations**: Update multiple products at once
- **Versioning**: Track product history with subcollections
- **Offline Support**: Queue writes when offline
- **Analytics**: Track which products are edited most
- **Duplicate Detection**: Prevent adding identical products

---

## �️ Google Maps Integration

### Overview
Farm2Home includes interactive maps for finding local farms, viewing farm locations, and tracking deliveries. The integration uses Google Maps SDK for Flutter with custom markers and user location tracking.

### Features

#### Basic Map Screen
- **Interactive Map Display**: Pan, zoom, rotate gestures
- **Custom Markers**: Display farm locations with custom icons
- **Map Type Controls**: Switch between normal, satellite, terrain views
- **User Location**: Show current device location on map
- **Camera Controls**: Programmatically move and animate camera

#### Location Tracking Screen
- **Real-time GPS Tracking**: Live position updates as you move
- **Path Visualization**: Draw line showing your movement trail
- **Distance Calculations**: Track distance traveled
- **Location Permissions**: Handle runtime permissions gracefully
- **Custom Markers**: Different colors for start, current, and waypoints
- **Stop/Start Tracking**: Control tracking with button

### Setup

#### 1. Dependencies
```yaml
dependencies:
  google_maps_flutter: ^2.5.0
  location: ^5.0.0
  geolocator: ^10.1.0
```

#### 2. Android Configuration
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest>
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
  <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
  
  <application>
    <meta-data
      android:name="com.google.android.geo.API_KEY"
      android:value="YOUR_API_KEY_HERE" />
  </application>
</manifest>
```

#### 3. iOS Configuration
```xml
<!-- ios/Runner/Info.plist -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to your location to show nearby farms</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to your location for delivery tracking</string>
```

### Code Examples

#### Basic Map Implementation
```dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  final LatLng _initialPosition = const LatLng(37.7749, -122.4194);
  
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _initialPosition,
        zoom: 12,
      ),
      onMapCreated: (controller) => _controller = controller,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }
}
```

#### Location Tracking
```dart
import 'package:geolocator/geolocator.dart';

Future<void> _startLiveTracking() async {
  // Check permissions
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  
  // Start tracking
  Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    ),
  ).listen((Position position) {
    // Update marker position
    _updateMarker(LatLng(position.latitude, position.longitude));
  });
}
```

### File Locations
- [lib/screens/map_screen.dart](lib/screens/map_screen.dart) - Basic map screen
- [lib/screens/location_tracking_screen.dart](lib/screens/location_tracking_screen.dart) - Advanced tracking
- [GOOGLE_MAPS_QUICK_REFERENCE.md](GOOGLE_MAPS_QUICK_REFERENCE.md) - Quick reference guide

### API Key Setup
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Enable **Maps SDK for Android** and **Maps SDK for iOS**
3. Create an API key for your project
4. Add restrictions (Android package name, iOS bundle ID)
5. Add keys to `AndroidManifest.xml` and `Info.plist`

---

## 🔄 CRUD Operations (Create, Read, Update, Delete)

### Overview
Farm2Home implements a complete CRUD system for managing user-specific data (notes, tasks, preferences). All operations are secured with Firebase Authentication and use Firestore's real-time capabilities for instant UI updates.

### Features

- ✅ **Create**: Add new items with validation
- ✅ **Read**: Real-time list with StreamBuilder
- ✅ **Update**: Edit existing items
- ✅ **Delete**: Remove items with confirmation
- ✅ **User-Specific Data**: Each user sees only their own items
- ✅ **Firestore Security Rules**: Server-side access control
- ✅ **Error Handling**: User-friendly error messages
- ✅ **Loading States**: Visual feedback during operations
- ✅ **Form Validation**: Prevent empty or invalid data

### Architecture

#### Data Model (`lib/models/note_item.dart`)
```dart
class NoteItem {
  final String? id;
  final String title;
  final String description;
  final String userId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  NoteItem({
    this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.createdAt,
    this.updatedAt,
  });

  factory NoteItem.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return NoteItem(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      userId: data['userId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null 
        ? (data['updatedAt'] as Timestamp).toDate() 
        : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt) : null,
    };
  }
}
```

#### CRUD Service (`lib/services/crud_service.dart`)
```dart
class CrudService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  // CREATE
  Future<String> createItem({
    required String title,
    required String description,
  }) async {
    final user = _authService.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final item = NoteItem(
      title: title,
      description: description,
      userId: user.uid,
      createdAt: DateTime.now(),
    );

    final docRef = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('items')
        .add(item.toMap());

    return docRef.id;
  }

  // READ (Real-time Stream)
  Stream<List<NoteItem>> getUserItemsStream() {
    final user = _authService.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('items')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NoteItem.fromFirestore(doc))
            .toList());
  }

  // UPDATE
  Future<void> updateItem({
    required String itemId,
    required String title,
    required String description,
  }) async {
    final user = _authService.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('items')
        .doc(itemId)
        .update({
      'title': title,
      'description': description,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // DELETE
  Future<void> deleteItem(String itemId) async {
    final user = _authService.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('items')
        .doc(itemId)
        .delete();
  }
}
```

### UI Implementation (`lib/screens/crud_demo_screen.dart`)

The CRUD demo screen provides a complete user interface with:

1. **Real-time List**: StreamBuilder automatically updates when data changes
2. **Create Dialog**: Form with validation for new items
3. **Edit Dialog**: Pre-filled form for updating items
4. **Delete Confirmation**: Prevents accidental deletions
5. **Empty State**: User-friendly message when no items exist
6. **Loading Indicators**: Visual feedback during operations
7. **Error Messages**: SnackBar notifications for success/failure

#### Key Features:
```dart
// Real-time List
StreamBuilder<List<NoteItem>>(
  stream: _crudService.getUserItemsStream(),
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }
    
    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }
    
    final items = snapshot.data!;
    
    if (items.isEmpty) {
      return Center(
        child: Text('No items yet. Tap + to create one!'),
      );
    }
    
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(item.title),
          subtitle: Text(item.description),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showEditDialog(item),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _showDeleteDialog(item),
              ),
            ],
          ),
        );
      },
    );
  },
)
```

### Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // User-specific items collection
    match /users/{userId}/items/{itemId} {
      // Only authenticated users can access
      allow read: if request.auth != null && request.auth.uid == userId;
      allow create: if request.auth != null && request.auth.uid == userId;
      allow update: if request.auth != null && request.auth.uid == userId;
      allow delete: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### Data Structure

```
Firestore Database
└── users/
    └── {userId}/               # User's unique ID
        └── items/              # Subcollection of user's items
            └── {itemId}/       # Auto-generated document ID
                ├── title: string
                ├── description: string
                ├── userId: string
                ├── createdAt: Timestamp
                └── updatedAt: Timestamp?
```

### Usage Example

```dart
// Navigate to CRUD Demo Screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const CrudDemoScreen(),
  ),
);
```

### Best Practices Implemented

✅ **Real-time Updates**: StreamBuilder provides instant UI refresh  
✅ **User Authentication**: All operations require logged-in user  
✅ **Security Rules**: Server-side access control prevents unauthorized access  
✅ **Error Handling**: Try-catch blocks with user feedback  
✅ **Form Validation**: Prevent empty or invalid data submission  
✅ **Loading States**: CircularProgressIndicator during operations  
✅ **Confirmation Dialogs**: Prevent accidental destructive actions  
✅ **Timestamps**: Automatic tracking of creation and modification times  
✅ **Subcollections**: Organized user-specific data structure  
✅ **Immutable Models**: copyWith() method for safe updates

### File Locations
- [lib/models/note_item.dart](lib/models/note_item.dart) - Data model
- [lib/services/crud_service.dart](lib/services/crud_service.dart) - CRUD operations
- [lib/screens/crud_demo_screen.dart](lib/screens/crud_demo_screen.dart) - UI implementation
- [firestore_rules_with_crud.rules](firestore_rules_with_crud.rules) - Security rules
- [CRUD_IMPLEMENTATION_GUIDE.md](CRUD_IMPLEMENTATION_GUIDE.md) - Complete documentation
- [CRUD_QUICK_REFERENCE.md](CRUD_QUICK_REFERENCE.md) - Quick reference guide

### Testing Checklist

- [ ] User can create new items
- [ ] Items appear in list immediately after creation
- [ ] User can edit existing items
- [ ] Changes reflect in UI instantly
- [ ] User can delete items with confirmation
- [ ] Only authenticated users can access CRUD features
- [ ] Each user sees only their own items (test with 2 accounts)
- [ ] Form validation prevents empty submissions
- [ ] Error messages display for failures
- [ ] Loading indicators show during operations

---

## 🔄 State Management with Provider

### Overview

Farm2Home uses **Provider** as its state management solution. Provider is a wrapper around Flutter's `InheritedWidget` that makes it easier to manage and share app state across the widget tree.

**Why Provider?**
- ✅ **Simplicity**: Easy to learn and implement
- ✅ **Performance**: Rebuilds only widgets that need updates
- ✅ **Scalability**: Works well for small to medium apps
- ✅ **Official**: Recommended by the Flutter team
- ✅ **Type-safe**: Compile-time safety with strong typing

### Architecture

The Provider pattern follows a unidirectional data flow:

```
┌─────────────────────────────────────────────────┐
│                  Provider Tree                   │
│  (Root of app - wraps MaterialApp)              │
└──────────────────┬──────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────┐
│              State Classes                       │
│  - AuthProvider (User authentication)           │
│  - ProductProvider (Product data)               │
│  - CartProvider (Shopping cart)                 │
└──────────────────┬──────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────┐
│               UI Widgets                         │
│  - Consume state with Consumer/context.watch    │
│  - Update state by calling provider methods     │
└─────────────────────────────────────────────────┘
```

### Setup Instructions

#### 1. Add Provider Dependency

In `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
```

Run:
```bash
flutter pub get
```

#### 2. Create a Provider Class

Example: `lib/providers/product_provider.dart`

```dart
import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/firestore_service.dart';

class ProductProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;
  
  // Getters
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Fetch products from Firestore
  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners(); // Notify UI to show loading
    
    try {
      _products = await _firestoreService.getProducts();
      _isLoading = false;
      notifyListeners(); // Notify UI with data
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners(); // Notify UI with error
    }
  }
  
  // Add a new product
  Future<void> addProduct(Product product) async {
    try {
      await _firestoreService.addProduct(product);
      _products.add(product);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }
  
  // Update a product
  Future<void> updateProduct(Product product) async {
    try {
      await _firestoreService.updateProduct(product);
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }
  
  // Delete a product
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestoreService.deleteProduct(productId);
      _products.removeWhere((p) => p.id == productId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}
```

#### 3. Wrap Your App with Provider

In `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm2Home',
      home: const HomeScreen(),
    );
  }
}
```

### Reading State in Widgets

There are three main ways to read state from Provider:

#### 1. Consumer Widget (Rebuilds only the Consumer)

```dart
class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.isLoading) {
          return const CircularProgressIndicator();
        }
        
        if (productProvider.error != null) {
          return Text('Error: ${productProvider.error}');
        }
        
        return ListView.builder(
          itemCount: productProvider.products.length,
          itemBuilder: (context, index) {
            final product = productProvider.products[index];
            return ListTile(
              title: Text(product.name),
              subtitle: Text('\$${product.price}'),
            );
          },
        );
      },
    );
  }
}
```

#### 2. context.watch (Rebuilds entire widget)

```dart
class ProductCount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This widget rebuilds when products change
    final productCount = context.watch<ProductProvider>().products.length;
    
    return Text('Total Products: $productCount');
  }
}
```

#### 3. context.read (No rebuild, for calling methods)

```dart
class AddProductButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Use context.read to access provider without listening
        final provider = context.read<ProductProvider>();
        provider.addProduct(Product(
          id: DateTime.now().toString(),
          name: 'New Product',
          price: 9.99,
        ));
      },
      child: const Text('Add Product'),
    );
  }
}
```

### Updating State

#### Example: Add Product Form

```dart
class AddProductScreen extends StatefulWidget {
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final product = Product(
                      id: DateTime.now().toString(),
                      name: _nameController.text,
                      price: double.parse(_priceController.text),
                    );
                    
                    try {
                      await context.read<ProductProvider>().addProduct(product);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Product added!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                child: const Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
```

### Multi-Screen Shared State Example

#### Scenario: Shopping Cart across multiple screens

**1. Cart Provider** (`lib/providers/cart_provider.dart`):

```dart
class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};
  
  Map<String, CartItem> get items => {..._items};
  
  int get itemCount => _items.length;
  
  double get totalAmount {
    return _items.values
        .fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }
  
  void addItem(String productId, String name, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existing) => CartItem(
          id: existing.id,
          name: existing.name,
          price: existing.price,
          quantity: existing.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          name: name,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }
  
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }
  
  void clear() {
    _items.clear();
    notifyListeners();
  }
}
```

**2. Product List Screen** (adds to cart):

```dart
class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) => Badge(
              label: Text('${cart.itemCount}'),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CartScreen()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return ListView.builder(
            itemCount: productProvider.products.length,
            itemBuilder: (context, index) {
              final product = productProvider.products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('\$${product.price}'),
                trailing: IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    context.read<CartProvider>().addItem(
                      product.id,
                      product.name,
                      product.price,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.name} added to cart')),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
```

**3. Cart Screen** (displays cart items):

```dart
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart')),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.itemCount == 0) {
            return const Center(child: Text('Your cart is empty'));
          }
          
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items.values.toList()[index];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text('${item.quantity} x \$${item.price}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          cart.removeItem(cart.items.keys.toList()[index]);
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Total: \$${cart.totalAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Checkout logic
                        cart.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Order placed!')),
                        );
                      },
                      child: const Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

### Best Practices

#### 1. Keep Providers Focused

Each provider should manage a single concern:

```dart
✅ Good: Separate providers
- AuthProvider (authentication)
- ProductProvider (product data)
- CartProvider (shopping cart)

❌ Bad: One giant provider
- AppProvider (everything mixed together)
```

#### 2. Use Private Fields with Public Getters

```dart
class ProductProvider with ChangeNotifier {
  List<Product> _products = []; // Private
  
  List<Product> get products => _products; // Public getter
}
```

#### 3. Always Call notifyListeners()

Call after state changes to update UI:

```dart
void addProduct(Product product) {
  _products.add(product);
  notifyListeners(); // Don't forget this!
}
```

#### 4. Handle Async Operations Properly

```dart
Future<void> fetchProducts() async {
  _isLoading = true;
  notifyListeners(); // Show loading indicator
  
  try {
    _products = await _service.getProducts();
  } catch (e) {
    _error = e.toString();
  } finally {
    _isLoading = false;
    notifyListeners(); // Hide loading indicator
  }
}
```

#### 5. Use context.read for Actions, context.watch for Data

```dart
// Reading data (widget rebuilds on changes)
final products = context.watch<ProductProvider>().products;

// Calling methods (no rebuild)
context.read<ProductProvider>().addProduct(product);
```

#### 6. Dispose Resources

```dart
class ProductProvider with ChangeNotifier {
  StreamSubscription? _subscription;
  
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
```

### Common Issues and Solutions

#### Issue 1: "Could not find the correct Provider"

**Error:**
```
Error: Could not find the correct Provider<ProductProvider> above this Widget
```

**Solution:** Make sure the widget is inside the Provider tree:

```dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: const MyApp(), // This and all children can access ProductProvider
    ),
  );
}
```

#### Issue 2: Widget Not Rebuilding

**Problem:** State changes but UI doesn't update.

**Solutions:**

1. Use `Consumer` or `context.watch`:
```dart
// ✅ This rebuilds
Consumer<ProductProvider>(
  builder: (context, provider, child) => Text('${provider.products.length}'),
)

// ❌ This doesn't rebuild
final provider = context.read<ProductProvider>();
Text('${provider.products.length}')
```

2. Make sure to call `notifyListeners()`:
```dart
void addProduct(Product product) {
  _products.add(product);
  notifyListeners(); // Essential!
}
```

#### Issue 3: setState Called During Build

**Error:**
```
setState() or markNeedsBuild() called during build
```

**Solution:** Use `WidgetsBinding.instance.addPostFrameCallback`:

```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<ProductProvider>().fetchProducts();
  });
}
```

Or use FutureProvider for initial data loading.

#### Issue 4: Memory Leaks

**Problem:** Provider not disposed properly.

**Solution:** Override dispose method:

```dart
class ProductProvider with ChangeNotifier {
  @override
  void dispose() {
    // Clean up resources
    super.dispose();
  }
}
```

### File Locations in Farm2Home

```
lib/
├── providers/
│   ├── auth_provider.dart           # User authentication state
│   ├── product_provider.dart        # Product CRUD operations
│   └── cart_provider.dart           # Shopping cart state
├── models/
│   ├── product.dart                 # Product data model
│   ├── cart_item.dart              # Cart item model
│   └── user.dart                   # User data model
├── services/
│   └── firestore_service.dart      # Firestore operations
└── main.dart                        # Provider setup with MultiProvider
```

### Testing Your State Management

1. **Open the app** in your emulator/device
2. **Navigate** to different screens
3. **Add items** to cart from product list
4. **Check cart badge** updates in real-time
5. **Navigate to cart screen** - items persist
6. **Delete items** - UI updates immediately
7. **Close and reopen app** - state resets (unless using persistence)

### Interactive Demo

Try these actions to see Provider in action:

1. Add a product → All product lists update instantly
2. Add to cart → Cart badge updates on all screens
3. Open cart from any screen → Same cart data
4. Delete from cart → Updates reflect everywhere
5. Sign out → All state clears appropriately

### Additional Resources

- **Official Docs**: https://pub.dev/packages/provider
- **Flutter Documentation**: https://docs.flutter.dev/data-and-backend/state-mgmt/simple
- **Video Tutorial**: https://www.youtube.com/watch?v=d_m5csmrf7I

---

## �🛠️ Technologies Used

- **Flutter**: Cross-platform UI framework
- **Dart**: Programming language
- **Material Design 3**: Modern UI components

### Firebase Services
- **Firebase Authentication**: User signup, login, and session management
- **Cloud Firestore**: NoSQL real-time database for products, orders, and user data
- **Firebase Core**: Firebase SDK initialization

### Google Maps & Location
- **google_maps_flutter**: ^2.5.0 - Interactive maps with custom markers
- **location**: ^5.0.0 - Basic location services
- **geolocator**: ^10.1.0 - Advanced GPS tracking and geolocation

### State Management & Architecture
- **provider**: ^6.1.0 - Scalable state management with ChangeNotifier
- **CartService, FavoritesService, AppThemeService**: Reactive state classes
- **MultiProvider**: App-wide state registration
- **StreamBuilder**: Real-time UI updates from Firestore
- **Service Layer Architecture**: Separation of business logic from UI
- **context.watch/read/Consumer**: Efficient state access patterns

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
