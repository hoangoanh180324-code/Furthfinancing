@echo off
chcp 65001 >nul
title Furth Financing - Setup Flutter
echo ============================================================
echo  FURTH FINANCING - TAO PROJECT ANDROID / IOS / WEB
echo ============================================================
echo.

where flutter >nul 2>nul
if errorlevel 1 (
  echo [LOI] Khong tim thay Flutter trong PATH.
  echo Hay cai Flutter SDK va them flutter\bin vao PATH truoc.
  echo Sau do mo lai file nay.
  pause
  exit /b 1
)

echo [1/4] Kiem tra Flutter...
flutter --version
if errorlevel 1 goto :error

echo.
echo [2/4] Tao cac thu muc platform...
flutter create .
if errorlevel 1 goto :error

echo.
echo [3/4] Tai dependency...
flutter pub get
if errorlevel 1 goto :error

echo.
echo [4/4] Kiem tra moi truong...
flutter doctor

echo.
echo ============================================================
echo  HOAN TAT
echo ============================================================
echo.
echo De chay app:
echo   flutter run
echo.
echo De build Android APK:
echo   flutter build apk --release
echo.
pause
exit /b 0

:error
echo.
echo [LOI] Qua trinh setup bi loi. Xem thong bao phia tren.
pause
exit /b 1
