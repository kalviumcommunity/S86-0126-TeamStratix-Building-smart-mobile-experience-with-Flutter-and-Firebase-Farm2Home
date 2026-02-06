# ⚡ Quick Start: Testing Persistent Sessions

## 🎯 TL;DR - Test in 3 Minutes

### Prerequisites
- Flutter app with Firebase Auth configured
- One test user account

---

## 📱 Quick Test Steps

### 1️⃣ Login Test (30 seconds)
```bash
# Run the app
flutter run -d windows  # or chrome, or your device

# In the app:
1. Wait for splash screen
2. Enter email/password
3. Click Login
4. ✅ Verify: HomeScreen appears with email
```

---

### 2️⃣ Auto-Login Test (1 minute) ⭐ **MOST IMPORTANT**
```bash
# With app running and logged in:
1. Close the app COMPLETELY
   - Windows: Close window
   - Chrome: Close tab
   - Mobile: Swipe away from recent apps

2. Wait 5 seconds

3. Reopen the app

4. ✅ Verify: 
   - Splash screen appears briefly
   - App goes DIRECTLY to HomeScreen
   - NO login screen
   - Email still displayed
```

**❌ If login screen appears → Auto-login NOT working**

---

### 3️⃣ Logout Test (30 seconds)
```bash
# From HomeScreen:
1. Click logout icon (top-right)
2. ✅ Verify: Redirected to LoginScreen

3. Close app
4. Reopen app
5. ✅ Verify: LoginScreen appears (NOT HomeScreen)
```

---

## ✅ Success Checklist

- [ ] Splash screen shows on app start
- [ ] Login redirects to HomeScreen
- [ ] **Auto-login works after restart** ⭐
- [ ] Logout redirects to LoginScreen
- [ ] Login screen shows after logout + restart

---

## 🎥 Record Video Demo

**Total Time**: 60-90 seconds

1. **Start Recording** 📹
2. **Login** (10 sec)
   - "Logging in..."
3. **Show HomeScreen** (5 sec)
   - "Now logged in, you can see my email here..."
4. **Close App** (10 sec)
   - "Closing the app completely..."
   - Show task manager/app switcher
5. **Reopen App** (10 sec)
   - "Reopening the app..."
6. **Show Auto-Login** (10 sec) ⭐
   - "And I'm automatically logged in! No need to enter credentials again."
7. **Logout** (10 sec)
   - "Now let me logout..."
8. **Close & Reopen** (10 sec)
   - "Closing and reopening..."
9. **Show LoginScreen** (5 sec)
   - "Correctly shows login screen after logout."
10. **Stop Recording** 🛑

---

## 🚀 Submit PR

### Commit & Push
```bash
cd d:\Farm2Home\farm2home_app

git add .
git commit -m "feat: implemented persistent user session handling with Firebase Auth"
git push origin main
```

### Create PR
1. Go to GitHub repository
2. Click "New Pull Request"
3. Title: `[Sprint-2] Persistent Login State (Auto-Login) – YourTeamName`
4. Description:
```markdown
## Persistent Sessions Implementation

✅ Auto-login after app restart
✅ Splash screen during auth check
✅ Automatic navigation via AuthWrapper
✅ Clean logout functionality

### Video Demo
[Your video link here]

### Changes
- Created SplashScreen widget
- Enhanced AuthWrapper with authStateChanges()
- Removed manual navigation from auth screens
- Updated README with comprehensive docs

### Testing
Tested on: [Windows/Chrome/Android]
✅ All test cases passed
```

---

## 📸 Screenshot Guide

### Required Screenshots (5 total)

1. **Splash Screen**
   - Capture while loading

2. **Login Screen**
   - Before login

3. **HomeScreen**
   - After successful login
   - Show email in AppBar

4. **Auto-Login**
   - HomeScreen after app restart
   - Add caption: "Automatically logged in after restart"

5. **Logout**
   - LoginScreen after logout

### How to Capture
- Windows: `Win + Shift + S`
- Mac: `Cmd + Shift + 4`
- Mobile: Volume Down + Power

---

## 🆘 Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| Login screen after restart | Check AuthWrapper uses `authStateChanges()` |
| Stuck on splash screen | Check Firebase initialization |
| Logout doesn't work | Verify `FirebaseAuth.instance.signOut()` called |
| Navigation conflicts | Remove manual navigation from login/signup |

---

## 📚 Full Documentation

- **Detailed Guide**: `TESTING_GUIDE_PERSISTENT_SESSIONS.md`
- **Submission Checklist**: `PERSISTENT_SESSIONS_SUBMISSION_CHECKLIST.md`
- **Implementation Summary**: `IMPLEMENTATION_COMPLETE_PERSISTENT_SESSIONS.md`
- **README Section**: `README.md` (Persistent Sessions)

---

## ✨ Key Files Changed

### New Files ✅
- `lib/screens/splash_screen.dart`
- `TESTING_GUIDE_PERSISTENT_SESSIONS.md`
- `PERSISTENT_SESSIONS_SUBMISSION_CHECKLIST.md`
- `IMPLEMENTATION_COMPLETE_PERSISTENT_SESSIONS.md`

### Modified Files ✏️
- `lib/main.dart` - Enhanced AuthWrapper
- `lib/screens/login_screen.dart` - Removed manual navigation
- `lib/screens/signup_screen.dart` - Removed manual navigation
- `README.md` - Added documentation

---

## 🎯 Remember

**Most Important Test**: 
👉 Close app → Reopen → Should auto-login to HomeScreen

**That's the whole point of persistent sessions!**

---

**Good Luck! 🚀**

Need help? Check the full guides or contact your instructor.
