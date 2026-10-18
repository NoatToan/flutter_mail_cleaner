# Bản web: kết nối hộp thư qua IMAP/SMTP

Bản web dùng **đúng IMAP (đọc, dọn) và SMTP (gửi)** như app macOS, cho mọi nhà cung cấp: Gmail,
Outlook/Microsoft 365, iCloud và mọi máy chủ IMAP. Không dùng Gmail API hay Microsoft Graph.

Trình duyệt không mở được socket IMAP/SMTP, nên mỗi thao tác đi qua function **`/api/mail`**
(`api/mail.js` + `api/_mail/bridge.js`, Node, dùng `imapflow` và `nodemailer`):

- Không lưu trạng thái. Mỗi request mở một phiên IMAP hoặc SMTP, làm một việc, rồi đóng.
- Thông tin đăng nhập (app password hoặc OAuth access token) gửi kèm từng request qua HTTPS, chỉ
  dùng cho phiên đó, **không lưu và không ghi log**. Trong app, chúng được lưu trong trình duyệt
  (flutter_secure_storage).
- Đọc luôn dùng `BODY.PEEK`, nên không làm mất trạng thái chưa đọc.
- Chỉ nhận request cùng origin. Chỉ kết nối tới máy chủ có địa chỉ công khai, cổng IMAP 993/143
  và SMTP 465/587, để function không bị dùng để dò mạng nội bộ.
- Thao tác: `verify`, `folders`, `headers` (phân trang, đồng bộ tăng dần theo UID), `body`,
  `move`, `seen`, `quota`, `send`.

Phía app: `BridgeMailProvider` (đọc/dọn) và `MailSender` (gửi). Trên macOS, `MailSender` gửi
SMTP trực tiếp bằng enough_mail.

## Cách người dùng kết nối

| Hộp thư | Đăng nhập | IMAP | SMTP |
| --- | --- | --- | --- |
| Gmail | Google (OAuth, XOAUTH2) hoặc app password | imap.gmail.com:993 | smtp.gmail.com:465 |
| Outlook / Microsoft 365 | Microsoft (OAuth, XOAUTH2) | outlook.office365.com:993 | smtp.office365.com:587 |
| iCloud | App password | imap.mail.me.com:993 | smtp.mail.me.com:587 |
| IMAP khác | Mật khẩu / app password | tự nhập | `smtp.<domain>`:465 |

Đăng nhập Google/Microsoft là chuyển cả trang sang nhà cung cấp rồi quay về
`/onboarding/oauth-callback` (authorization code + PKCE). Đổi code lấy token và refresh token đi
qua `api/oauth-token.js`: function này giữ client secret, và chỉ trả địa chỉ email lấy từ
`id_token` cho app, không trả cả `id_token`. Trước khi lưu tài khoản, app luôn thử đăng nhập IMAP
thật.

## Biến môi trường trên Vercel

Vercel → project → **Settings › Environment Variables** (Production + Preview), xong thì
**Redeploy**:

| Biến | Giá trị |
| --- | --- |
| `GOOGLE_WEB_CLIENT_ID` | Client ID của OAuth client loại **Web application** |
| `GOOGLE_WEB_CLIENT_SECRET` | Client secret tương ứng |
| `MICROSOFT_CLIENT_ID` | Application (client) ID của app registration |
| `MICROSOFT_CLIENT_SECRET` | Client secret (lấy **Value**, không phải Secret ID) |
| `MICROSOFT_TENANT` | Không bắt buộc. Mặc định `common`; có thể đặt `consumers` hoặc tenant ID |

iCloud và IMAP khác không cần biến nào. Thiếu biến của Google/Microsoft thì nút đăng nhập tương
ứng hiện "chưa được cấu hình", nhưng Gmail vẫn kết nối được bằng app password.

Kiểm tra: `curl https://<domain>/api/oauth-config` phải trả client ID và không bao giờ trả secret.

## 1. Google Cloud (Gmail qua IMAP)

1. **OAuth consent screen**: thêm các scope `openid`, `email`, `https://mail.google.com/`. Thêm
   **Authorized domain** (`vercel.app` hoặc domain riêng).
2. **Credentials › OAuth client ID › Web application**:
   - Authorized JavaScript origins: `https://fluttermailcleaner.vercel.app`
   - Authorized redirect URIs: `https://fluttermailcleaner.vercel.app/onboarding/oauth-callback`
   - Mỗi domain khác (domain riêng, preview) cần thêm một cặp origin/redirect; Google không nhận
     wildcard.
3. Copy client ID/secret vào `GOOGLE_WEB_CLIENT_ID` / `GOOGLE_WEB_CLIENT_SECRET`.

Production: `https://mail.google.com/` là **restricted scope**. Ở chế độ Testing, chỉ email trong
danh sách Test users đăng nhập được, và refresh token hết hạn sau 7 ngày (app sẽ hiện "Đăng nhập
lại"). Muốn mở cho mọi người phải Publish app và qua xác minh của Google (CASA), mất vài tuần.
Trong lúc chờ, người dùng Gmail vẫn kết nối được bằng **app password** (cần bật xác minh 2 bước).

## 2. Microsoft Entra ID (Outlook / Microsoft 365 qua IMAP)

1. https://entra.microsoft.com → **App registrations › New registration**:
   - Supported account types: **Accounts in any organizational directory and personal Microsoft
     accounts**.
   - Redirect URI: platform **Web** (không chọn SPA),
     `https://fluttermailcleaner.vercel.app/onboarding/oauth-callback`.
2. **Certificates & secrets › New client secret**: copy **Value** vào `MICROSOFT_CLIENT_SECRET`.
   Secret có hạn, tối đa 24 tháng, nhớ gia hạn.
3. **API permissions › Add a permission**:
   - Microsoft Graph › Delegated: `openid`, `email`, `offline_access`.
   - **APIs my organization uses › Office 365 Exchange Online** › Delegated: `IMAP.AccessAsUser.All`,
     `SMTP.Send`.
4. Với tenant Microsoft 365, admin phải bật **SMTP AUTH** cho mailbox (Exchange admin center ›
   Mailbox › Manage email apps › Authenticated SMTP) và cấp admin consent nếu tenant chặn user
   consent. Tài khoản Outlook.com cá nhân không cần bước này.

## Chạy thử ở máy

- Bridge: `pnpm install && pnpm test` ở root repo. Muốn chạy cả test tích hợp với một máy chủ
  IMAP/SMTP thật ở máy (ví dụ GreenMail standalone trên 3993/3465, user `tester@localhost` /
  `pw123`), thêm `MAIL_BRIDGE_IT=1 MAIL_BRIDGE_ALLOW_PRIVATE=1`. Biến
  `MAIL_BRIDGE_ALLOW_PRIVATE` chỉ dùng khi test ở máy, **không bao giờ** đặt trên Vercel.
- App: `vercel dev` ở root repo chạy cả bản web lẫn các function `/api`. `flutter run -d chrome`
  không có `/api`, nên không kết nối được hộp thư thật.

## Giới hạn hiện tại

- Mỗi thao tác là một phiên IMAP mới, nên chậm hơn app macOS. Đồng bộ lần đầu tải 200 header mỗi
  lần gọi.
- Gửi mail chỉ hỗ trợ văn bản thuần, chưa có file đính kèm. Gmail và Outlook tự lưu thư đã gửi
  vào Sent; iCloud và máy chủ IMAP khác thì chưa.
- Gmail: giống bản macOS, "Lưu trữ" chưa chuyển mail sang All Mail.
