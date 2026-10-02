@echo off
chcp 65001 >nul
title Furth Financing - Build Android APK
where flutter >nul 2>nul
if errorlevel 1 (
  echo Khong tim thay Flutter trong PATH.
  pause
  exit /b 1
)
flutter pub get
flutter build apk --release
echo.
echo APK: build\app\outputs\flutter-apk\app-release.apk
pause
