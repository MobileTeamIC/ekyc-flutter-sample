# eKYC Flutter Sample

Dự án mẫu thực hiện việc tích hợp SDK eKYC (Electronic Know Your Customer) cho ứng dụng di động (Flutter)

## Lưu ý quan trọng

**Quan trọng**: Liên hệ với chúng tôi qua trang web: [https://ekyc.vnpt.vn/vi](https://ekyc.vnpt.vn/vi) hoặc email **vnptai@vnpt.vn** để có thể lấy được các token và SDK, nếu không app sẽ không chạy được.

**Lưu ý**: Ứng dụng này sử dụng FVM version 3.29.2

## Yêu cầu trước khi bắt đầu

- Flutter SDK >= 3.0.0
- Dart SDK >= 2.19.6
- Android Studio / Xcode
- Thiết bị Android/iOS
- Java 11/17 cho Android development
- Hiện đang sử dụng FVM Flutter 3.29.2

## Cài đặt & Tích hợp SDK

### Tích hợp SDK iOS

#### Bước 1: Tạo thư mục SDK
- Điều hướng đến thư mục dự án iOS: `ios/Runner/`
- Tạo một thư mục mới tên `Fws` (nếu chưa có)
- Thư mục này sẽ chứa tất cả các framework SDK iOS

#### Bước 2: Thêm SDK Frameworks
Kéo thả các framework SDK sau vào thư mục `Fws`:
- `eKYCLib.xcframework` - SDK eKYC chính
- `ICSdkEKYC.xcframework` - SDK eKYC bổ sung
- `ICNFCCardReader.xcframework` - SDK đọc thẻ NFC (nếu cần)
- `OpenSSL.xcframework` - Thư viện OpenSSL

#### Bước 3: Cấu hình Dự án Xcode
1. Mở dự án trong Xcode: `ios/Runner.xcworkspace`
2. Chọn dự án trong navigator
3. Chọn target `Runner`
4. Vào tab **General** → **Frameworks, Libraries, and Embedded Content**
5. Nhấn nút **+** và thêm các framework từ thư mục `Fws`
6. Đặt **Embed** thành "Embed & Sign" cho mỗi framework

### Tích hợp SDK Android

#### Bước 1: Thêm file AAR SDK
1. Điều hướng đến thư mục dự án Android: `android/`
2. Tạo các thư mục sau nếu chưa có:
   - `android/ekyc/` - Chứa SDK eKYC
   - `android/scanqr/` - Chứa SDK Scan QR (nếu cần)

#### Bước 2: Thêm SDK files
- Copy file `ekyc_sdk-release-v3.5.3.aar` vào thư mục `android/ekyc/sdk/`
- Copy file `scanqr_ic_sdk-release-v1.0.5.aar` vào thư mục `android/scanqr/sdk/` (nếu cần)

#### Bước 3: Cấu hình build.gradle
Cập nhật file `android/settings.gradle`:

```gradle
include ':app'
include ':ekyc'
include ':scanqr'
```

Cập nhật file `android/app/build.gradle`:

```gradle
dependencies {
    implementation project(':ekyc')
    implementation project(':scanqr')
    // ... other dependencies
}
```

## Chạy ứng dụng

### Bước 1: Cài đặt dependencies
```bash
cd SampleIntegrateEkycFlutter
fvm flutter pub get
```

### Bước 2: Chạy ứng dụng
```bash
fvm flutter run
```

## Cấu trúc dự án

```
SampleIntegrateEkycFlutter/
├── lib/
│   ├── main.dart                 # Entry point
│   ├── log_screen.dart           # Màn hình log
│   └── services/
│       ├── ekyc_config.dart      # Cấu hình eKYC
│       ├── ekyc_method_channel.dart # Method channel cho eKYC
│       ├── ekyc_presentation.dart # Presentation layer
│       └── enum_ekyc.dart        # Enum definitions
├── android/
│   ├── ekyc/                     # SDK eKYC Android
│   │   └── sdk/
│   │       └── ekyc_sdk-release-v3.5.3.aar
│   └── scanqr/                   # SDK Scan QR Android
├── ios/
│   └── Runner/
│       └── Fws/                  # SDK iOS
│           ├── eKYCLib.xcframework
│           ├── ICSdkEKYC.xcframework
│           ├── ICNFCCardReader.xcframework
│           └── OpenSSL.xcframework
└── assets/
    └── config/                   # Cấu hình
```

## Tính năng

- Tích hợp SDK eKYC VNPT
- Xác thực danh tính điện tử
- Đọc thông tin từ CCCD/CMND
- Quét mã QR (tùy chọn)
- Đọc thẻ NFC (tùy chọn)
- Giao diện người dùng thân thiện

## Hỗ trợ

Nếu gặp vấn đề, vui lòng liên hệ:
- Website: [https://ekyc.vnpt.vn/vi](https://ekyc.vnpt.vn/vi)
- Email: vnptai@vnpt.vn

## License

Dự án này được phát triển bởi VNPT AI Team.
