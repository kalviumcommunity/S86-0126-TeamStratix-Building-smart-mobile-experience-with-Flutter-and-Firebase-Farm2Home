#!/usr/bin/env powershell

# Release Build Configuration Script
# This script helps you generate a keystore and configure signing for release builds

param(
    [string]$Name = "Upload Key Certificate",
    [string]$Org = "TeamStratix",
    [string]$City = "San Francisco", 
    [string]$State = "California",
    [string]$Country = "US"
)

Write-Host "=== Flutter Release Build Keystore Generator ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Verify keytool availability
Write-Host "[1/5] Checking keytool availability..." -ForegroundColor Yellow
try {
    $keytoolVersion = keytool -version 2>&1
    if ($?) {
        Write-Host "✓ keytool found" -ForegroundColor Green
    }
} catch {
    Write-Host "✗ keytool not found. Please install JDK first." -ForegroundColor Red
    exit 1
}

Write-Host ""

# Step 2: Get keystore password
Write-Host "[2/5] Setting up keystore password..." -ForegroundColor Yellow
$password1 = Read-Host "Enter keystore password (min 6 chars, remember this!)" -AsSecureString
$password1Text = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($password1))

if ($password1Text.Length -lt 6) {
    Write-Host "✗ Password must be at least 6 characters" -ForegroundColor Red
    exit 1
}

$password2 = Read-Host "Confirm keystore password" -AsSecureString
$password2Text = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($password2))

if ($password1Text -ne $password2Text) {
    Write-Host "✗ Passwords do not match" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Password set" -ForegroundColor Green
Write-Host ""

# Step 3: Generate keystore
Write-Host "[3/5] Generating keystore (this may take a minute)..." -ForegroundColor Yellow

$keystorePath = "app-release-key.jks"

keytool -genkey -v `
    -keystore $keystorePath `
    -keyalg RSA `
    -keysize 2048 `
    -validity 10000 `
    -alias upload `
    -dname "CN=$Name, OU=$Org, O=$Org, L=$City, S=$State, C=$Country" `
    -storepass $password1Text `
    -keypass $password1Text

if ($?) {
    Write-Host "✓ Keystore generated successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to generate keystore" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Step 4: Display fingerprints
Write-Host "[4/5] Getting certificate fingerprints (SHA-1 and SHA-256)..." -ForegroundColor Yellow
Write-Host ""
Write-Host "Add these to your Firebase Console:" -ForegroundColor Cyan
Write-Host ""

keytool -list -v -keystore $keystorePath -storepass $password1Text | findstr /C:"Alias" /C:"SHA1" /C:"SHA256"

Write-Host ""
Write-Host "✓ Fingerprints displayed" -ForegroundColor Green
Write-Host ""

# Step 5: Create config file
Write-Host "[5/5] Creating key.properties configuration file..." -ForegroundColor Yellow

$configContent = @"
# Release signing configuration
storePassword=$password1Text
keyPassword=$password1Text
keyAlias=upload
storeFile=app-release-key.jks
"@

$configContent | Out-File -FilePath "key.properties" -Encoding ASCII

Write-Host "✓ key.properties created" -ForegroundColor Green
Write-Host ""

# Move keystore to app directory
Write-Host "Moving keystore to android/app/..." -ForegroundColor Yellow
if (Test-Path "android/app") {
    Move-Item -Path $keystorePath -Destination "android/app/$keystorePath" -Force
    Write-Host "✓ Keystore moved to android/app/" -ForegroundColor Green
} else {
    Write-Host "! Keystore is at root. You can manually move it to android/app/ if needed" -ForegroundColor Yellow
    Write-Host "$keystorePath"
}

Write-Host ""
Write-Host "=== Setup Complete! ===" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Add these SHA-1 and SHA-256 fingerprints to Firebase Console"
Write-Host "2. Ensure key.properties is in .gitignore (should be already)"
Write-Host "3. Build release: flutter build apk --release"
Write-Host "4. Test on device: adb install build/app/outputs/flutter-apk/app-release.apk"
Write-Host ""
