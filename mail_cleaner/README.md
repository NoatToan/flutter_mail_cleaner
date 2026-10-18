# AI Smart Mail (Mail Cleaner) — Project bundle

Thư mục này gom mọi thứ đã làm trong phiên lập kế hoạch (15–16/10/2026) để bạn code tiếp trên máy.

- `docs/PRODUCT.md` — định vị, đối thủ, personas, 25 use case (MoSCoW), roadmap, metrics.
- `docs/TECH_SPEC.md` — quyết định cần chốt, kiến trúc, provider matrix, sync engine, data model, AI pipeline, compliance, spike Phase 0.
- `docs/CHAT_HISTORY.md` — lịch sử trao đổi.
- `design/screens/*.dc.html` — 15 màn thiết kế iOS (390×844) + `canvas.json`. Mở trực tiếp bằng canvas online để xem đúng; file nguồn dùng làm tham chiếu layout, màu, copy tiếng Việt.

Bản gốc (sống, có sơ đồ, sửa/comment được):
- Tài liệu: https://claude.ai/code/artifact/20654471-10ad-46b9-889d-14e5e055b6b9
- Thiết kế: https://claude.ai/artifact/HpPJH6NnEnKC95pfgwa11s

Bước tiếp theo gợi ý: `flutter create --org com.donmail mail_cleaner` trong thư mục này, rồi theo TECH_SPEC §2–6 (Riverpod 3 + codegen, go_router, drift, freezed, enough_mail sau interface MailProvider).

## Bản web (Vercel)

- Build: `bash scripts/build_web.sh` → `build/web` (tự clone Flutter 3.47.7 vào `.flutter-sdk/` nếu máy không có `flutter`; đặt `FLUTTER=/path/to/flutter` để dùng SDK khác).
- Chạy thử: `flutter run -d chrome --web-header=Cross-Origin-Opener-Policy=same-origin --web-header=Cross-Origin-Embedder-Policy=credentialless`.
- Deploy: `vercel.json` ở root repo — Vercel chạy script trên và serve `mail_cleaner/build/web` (kèm header COOP/COEP để drift dùng OPFS).
- Drift trên web cần `web/sqlite3.wasm` + `web/drift_worker.js`, lấy từ release drift **đúng version trong `pubspec.lock`** (hiện 2.35.2) — nâng drift thì tải lại 2 file này.
- Hộp thư thật trên web: dùng **IMAP/SMTP** như app macOS (Gmail, Outlook, iCloud, mọi máy chủ IMAP), qua function `/api/mail` trên Vercel vì trình duyệt không mở được socket IMAP/SMTP. Không dùng Gmail API hay Graph. Gmail và Outlook đăng nhập bằng OAuth (XOAUTH2), iCloud và IMAP khác bằng app password. Gửi và trả lời mail qua SMTP. Cấu hình và giới hạn: [docs/OAUTH_WEB.md](docs/OAUTH_WEB.md). Function Node dùng **pnpm** (`package.json` ở root repo, `pnpm test`).
