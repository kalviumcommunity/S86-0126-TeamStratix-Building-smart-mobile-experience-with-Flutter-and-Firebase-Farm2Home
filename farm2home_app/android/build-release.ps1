#!/usr/bin/env powershell

# Flutter Release Build Script
# Builds either Release APK, App Bundle, or both

param(
    [ValidateSet("apk", "aab", "both")]
    [string]$BuildType = "apk",
    [switch]$Clean = $false,
    [switch]$Verbose = $false
)

Write-Host "=== Flutter Release Build ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Verify prerequisites
Write-Host "[1/4] Verifying prerequisites..." -ForegroundColor Yellow

# Check if in Flutter project
if (!(Test-Path "pubspec.yaml")) {
    Write-Host "✗ Not in Flutter project root (pubspec.yaml not found)" -ForegroundColor Red
    exit 1
}

# Check if key.properties exists
if (!(Test-Path "android/key.properties")) {
    Write-Host "✗ android/key.properties not found" -ForegroundColor Red
    Write-Host "Run: powershell android/generate-keystore.ps1" -ForegroundColor Yellow
    exit 1
}

# Check if keystore exists
$keystoreFile = Get-Content "android/key.properties" | Select-String "storeFile" | ForEach-Object { $_ -replace '.*=', '' }
$keystorePath = "android/app/$keystoreFile"

if (!(Test-Path $keystorePath)) {
    Write-Host "✗ Keystore file not found at $keystorePath" -ForegroundColor Red
    exit 1
}

Write-Host "✓ All prerequisites met" -ForegroundColor Green
Write-Host ""

# Step 2: Clean (optional)
if ($Clean) {
    Write-Host "[2/4] Cleaning project..." -ForegroundColor Yellow
    flutter clean | Out-Null
    flutter pub get | Out-Null
    Write-Host "✓ Project cleaned and dependencies updated" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "[2/4] Skipping clean (use -Clean flag to force clean build)" -ForegroundColor Yellow
    Write-Host ""
}

# Step 3: Build APK
if ($BuildType -eq "apk" -or $BuildType -eq "both") {
    Write-Host "[3/4] Building Release APK..." -ForegroundColor Yellow
    
    if ($Verbose) {
        flutter build apk --release
    } else {
        flutter build apk --release 2>&1 | Out-Null
    }
    
    if ($?) {
        $apkPath = "build/app/outputs/flutter-apk/app-release.apk"
        $apkSize = (Get-Item $apkPath).Length / 1MB
        Write-Host "✓ Release APK built successfully" -ForegroundColor Green
        Write-Host "  Location: $apkPath" -ForegroundColor Green
        Write-Host "  Size: $([Math]::Round($apkSize, 2)) MB" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to build APK" -ForegroundColor Red
        exit 1
    }
    
    Write-Host ""
}

# Step 4: Build AAB
if ($BuildType -eq "aab" -or $BuildType -eq "both") {
    Write-Host "[4/4] Building Release App Bundle (AAB)..." -ForegroundColor Yellow
    
    if ($Verbose) {
        flutter build appbundle --release
    } else {
        flutter build appbundle --release 2>&1 | Out-Null
    }
    
    if ($?) {
        $aabPath = "build/app/outputs/bundle/release/app-release.aab"
        $aabSize = (Get-Item $aabPath).Length / 1MB
        Write-Host "✓ Release AAB built successfully" -ForegroundColor Green
        Write-Host "  Location: $aabPath" -ForegroundColor Green
        Write-Host "  Size: $([Math]::Round($aabSize, 2)) MB" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to build AAB" -ForegroundColor Red
        exit 1
    }
    
    Write-Host ""
}

# Summary
Write-Host "=== Build Complete ===" -ForegroundColor Green
Write-Host ""

if ($BuildType -eq "apk" -or $BuildType -eq "both") {
    Write-Host "APK Build Output:" -ForegroundColor Cyan
    Write-Host "  $apkPath" -ForegroundColor Green
    Write-Host ""
    Write-Host "To install on device:" -ForegroundColor Cyan
    Write-Host "  adb install $apkPath" -ForegroundColor Green
    Write-Host ""
}

if ($BuildType -eq "aab" -or $BuildType -eq "both") {
    Write-Host "AAB Build Output:" -ForegroundColor Cyan
    Write-Host "  $aabPath" -ForegroundColor Green
    Write-Host ""
    Write-Host "To upload to Play Store:" -ForegroundColor Cyan
    Write-Host "  Upload via Google Play Console" -ForegroundColor Green
    Write-Host ""
}

Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Verify the build output files exist"
Write-Host "2. Test on device (APK): adb install <apk_path>"
Write-Host "3. Verify no debug banner appears"
Write-Host "4. Test key features in release mode"
Write-Host ""
