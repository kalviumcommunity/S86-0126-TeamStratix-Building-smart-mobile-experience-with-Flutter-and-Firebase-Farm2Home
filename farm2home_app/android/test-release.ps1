#!/usr/bin/env powershell

# Flutter Release APK Testing Script
# Helps verify APK signature, install on device, and test functionality

param(
    [string]$ApkPath = "build/app/outputs/flutter-apk/app-release.apk",
    [switch]$Install = $false,
    [switch]$Verify = $false,
    [switch]$Uninstall = $false
)

Write-Host "=== Flutter Release APK Testing ===" -ForegroundColor Cyan
Write-Host ""

# Verify APK exists
if (!(Test-Path $ApkPath)) {
    Write-Host "✗ APK not found at: $ApkPath" -ForegroundColor Red
    Write-Host "  Build first: flutter build apk --release" -ForegroundColor Yellow
    exit 1
}

$apkSize = (Get-Item $ApkPath).Length / 1MB
Write-Host "[✓] APK found" -ForegroundColor Green
Write-Host "  Path: $ApkPath"
Write-Host "  Size: $([Math]::Round($apkSize, 2)) MB"
Write-Host ""

# Verify signing
if ($Verify -or !$Install) {
    Write-Host "[1/3] Verifying APK signature..." -ForegroundColor Yellow
    
    $signatureCheck = jarsigner -verify -verbose $ApkPath 2>&1
    
    if ($signatureCheck -match "jar verified") {
        Write-Host "✓ APK signature verified" -ForegroundColor Green
        Write-Host ""
    } else {
        Write-Host "✗ APK signature verification failed" -ForegroundColor Red
        Write-Host $signatureCheck
        exit 1
    }
}

# List connected devices
if ($Install) {
    Write-Host "[2/3] Checking connected devices..." -ForegroundColor Yellow
    
    $devices = (adb devices | Select-Object -Skip 1 | Where-Object { $_ -match "device$" })
    
    if ($devices.Count -eq 0) {
        Write-Host "✗ No devices connected" -ForegroundColor Red
        Write-Host "Connect a device or start an emulator" -ForegroundColor Yellow
        exit 1
    }
    
    Write-Host "[$($devices.Count)] device(s) connected:" -ForegroundColor Green
    foreach ($device in $devices) {
        $deviceId = $device -split '\s+' | Select-Object -First 1
        Write-Host "  - $deviceId"
    }
    Write-Host ""
    
    # Uninstall if requested
    if ($Uninstall) {
        Write-Host "[3/3] Uninstalling existing app..." -ForegroundColor Yellow
        adb uninstall com.example.farm2home_app 2>&1 | Out-Null
        Write-Host "✓ Uninstalled (if it existed)" -ForegroundColor Green
        Write-Host ""
    }
    
    # Install APK
    Write-Host "[3/3] Installing APK..." -ForegroundColor Yellow
    
    $installOutput = adb install $ApkPath 2>&1
    
    if ($installOutput -match "Success") {
        Write-Host "✓ APK installed successfully" -ForegroundColor Green
    } else {
        Write-Host "✗ Installation failed:" -ForegroundColor Red
        Write-Host $installOutput
        exit 1
    }
    Write-Host ""
}

# Testing instructions
Write-Host "=== Testing Checklist ===" -ForegroundColor Cyan
Write-Host "[✓] APK verified and ready for testing"
Write-Host ""
Write-Host "Manual testing steps:" -ForegroundColor Yellow
Write-Host "1. Launch the app from device home screen"
Write-Host "2. Verify NO debug banner appears in top-right corner"
Write-Host "3. Test core features (navigation, data loading, etc)"
Write-Host "4. Check Firebase is working correctly"
Write-Host "5. Test permissions (location, camera, etc)"
Write-Host "6. Verify performance is smooth"
Write-Host ""
Write-Host "To view logs while testing:" -ForegroundColor Yellow
Write-Host "  adb logcat | findstr -i farm2home"
Write-Host ""
Write-Host "To check for errors:" -ForegroundColor Yellow
Write-Host "  adb logcat | findstr -i error"
Write-Host ""
