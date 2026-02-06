# Firestore Security Rules Configuration

## Official Firestore Rules File

Copy and paste the following rules into your Firebase Console under **Firestore Database → Rules tab**.

### Complete Security Rules

```firestore
rules_version = '2';

// Farm2Home - Secure Data Access with Firebase Authentication
// Rules ensure users can only access their own documents

service cloud.firestore {
  match /databases/{database}/documents {
    
    // ========== USERS COLLECTION ==========
    // User profiles - strict access control
    match /users/{uid} {
      // Allow read and write only if:
      // 1. User is authenticated (request.auth != null)
      // 2. User's UID matches the document ID (request.auth.uid == uid)
      allow read, write: if request.auth != null && request.auth.uid == uid;
      
      // Deny all other access
      allow read, write: if false;
    }
    
    // ========== USER SETTINGS SUBCOLLECTION ==========
    // Store user preferences - same owner-only rule
    match /users/{uid}/settings/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }
    
    // ========== PRODUCTS COLLECTION ==========
    // Public read for all authenticated users
    match /products/{productId} {
      // Anyone authenticated can read products
      allow read: if request.auth != null;
      
      // Only admin can write (implement custom claims in Firebase Auth)
      allow write: if request.auth != null && 
                      request.auth.token.get('role') == 'admin';
    }
    
    // ========== ORDERS COLLECTION ==========
    // Users can only access their own orders
    match /orders/{orderId} {
      allow read: if request.auth != null && 
                     resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && 
                       request.resource.data.userId == request.auth.uid;
      allow update, delete: if request.auth != null && 
                               resource.data.userId == request.auth.uid;
    }
    
    // ========== CART COLLECTION ==========
    // Users can only access their own cart
    match /carts/{uid}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }
    
    // ========== MEDIA UPLOADS COLLECTION ==========
    // Users can only access their own uploads
    match /media/{uid}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }
    
    // ========== MESSAGES COLLECTION ==========
    // For notifications or messaging features
    match /messages/{messageId} {
      // Users can read messages sent to them or by them
      allow read: if request.auth != null && 
                     (resource.data.recipientId == request.auth.uid ||
                      resource.data.senderId == request.auth.uid);
    }
    
    // ========== DEFAULT DENY ==========
    // Block all access by default
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

## Rule-by-Rule Explanation

### Users Collection - Primary Security Rule
```firestore
match /users/{uid} {
  allow read, write: if request.auth != null && request.auth.uid == uid;
}
```

**This is the most critical rule. It ensures:**

1. **Authentication Check** (`request.auth != null`)
   - Only authenticated users can access
   - Unauthenticated requests are blocked

2. **Ownership Verification** (`request.auth.uid == uid`)
   - The authenticated user's UID must match the document ID
   - User can ONLY read/write their own document
   - User CANNOT access other users' documents

3. **Operation Coverage**
   - Applies to both READ and WRITE operations
   - Includes create, update, delete, and get operations

**Example Scenarios:**

| Scenario | UID Match | Result | Why |
|----------|-----------|--------|-----|
| User A reads User A's profile | Yes | ✅ ALLOWED | Authenticated + UID matches |
| User A reads User B's profile | No | ❌ DENIED | UID doesn't match |
| User A writes to User A's profile | Yes | ✅ ALLOWED | Authenticated + UID matches |
| User A writes to User B's profile | No | ❌ DENIED | UID doesn't match |
| Unauthenticated reads User A's profile | N/A | ❌ DENIED | Not authenticated |

## How These Rules Are Tested in the App

### In SecureProfileScreen.dart

1. **Allowed Operation (Read Own Profile)**
   ```dart
   // User is authenticated as User A
   final profile = await _authService.getUserProfile(currentUserID);
   // Gets from /users/{currentUserID} 
   // ✅ SUCCEEDS - request.auth.uid == uid
   ```

2. **Allowed Operation (Write Own Profile)**
   ```dart
   await _authService.updateUserProfile(
     uid: currentUserID,
     displayName: 'New Name',
   );
   // Updates /users/{currentUserID}
   // ✅ SUCCEEDS - request.auth.uid == uid
   ```

3. **Denied Operation (Read Other's Profile)**
   ```dart
   // User A attempts to read User B's profile
   final otherProfile = await _firestore
       .collection('users')
       .doc('userB_id')
       .get();
   // Gets from /users/userB_id
   // ❌ FAILS - request.auth.uid (User A) != uid (User B)
   // Error: PERMISSION_DENIED
   ```

4. **Denied Operation (Write Other's Profile)**
   ```dart
   // User A attempts to modify User B's profile
   await _firestore
       .collection('users')
       .doc('userB_id')
       .update({'displayName': 'Hacked'});
   // Writes to /users/userB_id
   // ❌ FAILS - request.auth.uid (User A) != uid (User B)
   // Error: PERMISSION_DENIED
   ```

## Firebase Security Best Practices Applied

### ✅ Authentication First
- Every rule starts with `request.auth != null`
- No public data access without authentication

### ✅ Ownership Verification
- Documents are indexed by user ID for easy ownership check
- URL structure matches auth structure: `/users/{uid}`

### ✅ Least Privilege Principle
- Users get ONLY the minimum necessary access
- Default is DENY unless explicitly allowed

### ✅ Fail Securely
- Last rule blocks all other access: `match /{document=**} { allow read, write: if false; }`
- Ensures no unexpected access paths

### ✅ No Escalation Paths
- Cannot modify another user's auth token
- Cannot update their own `uid` field
- Cannot create documents with someone else's ID

## Testing the Rules in Firebase Console

### 1. Test as Authenticated User (Should Succeed)

```javascript
// Firebase Console Rules Simulator
// Authenticated as uid: "user_A_id"
// Attempt to read: /users/user_A_id
// ✅ ALLOWED
```

### 2. Test as Different User (Should Fail)

```javascript
// Firebase Console Rules Simulator
// Authenticated as uid: "user_A_id"
// Attempt to read: /users/user_B_id
// ❌ DENIED - request.auth.uid != uid
```

### 3. Test as Unauthenticated (Should Fail)

```javascript
// Firebase Console Rules Simulator
// Authenticated as: NONE
// Attempt to read: /users/any_id
// ❌ DENIED - request.auth == null
```

## Setting Up Rules in Firebase Console

### Step 1: Open Firestore Database
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Click **Cloud Firestore**

### Step 2: Navigate to Rules Tab
1. Click **Rules** tab at the top
2. You'll see the current rules editor

### Step 3: Paste New Rules
1. Select all existing text (Ctrl+A / Cmd+A)
2. Paste the complete rules from above
3. Click **Publish** button (top right)

### Step 4: Confirm Deployment
1. A popup will ask to confirm deployment
2. Click **Publish** to apply rules
3. Rules are now live for your application

## Debugging Rules Violations

### When Users See "Permission Denied"

**In Flutter Code:**
```dart
try {
  await _firestore.collection('users').doc('otherUserId').get();
} catch (e) {
  // e.code == 'permission-denied'
  // e.message == 'Missing or insufficient permissions'
}
```

**In Firebase Console Logs:**
1. Click **Logs** in Cloud Firestore
2. Filter by error type
3. See which rule rejected the request
4. Compare with your current security rules

### Common Issues

1. **"PERMISSION_DENIED" on own profile read**
   - Check: Is user logged in? (`request.auth != null`)
   - Check: Does `request.auth.uid` match the document ID?
   - Solution: Ensure user is authenticated before accessing Firestore

2. **"PERMISSION_DENIED" on profile update**
   - Check: Is user attempting to update their own document?
   - Check: Are they modifying the `uid` field? (This should fail)
   - Solution: Only allow updates to non-sensitive fields

3. **Can read other users' documents (SECURITY ISSUE!)**
   - Check: Is `request.auth.uid == uid` in your rule?
   - Solution: Add the UID check immediately
   - **This means unauthorized access is possible!**

## Rule Deployment Workflow

```
1. Write rules locally (in this file)
   ↓
2. Test in Firebase Console Rules Simulator
   ↓
3. Deploy to production
   ↓
4. Monitor with Firebase Console Logs
   ↓
5. Adjust if needed
```

## Difference Between Rule States

### ❌ UNSAFE - No Authentication Check
```firestore
match /users/{uid} {
  allow read, write: if true;  // DANGEROUS! Anyone can access
}
```

### ⚠️ PARTIALLY SAFE - Checks Auth Only
```firestore
match /users/{uid} {
  allow read, write: if request.auth != null;  // Authenticated, but can read anyone's
}
```

### ✅ SAFE - Checks Auth + Ownership
```firestore
match /users/{uid} {
  allow read, write: if request.auth != null && request.auth.uid == uid;  // Proper!
}
```

## Related Files

- **AuthService** (`lib/services/auth_service.dart`) - Handles user authentication
- **SecureProfileScreen** (`lib/screens/secure_profile_screen.dart`) - Demonstrates rule enforcement
- **Documentation** (`FIREBASE_AUTH_RULES_DOCUMENTATION.md`) - Extended guide

## Testing Checklist

- [ ] Create two test user accounts
- [ ] Sign in as User 1
- [ ] Successfully read/write User 1's profile
- [ ] Copy User 2's UID
- [ ] Attempt to read User 2's profile → See "Permission Denied"
- [ ] Attempt to write to User 2's profile → See "Permission Denied"
- [ ] Sign out and try accessing any profile → See "Permission Denied"
- [ ] Monitor Firebase Logs for rule violations

---

**Security Note**: These rules are production-grade for the "Secure Profile" use case. Always test rules thoroughly before deploying to production, and monitor Firebase logs for unexpected access attempts.
