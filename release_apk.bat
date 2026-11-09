@echo off
REM Builds a signed release APK for testing on a physical device.
where flutter >nul 2>nul || (echo flutter not found in PATH & exit /b 1)
if not exist android\key.properties (echo Missing android\key.properties & exit /b 1)

flutter build apk --release || exit /b 1
echo Done: build\app\outputs\flutter-apk\app-release.apk
