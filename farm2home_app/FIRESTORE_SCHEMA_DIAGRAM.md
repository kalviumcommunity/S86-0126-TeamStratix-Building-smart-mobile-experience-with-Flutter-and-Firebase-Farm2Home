# Farm2Home Firestore Schema Diagram

## Visual Database Structure

```mermaid
graph TB
    subgraph "Top-Level Collections"
        Users[👤 users]
        Farmers[🚜 farmers]
        Products[🥬 products]
        Orders[📦 orders]
        Categories[📂 categories]
        Notifications[🔔 notifications]
    end
    
    subgraph "users/{userId}"
        UserDoc[Document Fields:<br/>- name: string<br/>- email: string<br/>- phoneNumber: string<br/>- accountType: string<br/>- favorites: array<br/>- createdAt: timestamp]
        Addresses[📍 addresses subcollection]
    end
    
    subgraph "users/{userId}/addresses/{addressId}"
        AddressDoc[Document Fields:<br/>- label: string<br/>- street: string<br/>- city: string<br/>- state: string<br/>- zipCode: string<br/>- isDefault: boolean]
    end
    
    subgraph "farmers/{farmerId}"
        FarmerDoc[Document Fields:<br/>- userId: string ref<br/>- farmName: string<br/>- description: string<br/>- location: geopoint<br/>- certifications: array<br/>- rating: number<br/>- isVerified: boolean]
    end
    
    subgraph "products/{productId}"
        ProductDoc[Document Fields:<br/>- name: string<br/>- description: string<br/>- farmerId: string ref<br/>- category: string<br/>- price: number<br/>- unit: string<br/>- stockQuantity: number<br/>- isAvailable: boolean<br/>- imageUrls: array<br/>- rating: number]
        Reviews[⭐ reviews subcollection]
    end
    
    subgraph "products/{productId}/reviews/{reviewId}"
        ReviewDoc[Document Fields:<br/>- userId: string ref<br/>- userName: string<br/>- rating: number<br/>- comment: string<br/>- isVerifiedPurchase: boolean<br/>- helpfulCount: number<br/>- createdAt: timestamp]
    end
    
    subgraph "orders/{orderId}"
        OrderDoc[Document Fields:<br/>- userId: string ref<br/>- orderNumber: string<br/>- status: string<br/>- items: array of maps<br/>- subtotal: number<br/>- totalAmount: number<br/>- deliveryAddress: map<br/>- paymentStatus: string<br/>- estimatedDelivery: timestamp]
        OrderUpdates[📝 updates subcollection]
    end
    
    subgraph "orders/{orderId}/updates/{updateId}"
        UpdateDoc[Document Fields:<br/>- status: string<br/>- message: string<br/>- location: string<br/>- updatedBy: string<br/>- timestamp: timestamp]
    end
    
    subgraph "categories/{categoryId}"
        CategoryDoc[Document Fields:<br/>- name: string<br/>- description: string<br/>- icon: string<br/>- subcategories: array<br/>- sortOrder: number<br/>- isActive: boolean]
    end
    
    subgraph "notifications/{notificationId}"
        NotificationDoc[Document Fields:<br/>- userId: string ref<br/>- type: string<br/>- title: string<br/>- message: string<br/>- isRead: boolean<br/>- priority: string<br/>- createdAt: timestamp]
    end
    
    Users --> UserDoc
    UserDoc --> Addresses
    Addresses --> AddressDoc
    
    Farmers --> FarmerDoc
    
    Products --> ProductDoc
    ProductDoc --> Reviews
    Reviews --> ReviewDoc
    
    Orders --> OrderDoc
    OrderDoc --> OrderUpdates
    OrderUpdates --> UpdateDoc
    
    Categories --> CategoryDoc
    
    Notifications --> NotificationDoc
    
    %% Relationships
    FarmerDoc -.->|references| UserDoc
    ProductDoc -.->|references| FarmerDoc
    OrderDoc -.->|references| UserDoc
    ReviewDoc -.->|references| UserDoc
    NotificationDoc -.->|references| UserDoc
    
    classDef collection fill:#4CAF50,stroke:#2E7D32,color:#fff
    classDef subcollection fill:#2196F3,stroke:#1565C0,color:#fff
    classDef document fill:#FFF3E0,stroke:#E65100,color:#000
    
    class Users,Farmers,Products,Orders,Categories,Notifications collection
    class Addresses,Reviews,OrderUpdates subcollection
    class UserDoc,AddressDoc,FarmerDoc,ProductDoc,ReviewDoc,OrderDoc,UpdateDoc,CategoryDoc,NotificationDoc document
```

## Simplified ER-Style Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         FIRESTORE DATABASE                       │
└─────────────────────────────────────────────────────────────────┘

┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│    users     │         │   farmers    │         │  products    │
│──────────────│         │──────────────│         │──────────────│
│ • userId (PK)│────────>│ • farmerId   │────────>│ • productId  │
│ • name       │         │ • userId (FK)│         │ • farmerId   │
│ • email      │         │ • farmName   │         │ • name       │
│ • phone      │         │ • location   │         │ • price      │
│ • favorites[]│         │ • rating     │         │ • category   │
└──────────────┘         │ • verified   │         │ • stock      │
       │                 └──────────────┘         │ • rating     │
       │                                          └──────────────┘
       │                                                 │
       │                                                 │
       ▼                                                 ▼
┌──────────────┐                              ┌──────────────────┐
│  addresses   │                              │     reviews      │
│ (subcoll)    │                              │   (subcollection)│
│──────────────│                              │──────────────────│
│ • addressId  │                              │ • reviewId       │
│ • street     │                              │ • userId (FK)    │
│ • city       │                              │ • rating         │
│ • isDefault  │                              │ • comment        │
└──────────────┘                              │ • verified       │
                                              └──────────────────┘

┌──────────────┐         ┌──────────────────┐
│    orders    │         │  notifications   │
│──────────────│         │──────────────────│
│ • orderId(PK)│         │ • notificationId │
│ • userId(FK) │<────────│ • userId (FK)    │
│ • orderNum   │         │ • type           │
│ • status     │         │ • title          │
│ • items[]    │         │ • message        │
│ • total      │         │ • isRead         │
│ • address    │         │ • priority       │
└──────────────┘         └──────────────────┘
       │
       │
       ▼
┌──────────────┐         ┌──────────────┐
│   updates    │         │ categories   │
│ (subcoll)    │         │──────────────│
│──────────────│         │ • categoryId │
│ • updateId   │         │ • name       │
│ • status     │         │ • icon       │
│ • message    │         │ • subcats[]  │
│ • timestamp  │         │ • sortOrder  │
└──────────────┘         └──────────────┘

Legend:
────> : References (Foreign Key)
(PK)  : Primary Key (Document ID)
(FK)  : Foreign Key Reference
[]    : Array field
(subcoll) : Subcollection
```

## ASCII Data Flow Diagram

```
┌─────────────┐
│   Customer  │
└──────┬──────┘
       │
       │ 1. Browse Products
       ▼
┌─────────────────────────┐
│   products collection   │
│  ┌─────────────────┐   │
│  │ Filter by cat   │   │
│  │ Search by name  │   │
│  │ Sort by rating  │   │
│  └─────────────────┘   │
└─────────┬───────────────┘
          │
          │ 2. View Reviews
          ▼
    ┌──────────────┐
    │products/{id}/│
    │   reviews/   │
    └──────────────┘
          │
          │ 3. Add to Cart
          ▼
    ┌──────────────┐
    │ Client-side  │
    │   cart       │
    └──────┬───────┘
           │
           │ 4. Place Order
           ▼
    ┌──────────────┐      ┌────────────────┐
    │   orders/    │─────>│  Notify User   │
    │ {orderId}    │      │ notifications/ │
    └──────┬───────┘      └────────────────┘
           │
           │ 5. Track Order
           ▼
    ┌──────────────┐
    │ orders/{id}/ │
    │  updates/    │
    └──────────────┘
```

## Collection Relationships Summary

| Parent Collection | Subcollection | Relationship | Purpose |
|------------------|---------------|--------------|---------|
| `users` | `addresses` | 1:Many | Multiple delivery addresses per user |
| `products` | `reviews` | 1:Many | Multiple customer reviews per product |
| `orders` | `updates` | 1:Many | Status tracking history per order |
| `orders` | N/A (top-level) | N/A | Enables cross-user queries for admin |
| `farmers` | N/A (top-level) | References `users` | Farmer profiles separate from products |
| `products` | N/A (top-level) | References `farmers` | All products queryable together |
| `categories` | N/A (top-level) | Referenced by products | Browse and filter support |
| `notifications` | N/A (top-level) | References `users` | User-specific notifications |

## Key Design Patterns

### ✅ Subcollections Used For:
- **High Volume Data**: Reviews can be thousands per product
- **Independent Updates**: Order updates don't affect order document
- **Lazy Loading**: Addresses loaded only when needed
- **Pagination**: Easy "load more" implementation

### ✅ Top-Level Collections For:
- **Cross-Entity Queries**: All orders for admin dashboard
- **Multiple References**: Products referenced by orders, reviews, favorites
- **Public Data**: Categories browsed by all users
- **Independent Lifecycle**: Farmers exist independently of products

### ✅ References (IDs) Instead of Embedding:
- **Prevents Duplication**: Product updates don't require order updates
- **Flexibility**: Easy to query relationships
- **Consistency**: Single source of truth for farmer/user data
- **Trade-off**: Denormalize display names (userName in reviews) for performance

## Schema Evolution Plan

### Phase 1 (Current): Core E-commerce
- ✅ Users, Products, Orders, Farmers, Reviews

### Phase 2: Enhanced Features
- 🔜 Add `carts` collection (move from client-side)
- 🔜 Add `promotions` collection (discount codes, sales)
- 🔜 Add `inventory` subcollection for farmers

### Phase 3: Community Features
- 🔜 Add `conversations` (user-farmer chat)
- 🔜 Add `posts` (farmer blog posts, updates)
- 🔜 Add `subscriptions` (recurring deliveries)

### Phase 4: Analytics & Admin
- 🔜 Add `analytics` collection (aggregated stats)
- 🔜 Add `admin_logs` (audit trail)
- 🔜 Export to BigQuery for advanced analytics

---

This visual representation helps developers understand the database structure at a glance and makes implementation much easier! 🎨
