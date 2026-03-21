@echo off
echo Building release APK...
flutter build apk --release

echo Renaming APK...
set VERSION=v1.0.1
copy build\app\outputs\flutter-apk\app-release.apk build\app\outputs\flutter-apk\DailyPulse-%VERSION%.apk

echo Creating GitHub release...
set APK_PATH=build\app\outputs\flutter-apk\DailyPulse-%VERSION%.apk
if not exist "%APK_PATH%" (
    echo Error: APK file not found at %APK_PATH%
    exit /b 1
)
gh release create v1.0.1 "build\app\outputs\flutter-apk\DailyPulse-v1.0.1.apk" --title "DailyPulse v1.0.1" --notes "Release notes here"

echo Done!

