@echo off
chcp 65001 >nul
title Furth Financing - Run
where flutter >nul 2>nul
if errorlevel 1 (
  echo Khong tim thay Flutter trong PATH.
  pause
  exit /b 1
)
flutter pub get
flutter run
pause
