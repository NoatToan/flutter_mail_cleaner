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
