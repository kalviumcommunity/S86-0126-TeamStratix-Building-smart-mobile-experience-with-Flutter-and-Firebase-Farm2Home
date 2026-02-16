# Release Build Setup Guide - Keystore & Gradle Configuration

## Complete Step-by-Step Instructions

This guide walks you through creating a signing key, configuring Gradle, and preparing your app for release.

---

## Phase 1: Prerequisites Check

### Step 1: Verify Java Development Kit (JDK) Installation

```powershell
java -version
```

**Expected Output:**
```
java version "17.0.x" (or higher)
Java(TM) SE Runtime Environment (build 17.0.x)
Java HotSpot(TM) 64-Bit Server VM
```

**If Not Found:**
1. Download JDK from: https://www.oracle.com/java/technologies/downloads/
2. Install JDK (choose latest LTS version, e.g., Java 17+)
3. Add to PATH if needed:
   - Windows: System Properties → Environment Variables → Add JDK bin folder to PATH
4. Restart terminal and verify again

### Step 2: Verify keytool Availability

```powershell
keytool -help
```

**Expected Output:**
```
Key and Certificate Management Tool
...
Commands:
 -certreq          Generate a certificate request
 -changealias      Change an entry's alias
     [etc.]
```

**If Not Found:**
- keytool comes with JDK
- Verify JDK installation (Step 1)
- Restart terminal after JDK installation

### Step 3: Check Flutter & Gradle Setup

```powershell
cd farm2home_app
flutter --version
```

**Expected Output:**
```
Flutter 3.38.7 or higher
Dart 3.10.7 or higher
```

---

## Phase 2: Generate Keystore (Signing Key)

### Step 1: Open Terminal in Project Directory

```powershell
cd farm2home_app
# Verify you're in the Flutter project root
ls pubspec.yaml  # Should exist
```

### Step 2: Generate Keystore File

**Run this command:**
```powershell
keytool -genkey -v -keystore app-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**Command Breakdown:**
- `-genkey` → Generate a new key
- `-v` → Verbose output
- `-keystore app-release-key.jks` → Output filename
- `-keyalg RSA` → RSA encryption algorithm
- `-keysize 2048` → 2048-bit key (industry standard security)
- `-validity 10000` → Valid for ~27 years
- `-alias upload` → Alias name (used by Google Play)

### Step 3: Enter Keystore Information

**You'll be prompted for:**

```
1. First and Last Name: [Enter your name or company name]
   Example: John Doe

2. Organizational Unit: [Your team/department]
   Example: Farm2Home Development

3. Organization Name: [Company name]
   Example: TeamStratix

4. City or Locality: [Your city]
   Example: San Francisco

5. State or Province Name: [Your state]
   Example: California

6. Two-letter Country Code: [ISO country code]
   Example: US

7. Correctly? (yes/no): yes [Enter YES]

8. Enter key password for <upload>: [Create a STRONG password]
   Example: MyStr0ng!Pass#2024
   Note: This will be needed later
   IMPORTANT: Write this down securely!

9. Re-enter new password: [Repeat the same password]
```

**Password Requirements:**
- Minimum 6 characters
- Should be strong (uppercase, lowercase, numbers, symbols)
- Examples of GOOD passwords:
  - `MyApp!Release#2024`
  - `Str0ng$afe@2024Key`
  - `Prod!Build&Deploy123`

### Step 4: Verify Keystore Generated

**After successful generation, you should see:**
```
Generating 2,048 bit RSA key pair and self-signed certificate...
[####################################] 100%
The self-signed certificate will be valid for 10,000 days
```

**File location:**
```
Your current directory should now have:
app-release-key.jks (the keystore file)
```

### Step 5: Move Keystore to Correct Location

```powershell
# Check if android/app directory exists
ls android/app

# Move the keystore file
Move-Item -Path app-release-key.jks -Destination android/app/app-release-key.jks

# Verify it's in the right location
ls android/app/app-release-key.jks
```

**Expected Output:**
```
    Directory: C:\...\farm2home_app\android\app

Mode                 LastWriteTime         Length Name
----                 --------------------  ------ ----
-a---  2/16/2026 10:30 AM            2560 app-release-key.jks
```

### Step 6: Get Certificate Fingerprints (for Firebase)

```powershell
cd android/app
keytool -list -v -keystore app-release-key.jks
```

**When prompted, enter the keystore password you created.**

**Copy the following values (you'll need them for Firebase):**
- **SHA-1 Fingerprint** ← For Firebase Console
- **SHA-256 Fingerprint** ← For Firebase Console

**Example Output (save these):**
```
Certificate Fingerprints:
MD5:  xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx
SHA1: xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx
SHA256: xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx
```

**Action:** Add SHA-1 and SHA-256 to Firebase Console (if you haven't already):
1. Go to: Firebase Console → Your Project → Settings → Your Apps
2. Click: Android app
3. Add both SHA-1 and SHA-256 fingerprints

---

## Phase 3: Store Credentials Securely

### Step 1: Understanding key.properties

The `key.properties` file stores your signing credentials. This file should **NEVER** be committed to GitHub.

### Step 2: Create key.properties File

**Location:** `android/key.properties`

**Create the file with this content:**
```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=app-release-key.jks
```

**Replace:**
- `YOUR_KEYSTORE_PASSWORD` → Password from keystore generation
- `YOUR_KEY_PASSWORD` → Same as keystore password (usually)
- `upload` → Keep as is (your key alias)
- `app-release-key.jks` → Keep as is (filename)

**Example:**
```properties
storePassword=MyStr0ng!Pass#2024
keyPassword=MyStr0ng!Pass#2024
keyAlias=upload
storeFile=app-release-key.jks
```

### Step 3: Add to .gitignore (CRITICAL!)

**Open:** `android/.gitignore`

**Add these lines:**
```
# Release signing
key.properties
app-release-key.jks
```

**Verify in:** `android/.gitignore`
```
# See .gitignore for the git config
*.jks
*.jks.bak
*.keystore
*.keystore.bak
key.properties
```

**These lines prevent credentials from being uploaded to GitHub.**

### Step 4: Verify File Locations

```powershell
# From farm2home_app directory
ls android/app/app-release-key.jks  # Should exist
ls android/key.properties           # Should exist
```

---

## Phase 4: Configure Gradle for Signing

### Step 1: Load Properties in build.gradle

**Edit:** `android/app/build.gradle.kts` (if using Kotlin DSL)

**Or:** `android/app/build.gradle` (if using Groovy DSL)

For this guide, we'll use the **Kotlin DSL** (`.kts`) which is modern:

### Step 2: Add Properties Loading (Kotlin DSL)

**At the top of `android/app/build.gradle.kts`, add:**

```kotlin
import java.util.Properties
import java.io.FileInputStream

// Load key.properties
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
```

**Location:** BEFORE the `android {` block

### Step 3: Add Signing Configuration (Kotlin DSL)

**Inside the `android { }` block, add:**

```kotlin
signingConfigs {
    create("release") {
        keyAlias = keystoreProperties.getProperty("keyAlias") ?: ""
        keyPassword = keystoreProperties.getProperty("keyPassword") ?: ""
        storeFile = file(keystoreProperties.getProperty("storeFile") ?: "")
        storePassword = keystoreProperties.getProperty("storePassword") ?: ""
    }
}
```

### Step 4: Apply Signing to Release Build Type

**Find the `buildTypes { }` block and update `release { }`:**

```kotlin
buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")
        isMinifyEnabled = false  // Set to true if using ProGuard
        isShrinkResources = false  // Set to true to shrink unused resources
    }
}
```

### Complete build.gradle.kts Example

**Here's what your file should look like (simplified):**

```kotlin
import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Load key.properties
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.farm2home_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.farm2home_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias") ?: ""
            keyPassword = keystoreProperties.getProperty("keyPassword") ?: ""
            storeFile = file(keystoreProperties.getProperty("storeFile") ?: "")
            storePassword = keystoreProperties.getProperty("storePassword") ?: ""
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
```

### Step 5: Verify Gradle Syntax

```powershell
cd farm2home_app
flutter pub get
```

**Expected Output:**
```
Running "flutter pub get" in farm2home_app...
Resolving dependencies...
+ ... (dependencies listed)
Done.
```

**If there are errors:**
- Check bracket matching in build.gradle.kts
- Verify file paths are correct
- Ensure Properties import is present

---

## Phase 5: Update App Version

### Step 1: Check Current Version

**Open:** `pubspec.yaml`

**Find:**
```yaml
version: 1.0.0+1
```

### Step 2: Understand Version Format

```
version: MAJOR.MINOR.PATCH+BUILD_NUMBER

Example: 1.0.0+1
- MAJOR = 1 (breaking changes)
- MINOR = 0 (new features)
- PATCH = 0 (bug fixes)
- BUILD_NUMBER = 1 (increment for each release)
```

### Step 3: Update Version for Release

```yaml
# First release
version: 1.0.0+1

# Second release
version: 1.0.1+2

# Next major version
version: 2.0.0+3
```

**Update both in Android Manifest (automatic) and pubspec.yaml**

---

## Phase 6: Troubleshooting

### Issue: keytool not found

**Solution:**
```powershell
# Check Java installation
java -version

# If error, reinstall JDK and add to PATH:
setx JAVA_HOME "C:\Program Files\Java\jdk-17.0.x"
```

### Issue: Keystore password incorrect

**Solution:**
```powershell
# Re-enter password carefully
# Check key.properties for typos
# Passwords are case-sensitive!
```

### Issue: File not found at android/key.properties

**Solution:**
```powershell
# Create from android directory
cd android
echo. > key.properties
# Then edit the file with your values
```

### Issue: Gradle reports "Unknown signing config"

**Solution:**
1. Clear Gradle cache: `flutter clean`
2. Verify key.properties exists and is readable
3. Check .gitignore properly placed
4. Restart IDE/terminal

### Issue: Firebase auth not working in release build

**Solution:**
1. Add SHA-1 and SHA-256 to Firebase Console
2. Download new `google-services.json`
3. Replace file in `android/app/google-services.json`
4. Rebuild release APK

---

## ✅ Verification Checklist

Before moving to building, verify:

- [ ] JDK installed and keytool working
- [ ] `android/app/app-release-key.jks` exists
- [ ] `android/key.properties` created with correct passwords
- [ ] `.gitignore` includes `key.properties` and `*.jks`
- [ ] Gradle build file updated with signing config
- [ ] `flutter pub get` succeeds
- [ ] SHA-1 and SHA-256 added to Firebase Console
- [ ] App version updated in pubspec.yaml
- [ ] `flutter clean` run successfully

**When all are checked, proceed to building!**

---

## Quick Reference Commands

```powershell
# Navigate to project
cd farm2home_app

# Generate keystore (run from farm2home_app directory)
keytool -genkey -v -keystore app-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Move keystore to correct location
Move-Item app-release-key.jks android/app/

# Get SHA-1 and SHA-256 fingerprints
cd android/app
keytool -list -v -keystore app-release-key.jks

# Verify setup
cd ../..
flutter pub get
flutter clean

# Ready to build!
```

---

**Status: Setup Complete** ✅  
**Next Step:** [RELEASE_BUILD_TESTING_CHECKLIST.md](./RELEASE_BUILD_TESTING_CHECKLIST.md)

Good luck! 🚀
