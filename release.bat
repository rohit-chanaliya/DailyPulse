@echo off
REM Publishes a Play Store bundle (AAB). Run release_apk.bat for a test APK.
set VERSION=1.0.2

where flutter >nul 2>nul || (echo flutter not found in PATH & exit /b 1)
if not exist android\key.properties (echo Missing android\key.properties & exit /b 1)

echo Building release AAB...
flutter build appbundle --release || exit /b 1

set AAB=build\app\outputs\bundle\release\app-release.aab
if not exist "%AAB%" (echo AAB not found at %AAB% & exit /b 1)

echo Done: %AAB%
echo Upload this file to the Play Console (internal or closed testing first).
echo If you also want a GitHub release, run the following after a successful upload:
echo   gh release create v%VERSION% "%AAB%" --title "DailyPulse v%VERSION%" --notes "Release notes here"
