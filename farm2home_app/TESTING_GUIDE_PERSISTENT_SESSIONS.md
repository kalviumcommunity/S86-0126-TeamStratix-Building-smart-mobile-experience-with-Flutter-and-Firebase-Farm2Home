# Testing Guide: Persistent User Sessions

## Overview
This guide will help you test the persistent user session implementation to verify that auto-login works correctly across app restarts.

---

## Prerequisites
- Firebase Authentication configured in your project
- At least one test user account created (or ability to create new account)
- Device/emulator to run the app (Windows, Chrome, or Mobile device)

---

## Test Cases

### ✅ Test Case 1: First-Time Login
**Objective**: Verify that users can log in successfully

**Steps:**
1. Launch the app
2. You should see the **SplashScreen** briefly (loading animation)
3. App should navigate to **LoginScreen** (since no user is logged in)
4. Enter valid credentials:
   - Email: `test@example.com`
   - Password: `password123`
5. Click **Login** button

**Expected Results:**
- ✅ SplashScreen appears briefly during auth check
- ✅ LoginScreen displays with email and password fields
- ✅ Success message "Login successful!" appears
- ✅ App automatically navigates to **HomeScreen**
- ✅ User email appears in AppBar
- ✅ Logout button visible in AppBar

---

### ✅ Test Case 2: Auto-Login After App Restart (Main Test)
**Objective**: Verify persistent login state across app restarts

**Steps:**
1. Ensure you're logged in (from Test Case 1)
2. You should be on **HomeScreen** with user email visible
3. **Fully close the app** (not just minimize):
   - Windows: Close the window completely
   - Chrome: Close the browser tab
   - Mobile: Swipe away from recent apps
4. Wait 5 seconds
5. **Reopen the app**

**Expected Results:**
- ✅ SplashScreen appears briefly (Firebase checking session)
- ✅ App **automatically navigates to HomeScreen** WITHOUT showing LoginScreen
- ✅ User email still displayed in AppBar
- ✅ No need to enter credentials again
- ✅ Session persisted successfully

**If This Fails:**
- ❌ App shows LoginScreen after restart → Session NOT persisting
- Check Firebase configuration and AuthWrapper implementation

---

### ✅ Test Case 3: Multiple Restarts
**Objective**: Verify session persists across multiple app restarts

**Steps:**
1. Ensure you're logged in
2. Close the app completely
3. Reopen the app → Should go to HomeScreen
4. Close the app again
5. Reopen the app → Should still go to HomeScreen
6. Repeat 2-3 more times

**Expected Results:**
- ✅ Every restart should show HomeScreen automatically
- ✅ No prompts to log in again
- ✅ Session remains valid indefinitely

---

### ✅ Test Case 4: Logout and Session Termination
**Objective**: Verify logout properly clears session

**Steps:**
1. Ensure you're logged in on **HomeScreen**
2. Click the **Logout** icon (top-right corner of AppBar)
3. Observe the app behavior

**Expected Results:**
- ✅ "Logged out successfully" message appears
- ✅ App automatically navigates to **LoginScreen**
- ✅ No user email visible (since logged out)

**Now Test Persistence After Logout:**
4. Close the app completely
5. Reopen the app

**Expected Results:**
- ✅ App shows **LoginScreen** (NOT HomeScreen)
- ✅ Session was properly cleared
- ✅ User must log in again

---

### ✅ Test Case 5: Sign Up New User
**Objective**: Verify auto-login works for newly created accounts

**Steps:**
1. From **LoginScreen**, click "Sign Up" link
2. Enter new user details:
   - Name: `John Doe`
   - Email: `johndoe@example.com`
   - Password: `SecurePass123`
   - Confirm Password: `SecurePass123`
3. Click **Sign Up** button

**Expected Results:**
- ✅ "Account created successfully!" message appears
- ✅ App automatically navigates to **HomeScreen**
- ✅ New user email appears in AppBar
- ✅ No manual navigation required

**Now Test Auto-Login for New User:**
4. Close the app completely
5. Reopen the app

**Expected Results:**
- ✅ App shows **HomeScreen** with `johndoe@example.com`
- ✅ New user session persisted across restart

---

### ✅ Test Case 6: Session During App Lifecycle Changes
**Objective**: Verify session remains valid during app pause/resume

**Steps:**
1. Login and navigate to **HomeScreen**
2. **Minimize** the app (don't close it):
   - Windows: Minimize window
   - Mobile: Press home button (app goes to background)
3. Wait 30 seconds
4. **Resume** the app (bring it back to foreground)

**Expected Results:**
- ✅ HomeScreen still displayed
- ✅ User still logged in
- ✅ No need to re-authenticate
- ✅ Session maintained during app pause

---

## Troubleshooting

### Issue: App shows LoginScreen after restart (auto-login NOT working)
**Possible Causes:**
1. Firebase not initialized properly
2. AuthWrapper not using `authStateChanges()` correctly
3. Firebase configuration missing

**Solutions:**
- Check `firebase_options.dart` is configured
- Verify `FirebaseAuth.instance.authStateChanges()` is used in AuthWrapper
- Check Firebase Console that user exists

---

### Issue: App gets stuck on SplashScreen
**Possible Causes:**
1. Firebase initialization error
2. Network connectivity issue
3. StreamBuilder not handling connection states properly

**Solutions:**
- Check internet connection
- Look for errors in console/debug logs
- Verify Firebase project is active

---

### Issue: Logout doesn't redirect to LoginScreen
**Possible Causes:**
1. `FirebaseAuth.instance.signOut()` not called
2. AuthWrapper not listening to auth changes

**Solutions:**
- Verify logout button calls `signOut()`
- Check AuthWrapper's `authStateChanges()` stream

---

## Expected File Changes

After implementation, these files should be created/modified:

### New Files:
- ✅ `lib/screens/splash_screen.dart` - Loading screen during auth check

### Modified Files:
- ✅ `lib/main.dart` - Updated AuthWrapper with authStateChanges() and SplashScreen
- ✅ `lib/screens/login_screen.dart` - Removed manual navigation
- ✅ `lib/screens/signup_screen.dart` - Removed manual navigation
- ✅ `README.md` - Added comprehensive persistent sessions documentation

---

## Testing Checklist

Before submitting, verify all these work:

- [ ] ✅ First-time login redirects to HomeScreen
- [ ] ✅ App restart shows HomeScreen automatically (auto-login)
- [ ] ✅ Multiple restarts maintain session
- [ ] ✅ Logout clears session and redirects to LoginScreen
- [ ] ✅ App restart after logout shows LoginScreen
- [ ] ✅ New user sign-up automatically logs in
- [ ] ✅ SplashScreen appears during auth check
- [ ] ✅ User email displays in HomeScreen AppBar
- [ ] ✅ No manual navigation code in login/signup screens
- [ ] ✅ README documentation complete

---

## Video Demo Requirements

Your 1-2 minute video should demonstrate:

1. **Login Flow**
   - Open app → SplashScreen → LoginScreen
   - Enter credentials → Login → Navigate to HomeScreen

2. **Auto-Login After Restart**
   - Show HomeScreen with user email
   - Close app completely (show task manager/app switcher)
   - Reopen app → SplashScreen → HomeScreen automatically
   - **This is the most important part!**

3. **Logout Flow**
   - Click logout button
   - Redirect to LoginScreen
   - Close and reopen app
   - App shows LoginScreen (session cleared)

4. **Narration Tips:**
   - "Here I'm logging in for the first time..."
   - "Now I'm closing the app completely..."
   - "As you can see, when I reopen the app, I'm automatically logged in..."
   - "Now I'll log out..."
   - "After reopening, the app correctly shows the login screen..."

---

## Firebase Console Verification (Optional)

1. Open [Firebase Console](https://console.firebase.google.com/)
2. Navigate to **Authentication** → **Users**
3. Find your test user
4. Observe:
   - **Created** timestamp
   - **Last sign-in** timestamp
   - **User UID**

**What This Shows:**
- Session is managed by Firebase backend
- Token validation happens server-side
- Not just local device storage

---

## Success Criteria

Your implementation is successful if:

✅ **Auto-Login Works** - Users remain logged in after app restarts  
✅ **Logout Works** - Users must log in again after logging out  
✅ **SplashScreen Shows** - Professional loading experience  
✅ **No Manual Navigation** - AuthWrapper handles all routing  
✅ **Documentation Complete** - README has all required sections  
✅ **Code Quality** - No analyzer warnings related to auth flow  

---

## Next Steps

1. ✅ Complete all test cases above
2. ✅ Record video demo showing auto-login
3. ✅ Update README with screenshots
4. ✅ Create Pull Request with:
   - Commit: `feat: implemented persistent user session handling with Firebase Auth`
   - Title: `[Sprint-2] Persistent Login State (Auto-Login) – YourTeamName`
   - Description with explanation, code snippets, screenshots
5. ✅ Upload video to Google Drive/Loom/YouTube (unlisted)
6. ✅ Submit PR with video link

---

**Good Luck! 🚀**
