# Play Store Deployment Guide - Complete Workflow

## Current Status

### ✅ Completed
- **Keystore Generated**: `android/app-release-key.jks` created successfully
- **SHA-1 Fingerprint**: `98:EC:85:58:C5:C1:A4:1B:82:A9:93:1C:D5:04:F8:4D:05:BF:84:AD`
- **SHA-256 Fingerprint**: `44:71:BF:80:10:4F:DE:12:BE:06:BD:6D:99:4E:37:9C:C6:67:F9:EB:70:B5:B4:FE:F9:0D:3A:9F:94:10:7E:85`
- **Gradle Configuration**: Signing config updated in `android/app/build.gradle.kts`
- **Key Properties**: `android/key.properties` created with secure credentials

### ⚠️ Required Prerequisites
**Android SDK installation is needed to build the AAB**

---

## Step 1: Install Android SDK

### Option A: Android Studio (Recommended)
1. Download: https://developer.android.com/studio
2. Install Android Studio
3. Open project wizard
4. Android Studio will automatically install SDK and tools
5. Accept licenses:
   ```bash
   flutter doctor --android-licenses
   ```

### Option B: Command Line Tools
1. Download: https://developer.android.com/studio#command-tools
2. Extract to a location (e.g., `C:\Android\cmdline-tools`)
3. Set `ANDROID_HOME` environment variable:
   ```powershell
   [Environment]::SetEnvironmentVariable("ANDROID_HOME", "C:\Android", [EnvironmentVariableTarget]::User)
   ```
4. Verify Flutter recognizes SDK:
   ```bash
   flutter doctor
   ```

### Option C: Update Existing Flutter
If Android SDK is installed elsewhere:
```bash
flutter config --android-sdk C:\path\to\android-sdk
flutter doctor
```

---

## Step 2: Build Release AAB

Once Android SDK is properly installed and `flutter doctor` shows [√] for Android:

```bash
cd farm2home_app
flutter build appbundle --release
```

**Output location**: `build/app/outputs/bundle/release/app-release.aab`

---

## Step 3: Set Up Google Play Console

### Create Developer Account
1. Go to: https://play.google.com/apps/publish/
2. Create account ($25 one-time fee)
3. Accept agreements

###Create New App
1. Click **Create App**
2. Fill in:
   - **App name**: Farm2Home or your app name
   - **Default language**: English
   - **App type**: App
   - **Free or paid**: Free
   - Check policy boxes
3. Click **Create**

---

## Step 4: Upload Store Listing

### App Details
- **Title**: Farm2Home
- **Short description**: (80 chars max) - Brief description
- **Full description**: (4000 chars max) - Detailed feature list

### Graphics & Assets
Required:
- **Icon** (512x512 PNG): `farm2home_app/assets/images/` (highest resolution icon)
- **Feature graphic** (1024x500 PNG): Create a promotional image
- **Screenshots** (at least 2): Show key features on phone screens
  - Dimensions: 1080x1920 px (portrait) or 1920x1080 px (landscape)
  - Tools: Use emulator screenshots or phone screenshots

Optional:
- **Promotional graphic** (landscape 1200x500)
- **Video preview** (YouTube link)

### Content Rating
1. Navigate to **Content Rating** section
2. Fill questionnaire:
   - Violence: None
   - Sexual content: None
   - Profanity: None
   - Alcohol/tobacco: None
3. Get rating (usually complete in seconds)

### Privacy Policy
1. Create privacy policy document
2. Host on your website or use:
   - GitHub Pages
   - Google Sites
   - Privacy policy generator (e.g., policies.google.com)
3. Link in **Privacy Policy** field

### Categorization
- **Category**: Maps (or appropriate category)
- **Content rating**: As per questionnaire
- **Target audience**: 13+ recommended

---

## Step 5: Upload AAB File

### In Play Console
1. Navigate to **Releases** → **Production**
2. Click **Create New Release**
3. Click **Browse Files**
4. Select: `build/app/outputs/bundle/release/app-release.aab`
5. Upload completes automatically

### Version Information
Get from `farm2home_app/pubspec.yaml`:
```yaml
version: 1.0.0+1  (format: version+build)
```
- **Version name**: 1.0.0 (user-facing)
- **Version code**: 1 (must increment for each release)

### Release Notes (optional)
```
Version 1.0.0 - Initial Release

Features:
- Multi-device compatibility testing
- Firebase authentication
- Real-time location services
- In-app messaging
- Cloud Functions integration
```

---

## Step 6: Testing Options (Choose One)

### Internal Testing (Recommended First)
1. Click **Release to Internal Testing**
2. Add testers: your email or team members
3. They receive install link within minutes
4. Fastest way to test apps

### Closed Testing
1. Click **Release to Closed Testing**
2. Add testing group
3. Larger group, more realistic testing

### Open Testing (Beta)
1. Click **Release to Open Testing**
2. Visible on Play Store as "Early Access"
3. Public beta testing

---

## Step 7: Production Release

### Submit to Production
1. Click **Release to Production**
2. Review all requirements (ensure green checkmarks)
3. Review policy compliance
4. Click **Submit for Review**

### Review Time
- **Typical**: 24 hours
- **First time account**: Up to 7 days
- **Complex apps**: May take longer

### Track Status
1. Go to **Releases** → **Production**
2. Status shows: "In Review", "Approved", "Live", etc.
3. Get email notifications

---

## Step 8: Post-Launch

### View Live App
1. Search in Play Store: "Farm2Home"
2. Link: `https://play.google.com/store/apps/details?id=com.example.farm2home`

### Monitor Performance
1. **Crashes**: Firebase Crashlytics integration shows crash reports
2. **User ratings**: See reviews in Play Console
3. **Install stats**: Track installs, uninstalls, active users
4. **Performance**: ANR (Application Not Responding) rate, crash-free rate

### Push Updates
1. Increment version code in `pubspec.yaml`:
   ```yaml
   version: 1.1.0+2
   ```
2. Make code changes
3. Build new AAB: `flutter build appbundle --release`
4. Upload to next internal/production release

---

## Assignment Submission Requirements

### What to Include in Video
1. **Play Console Setup** (1-2 min)
   - Opening Play Console
   - Creating/selecting app
   - Showing store listing setup

2. **AAB Upload** (1 min)
   - Uploading release AAB file
   - Showing version information

3. **Metadata** (1 min)
   - Store description
   - Screenshots (if added)
   - Content rating completion

4. **Release Status** (1 min)
   - Show ONE of:
     - Live app on Play Store
     - "Approved" status in console
     - "In Review" status (if just submitted)

5. **Reflection** (2-3 min)
   - **Technical learnings**: What you learned about Play Store, signing, AAB format
   - **Challenges**: Keystore generation, submission process difficulties
   - **Confidence**: What you feel more confident about now
   - **Improvements**: What you'd do differently next time
   - **Skills gained**: Production deployment experience

### PR Requirements
Create PR with:
- Title: `feat: distribute app to play store - reflection and deployment`
- Description includes:
  - Keystore fingerprints (SHA-1 & SHA-256)
  - Play Console app link
  - Store listing details
  - Release notes
  - Reflection on learnings

### Google Drive Upload
- Share URL with **edit access for all**
- Video should show your face presenting
- Clear audio explaining each step
- Duration: 5-8 minutes recommended

---

## Common Issues & Fixes

| Issue | Cause | Fix |
|-------|-------|-----|
| `No Android SDK found` | SDK not installed | Install Android Studio or SDK tools |
| AAB upload rejected | Wrong package name | Check `android/app/build.gradle.kts` applicationId |
| Version conflict | Same version code used | Increment version code in pubspec.yaml |
| Release blocked | Incomplete policies | Complete content rating & privacy policy |
| SHA fingerprints wrong | Different keystore used | Use same keystore: `app-release-key.jks` |
| App crashes on launch | Debug manifests in release | Ensure release build (no debug banner) |

---

## Keystore Information

**Important**: Never commit keystore or key.properties to git!

### Created Keystore Details
- **File**: `android/app-release-key.jks`
- **Alias**: upload
- **Validity**: 10,000 days (~27 years)
- **Algorithm**: RSA 2048-bit
- **Certificate CN**: Upload Key Certificate

### Key.properties
```properties
storePassword=[REDACTED]
keyPassword=[REDACTED]
keyAlias=upload
storeFile=app-release-key.jks
```

**KEEP SECURE**: Back up keystore, never share passwords

---

## Firebase Configuration

### Add SHA Fingerprints
1. In Firebase Console: Project Settings
2. Add SHA-1 and SHA-256 to Android app:
   ```
   SHA-1:  98:EC:85:58:C5:C1:A4:1B:82:A9:93:1C:D5:04:F8:4D:05:BF:84:AD
   SHA-256: 44:71:BF:80:10:4F:DE:12:BE:06:BD:6D:99:4E:37:9C:C6:67:F9:EB:70:B5:B4:FE:F9:0D:3A:9F:94:10:7E:85
   ```
3. Save changes
4. Download updated `google-services.json` (if needed)

---

## Resources

- [Flutter Distribution](https://docs.flutter.dev/deployment/android)
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [App Bundle Guide](https://developer.android.com/guide/app-bundle)
- [Android Signing Guide](https://developer.android.com/studio/publish/app-signing)
- [Content Rating](https://support.google.com/googleplay/android-developer/answer/188189)

---

## Next Steps

1. **Immediate**: Install Android SDK
2. **Build**: Run `flutter build appbundle --release`
3. **Upload**: Get AAB file and upload to Play Console
4. **Configure**: Fill all store listing details
5. **Review**: Check all green checkmarks
6. **Submit**: Release to internal testing first
7. **Record**: Video demonstration
8. **Submit**: PR + Google Drive link

---

**Timeline**: 1-2 hours for complete setup + testing
**Difficulty**: Intermediate (first time may take longer)
**Key Skill**: Understanding production deployment workflow
