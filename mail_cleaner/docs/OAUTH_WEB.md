# Bản web: kết nối Gmail và Outlook (Gmail API + Microsoft Graph)

Trình duyệt không mở được socket IMAP, nên bản web (Vercel) đồng bộ mail qua REST API của từng nhà
cung cấp:

| Hộp thư | Transport | Scope |
| --- | --- | --- |
| Gmail | Gmail API (`lib/core/mail/gmail_api_mail_provider.dart`) | `https://www.googleapis.com/auth/gmail.modify` |
| Outlook.com / Microsoft 365 | Microsoft Graph (`lib/core/mail/graph_mail_provider.dart`) | `offline_access User.Read Mail.ReadWrite` |

Luồng đăng nhập: authorization code + PKCE, **chuyển cả trang** sang Google/Microsoft rồi quay về
`/onboarding/oauth-callback` (không dùng popup vì header COOP `same-origin` mà drift web cần sẽ chặn
popup). Đổi code lấy token và refresh token đi qua function `api/oauth-token.js` của chính
deployment: function chỉ thêm client secret rồi chuyển tiếp, không lưu gì. Token được lưu trong
trình duyệt (flutter_secure_storage, mã hoá bằng WebCrypto). Nội dung mail không đi qua server.

Tài khoản web có `authKind = oauthApi`. Uid kiểu IMAP được cấp cho từng (tài khoản, thư mục) trong
bảng `remote_message_ids`, nên sync engine, action executor, undo… chạy y như với IMAP.

## Biến môi trường trên Vercel

Vercel → project `flutter-mail-cleaner` → **Settings › Environment Variables** (Production + Preview):

| Biến | Giá trị |
| --- | --- |
| `GOOGLE_WEB_CLIENT_ID` | Client ID của OAuth client loại **Web application** (mục 1) |
| `GOOGLE_WEB_CLIENT_SECRET` | Client secret tương ứng |
| `MICROSOFT_CLIENT_ID` | Application (client) ID của app registration (mục 2) |
| `MICROSOFT_CLIENT_SECRET` | Client secret (Value, không phải Secret ID) |
| `MICROSOFT_TENANT` | Tuỳ chọn. `common` (mặc định: cả tài khoản cá nhân và công ty), `consumers` hoặc tenant ID |

Đổi biến xong phải **Redeploy** để function nhận giá trị mới. Kiểm tra:
`curl https://flutter-mail-cleaner.vercel.app/api/oauth-config` phải trả về client ID (không bao giờ
trả secret). Provider nào thiếu ID hoặc secret thì trả `null` và nút đăng nhập bị tắt.

Không đưa secret vào repo (repo public).

## 1. Google Cloud (Gmail)

Có thể dùng chung project với bản macOS (docs/OAUTH_GOOGLE.md), nhưng cần **một OAuth client mới**.

1. **APIs & Services › Library** → bật **Gmail API**.
2. **OAuth consent screen**: thêm scope `https://www.googleapis.com/auth/gmail.modify`. Thêm
   **Authorized domain** `vercel.app` (hoặc domain riêng nếu có).
3. **Credentials › Create credentials › OAuth client ID** → loại **Web application**:
   - Authorized JavaScript origins: `https://flutter-mail-cleaner.vercel.app`
   - Authorized redirect URIs: `https://flutter-mail-cleaner.vercel.app/onboarding/oauth-callback`
   - Domain riêng hay preview URL thì thêm cặp origin/redirect tương ứng (Google không nhận wildcard).
4. Copy Client ID/Client secret vào `GOOGLE_WEB_CLIENT_ID` / `GOOGLE_WEB_CLIENT_SECRET`.

Lưu ý khi chạy production:

- Ở trạng thái **Testing**, chỉ email trong **Test users** đăng nhập được, và refresh token **hết hạn
  sau 7 ngày** (app sẽ báo lỗi và hiện "Đăng nhập lại" trong Cài đặt › Tài khoản).
- `gmail.modify` là **restricted scope**: muốn mở cho mọi người phải **Publish app** và qua
  **xác minh của Google** (CASA security assessment). Việc này mất vài tuần, nên nộp sớm. Cần có
  trang chủ, Privacy Policy, Terms trên domain đã xác minh và video demo luồng dùng scope.

## 2. Microsoft Entra ID (Outlook / Microsoft 365)

1. https://entra.microsoft.com → **App registrations › New registration**:
   - Supported account types: **Accounts in any organizational directory and personal Microsoft
     accounts** (khớp `MICROSOFT_TENANT=common`).
   - Redirect URI: platform **Web** (không chọn SPA), giá trị
     `https://flutter-mail-cleaner.vercel.app/onboarding/oauth-callback`.
2. **Certificates & secrets › New client secret** → copy **Value** vào `MICROSOFT_CLIENT_SECRET`
   (secret có hạn, tối đa 24 tháng; nhớ gia hạn).
3. **API permissions › Add › Microsoft Graph › Delegated**: `offline_access`, `User.Read`,
   `Mail.ReadWrite`. Không cần admin consent cho tài khoản cá nhân. Tenant công ty có chặn user
   consent thì admin phải **Grant admin consent**.
4. **Overview** → copy Application (client) ID vào `MICROSOFT_CLIENT_ID`.
5. Production: **Branding & properties** → điền publisher domain (verified publisher) để màn consent
   không hiện cảnh báo "unverified".

## Chạy thử

- Sau khi đặt biến và redeploy: mở bản web → **Kết nối hộp thư** → **Đăng nhập với Google** hoặc
  **Đăng nhập bằng Microsoft** → đồng ý → app quay về, đồng bộ và chuyển sang màn quét.
- Chạy local (`flutter run -d chrome`) không có function `/api`, nên nút đăng nhập bị tắt. Muốn thử
  OAuth thật ở local thì dùng `vercel dev` ở root repo, và thêm redirect URI
  `http://localhost:3000/onboarding/oauth-callback` vào client.

## Giới hạn hiện tại

- Không có số liệu dung lượng hộp thư (Gmail API / Graph không trả quota với các scope này).
- Gmail: "Lưu trữ" là thư mục ảo (mail không có nhãn INBOX/SENT/DRAFT/SPAM/TRASH); lưu trữ = bỏ nhãn
  INBOX, giống web Gmail.
- Outlook: chỉ thư mục cấp cao nhất được liệt kê.
- Lần đồng bộ đầu của Gmail gọi một request cho mỗi mail (giới hạn 8 request song song, tự chờ khi
  bị 429). Hộp thư rất lớn sẽ mất một lúc.
