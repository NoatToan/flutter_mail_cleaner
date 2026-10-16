# Phát hành AI Smart Mail trên macOS

> Bundle id: `com.aismartmail.aiSmartMail` · deployment target: 13.0 · sandboxed.
> Flutter 3.47 (Swift Package Manager, không có Podfile).

## 1. Hai đường phát hành

| Đường | Dùng khi | Script |
|---|---|---|
| **Developer ID + Notarization** | Phát hành trực tiếp qua website / DMG | `scripts/release_macos.sh` (tự động) |
| **Mac App Store (MAS)** | Lên Mac App Store | `flutter build macos --release` → mở `macos/Runner.xcworkspace` trong Xcode → Product › Archive → Distribute App (không tự động) |

Phiên bản MVP đi theo đường Developer ID; MAS làm sau khi đã có App Store Connect record và CASA xong (xem §7).

## 2. Chứng chỉ & profile cần có

Trên tài khoản Apple Developer (99 USD/năm, cần D-U-N-S nếu đứng tên công ty):
- **Developer ID Application** — để sign app phát hành ngoài MAS.
- **Developer ID Installer** — nếu phân phối bằng `.pkg` (chưa dùng, DMG đủ).
- **Mac App Distribution** + **Mac Installer Distribution** — nếu đưa lên MAS.
- **Apple Development** (dev team) — ký build debug trên máy dev.

Ghi `TEAM_ID` (10 ký tự alphanumeric, có trong Membership) để nhập vào Xcode và `keychain-access-groups` (xem §4).

Tạo keychain profile cho `notarytool` (chạy 1 lần/máy build):
```bash
xcrun notarytool store-credentials "AI_SMART_MAIL_NOTARY" \
  --apple-id "<apple-id@mail>" \
  --team-id "<TEAM_ID>" \
  --password "<app-specific-password>"
```
Rồi set `NOTARY_PROFILE=AI_SMART_MAIL_NOTARY` cho script release.

## 3. Entitlements & lý do

| Key | Nơi khai | Vì sao |
|---|---|---|
| `com.apple.security.app-sandbox` | Debug + Release | Yêu cầu bắt buộc MAS; Developer ID vẫn giữ để giảm quyền. |
| `com.apple.security.network.client` | Debug + Release | IMAP/SMTP ra Gmail/Outlook/iCloud, OAuth, LLM proxy. |
| `com.apple.security.network.server` | Debug (loopback plugin dev) | Flutter hot-reload. KHÔNG bật ở Release. |
| `com.apple.security.cs.allow-jit` | Debug | Dart VM JIT. KHÔNG bật ở Release (AOT). |
| `keychain-access-groups` (sẽ thêm) | Debug + Release | `flutter_secure_storage` lưu OAuth token vào Keychain. Trong build đã sign cần group `${TeamIdentifierPrefix}com.aismartmail.aiSmartMail` để map đúng data-protection keychain; không có thì secure storage fallback có thể fail trên macOS đã sign. |

**Việc coordinator phải làm:** nhập Team ID vào `Runner/DebugProfile.entitlements` và `Runner/Release.entitlements` theo mẫu:
```xml
<key>keychain-access-groups</key>
<array>
    <string>$(AppIdentifierPrefix)com.aismartmail.aiSmartMail</string>
</array>
```
`$(AppIdentifierPrefix)` sẽ được Xcode thay bằng `TEAM_ID.` khi ký.

Khi lên MAS cần thêm `com.apple.security.application-groups` nếu có share data giữa app chính và helper (chưa cần cho MVP).

## 4. Keychain / `flutter_secure_storage`

- App sandbox + Developer ID: Keychain truy cập được **sau khi** group `keychain-access-groups` khớp Team ID. Không có group → ở macOS 13+ sẽ ghi vào legacy keychain, không bền giữa restart.
- `flutter_secure_storage_darwin` dùng `kSecAttrAccessGroup`; nhớ set `IOSOptions`/`MacOsOptions` tương ứng trong code Dart (coordinator / dev app chịu trách nhiệm).
- Khi đổi bundle id hoặc Team ID → token cũ không đọc được, phải reset onboarding.

## 5. Notarization & stapling

`scripts/release_macos.sh` lo:
1. `flutter build macos --release` với `--dart-define` cho `GOOGLE_CLIENT_ID`, `OUTLOOK_CLIENT_ID`.
2. `codesign` nested frameworks → app, dùng hardened runtime + `Release.entitlements`.
3. `xcrun notarytool submit --wait` (profile keychain).
4. `xcrun stapler staple` cả `.app` và DMG đã sign.
5. `hdiutil` tạo DMG có symlink `/Applications`, kèm `.sha256`.

Yêu cầu env:
```
MACOS_SIGN_IDENTITY="Developer ID Application: Tên của bạn (TEAMID)"
NOTARY_PROFILE="AI_SMART_MAIL_NOTARY"
GOOGLE_CLIENT_ID="..."
OUTLOOK_CLIENT_ID="..."
```
Chạy dev local: `SKIP_NOTARIZATION=1 scripts/release_macos.sh` để test build + ký không gửi notary.

## 6. Privacy Manifest

File: `macos/Runner/PrivacyInfo.xcprivacy` (đã wire vào `Runner.xcodeproj`, có trong Resources build phase).

Khai báo:
- `NSPrivacyTracking = false`, không domain tracking, không thu thập dữ liệu nào.
- Required-reason API dùng:
  - **CA92.1** (UserDefaults): `shared_preferences_foundation`, cache UI nhẹ.
  - **C617.1** (File timestamp): `path_provider` + drift/SQLite đọc `mtime` của DB.
  - **35F9.1** (System boot time): Flutter engine đo thời gian liên tục (`mach_absolute_time`).

Không khai E174.1 vì chưa gọi disk-space API ở MVP. Khi thêm "DB size dashboard" (UC-04) thì bổ sung dòng `NSPrivacyAccessedAPICategoryDiskSpace` + `E174.1`.

## 7. OAuth: Google verification & Microsoft registration

### Gmail (restricted scope `https://mail.google.com/`)
1. Google Cloud project → OAuth consent screen (External, Production).
2. Nộp đơn verification (hồ sơ: privacy policy URL, demo video, scope justification). Lead time **~6 tuần**.
3. Tất cả scope restricted (Gmail) đều cần **CASA** (Cloud Application Security Assessment) hằng năm, phí ~540–1.800 USD (TECH_SPEC §1).
4. Testing mode cho đến khi verify: tối đa 100 user, refresh token hết hạn 7 ngày — không ship rộng được.

### Outlook / M365
1. Azure AD app registration (Microsoft Entra).
2. Redirect URI loopback (`http://localhost:<port>`) hoặc custom scheme `msauth.com.aismartmail.aiSmartMail`.
3. Scope: `https://outlook.office.com/IMAP.AccessAsUser.All`, `SMTP.Send`, `offline_access`.
4. Admin consent không cần cho tenant personal; tenant doanh nghiệp có thể cần.
5. Pass **client secret không có trên app** (public client). Dùng PKCE qua `flutter_appauth`.

### iCloud
Không OAuth. App-specific password do user tạo tại appleid.apple.com. Không cần verification.

Set client id vào env khi build:
```
GOOGLE_CLIENT_ID=...apps.googleusercontent.com
OUTLOOK_CLIENT_ID=...
```

## 8. Versioning

- `pubspec.yaml` dòng `version: X.Y.Z+N` → Flutter inject:
  - `$(FLUTTER_BUILD_NAME)` → `CFBundleShortVersionString` (hiện cho user)
  - `$(FLUTTER_BUILD_NUMBER)` → `CFBundleVersion` (phải tăng mỗi lần nộp notary / App Store Connect)
- Script release đọc `version` từ `pubspec.yaml` để đặt tên DMG.
- Convention: bump patch cho hotfix (`1.0.1+2`), minor cho feature (`1.1.0+3`), major cho breaking (`2.0.0+10`).

## 9. Pre-release checklist

- [ ] `flutter pub get`, `dart run build_runner build --delete-conflicting-outputs` không lỗi.
- [ ] `flutter analyze` sạch, `flutter test` xanh (CI `.github/workflows/macos.yml` xác nhận).
- [ ] `pubspec.yaml` tăng `+N`.
- [ ] `CHANGELOG` / release notes viết trước khi tag.
- [ ] Entitlements đã có `keychain-access-groups` + Team ID (xem §3).
- [ ] Icon preview đúng (ứng dụng Preview → Get Info của `AI Smart Mail.app`).
- [ ] `MACOS_SIGN_IDENTITY`, `NOTARY_PROFILE`, `GOOGLE_CLIENT_ID`, `OUTLOOK_CLIENT_ID` set đúng.
- [ ] `scripts/release_macos.sh` chạy xong, `.dmg` + `.sha256` ở `dist/`.
- [ ] `spctl --assess -vv dist/AI\ Smart\ Mail-*.dmg` cho kết quả `source=Notarized Developer ID`.
- [ ] Mở DMG trên máy sạch (hoặc máy khác cùng OS) → không cảnh báo "unverified developer".
- [ ] Google Cloud OAuth consent screen vẫn ở trạng thái Production (nếu đã verify) hoặc còn hạn testing.
- [ ] Privacy policy URL vẫn live (yêu cầu bắt buộc của Google verification).
