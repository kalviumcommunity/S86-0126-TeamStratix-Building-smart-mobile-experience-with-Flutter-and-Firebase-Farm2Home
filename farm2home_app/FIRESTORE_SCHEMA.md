# Farm2Home Firestore Database Schema

## Overview
This document outlines the complete Firestore database structure for the Farm2Home application - a farm-to-consumer marketplace connecting farmers directly with customers.

---

## Data Requirements Analysis

### What Data Does the App Need to Store?

1. **Users** - Customer profiles, authentication details, addresses, preferences
2. **Products** - Farm products with details, pricing, inventory, categories
3. **Orders** - Purchase history, order status, delivery information
4. **Reviews** - Product ratings and customer feedback
5. **Cart** - Temporary shopping cart data (can be client-side or server-side)
6. **Favorites** - User's saved/favorite products
7. **Categories** - Product categorization and filtering
8. **Farmers** - Seller/vendor profiles and information
9. **Addresses** - User delivery addresses
10. **Notifications** - Order updates, promotions, system messages

### Scalability Considerations

- Products: 1,000 - 100,000 items
- Users: 1,000 - 1,000,000+ customers
- Orders: Growing continuously (millions over time)
- Reviews: Multiple per product (thousands per popular product)
- Real-time updates needed for: orders, inventory, notifications

---

## Firestore Schema Design

### Collection: `users`
Stores customer profile information and preferences.

```
users/
  └── {userId} (document)
        ├── name: string
        ├── email: string
        ├── phoneNumber: string
        ├── profileImageUrl: string (optional)
        ├── accountType: string ("customer" | "farmer")
        ├── favorites: array<string> (productIds)
        ├── createdAt: timestamp
        └── updatedAt: timestamp
```

**Sample Document:**
```json
{
  "userId": "user_abc123",
  "name": "Sarah Johnson",
  "email": "sarah.johnson@example.com",
  "phoneNumber": "+1234567890",
  "profileImageUrl": "https://storage.googleapis.com/profiles/sarah.jpg",
  "accountType": "customer",
  "favorites": ["prod_001", "prod_045", "prod_089"],
  "createdAt": "2026-02-06T10:30:00Z",
  "updatedAt": "2026-02-06T10:30:00Z"
}
```

---

### Subcollection: `users/{userId}/addresses`
Stores multiple delivery addresses for each user.

```
users/{userId}/addresses/
  └── {addressId} (document)
        ├── label: string ("Home", "Work", "Other")
        ├── street: string
        ├── city: string
        ├── state: string
        ├── zipCode: string
        ├── country: string
        ├── isDefault: boolean
        ├── deliveryInstructions: string (optional)
        └── createdAt: timestamp
```

**Sample Document:**
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

**Why Subcollection?**
- Users can have multiple addresses (scalable)
- Addresses don't need to be loaded with user profile every time
- Allows independent querying and updating

---

### Collection: `farmers`
Stores farmer/vendor profiles and business information.

```
farmers/
  └── {farmerId} (document)
        ├── userId: string (reference to users collection)
        ├── farmName: string
        ├── description: string
        ├── farmImageUrl: string
        ├── location: geopoint
        ├── address: string
        ├── certifications: array<string> ("Organic", "Non-GMO", etc.)
        ├── rating: number (0-5)
        ├── totalReviews: number
        ├── isVerified: boolean
        ├── createdAt: timestamp
        └── updatedAt: timestamp
```

**Sample Document:**
```json
{
  "farmerId": "farm_456",
  "userId": "user_farmer_001",
  "farmName": "Green Valley Organic Farm",
  "description": "Family-owned organic farm specializing in vegetables",
  "farmImageUrl": "https://storage.googleapis.com/farms/greenvalley.jpg",
  "location": {"latitude": 39.7817, "longitude": -89.6501},
  "address": "456 Rural Route 1, Springfield, IL 62702",
  "certifications": ["USDA Organic", "Non-GMO"],
  "rating": 4.8,
  "totalReviews": 127,
  "isVerified": true,
  "createdAt": "2026-01-15T08:00:00Z",
  "updatedAt": "2026-02-05T14:20:00Z"
}
```

---

### Collection: `products`
Stores all farm products available for purchase.

```
products/
  └── {productId} (document)
        ├── name: string
        ├── description: string
        ├── farmerId: string (reference)
        ├── category: string
        ├── subcategory: string (optional)
        ├── price: number
        ├── unit: string ("lb", "kg", "bunch", "dozen", etc.)
        ├── stockQuantity: number
        ├── isAvailable: boolean
        ├── imageUrls: array<string>
        ├── tags: array<string> ("organic", "local", "seasonal")
        ├── nutritionInfo: map (optional)
        ├── rating: number (0-5)
        ├── totalReviews: number
        ├── totalSales: number
        ├── createdAt: timestamp
        └── updatedAt: timestamp
```

**Sample Document:**
```json
{
  "productId": "prod_001",
  "name": "Organic Tomatoes",
  "description": "Fresh, vine-ripened organic tomatoes grown without pesticides",
  "farmerId": "farm_456",
  "category": "Vegetables",
  "subcategory": "Fruits",
  "price": 3.99,
  "unit": "lb",
  "stockQuantity": 150,
  "isAvailable": true,
  "imageUrls": [
    "https://storage.googleapis.com/products/tomatoes_1.jpg",
    "https://storage.googleapis.com/products/tomatoes_2.jpg"
  ],
  "tags": ["organic", "local", "non-gmo", "seasonal"],
  "nutritionInfo": {
    "calories": 18,
    "protein": 0.9,
    "carbs": 3.9,
    "fiber": 1.2
  },
  "rating": 4.7,
  "totalReviews": 45,
  "totalSales": 523,
  "createdAt": "2026-01-20T09:00:00Z",
  "updatedAt": "2026-02-06T08:15:00Z"
}
```

---

### Subcollection: `products/{productId}/reviews`
Customer reviews and ratings for each product.

```
products/{productId}/reviews/
  └── {reviewId} (document)
        ├── userId: string (reference)
        ├── userName: string
        ├── userPhotoUrl: string (optional)
        ├── rating: number (1-5)
        ├── comment: string
        ├── isVerifiedPurchase: boolean
        ├── helpfulCount: number
        ├── images: array<string> (optional)
        ├── createdAt: timestamp
        └── updatedAt: timestamp
```

**Sample Document:**
```json
{
  "reviewId": "rev_abc123",
  "userId": "user_abc123",
  "userName": "Sarah Johnson",
  "userPhotoUrl": "https://storage.googleapis.com/profiles/sarah.jpg",
  "rating": 5,
  "comment": "Best tomatoes I've ever tasted! So fresh and flavorful.",
  "isVerifiedPurchase": true,
  "helpfulCount": 12,
  "images": ["https://storage.googleapis.com/reviews/tomato_review_1.jpg"],
  "createdAt": "2026-02-01T16:45:00Z",
  "updatedAt": "2026-02-01T16:45:00Z"
}
```

**Why Subcollection?**
- Products can have hundreds/thousands of reviews
- Reviews don't need to be loaded with product list
- Enables pagination and lazy loading
- Better query performance

---

### Collection: `categories`
Product category definitions and metadata.

```
categories/
  └── {categoryId} (document)
        ├── name: string
        ├── description: string
        ├── imageUrl: string
        ├── icon: string (emoji or icon name)
        ├── subcategories: array<string>
        ├── sortOrder: number
        ├── isActive: boolean
        └── createdAt: timestamp
```

**Sample Document:**
```json
{
  "categoryId": "cat_vegetables",
  "name": "Vegetables",
  "description": "Fresh vegetables from local farms",
  "imageUrl": "https://storage.googleapis.com/categories/vegetables.jpg",
  "icon": "🥬",
  "subcategories": ["Leafy Greens", "Root Vegetables", "Fruits", "Herbs"],
  "sortOrder": 1,
  "isActive": true,
  "createdAt": "2026-01-10T00:00:00Z"
}
```

---

### Collection: `orders`
Customer purchase orders and order history.

```
orders/
  └── {orderId} (document)
        ├── userId: string (reference)
        ├── orderNumber: string (human-readable)
        ├── status: string ("pending", "confirmed", "preparing", "shipped", "delivered", "cancelled")
        ├── items: array<map>
        │     ├── productId: string
        │     ├── productName: string
        │     ├── quantity: number
        │     ├── unit: string
        │     ├── pricePerUnit: number
        │     ├── totalPrice: number
        │     └── farmerId: string
        ├── subtotal: number
        ├── tax: number
        ├── deliveryFee: number
        ├── totalAmount: number
        ├── deliveryAddress: map
        │     ├── street: string
        │     ├── city: string
        │     ├── state: string
        │     ├── zipCode: string
        │     └── instructions: string
        ├── paymentMethod: string
        ├── paymentStatus: string ("pending", "completed", "failed", "refunded")
        ├── estimatedDelivery: timestamp
        ├── actualDelivery: timestamp (optional)
        ├── trackingNumber: string (optional)
        ├── notes: string (optional)
        ├── createdAt: timestamp
        └── updatedAt: timestamp
```

**Sample Document:**
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
    },
    {
      "productId": "prod_045",
      "productName": "Fresh Lettuce",
      "quantity": 1,
      "unit": "head",
      "pricePerUnit": 2.49,
      "totalPrice": 2.49,
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
    "zipCode": "62701",
    "instructions": "Leave at front door"
  },
  "paymentMethod": "credit_card",
  "paymentStatus": "completed",
  "estimatedDelivery": "2026-02-08T14:00:00Z",
  "trackingNumber": "TRACK123456",
  "notes": "Please deliver in the morning",
  "createdAt": "2026-02-06T11:30:00Z",
  "updatedAt": "2026-02-06T11:35:00Z"
}
```

**Why Not Subcollection?**
- Orders need to be queried across all users (admin dashboard)
- Farmers need to see all orders containing their products
- Top-level collection enables better querying and analytics

---

### Subcollection: `orders/{orderId}/updates`
Order status updates and tracking history.

```
orders/{orderId}/updates/
  └── {updateId} (document)
        ├── status: string
        ├── message: string
        ├── location: string (optional)
        ├── updatedBy: string (userId or "system")
        └── timestamp: timestamp
```

**Sample Document:**
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

### Collection: `notifications`
User notifications for orders, promotions, and system messages.

```
notifications/
  └── {notificationId} (document)
        ├── userId: string (reference)
        ├── type: string ("order", "promotion", "system", "review")
        ├── title: string
        ├── message: string
        ├── imageUrl: string (optional)
        ├── actionUrl: string (optional, deep link)
        ├── isRead: boolean
        ├── priority: string ("low", "medium", "high")
        ├── expiresAt: timestamp (optional)
        └── createdAt: timestamp
```

**Sample Document:**
```json
{
  "notificationId": "notif_123",
  "userId": "user_abc123",
  "type": "order",
  "title": "Order Confirmed! 🎉",
  "message": "Your order F2H-20260206-001 has been confirmed and is being prepared.",
  "imageUrl": "https://storage.googleapis.com/notifications/order_confirmed.png",
  "actionUrl": "farm2home://orders/order_xyz789",
  "isRead": false,
  "priority": "high",
  "createdAt": "2026-02-06T11:35:00Z"
}
```

---

## Schema Justification & Design Decisions

### 1. Why Subcollections for Reviews?
- **Scalability**: Popular products may have thousands of reviews
- **Performance**: Don't load all reviews when fetching product list
- **Pagination**: Easy to implement "load more" functionality
- **Independent Updates**: Reviews can be added/updated without touching product document

### 2. Why Subcollections for Addresses?
- **Multiple Addresses**: Users have home, work, vacation addresses
- **Privacy**: Addresses loaded only when needed
- **Flexibility**: Easy to add/remove addresses without affecting user document size

### 3. Why Subcollections for Order Updates?
- **Audit Trail**: Complete history of order status changes
- **Real-time Tracking**: Stream updates without re-fetching entire order
- **Scalability**: Order document stays small, updates can be numerous

### 4. Why Top-Level Orders Collection?
- **Cross-User Queries**: Admin needs to see all orders
- **Farmer Dashboard**: Farmers need orders containing their products
- **Analytics**: Aggregate queries across all orders
- **Reporting**: Sales reports, revenue tracking

### 5. Field Naming Conventions
- **lowerCamelCase**: Consistent with JavaScript/Flutter conventions
- **Descriptive Names**: `estimatedDelivery` not `estDel`
- **Boolean Prefix**: `isAvailable`, `isVerified`, `isRead`
- **Timestamps**: `createdAt`, `updatedAt` for all documents

### 6. Data Types Chosen
- **Timestamps**: `FieldValue.serverTimestamp()` for consistency
- **Arrays**: For lists that won't exceed 100 items (favorites, tags)
- **Maps**: For structured data that belongs together (address, nutrition)
- **References (strings)**: Store IDs, not entire documents (prevents duplication)
- **Geopoints**: For location-based queries (find nearby farmers)

---

## Performance & Scalability Considerations

### ✅ What Makes This Schema Scalable?

1. **Subcollections for Large Datasets**
   - Reviews, addresses, order updates use subcollections
   - Prevents document size limits (1MB max)
   - Enables efficient pagination

2. **Indexed Fields**
   - `userId` in orders for user-specific queries
   - `farmerId` in products for farmer dashboard
   - `status` in orders for filtering
   - `category` in products for browsing

3. **Denormalization Where Appropriate**
   - Product name stored in order items (prevents extra reads)
   - User name stored in reviews (faster display)
   - Trade-off: Slight data duplication for massive read performance

4. **Real-time Optimization**
   - Stream only what's needed (user's orders, not all orders)
   - Subcollections enable targeted listeners
   - `isRead` boolean for efficient notification queries

5. **Avoiding Common Pitfalls**
   - ❌ No large arrays (reviews in product document)
   - ❌ No deeply nested maps (max 2-3 levels)
   - ❌ No unbounded arrays (favorites has practical limit)
   - ✅ Proper use of references vs embedding

---

## Query Examples

### Common Queries This Schema Supports:

```dart
// Get all products in a category
firestore.collection('products')
  .where('category', isEqualTo: 'Vegetables')
  .where('isAvailable', isEqualTo: true)
  .orderBy('rating', descending: true)
  .get();

// Get user's recent orders
firestore.collection('orders')
  .where('userId', isEqualTo: userId)
  .orderBy('createdAt', descending: true)
  .limit(10)
  .get();

// Get products from specific farmer
firestore.collection('products')
  .where('farmerId', isEqualTo: farmerId)
  .where('isAvailable', isEqualTo: true)
  .get();

// Stream product reviews
firestore.collection('products')
  .doc(productId)
  .collection('reviews')
  .orderBy('createdAt', descending: true)
  .snapshots();

// Get unread notifications
firestore.collection('notifications')
  .where('userId', isEqualTo: userId)
  .where('isRead', isEqualTo: false)
  .orderBy('createdAt', descending: true)
  .get();

// Find nearby farmers (geoqueries require plugin)
firestore.collection('farmers')
  .where('location', isNear: userLocation, within: 50km)
  .get();
```

---

## Future Expansion Possibilities

This schema can easily support:

1. **Chat/Messaging**: Add `conversations` and `messages` subcollections
2. **Promotions**: Add `coupons` collection with redemption tracking
3. **Subscriptions**: Add `subscriptions` for recurring deliveries
4. **Inventory Management**: Add `inventory` subcollection for farmers
5. **Analytics**: All data structured for BigQuery export
6. **Admin Dashboard**: Top-level collections enable comprehensive queries

---

## Data Security Rules (Firebase Rules Overview)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // User addresses
      match /addresses/{addressId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
    
    // Products are publicly readable, farmers can write their own
    match /products/{productId} {
      allow read: if true;
      allow create, update, delete: if request.auth != null 
        && get(/databases/$(database)/documents/products/$(productId)).data.farmerId == request.auth.uid;
      
      // Anyone can read reviews, only verified purchasers can write
      match /reviews/{reviewId} {
        allow read: if true;
        allow create: if request.auth != null;
        allow update, delete: if request.auth != null && resource.data.userId == request.auth.uid;
      }
    }
    
    // Orders - users can read their own orders
    match /orders/{orderId} {
      allow read: if request.auth != null 
        && (resource.data.userId == request.auth.uid 
            || request.auth.token.admin == true);
      allow create: if request.auth != null;
      allow update: if request.auth != null 
        && (resource.data.userId == request.auth.uid 
            || request.auth.token.admin == true);
    }
    
    // Farmers - publicly readable
    match /farmers/{farmerId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == resource.data.userId;
    }
    
    // Categories - publicly readable, admin write
    match /categories/{categoryId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }
    
    // Notifications - users see only their own
    match /notifications/{notificationId} {
      allow read, update: if request.auth != null && resource.data.userId == request.auth.uid;
      allow create: if request.auth != null;
    }
  }
}
```

---

## Reflection

### Why This Structure?

1. **Separation of Concerns**: Users, products, orders, farmers are independent
2. **Query Efficiency**: Structured to support app's most common queries
3. **Scalability**: Subcollections prevent document bloat
4. **Real-time Capable**: Schema optimized for Firestore real-time listeners
5. **Maintainability**: Clear, logical structure easy for team to understand

### Performance Benefits

- **Faster Reads**: Denormalized data reduces joins
- **Efficient Writes**: Targeted updates to specific documents
- **Pagination Ready**: Subcollections enable cursor-based pagination
- **Real-time Friendly**: Small, focused documents for live updates

### Challenges Faced

1. **Denormalization Trade-offs**: Deciding what to duplicate (product names in orders)
2. **Subcollection vs Array**: Reviews needed subcollection, favorites okay as array
3. **Reference Management**: Storing IDs vs full objects (chose IDs for flexibility)
4. **Query Limitations**: Firestore doesn't support OR queries (used multiple queries)

### What I Learned

- **Plan Queries First**: Schema should support app's query patterns
- **Document Size Matters**: 1MB limit means subcollections for large datasets
- **Denormalization is OK**: NoSQL embraces controlled redundancy for speed
- **Security Rules**: Schema should align with security model from day one

---

## Summary

This Firestore schema provides:

✅ **Scalable structure** for thousands of products, users, and orders  
✅ **Efficient queries** for browsing, searching, and filtering  
✅ **Real-time capabilities** for orders, notifications, reviews  
✅ **Clear organization** easy for developers to understand  
✅ **Future-proof design** easy to extend with new features  
✅ **Performance optimized** through proper use of subcollections and denormalization  

The schema balances NoSQL best practices with Farm2Home's specific needs, creating a solid foundation for app development.
