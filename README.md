# Furth Financing UI V3

Bản này fix lại giao diện app theo mockup mới.

## Thay vào project hiện tại

Project hiện tại của bạn:

C:\flutter-projects\furth_financing_flutter

1. Copy `lib/main.dart` vào:
   `C:\flutter-projects\furth_financing_flutter\lib\main.dart`

2. Copy thư mục `assets` vào:
   `C:\flutter-projects\furth_financing_flutter\assets`

3. Thay `pubspec.yaml` bằng file trong gói này hoặc thêm:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/student_hero.jpg
```

4. Chạy:

```powershell
flutter pub get
flutter run -d web-server
```

Nếu Flutter đang chạy, dùng `R` (Hot Restart) vì có thêm asset mới.
