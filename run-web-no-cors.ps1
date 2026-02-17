# Farm2Home - Run with CORS Disabled for Web
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Farm2Home - Running with CORS Disabled" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This will run Flutter Web with CORS disabled for local development." -ForegroundColor Yellow
Write-Host ""
Write-Host "Press Ctrl+C to stop the app." -ForegroundColor Yellow
Write-Host ""

flutter run -d chrome --web-browser-flag "--disable-web-security" --web-browser-flag "--user-data-dir=$env:TEMP\chrome-farm2home-temp"
