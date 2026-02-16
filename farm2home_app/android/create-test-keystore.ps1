#!/usr/bin/env powershell

# Non-interactive keystore generation for demo
# This creates a test keystore with a known password

$keystorePath = "app-release-key.jks"
$password = "Test@123456"
$Name = "Upload Key Certificate"
$Org = "TeamStratix"
$City = "San Francisco"
$State = "California"
$Country = "US"

Write-Host "=== Creating Demo Release Keystore ===" -ForegroundColor Cyan
Write-Host ""

# Check if keytool exists
Write-Host "[1/3] Checking keytool availability..." -ForegroundColor Yellow
keytool -version 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] keytool found" -ForegroundColor Green
} else {
    Write-Host "[ERROR] keytool not found. Please install JDK." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[2/3] Generating keystore..." -ForegroundColor Yellow

# Generate keystore with fixed password
keytool -genkey -v `
  -keystore $keystorePath `
  -keyalg RSA `
  -keysize 2048 `
  -validity 10000 `
  -alias upload `
  -dname "CN=$Name, OU=$Org, O=$Org, L=$City, S=$State, C=$Country" `
  -storepass $password `
  -keypass $password

if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Keystore generated successfully" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Failed to generate keystore" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[3/3] Getting fingerprints..." -ForegroundColor Yellow
Write-Host ""

keytool -list -v -keystore $keystorePath -storepass $password | findstr /C:"Alias" /C:"SHA1" /C:"SHA256"

Write-Host ""
Write-Host "[OK] Fingerprints displayed" -ForegroundColor Green
Write-Host ""

# Create key.properties
$configContent = @"
storePassword=$password
keyPassword=$password
keyAlias=upload
storeFile=app-release-key.jks
"@

$configContent | Out-File -FilePath "key.properties" -Encoding ASCII

Write-Host "[OK] key.properties created" -ForegroundColor Green
Write-Host ""
Write-Host "=== Setup Complete! ===" -ForegroundColor Green
Write-Host "Now build with: flutter build appbundle --release"
Write-Host ""
