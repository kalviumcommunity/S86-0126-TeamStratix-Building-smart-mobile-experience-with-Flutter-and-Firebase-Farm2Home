# Release Build Video Recording Guide

## Complete Recording Script & Instructions

Your video should demonstrate the entire release build process from keystore creation to testing on a device.

**Target Duration:** 4-7 minutes  
**Key Requirement:** Show successful build with no debug banner when running on device

---

## Pre-Recording Setup (10 minutes)

### Equipment & Software
- [ ] Screen recording software ready (OBS Studio, Windows Game Bar, Bandicam, etc.)
- [ ] Microphone tested and working
- [ ] Device connected via USB (for APK installation)
- [ ] Terminal/PowerShell ready
- [ ] VS Code or IDE with project open
- [ ] All notifications silenced (Do Not Disturb ON)
- [ ] Camera (optional but recommended for face-on-camera explanation)

### Project Preparation
- [ ] All configuration files created and in place
- [ ] `android/app/app-release-key.jks` exists
- [ ] `android/key.properties` created (ready to edit)
- [ ] Gradle `build.gradle.kts` configured
- [ ] Project cleaned: `flutter clean`
- [ ] Dependencies updated: `flutter pub get`
- [ ] Device/emulator connected and ready
- [ ] Test recording done (verify quality)

---

## Recording Script & Shot Breakdown

### **SECTION 1: Introduction (30-45 seconds)**

#### Shot 1a: Face-to-Camera Introduction (Optional but Recommended)

**Narration:**
```
"Hi! In this video, I'll demonstrate the complete process of 
preparing and building a release APK for my Flutter app. 

I'll show you:
1. How I generated the signing keystore
2. How I configured Gradle for release signing
3. Building the release APK
4. Testing it on a device to verify it works
5. Confirming there's no debug banner

Let's get started!"
```

**Recording Tips:**
- Look at camera
- Speak clearly and naturally
- Maintain good lighting
- Pause for 3 seconds after introduction

#### Shot 1b: Show Project Structure

```powershell
ls -la android/app/
```

**What should be visible:**
- `app-release-key.jks` (the keystore file)
- `build.gradle.kts` (the gradle file)
- `google-services.json` (Firebase config)

**Narration:**
```
"Here you can see the Android app directory with the keystore file,
Gradle configuration, and Firebase settings all in place."
```

---

### **SECTION 2: Configuration Files (1-1.5 minutes)**

#### Shot 2a: Show key.properties (with passwords masked)

```powershell
# Show the file structure without exposing passwords
cat android/key.properties | findstr "keyAlias", "storeFile"
```

**Narration:**
```
"Here's the key.properties file. I can show you the configuration:
- keyAlias: upload
- storeFile: app-release-key.jks

The passwords are stored securely locally and not shown in this video."
```

**Recording Tips:**
- Don't show actual passwords
- Just show structure with findstr to filter
- Or screenshot and blur sensitive parts
- Explain why credentials aren't shared

#### Shot 2b: Show Gradle Signing Configuration

```powershell
# Navigate to gradle file
code android/app/build.gradle.kts
```

**What to show:**
```kotlin
signingConfigs {
    create("release") {
        keyAlias = keystoreProperties.getProperty("keyAlias")
        keyPassword = keystoreProperties.getProperty("keyPassword")
        storeFile = file(keystoreProperties.getProperty("storeFile"))
        storePassword = keystoreProperties.getProperty("storePassword")
    }
}

buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")
    }
}
```

**Narration:**
```
"In the Gradle file, I've configured the signing settings.
This tells the build system how to sign the APK using the keystore
and credentials from key.properties.

The release build type is configured to use this signing configuration.
This ensures the APK is properly signed for production."
```

**Recording Tips:**
- Scroll slowly through the file
- Highlight the signing config section
- Highlight the buildTypes section
- Pause on each section for 2-3 seconds

#### Shot 2c: Show Firebase Configuration

```powershell
ls android/app/google-services.json
```

**Narration:**
```
"Firebase configuration file is in place. This ensures Firebase
will work correctly in the release build, and the release signing
key's SHA-1 has been added to Firebase Console for security."
```

---

### **SECTION 3: Building Release APK (2-2.5 minutes)**

#### Shot 3a: Run Clean Command

```powershell
cd farm2home_app
flutter clean
```

**What to show:**
- Command execution
- Successful completion message

**Narration:**
```
"First, I'll clean the project to ensure a fresh build."
```

**Recording Tips:**
- Show the full output
- Wait for it to complete
- Don't fast-forward

#### Shot 3b: Get Dependencies

```powershell
flutter pub get
```

**Narration:**
```
"Getting all dependencies..."
```

**Recording Tips:**
- Show dependency resolution
- Let it complete fully

#### Shot 3c: Build Release APK (Main Build)

```powershell
flutter build apk --release
```

**What to shows:**
- Full build output
- Key stages:
  - Gradle compile
  - Resource bundling
  - Signing
  - Alignment (zipalign)
  - Success message with file path

**Narration:**
```
"Now I'm building the release APK. This will:
1. Compile the Dart code
2. Package resources
3. Sign with the keystore
4. Align and optimize

This usually takes 2-5 minutes depending on the project size."
```

**Recording Tips:**
- Show entire build process
- Don't skip or fast-forward
- Show the "Built build/app/outputs/flutter-apk/app-release.apk" message
- Pause at the success message for 2-3 seconds

#### Shot 3d: Verify APK File

```powershell
ls build/app/outputs/flutter-apk/app-release.apk -lh
```

**Narration:**
```
"The release APK has been successfully created. 
As you can see, the file is [SIZE] MB.
It's ready to be tested or uploaded to the Play Store."
```

**Recording Tips:**
- Show the file details
- Emphasize the file size
- Show the timestamp confirming it was just created

---

### **SECTION 4: Install and Test on Device (1.5-2 minutes)**

#### Shot 4a: Connect Device & List Devices

```powershell
flutter devices
```

**Expected Output:**
```
Found 2 connected devices:
  Android • emulator-5554 • android-33  • Android 13
  (mobile) • FA57W0305516 • android-13  • Android 13
```

**Narration:**
```
"I have my device connected. Let me verify the connection
by listing available devices."
```

#### Shot 4b: Install APK on Device

```powershell
adb install build/app/outputs/flutter-apk/app-release.apk
```

**Expected Output:**
```
Performing Streamed Install
Success
```

**Narration:**
```
"Now I'm installing the release APK on the device..."
```

**Recording Tips:**
- Show the install command
- Wait for success message
- Show "Success" or green checkmark

#### Shot 4c: Show App Launching on Device

**What to show on device screen:**
- App icon appears on home screen
- App is launching
- Splash screen (if exists)
- Home screen loading

**Narration:**
```
"The app is launching on the device. 
Notice that there's no debug banner - the one that usually 
appears in the top-right corner of Flutter apps during development.
This confirms it's a proper release build."
```

**Recording Tips:**
- Keep device screen clearly visible
- Screen should be oriented horizontally or vertically consistently
- Wait for app to fully load (5-10 seconds)
- **Emphasize the absence of the debug banner**

#### Shot 4d: Feature Testing on Device (15-20 seconds)

Show a few quick features:

1. **Navigate to different screen** (5 seconds)
   - Tap menu/drawer
   - Show navigation working
   
   **Narration:**
   ```
   "Let me test navigation - the app is responding smoothly."
   ```

2. **Check a key feature** (5 seconds)
   - Maps screen, Product listing, Firebase data, etc.
   
   **Narration:**
   ```
   "Here you can see the [feature name] is working correctly.
   All Firebase data is loading properly."
   ```

3. **Verify Performance** (5-10 seconds)
   - Scroll through list
   - Show smooth interactions
   
   **Narration:**
   ```
   "Performance is smooth and responsive. No lag or stuttering."
   ```

**Recording Tips:**
- Keep taps/swipes smooth and natural
- Avoid rapid clicking
- Show both the device screen and console (if possible)
- Let screens fully load before interaction

---

### **SECTION 5: Console Verification (30-45 seconds)**

#### Shot 5a: Logcat Output

```powershell
adb logcat | findstr -i error
```

**Expected Output:**
```
(Empty or only system-level warnings)
```

**Narration:**
```
"Checking the app logs for any errors... The console shows no error
messages from the app, confirming the release build is clean."
```

#### Shot 5b: APK Signing Verification

```powershell
jarsigner -verify -verbose build/app/outputs/flutter-apk/app-release.apk
```

**Expected Output:**
```
jar verified.
```

**Narration:**
```
"I'm verifying the APK signature to confirm it was 
properly signed with the keystore."
```

**Recording Tips:**
- Show the command
- Emphasize the "jar verified" message
- This proves proper signing

---

### **SECTION 6: Explanation (1-2 minutes)**

#### Shot 6a: Face-to-Camera Explanation (Recommended)

**Narration (script):**

```
"Let me explain what we just accomplished:

STEP 1: KEYSTORE GENERATION
I created a signing key using keytool with RSA encryption and 2048-bit
security. This keystore proves I own the app and prevents tampering.

STEP 2: GRADLE CONFIGURATION
I configured the Gradle build file to use the keystore and credentials 
from the key.properties file. This is applied only to release builds, 
not debug builds.

STEP 3: FIREBASE SETUP
I added the SHA-1 and SHA-256 fingerprints from the release key to 
Firebase Console. This ensures Firebase services work correctly with 
the release-signed APK.

STEP 4: RELEASE BUILD
Running 'flutter build apk --release' compiled all code, 
packaged resources, and signed the APK using the keystore. 
The process took about 3 minutes.

STEP 5: INSTALLATION & TESTING
I installed the APK on a physical device and verified:
- The app launches without crashes
- No debug banner appears (proving it's a real release build)
- All features work correctly
- Firebase is functional
- Performance is smooth

RESULT: PRODUCTION READY
The app is now ready for submission to Google Play Store or 
distribution through other channels."
```

**Recording Tips:**
- Make eye contact with camera (if visible)
- Speak clearly at natural pace
- Pause between sections for breath
- Be enthusiastic about the process
- Don't rush - 1-2 minutes is fine for explanation

#### Shot 6b: Show GitHub PR (Optional)

If you've already created a PR:
```
"You can see my GitHub PR here which includes all the 
gradle signing configuration changes. The keystore and 
key.properties files are safely ignored by git."
```

---

## Post-Recording Checklist

### Video Content Verification
- [ ] Introduction section clear and engaging
- [ ] Configuration files shown (passwords masked)
- [ ] Full build process visible (not skipped)
- [ ] Success message visible
- [ ] APK file verified to exist
- [ ] Device connection shown
- [ ] Installation successful
- [ ] App launched and tested on device
- [ ] No debug banner visible (emphasized)
- [ ] Feature testing showed functionality
- [ ] Console verification showed no errors
- [ ] APK signing verified
- [ ] Explanation clear and complete
- [ ] Total duration 4-7 minutes

### Video Quality
- [ ] Resolution: 1080p or 1440p
- [ ] Frame rate: 30 FPS minimum, 60 FPS ideal
- [ ] Audio: Clear, no background noise
- [ ] Narration: Audible, natural pace
- [ ] Screen content: Easily readable
- [ ] Device screen: Clearly visible
- [ ] Transitions: Smooth, no jumps
- [ ] No corruption or artifacts

### Video File
- [ ] File format: MP4 or compatible
- [ ] File size: Reasonable (< 1 GB)
- [ ] Duration: 4-7 minutes
- [ ] Ready to upload to Google Drive

---

## Recording Software Recommendations

### Free Options
- **OBS Studio** (Best for flexibility)
  - Download: https://obsproject.com/
  - Features: Multiple scenes, high quality, free

- **Windows Game Bar** (Built-in)
  - Win + G to open
  - Good for quick recordings
  - Limited features

- **ScreenFlow** (Mac)
  - Built-in screen recording
  - Edit before exporting

### Paid Options
- **Camtasia** (~$100/year)
  - Professional editing
  - High quality output
  - Educational discount available

- **Bandicam** (~$40 one-time)
  - Lightweight
  - Good for gaming/development
  - Good codec support

---

## Audio Quality Tips

### Recording Audio
- Use external microphone if available
- Position microphone 6-12 inches from mouth
- Avoid background noise
- Speak at natural volume
- Minimize echo (soft surfaces help)

### Audio Levels
- Record at -6dB to -3dB (not too loud/quiet)
- Test recording before full recording
- Use headphones to monitor

### Post-Processing (Optional)
- Remove background noise
- Adjust levels for consistency
- Don't over-compress

---

## Common Recording Issues & Solutions

| Issue | Solution |
|-------|----------|
| **Audio too quiet** | Speak louder, position mic closer, check settings |
| **Audio too loud** | Reduce volume, back away from mic |
| **Background noise** | Close windows, use quiet room, use noise gate |
| **Video choppy** | Lower resolution, close other apps, use hardware acceleration |
| **Video out of sync** | Use lossless codec, check frame rate, re-record |
| **Device screen not visible** | Increase device screen brightness, rotate device, use screen projection |
| **Screen flickering** | Disable screen refresh optimization, use 60Hz, check display settings |

---

## Upload to Google Drive

### Steps
1. **Complete recording** and verify quality
2. **Export** with good codec (H.264, AAC audio)
3. **Go to:** https://drive.google.com
4. **Upload:** Click New → File upload
5. **Select:** Your video file
6. **Wait:** Upload completes (5-15 minutes)
7. **Share:** Right-click → Share
8. **Configure:**
   - Change to "Editor" (not Viewer!)
   - Change to "Anyone with the link"
9. **Copy** the sharing link
10. **Test** link in incognito window

### Share Settings (CRITICAL)
```
✓ Sharing: Anyone with the link
✓ Role: Editor (NOT Viewer)
✓ No password required
✓ Link format: https://drive.google.com/file/d/[FILE_ID]/view?usp=sharing
```

---

## Recording Tips Summary

✅ **DO:**
- Be clear and concise
- Show the complete process (don't skip)
- Emphasize the absence of debug banner
- Show real-time builds (don't time-skip)
- Test the app on the device
- Explain what you're doing
- Show console verification
- Make eye contact with camera (optional)

❌ **DON'T:**
- Fast-forward through build process
- Skip important steps
- Rush through the narration
- Show passwords or sensitive data
- Use low video quality
- Record with poor audio
- Expect build to be fast (show real time)

---

**Status: Recording Guide Complete** ✅  
**Next Steps:**
1. Follow the script section by section
2. Record your video
3. Export with good quality
4. Upload to Google Drive
5. Test the sharing link
6. Continue with submission checklist

Good luck with your recording! 🎬
