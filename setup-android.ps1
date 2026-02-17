# Android Studio Post-Installation Setup
# Run this after installing Android Studio

Write-Host "🔍 Checking for Android SDK installation..."

$possibleSdkPaths = @(
    "$env:LOCALAPPDATA\Android\Sdk",
    "$env:USERPROFILE\AppData\Local\Android\Sdk",
    "C:\Android\Sdk"
)

$sdkPath = $null
foreach ($path in $possibleSdkPaths) {
    if (Test-Path $path) {
        $sdkPath = $path
        Write-Host "✅ Found Android SDK at: $sdkPath"
        break
    }
}

if ($sdkPath) {
    # Update local.properties
    $localPropsPath = "android\local.properties"
    $sdkPathEscaped = $sdkPath -replace '\\', '\\\\'
    
    $newContent = @"
flutter.sdk=C:\\flutter
flutter.buildMode=debug
flutter.versionName=1.0.0
flutter.versionCode=1
sdk.dir=$sdkPathEscaped
"@
    
    Set-Content -Path $localPropsPath -Value $newContent
    Write-Host "✅ Updated $localPropsPath with correct SDK path"
    Write-Host ""
    Write-Host "🧪 Test Android build:"
    Write-Host "flutter clean"
    Write-Host "flutter run"
    
} else {
    Write-Host "❌ Android SDK not found. Please install Android Studio first:"
    Write-Host "https://developer.android.com/studio"
}