# Đăng nhập Google (Gmail OAuth) — hướng dẫn cho dev

Người dùng cuối **không cấu hình gì cả** — bấm "Đăng nhập với Google" là xong. Tài liệu này dành cho
người build app: tạo project Google Cloud một lần, nhúng `client_id`/`client_secret` vào bản build.

Luồng kỹ thuật: RFC 8252 (loopback redirect cho ứng dụng cài đặt trên máy) + PKCE (RFC 7636). Xem
`lib/core/mail/google_oauth_flow.dart`.

## 1. Tạo project Google Cloud

1. Vào https://console.cloud.google.com/ → tạo project mới (hoặc dùng project có sẵn).
2. **APIs & Services › Library** → bật **Gmail API**. Ứng dụng dùng IMAP (`imap.gmail.com`) để đồng
   bộ, không gọi Gmail API trực tiếp, nhưng Google yêu cầu bật API này để qua bước xác minh scope
   nhạy cảm/hạn chế ở bước 4.

## 2. OAuth consent screen

1. **APIs & Services › OAuth consent screen** → chọn **External**.
2. Điền tên ứng dụng, email hỗ trợ, logo (tuỳ chọn ở giai đoạn Testing).
3. **Scopes** → thêm:
   - `openid`
   - `.../auth/userinfo.email` (hoặc để trống — `email` trong `openid email` đã đủ, Google tự map)
   - `https://mail.google.com/` (scope hạn chế — restricted scope, cần xác minh trước khi phát hành
     công khai, xem mục 5).
4. **Test users** → ở chế độ **Testing**, thêm tối đa 100 email (kể cả email của bạn) được phép đăng
   nhập. Ngoài danh sách này, Google chặn ngay ở màn hình consent.
5. Lưu lại ở trạng thái **Testing** cho tới khi sẵn sàng nộp xác minh (mục 5).

## 3. Tạo OAuth client — loại "Desktop app"

1. **APIs & Services › Credentials › Create Credentials › OAuth client ID**.
2. **Application type: Desktop app** (không phải Web, không phải iOS/Android) — loại này hỗ trợ
   loopback redirect (`http://127.0.0.1:<port>`) mà không cần đăng ký trước từng cổng.
3. Tạo xong, Google hiển thị `Client ID` và `Client secret`. Google **bắt buộc** phải có client
   secret kể cả với Desktop app, nhưng theo chính official docs của Google cho "installed apps",
   secret này **không được coi là bí mật thật sự** (ai decompile app cũng lấy được) — lớp bảo vệ
   thực sự ở đây là PKCE (`code_verifier`/`code_challenge`), không phải secret. Vẫn nên tránh commit
   nó vào git (xem mục 4).

## 4. Nhúng vào bản build — zero config cho người dùng cuối

1. Copy `config/oauth.example.json` → `config/oauth.json` (đã có trong `.gitignore`, không bao giờ
   commit file thật).
2. Điền:
   ```json
   {
     "GOOGLE_CLIENT_ID": "xxxxxxxx.apps.googleusercontent.com",
     "GOOGLE_CLIENT_SECRET": "xxxxxxxx"
   }
   ```
3. Build/run với:
   ```sh
   flutter run --dart-define-from-file=config/oauth.json
   ```
   hoặc trong VS Code chọn cấu hình **"AI Smart Mail (macOS, OAuth)"** trong `.vscode/launch.json`
   (cấu hình mặc định không có OAuth để không bắt buộc ai cũng phải có `config/oauth.json`).
4. Nếu build mà thiếu `GOOGLE_CLIENT_ID`, nút "Đăng nhập với Google" vẫn hiển thị nhưng bị vô hiệu
   hoá với dòng chữ dành cho dev: *"Thiếu GOOGLE_CLIENT_ID khi build — xem docs/OAUTH_GOOGLE.md"* —
   không crash, không giả vờ hoạt động.

Release build (CI, TestFlight, v.v.) cần truyền `config/oauth.json` (hoặc biến môi trường tương
đương) vào bước build — xem `docs/RELEASE_MACOS.md`.

## 5. Giới hạn ở chế độ Testing — và lộ trình lên production

TECH_SPEC §1 đã nêu nhưng nhắc lại ở đây vì nó ảnh hưởng trực tiếp đến trải nghiệm OAuth:

- **Tối đa 100 test user** trọn đời project — vượt quá phải thêm project mới hoặc xác minh.
- **Refresh token hết hạn sau 7 ngày** ở chế độ Testing — qua 7 ngày, lần đồng bộ kế tiếp sẽ nhận
  lỗi `invalid_grant` từ Google. App xử lý việc này bằng cách đặt tài khoản vào trạng thái lỗi và
  hiện nút **"Đăng nhập lại"** ở Settings › Tài khoản (`GoogleTokenRefresher` +
  `GmailReauthController`, xem `lib/core/mail/`) — không mất dữ liệu đã đồng bộ, chỉ thay token.
- **Màn hình cảnh báo "ứng dụng chưa được xác minh"** hiện ra ở mỗi lần đăng nhập cho tới khi xác
  minh xong — người dùng phải bấm "Advanced" → "Go to (tên app) (unsafe)" để tiếp tục.
- Scope `https://mail.google.com/` là **restricted scope** → để phát hành công khai (bỏ giới hạn
  100 user, bỏ màn hình cảnh báo) cần:
  1. Nộp **Google OAuth verification** cho restricted scope (~6 tuần xử lý, cần video demo luồng
     dùng scope, privacy policy, domain xác minh qua Search Console).
  2. **Đánh giá bảo mật CASA** (Cloud Application Security Assessment) hằng năm, chi phí ước tính
     540–1.800 USD/năm tuỳ tier — bắt buộc với restricted scope.
  3. Chuyển OAuth consent screen từ **Testing** sang **In production**.

Cho tới khi hoàn tất, ứng dụng chỉ nên được dùng bởi các test user đã thêm ở mục 2.4.
