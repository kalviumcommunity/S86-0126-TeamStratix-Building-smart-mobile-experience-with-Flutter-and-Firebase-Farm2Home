# Real-Time Sync Quick Start Guide

This guide helps you quickly test and verify all real-time synchronization features in Farm2Home.

## Quick Test Workflow (5 Minutes)

### Step 1: Run the App
```bash
cd farm2home_app
flutter run
```

### Step 2: Open Firebase Console
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your Farm2Home project
3. Navigate to **Firestore Database**
4. Keep this tab open alongside your app

### Step 3: Test Collection Listener (Farmer Dashboard)
1. In app: Navigate to **Farmer Dashboard**
2. In console: Click **Start collection** → `products`
3. Add a new document:
   ```json
   {
     "name": "Test Tomatoes",
     "price": 4.99,
     "category": "Vegetables",
     "farmerId": "YOUR_USER_ID",
     "stockQuantity": 50,
     "isAvailable": true,
     "unit": "lb",
     "imageIcon": "🍅",
     "description": "Fresh test tomatoes",
     "createdAt": [Timestamp - Now],
     "updatedAt": [Timestamp - Now]
   }
   ```
4. **Expected**: New product appears in app INSTANTLY ✅

### Step 4: Test Document Listener (Real-Time Demo)
1. In app: Open **Real-Time Sync Demo** screen
2. Navigate to **Document** tab
3. In console: Find your user document in `users` collection
4. Edit the `name` field
5. **Expected**: Name updates in app IMMEDIATELY ✅

### Step 5: Test Change Detection Log
1. In app: Go to **Change Detection** tab in Real-Time Demo
2. In console: Add, update, or delete any product
3. **Expected**: Change log shows real-time notifications ✅

### Step 6: Test Live Order Status
1. In app: Open **Live Order Status** screen
2. In console: Add an order to `orders` collection:
   ```json
   {
     "userId": "YOUR_USER_ID",
     "status": "pending",
     "totalAmount": 25.50,
     "createdAt": [Timestamp - Now]
   }
   ```
3. Update the `status` field to "confirmed"
4. **Expected**: Order status updates INSTANTLY + notification shows ✅

---

## Video Recording Checklist (2 Minutes)

### Scene 1: Collection Listener (30 seconds)
- Show Farmer Dashboard with existing products
- Split screen: App + Firebase Console
- Add new product in console
- **Show**: Product appears instantly in app

### Scene 2: Document Listener (30 seconds)
- Open Real-Time Sync Demo → Document tab
- Split screen: App + Console
- Edit user name in console
- **Show**: Name changes instantly in app

### Scene 3: Real-Time Order Tracking (40 seconds)
- Show Live Order Status screen
- Update order status in console from "pending" to "confirmed"
- **Show**: Status updates + notification appears
- Update again to "out_for_delivery"
- **Show**: Timeline updates in real-time

### Scene 4: Change Detection (20 seconds)
- Show Change Detection Log tab
- Rapidly add, update, delete products in console
- **Show**: Log populates with change notifications

**Total**: ~2 minutes

---

## Screenshot Capture Instructions

### Required Screenshots (10 images)

1. **realtime_collection_listener.png**
   - Farmer Dashboard showing product list
   - Include "LIVE" indicator if visible

2. **realtime_document_listener.png**
   - Real-Time Demo → Document tab
   - Show user profile with live sync badge

3. **change_detection_log.png**
   - Real-Time Demo → Change Detection tab
   - Show 5-10 change log entries

4. **live_order_status.png**
   - Live Order Status screen
   - Show order with status timeline

5. **console_before_add.png**
   - Firebase Console showing products collection
   - Before adding new product

6. **app_after_instant_sync.png**
   - App showing newly added product
   - Taken immediately after console add

7. **farmer_dashboard_realtime.png**
   - Farmer Dashboard with products
   - Show any real-time indicators

8. **loading_state.png**
   - Any screen showing CircularProgressIndicator
   - "Connecting to Firestore..." message

9. **empty_state.png**
   - Empty product list or orders
   - "No items available" message

10. **error_state.png**
    - Disconnect internet and trigger error
    - Show error icon + retry button

### How to Capture
- **Android Emulator**: Click camera icon in toolbar
- **iOS Simulator**: Cmd+S (Mac) or File > New Screenshot
- **Physical Device**: Volume Down + Power button
- Save to `farm2home_app/screenshots/`

---

## Validation Testing

### Test 1: Collection Snapshot Listener ✅
- [ ] Initial data loads correctly
- [ ] New documents appear instantly when added
- [ ] Updates to documents reflect immediately
- [ ] Deleted documents disappear from list
- [ ] Loading state shows during connection
- [ ] Empty state displays when no data
- [ ] Error state handles network failures

### Test 2: Document Snapshot Listener ✅
- [ ] Document data displays correctly
- [ ] Field updates reflect instantly
- [ ] Timestamp changes are detected
- [ ] Nested field updates work
- [ ] Loading state shows initially
- [ ] Error handling works

### Test 3: Change Detection ✅
- [ ] DocumentChangeType.added detected
- [ ] DocumentChangeType.modified detected
- [ ] DocumentChangeType.removed detected
- [ ] Change log updates in real-time
- [ ] SnackBar notifications appear
- [ ] Timestamps are accurate

### Test 4: StreamBuilder UI ✅
- [ ] UI rebuilds automatically on data change
- [ ] No manual refresh needed
- [ ] setState not called manually
- [ ] Memory leaks prevented (StreamBuilder auto-disposes)
- [ ] Multiple listeners work simultaneously

### Test 5: Connection States ✅
- [ ] ConnectionState.waiting handled
- [ ] snapshot.hasError handled
- [ ] Empty state (!snapshot.hasData) handled
- [ ] Success state displays data
- [ ] Retry button works on error

---

## Troubleshooting

### App doesn't update when console changes
**Possible causes**:
- Firestore rules blocking reads
- Wrong collection/document ID
- Not logged in (userId mismatch)
- Listener not set up correctly

**Solution**:
```dart
// Verify listener is active
StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('products')
      .snapshots(), // Ensure .snapshots() is called!
  builder: (context, snapshot) => ...
)
```

### "Permission Denied" Error
**Solution**:
```javascript
// Firestore Rules - Allow authenticated read
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /products/{product} {
      allow read: if request.auth != null;
    }
  }
}
```

### Memory Leaks / App Slow
**Cause**: Too many listeners or not disposing properly

**Solution**:
- Use `StreamBuilder` (handles disposal automatically)
- Limit queries: `.limit(50)`
- Filter data: `.where('farmerId', isEqualTo: userId)`

### Data Not Loading
**Check**:
1. Firebase Console → Firestore → Verify documents exist
2. Check Firestore Rules allow read
3. Verify user is authenticated
4. Check console for error messages

---

## Firestore Console Verification

### After Each Test
1. Open Firestore Console
2. Navigate to collection
3. Verify document was created/updated/deleted
4. Check timestamp fields updated
5. Confirm data matches app display

### Monitoring Real-Time Activity
- Firestore Console shows real-time updates
- You'll see documents appear/change/disappear
- Useful for debugging sync issues

---

## Final Submission Checklist

### Code ✅
- [ ] realtime_sync_demo_screen.dart created
- [ ] live_order_status_screen.dart created
- [ ] StreamBuilder used in farmer_dashboard_screen.dart
- [ ] FirestoreService has stream methods
- [ ] Connection states handled properly
- [ ] Change detection implemented
- [ ] flutter analyze passes (0 issues)

### Documentation ✅
- [ ] REALTIME_SYNC_DOCUMENTATION.md created
- [ ] QUICK_START_REALTIME_SYNC.md created
- [ ] Code examples provided
- [ ] Screenshots captured (10 images)
- [ ] Reflection written (why real-time matters)

### Testing ✅
- [ ] Collection listener tested
- [ ] Document listener tested
- [ ] Change detection tested
- [ ] Loading states verified
- [ ] Error handling verified
- [ ] Empty states verified

### Video Demo ✅
- [ ] 2-minute video recorded
- [ ] Shows split screen (app + console)
- [ ] Demonstrates instant updates
- [ ] Explains snapshot listeners briefly
- [ ] Uploaded to Drive/Loom/YouTube (unlisted)
- [ ] Link shared with "Anyone with the link"

### Pull Request ✅
- [ ] Branch: `realtime-sync-snapshots`
- [ ] Commit: `feat: implemented real-time Firestore sync using snapshot listeners`
- [ ] PR Title: `[Sprint-2] Real-Time Sync with Firestore Snapshots`
- [ ] PR Description includes:
  - Explanation of listeners
  - Code snippets
  - Screenshots
  - Video link
  - Reflection

---

## Quick Reference

### Collection Listener
```dart
FirebaseFirestore.instance.collection('products').snapshots()
```

### Document Listener
```dart
FirebaseFirestore.instance.collection('users').doc(userId).snapshots()
```

### StreamBuilder Pattern
```dart
StreamBuilder<QuerySnapshot>(
  stream: stream,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return Text('No data');
    }
    return ListView(...);
  },
)
```

### Change Detection
```dart
.snapshots().listen((snapshot) {
  for (var change in snapshot.docChanges) {
    if (change.type == DocumentChangeType.added) {
      // Handle new document
    }
  }
});
```

---

## Next Steps

1. **Test Everything**: Follow the Quick Test Workflow above
2. **Capture Screenshots**: Get all 10 required images
3. **Record Video**: 2-minute demo showing real-time sync
4. **Create PR**: Include all documentation and media
5. **Submit**: Share PR link with instructor

**Need Help?** Check REALTIME_SYNC_DOCUMENTATION.md for detailed explanations!
