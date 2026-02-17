@echo off
echo ========================================
echo  Farm2Home - Running with CORS Disabled
echo ========================================
echo.
echo This will run Flutter Web with CORS disabled for local development.
echo.
echo Press Ctrl+C to stop the app.
echo.

flutter run -d chrome --web-browser-flag "--disable-web-security" --web-browser-flag "--user-data-dir=%TEMP%\chrome-farm2home-temp"
