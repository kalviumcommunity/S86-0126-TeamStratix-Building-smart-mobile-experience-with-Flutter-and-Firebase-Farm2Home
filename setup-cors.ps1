# Firebase Storage CORS Fix Script
# Run this script after installing Google Cloud SDK

Write-Host "=== Firebase Storage CORS Configuration ===" -ForegroundColor Cyan
Write-Host ""

# Check if gsutil is installed
$gsutilExists = Get-Command gsutil -ErrorAction SilentlyContinue

if (-not $gsutilExists) {
    Write-Host "ERROR: gsutil is not installed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install Google Cloud SDK:" -ForegroundColor Yellow
    Write-Host "1. Download from: https://cloud.google.com/sdk/docs/install" -ForegroundColor Yellow
    Write-Host "2. Or install with: choco install gcloudsdk" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

Write-Host "✓ gsutil found" -ForegroundColor Green
Write-Host ""

# Authenticate
Write-Host "Authenticating with Google Cloud..." -ForegroundColor Cyan
Write-Host "A browser window will open for authentication." -ForegroundColor Yellow
gcloud auth login

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Authentication failed!" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Authentication successful" -ForegroundColor Green
Write-Host ""

# Apply CORS configuration
Write-Host "Applying CORS configuration to Firebase Storage..." -ForegroundColor Cyan
$bucketName = "gs://farm2home-59d16.firebasestorage.app"

gsutil cors set cors.json $bucketName

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ CORS configuration applied successfully!" -ForegroundColor Green
    Write-Host ""
    
    # Verify
    Write-Host "Verifying CORS configuration..." -ForegroundColor Cyan
    gsutil cors get $bucketName
    
    Write-Host ""
    Write-Host "=== SUCCESS ===" -ForegroundColor Green
    Write-Host "CORS has been configured for your Firebase Storage bucket." -ForegroundColor Green
    Write-Host "You can now upload images from your Flutter Web app!" -ForegroundColor Green
} else {
    Write-Host "ERROR: Failed to apply CORS configuration!" -ForegroundColor Red
    Write-Host "Please check that you have the correct permissions." -ForegroundColor Yellow
    exit 1
}
