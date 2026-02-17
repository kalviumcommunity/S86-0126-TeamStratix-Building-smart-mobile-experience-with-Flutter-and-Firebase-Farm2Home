# 🚀 Quick Start Guide - Testing Phase 2 Features

This guide will help you quickly test all the new Phase 2 features.

---

## 🔧 Prerequisites

Before testing, ensure you have:
- ✅ Flutter SDK installed
- ✅ Firebase project configured
- ✅ Dependencies installed (`flutter pub get`)
- ✅ Android/iOS emulator or physical device

---

## 📱 Step-by-Step Testing Guide

### 1. Initial Setup (5 minutes)

```bash
# Navigate to project directory
cd farm2home_demo

# Get dependencies (if not done)
flutter pub get

# Run the app
flutter run
```

### 2. Create Test Accounts

#### Create Customer Account
1. Launch app
2. Tap "Sign Up"
3. Enter:
   - Name: Test Customer
   - Email: customer@test.com
   - Password: test123
   - Role: Customer
4. Tap "Sign Up"

#### Create Farmer Account
1. Logout (or use another device/browser)
2. Tap "Sign Up"
3. Enter:
   - Name: Test Farmer
   - Email: farmer@test.com
   - Password: test123
   - Role: Farmer
4. Tap "Sign Up"

#### Create Admin Account (Optional)
1. Go to Firebase Console
2. Navigate to Firestore Database
3. Find the `users` collection
4. Create a new document:
```json
{
  "uid": "generate_random_id",
  "name": "Admin User",
  "email": "admin@test.com",
  "role": "admin",
  "createdAt": "current_timestamp"
}
```
5. Create Firebase Auth user with same email

---

## ✨ Testing Each Feature

### 🔔 Test Push Notifications

**As Customer:**
1. Login as customer
2. Place an order
3. Check notification bell icon - should show unread count
4. Tap notification bell
5. View notification for order creation

**As Farmer:**
1. Login as farmer
2. Update order status
3. Check notification appears for customer
4. Mark notification as read
5. Swipe to dismiss notification

**Expected Results:**
- ✅ Unread badge shows count
- ✅ Notifications appear in list
- ✅ Can mark as read
- ✅ Can dismiss notifications
- ✅ Tapping navigates to relevant screen

---

### 💬 Test In-App Messaging

**Setup:**
1. Login as customer
2. Navigate to an order
3. Find "Message" or chat icon

**Test Flow:**
1. Tap "Message" button
2. Type a message: "When will my order arrive?"
3. Send message
4. Switch to farmer account
5. Check message icon - should show unread badge
6. Tap message icon to view conversations
7. Open conversation with customer
8. Reply: "Your order will arrive tomorrow"
9. Switch back to customer
10. Check real-time message appears

**Expected Results:**
- ✅ Messages send instantly
- ✅ Real-time delivery (no refresh needed)
- ✅ Unread count updates
- ✅ Conversations list shows latest message
- ✅ Timestamps display correctly
- ✅ Message bubbles styled differently for sender/receiver

---

### ⭐ Test Rating System

**Prerequisite:** Order must be in "Delivered" status

**Test Flow:**
1. Login as farmer
2. Find pending order
3. Update status to "Delivered"
4. Login as customer
5. Navigate to order details
6. Look for "Rate This Order" button
7. Tap "Rate This Order"
8. Select 5 stars
9. Write review: "Excellent quality produce!"
10. Submit rating
11. Login as farmer
12. Check notification for new rating
13. View farmer profile to see updated rating

**Expected Results:**
- ✅ Rating button only appears for delivered orders
- ✅ Can select 1-5 stars (with half stars)
- ✅ Can write optional review
- ✅ Farmer receives notification
- ✅ Farmer stats update (average rating, total)
- ✅ Can't rate same order twice

---

### 💳 Test Payment System

**Test Flow:**
1. Login as customer
2. Browse products
3. Add items to cart
4. Proceed to checkout
5. Fill order details
6. Place order
7. You'll be directed to payment screen
8. View available payment methods:
   - Cash on Delivery
   - Credit/Debit Card
   - UPI
9. Select "Cash on Delivery"
10. Tap "Pay" button
11. View success message
12. Check order status - should show payment status

**Test Different Payment Methods:**
```dart
// For demonstration:
- COD: Always succeeds immediately
- Card: 90% success rate (simulated)
- UPI: 90% success rate (simulated)
```

**Expected Results:**
- ✅ All payment methods visible
- ✅ Can select payment method
- ✅ Payment processes correctly
- ✅ Success/failure message appears
- ✅ Order payment status updates
- ✅ Transaction record created in Firestore

---

### 🔐 Test Admin Dashboard

**Test Flow:**
1. Login with admin credentials
2. Navigate to Admin Dashboard
3. Check Overview tab:
   - Total users count
   - Total orders count
   - Total products count
   - Total ratings count
4. Click on "Users" in sidebar
5. View all users
6. Try deleting a test user
7. Click on "Orders" in sidebar
8. View all orders with status
9. Click on "Products" in sidebar
10. View products in grid
11. Click on "Ratings" in sidebar
12. View all ratings and reviews

**Expected Results:**
- ✅ Dashboard loads with statistics
- ✅ All tabs work correctly
- ✅ Real-time data updates
- ✅ Can delete users (with confirmation)
- ✅ Orders display with correct status colors
- ✅ Products show in grid layout
- ✅ Ratings display with customer info

---

## 🧪 Advanced Testing

### Test Real-time Updates

**Two Device Test:**
1. Open app on Device 1 (Customer)
2. Open app on Device 2 (Farmer)
3. Customer places order
4. Farmer should see notification immediately
5. Farmer updates order status
6. Customer should see notification immediately
7. Customer sends message
8. Farmer should see message badge update
9. Farmer opens chat
10. Farmer sends reply
11. Customer should see message appear without refresh

### Test Error Handling

**Test scenarios:**
1. Try to rate an order that's not delivered (should fail)
2. Try to rate same order twice (should fail)
3. Try to access admin dashboard as customer (should redirect)
4. Send empty message (should not send)
5. Submit rating without selecting stars (should validate)

### Test Data Persistence

1. Place order with payment
2. Close app completely
3. Reopen app
4. Check order still shows correct payment status
5. Check messages are still there
6. Check notifications persist

---

## 📊 Feature Checklist

Use this checklist to verify all features work:

### Notifications ✅
- [ ] Receive notification for new order
- [ ] Receive notification for status update
- [ ] Receive notification for new message
- [ ] Receive notification for new rating
- [ ] Unread badge shows correct count
- [ ] Can mark as read
- [ ] Can dismiss notification
- [ ] Tap navigation works

### Messaging ✅
- [ ] Can send message
- [ ] Can receive message in real-time
- [ ] Unread count updates
- [ ] Conversations list shows all chats
- [ ] Can view message history
- [ ] Timestamps display correctly
- [ ] Messages persist after app restart

### Ratings ✅
- [ ] Can rate delivered order
- [ ] Can select 1-5 stars
- [ ] Can write review
- [ ] Farmer receives notification
- [ ] Rating stats update
- [ ] Can view farmer's rating
- [ ] Cannot rate twice
- [ ] Cannot rate non-delivered order

### Payments ✅
- [ ] Can select payment method
- [ ] COD works
- [ ] Card processing works (simulated)
- [ ] UPI processing works (simulated)
- [ ] Success message appears
- [ ] Failure message appears (on failure)
- [ ] Payment status saves
- [ ] Transaction record created

### Admin Dashboard ✅
- [ ] Overview statistics load
- [ ] Users list displays
- [ ] Can delete user
- [ ] Orders list displays
- [ ] Products grid displays
- [ ] Ratings list displays
- [ ] Sidebar navigation works
- [ ] Data updates in real-time

---

## 🐛 Common Issues & Solutions

### Issue: Notifications not working
**Solution:**
- Check Firebase configuration
- Ensure google-services.json is in android/app/
- Enable FCM in Firebase Console
- Request notification permissions on iOS

### Issue: Messages not updating
**Solution:**
- Check internet connection
- Verify Firestore rules allow read/write
- Ensure user is authenticated
- Check Firebase Console for errors

### Issue: Can't see rating button
**Solution:**
- Ensure order status is "Delivered"
- Check if order already rated
- Verify user is the customer of the order

### Issue: Payment fails every time
**Solution:**
- Check order was created successfully
- Verify payment service initialization
- Check Firebase Console logs
- Ensure internet connection is stable

### Issue: Admin dashboard not accessible
**Solution:**
- Verify user role is "admin" in Firestore
- Check if user document exists
- Ensure proper authentication
- Review Firebase security rules

---

## 📸 Screenshot Checklist

Take screenshots of:
- [ ] Notifications screen with badges
- [ ] Chat screen with messages
- [ ] Rating screen with stars
- [ ] Payment selection screen
- [ ] Admin dashboard overview
- [ ] Conversations list
- [ ] Order with all action buttons
- [ ] Farmer profile with ratings

---

## 🎯 Performance Testing

### Test Load Times
- App launch: Should be < 3 seconds
- Screen navigation: Should be instant
- Message send: Should be < 1 second
- Notification appear: Should be < 2 seconds
- Real-time updates: Should be instant

### Test with Multiple Orders
1. Create 10+ orders
2. Check if lists scroll smoothly
3. Verify pagination works
4. Check memory usage
5. Ensure no lag

---

## ✅ Final Verification

Before considering testing complete:

1. **All features tested** - Check each feature works
2. **No errors** - Run `flutter analyze`
3. **No crashes** - App runs without crashes
4. **Real-time works** - Updates happen without refresh
5. **Notifications work** - All notification types deliver
6. **Messaging works** - Chat is real-time
7. **Ratings work** - Can rate and view stats
8. **Payments work** - All methods process
9. **Admin works** - Dashboard accessible and functional

---

## 🚀 Ready for Production?

If all tests pass:
- ✅ Features work as expected
- ✅ No critical bugs found
- ✅ Real-time updates work
- ✅ Error handling is proper
- ✅ UI is responsive

**Your app is ready for production deployment!** 🎉

---

## 📞 Need Help?

If you encounter issues:
1. Check Firebase Console for errors
2. Review Flutter logs: `flutter logs`
3. Check Firestore rules
4. Verify internet connection
5. Check authentication status
6. Review PHASE2_FEATURES.md for details
7. Check INTEGRATION_GUIDE.md for examples

---

## 🎊 Congratulations!

You've successfully tested all Phase 2 features! Your Farm2Home app now has:
- Push Notifications ✅
- Real-time Messaging ✅
- Rating System ✅
- Payment Integration ✅
- Admin Dashboard ✅

**Happy farming! 🌾**

---

*Testing Guide Version: 1.0*
*Last Updated: February 16, 2026*
