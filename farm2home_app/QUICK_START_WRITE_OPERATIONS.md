# 🚀 Quick Start: Firestore Write Operations

## Overview
This guide helps you quickly test the new write operations (Add, Set, Update, Delete) in Farm2Home.

---

## 📋 Prerequisites

1. **Firebase Project Setup** ✅ (Already configured)
2. **Firestore Database** ✅ (Already created)
3. **User Authentication** ✅ (Already implemented)

---

## 🎯 Quick Test Workflow

### Step 1: Run the App
```bash
cd farm2home_app
flutter run
```

### Step 2: Access Farmer Dashboard

**Option A: Add to Main Routes (Recommended)**

Update `lib/main.dart`:
```dart
'/farmer-dashboard': (context) => const FarmerDashboardScreen(),
```

Then navigate from products screen:
```dart
IconButton(
  icon: Icon(Icons.store),
  onPressed: () {
    Navigator.pushNamed(context, '/farmer-dashboard');
  },
)
```

**Option B: Direct Navigation**

From any screen:
```dart
import 'screens/farmer_dashboard_screen.dart';

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const FarmerDashboardScreen(),
  ),
);
```

### Step 3: Test Add Operation

1. **Open Farmer Dashboard**
2. **Click "Add Product" FAB**
3. **Fill Form:**
   - Name: "Test Product"
   - Description: "This is a test product for verification"
   - Price: 5.99
   - Unit: "per item"
   - Category: "Vegetables"
   - Stock: 25
   - Icon: 🧪
   - Available: ON
4. **Click "Add Product"**
5. **Verify:**
   - ✅ Success message appears
   - ✅ Product appears in dashboard
   - ✅ Open [Firestore Console](https://console.firebase.google.com/project/_/firestore)
   - ✅ See new document with `createdAt` and `updatedAt`

### Step 4: Test Update Operation

1. **Find your test product**
2. **Click "Edit"**
3. **Change price** from 5.99 to 7.99
4. **Click "Update Product"**
5. **Verify:**
   - ✅ Success message appears
   - ✅ Price updated in dashboard
   - ✅ Check Firestore Console
   - ✅ Price field changed
   - ✅ `updatedAt` timestamp changed
   - ✅ `createdAt` unchanged

### Step 5: Test Toggle Availability

1. **Click "Hide" button**
2. **Verify:**
   - ✅ Icon changes to ❌
   - ✅ Text changes to "Hidden"
   - ✅ `isAvailable: false` in Firestore
3. **Click "Show" button**
4. **Verify:**
   - ✅ Icon changes to ✅
   - ✅ Text changes to "Available"
   - ✅ `isAvailable: true` in Firestore

### Step 6: Test Delete Operation

1. **Click "Delete" button**
2. **Verify confirmation dialog appears**
3. **Click "Delete"**
4. **Verify:**
   - ✅ Success message appears
   - ✅ Product removed from dashboard
   - ✅ Check Firestore Console
   - ✅ Document deleted

---

## 🎬 Video Recording Checklist

Record a 2-minute video showing:

### Scene 1: Add Operation (30s)
- [ ] Show Farmer Dashboard
- [ ] Click "Add Product"
- [ ] Fill out form
- [ ] Submit
- [ ] Show success message
- [ ] Show product in dashboard
- [ ] Show Firestore Console (new document)

### Scene 2: Update Operation (30s)
- [ ] Click "Edit" on product
- [ ] Show pre-filled form
- [ ] Change a field
- [ ] Submit
- [ ] Show success message
- [ ] Show updated value
- [ ] Show Firestore Console (updated field & timestamp)

### Scene 3: Real-time Sync (20s)
- [ ] Split screen: Dashboard + Firestore Console
- [ ] Edit field in Firestore Console
- [ ] Show dashboard updates instantly

### Scene 4: Delete Operation (20s)
- [ ] Click "Delete"
- [ ] Show confirmation
- [ ] Confirm deletion
- [ ] Show product removed
- [ ] Show Firestore Console (document gone)

### Recording Tips
- Use OBS Studio or Loom
- 1080p resolution
- Show mouse cursor
- Keep it under 2 minutes
- Upload to Google Drive/YouTube (unlisted)
- Set access: "Anyone with the link"

---

## 📸 Screenshots to Capture

### Required Screenshots

1. **add-product-form.png**
   - Empty form with all fields visible
   - Show validation indicators

2. **add-product-filled.png**
   - Form filled with valid data
   - Ready to submit

3. **firestore-before-add.png**
   - Firestore Console showing products collection

4. **firestore-after-add.png**
   - New document visible
   - Highlight `createdAt` and `updatedAt` timestamps

5. **farmer-dashboard.png**
   - List of products
   - Edit, Hide, Delete buttons visible

6. **edit-product-form.png**
   - Pre-filled form
   - "Update Product" button

7. **firestore-after-update.png**
   - Updated field values
   - Highlight changed `updatedAt` timestamp

8. **delete-confirmation.png**
   - Confirmation dialog
   - Product name displayed

### How to Capture

**Windows:**
- Press `Windows + Shift + S`
- Select area to capture
- Paste into Paint or save

**Mac:**
- Press `Cmd + Shift + 4`
- Select area
- Screenshot saved to Desktop

**Save Location:**
```
farm2home_app/screenshots/
```

---

## 🧪 Validation Testing

### Test Invalid Inputs

1. **Empty Name:**
   - Leave name field blank
   - Click submit
   - ✅ Should show "Product name is required"

2. **Short Name:**
   - Enter "AB" (2 chars)
   - ✅ Should show "Name must be at least 3 characters"

3. **Empty Price:**
   - Leave price blank
   - ✅ Should show "Price is required"

4. **Zero Price:**
   - Enter 0
   - ✅ Should show "Invalid price"

5. **Negative Price:**
   - Enter -5
   - ✅ Should show "Invalid price"

6. **Short Description:**
   - Enter "Short" (5 chars)
   - ✅ Should show "Description must be at least 10 characters"

7. **Negative Stock:**
   - Enter -10
   - ✅ Should show "Invalid stock quantity"

---

## 🔧 Troubleshooting

### Problem: "User not authenticated" error

**Solution:**
```dart
// Verify you're logged in
final user = AuthService().currentUser;
print(user?.email); // Should print your email
```

### Problem: Dashboard shows no products

**Reasons:**
1. No products added yet (expected)
2. Not viewing correct farmer's products
3. Firestore rules blocking read

**Solution:**
```dart
// Check Firestore Console
// Verify products collection has documents
// Verify farmerId matches your user.uid
```

### Problem: Changes not appearing in Firestore

**Check:**
1. Internet connection
2. Firestore rules allow writes
3. Console shows any errors
4. Check Flutter debug console for errors

### Problem: StreamBuilder not updating

**Solution:**
```dart
// Verify StreamBuilder is using correct stream
StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('products')
      .where('farmerId', isEqualTo: user.uid)
      .snapshots(), // Must be snapshots(), not get()
  ...
)
```

---

## 📊 Firestore Console Verification

### Navigate to Console
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Click "Firestore Database"
4. Navigate to `products` collection

### Verify Document Structure

**After Add:**
```javascript
{
  "name": "Test Product",
  "description": "This is a test product",
  "price": 5.99,
  "unit": "per item",
  "category": "vegetables",
  "imageIcon": "🧪",
  "isAvailable": true,
  "stock": 25,
  "farmerId": "abc123...",  // Your user UID
  "rating": 0,
  "reviewCount": 0,
  "createdAt": Timestamp(2026, 2, 6, 10, 30, 45),  // Server timestamp
  "updatedAt": Timestamp(2026, 2, 6, 10, 30, 45)   // Same as createdAt initially
}
```

**After Update:**
```javascript
{
  ...
  "price": 7.99,  // Changed
  "updatedAt": Timestamp(2026, 2, 6, 10, 35, 12)  // New timestamp
}
```

---

## ✅ Final Checklist

Before submitting PR:

**Code:**
- [ ] `flutter analyze` passes with 0 issues
- [ ] All screens work without crashes
- [ ] Add operation creates documents
- [ ] Update operation modifies documents
- [ ] Delete operation removes documents
- [ ] Validation blocks invalid data
- [ ] Error messages are user-friendly
- [ ] Loading states display during operations

**Documentation:**
- [ ] README.md updated with Sprint 4 section
- [ ] Code snippets included
- [ ] Reflection written (200+ words)
- [ ] Screenshots captured (8 images)
- [ ] Video recorded (2 minutes)

**Testing:**
- [ ] Manual testing complete
- [ ] All test cases passed
- [ ] Firestore Console verified
- [ ] Real-time updates confirmed

**Git:**
- [ ] Changes committed
- [ ] Descriptive commit message
- [ ] PR created with template
- [ ] Video link in PR description

---

## 🎓 Quick Reference

### Service Methods
```dart
// Add
final id = await firestoreService.addProduct(data);

// Set (overwrites)
await firestoreService.setProduct(id, data);

// Set with merge (partial)
await firestoreService.setProductMerge(id, updates);

// Update (only specified fields)
await firestoreService.updateProduct(id, updates);

// Delete
await firestoreService.deleteProduct(id);
```

### Navigation
```dart
// Go to Farmer Dashboard
Navigator.pushNamed(context, '/farmer-dashboard');

// Go to Add Product
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const ProductManagementScreen(),
  ),
);

// Go to Edit Product
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ProductManagementScreen(
      productToEdit: product,
    ),
  ),
);
```

---

## 📞 Support

**Issues?**
- Check Flutter debug console for errors
- Verify Firestore rules allow writes
- Ensure user is authenticated
- Check network connection

**Questions?**
- Review [FIRESTORE_WRITE_OPERATIONS_COMPLETE.md](FIRESTORE_WRITE_OPERATIONS_COMPLETE.md)
- Check [README.md Sprint 4 section](README.md#firestore-write--update-operations-sprint-4)
- Review Firebase documentation

---

**Ready to Test!** 🚀

Start with Step 1 and work through each operation systematically.
