# Release Build Testing & Verification Checklist

## Complete Build and Testing Guide

This checklist guides you through building a release APK/AAB and testing it thoroughly.

---

## Phase 1: Pre-Build Verification

### Configuration Check

- [ ] JDK installed and working
- [ ] `android/app/app-release-key.jks` exists
- [ ] `android/key.properties` created
- [ ] `.gitignore` includes `key.properties`
- [ ] `gradle/build.gradle.kts` has signing config
- [ ] `pubspec.yaml` version updated
- [ ] `google-services.json` in `android/app/`
- [ ] Firebase Console has SHA-1 and SHA-256 added

### File Structure Verification

```powershell
# Verify all required files
ls android/app/app-release-key.jks        # Should exist
ls android/key.properties                 # Should exist
ls android/app/google-services.json       # Should exist
cat pubspec.yaml | findstr "version:"     # Check version
```

**Expected Output:**
```
✓ android/app/app-release-key.jks exists
✓ android/key.properties exists
✓ android/app/google-services.json exists
✓ version: 1.0.0+1 (or higher)
```

### Clean Project

```powershell
cd farm2home_app
flutter clean
flutter pub get
```

**Expected Output:**
```
✓ Flutter clean completed
✓ Dependencies resolved
✓ No errors reported
```

---

## Phase 2: Build Release APK

### Step 1: Run Build Command

```powershell
cd farm2home_app
flutter build apk --release
```

### Step 2: Monitor Build Progress

**Expected Output Sequence:**

```
Running Gradle assemble...
```
↓
```
> Task :app:compileLintVitalRelease
> Task :app:compileReleaseKotlin
> Task :app:compileReleaseJavaWithJavac
> Task :app:bundleReleaseResources
```
↓
```
> Task :app:createReleaseApkListingFileRedacted
> Task :app:signReleaseApk
> Task :app:zipalignReleaseApk
```
↓
```
✓ Built build/app/outputs/flutter-apk/app-release.apk (XX.X MB)
```

**Total Time:** 2-5 minutes

### Step 3: Verify APK Generated

```powershell
# Check if APK exists
ls build/app/outputs/flutter-apk/app-release.apk

# Check file size
ls -lh build/app/outputs/flutter-apk/app-release.apk
```

**Expected Output:**
```
Mode    LastWriteTime         Length Name
----    --------------------  ------ ----
-a---   2/16/2026 11:30 AM   XX.X MB app-release.apk
```

**File Size Guidelines:**
- Normal app: 40-80 MB
- Large app: 80-150 MB
- Size > 200 MB: May need optimization

### Checklist for APK Build

- [ ] Build completed without errors
- [ ] No red error messages in console
- [ ] APK file exists at correct location
- [ ] File size is reasonable (< 200 MB)
- [ ] Build time was reasonable (2-5 min)
- [ ] No "warning" messages about signing
- [ ] Gradle build didn't request password input

---

## Phase 3: Verify APK Signing

### Step 1: Check APK Signature

```powershell
jarsigner -verify -verbose build/app/outputs/flutter-apk/app-release.apk
```

**Expected Output:**
```
jar verified.
```

**OR with more details:**

```powershell
jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk
```

### Step 2: Extract Certificate Info

```powershell
$apkPath = "build/app/outputs/flutter-apk/app-release.apk"

# Verify the signature
jarsigner -verify -verbose -certs $apkPath | findstr "CN="
```

**Expected Output:**
```
✓ Signature verified

CN=Upload Key Certificate
```

### Checklist for Signing Verification

- [ ] APK signature verified successfully
- [ ] Certificate shows "CN=Upload Key Certificate" (or your name)
- [ ] No "error" messages in verification
- [ ] No tampering detected

---

## Phase 4: Install and Test on Device

### Step 1: Connect Physical Device or Emulator

```powershell
# List connected devices
flutter devices
```

**Expected Output:**
```
Found 2 connected devices:
  Android (android) • emulator-5554 • android-33  • Android 13
  (mobile)         • FA57W0305516 • android-13  • Android 13
```

- [ ] At least one device/emulator connected
- [ ] Device shows "android-XX" (not emulator recommended for testing)

### Step 2: Install APK on Device

**Option A: Using flutter**
```powershell
flutter install --release
```

**Option B: Using adb directly**
```powershell
adb install build/app/outputs/flutter-apk/app-release.apk
```

**Expected Output:**
```
Performing Streamed Install
Success
```

**Or with adb:**
```
Success:
```

### Step 3: Verify Installation

```powershell
adb shell pm list packages | findstr farm2home
```

**Expected Output:**
```
package:com.example.farm2home_app
```

### Installation Checklist

- [ ] Installation completed without errors
- [ ] App appears on device home screen
- [ ] Package listed in installed apps
- [ ] Previous debug version was replaced
- [ ] Installation took < 30 seconds

---

## Phase 5: Test Release APK Features

### Launch App

- [ ] App launches successfully (< 3 seconds)
- [ ] Splash screen displays
- [ ] No "debug" banner visible in top-right corner ← **CRITICAL**
- [ ] App initializes without crashes
- [ ] No error dialogs appear

### UI & Layout Tests

- [ ] Home screen displays correctly
- [ ] All buttons are functional
- [ ] Text is readable
- [ ] Images load properly
- [ ] No layout overflow or cutting
- [ ] Status bar displays correctly

### Navigation Tests

- [ ] Can navigate between screens
- [ ] Back button works correctly
- [ ] Named routes resolve properly
- [ ] No navigation-related crashes
- [ ] Drawer/menu functions (if applicable)

### Firebase & Auth Tests

- [ ] Firebase initializes automatically
- [ ] Authentication screen works
- [ ] Login/Signup processes function
- [ ] No Firebase error dialogs
- [ ] User sessions persist
- [ ] Database reads work correctly
- [ ] Cloud Storage access works (if used)

### Location & Maps Tests (if applicable)

- [ ] Location permission request appears
- [ ] Can grant location permission
- [ ] Maps load successfully
- [ ] Location services work properly
- [ ] No permission-related crashes

### Permission Handling Tests

- [ ] Runtime permissions request appears
- [ ] Can grant/deny permissions
- [ ] App handles denied permissions gracefully
- [ ] Permissions persist after app restart
- [ ] No permission-related errors in console

### Performance Tests

- [ ] App responds quickly to taps
- [ ] Navigation is smooth (no lag)
- [ ] Scrolling is smooth (60 FPS)
- [ ] No freezing or stuttering
- [ ] Memory usage stable
- [ ] No excessive battery drain during 5-min use

### Feature Tests (as per app requirements)

- [ ] Product listing displays (if applicable)
- [ ] Cart functionality works (if applicable)
- [ ] Data persistence works correctly
- [ ] Real-time updates sync (Firebase)
- [ ] Image uploads/downloads work
- [ ] Notifications appear (if FCM used)

### Crash Handling

- [ ] No unexpected crashes
- [ ] Error dialogs display properly
- [ ] Network errors handled gracefully
- [ ] Null values handled (no null pointer exceptions)

### Release Build Characteristics

- [ ] No yellow debug banner
- [ ] No debug logs in console
- [ ] Code is obfuscated (if ProGuard enabled)
- [ ] Performance is optimal
- [ ] Firebase works in production mode

---

## Phase 6: Console Log Analysis

### Check Logcat for Errors

```powershell
adb logcat | findstr -i error
```

**Expected Output:**
```
(Empty or only non-critical warnings)
```

### Look for Warnings

```powershell
adb logcat | findstr -i warning
```

**Expected:** Only minor Android system warnings, NOT app warnings

### Firebase Initialization Check

```powershell
adb logcat | findstr "firebase"
```

**Expected Output:**
```
I/FA: Firebase initialized successfully
```

### Checklist for Console Analysis

- [ ] No ERROR level messages from app
- [ ] No FATAL level messages from app
- [ ] Firebase logs show successful initialization
- [ ] No stack traces related to app code
- [ ] Warnings are only system-level, not app-level

---

## Phase 7: Build App Bundle (AAB) - Optional

*Only if planning to publish on Google Play Store*

### Step 1: Build AAB

```powershell
flutter build appbundle --release
```

### Step 2: Monitor Build

**Expected Output:**
```
Running Gradle bundleRelease...
✓ Built build/app/outputs/bundle/release/app-release.aab (XX.X MB)
```

### Step 3: Verify AAB Generated

```powershell
ls build/app/outputs/bundle/release/app-release.aab
```

**Expected Output:**
```
Mode    LastWriteTime         Length Name
----    --------------------  ------ ----
-a---   2/16/2026 11:35 AM   XX.X MB app-release.aab
```

### Checklist for AAB Build

- [ ] Build completed without errors
- [ ] AAB file exists at correct location
- [ ] File size is smaller than APK (normal)
- [ ] Build took 2-5 minutes

---

## Phase 8: Uninstall and Reinstall Test

### Clean Installation Test

```powershell
adb uninstall com.example.farm2home_app
adb install build/app/outputs/flutter-apk/app-release.apk
```

**Expected:** Fresh install, first launch, all permissions requested

### Verification

- [ ] Uninstall succeeded
- [ ] Reinstall succeeded
- [ ] First-run experience works
- [ ] All permission prompts appear
- [ ] App initializes fresh (no stale data)
- [ ] All features work on fresh install

---

## Phase 9: Final Documentation

### Build Information Summary

```
Release Build Summary:
- Build Type: APK ✓ / AAB ✓
- File Size: [XX.X MB]
- Build Duration: [X minutes]
- Android Minimum API: [Level XX]
- Firebase: Enabled ✓ / Disabled ✓
- Debug Banner: None (Confirmed) ✓
- Signing: Successful ✓
```

### Testing Results Summary

```
Feature Testing: All Passed ✓
- Authentication: ✓
- Navigation: ✓
- Permissions: ✓
- Firebase: ✓
- UI/Layout: ✓
- Performance: ✓

Release Build Quality: PRODUCTION READY ✓
```

### Screenshots to Capture

- [ ] Home screen (no debug banner visible)
- [ ] App drawer/menu (if applicable)
- [ ] Firebase data loading
- [ ] Permissions request dialog
- [ ] Maps/Location feature (if applicable)
- [ ] Console output showing successful build
- [ ] APK file in file explorer showing file size
- [ ] Device showing app installed and running

---

## Troubleshooting Guide

| Issue | Symptom | Solution |
|-------|---------|----------|
| **Build fails with signing error** | `Signing config not found` | 1. Check key.properties exists<br>2. Verify .gitignore<br>3. Run `flutter clean && flutter pub get` |
| **APK won't install** | `INSTALL_FAILED_*` error | 1. Uninstall old version: `adb uninstall com.example.farm2home_app`<br>2. Try again<br>3. Check device storage (needs 100+ MB free) |
| **App crashes on startup** | Black screen or immediate crash | 1. Check logcat: `adb logcat`<br>2. Look for Firebase errors<br>3. Verify google-services.json present<br>4. Check SHA-1 in Firebase Console |
| **Debug banner visible** | "Debug" text in top corner | 1. This shouldn't happen in release<br>2. Delete old debug APK first<br>3. Run `flutter clean && flutter build apk --release` |
| **Firebase auth not working** | Login fails in release APK | 1. Add SHA-1 fingerprint to Firebase<br>2. Download new google-services.json<br>3. Replace android/app/google-services.json<br>4. Rebuild APK |
| **App much slower than debug** | 1-2 second delay in actions | 1. Normal: Release has less debug overhead BUT code optimization<br>2. Check for network latency<br>3. Monitor memory usage |
| **APK file size too large** | > 200 MB | 1. Enable minify: `minifyEnabled = true`<br>2. Enable shrinkResources: `shrinkResources = true`<br>3. Check for unused dependencies |

---

## Final Verification Checklist

Before moving to PR creation:

- [ ] Release APK built successfully without errors
- [ ] APK file exists and is properly signed
- [ ] APK signature verified successfully
- [ ] APK installed on device without errors
- [ ] App launches without crashes
- [ ] No debug banner visible
- [ ] All core features tested and working
- [ ] Firebase functional in release mode
- [ ] Permissions handled correctly
- [ ] Performance acceptable
- [ ] Console logs show no errors from app
- [ ] Screenshots captured for evidence
- [ ] Build configuration documented

**When all items checked: Ready for PR and video recording!**

---

**Status: Build Complete & Verified** ✅  
**Next Steps:** 
1. Create GitHub PR with changes
2. Record video demonstration
3. Upload to Google Drive
4. Submit both URLs

Good luck! 🚀
