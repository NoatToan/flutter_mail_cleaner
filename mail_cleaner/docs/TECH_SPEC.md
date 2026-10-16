# Technical Spec — Dọn Mail

> Bản gọn để code. Bản đầy đủ có nguồn trích dẫn + sơ đồ: tab "Technical Spec" của
> https://claude.ai/code/artifact/20654471-10ad-46b9-889d-14e5e055b6b9 (research ngày 16/10/2026).

## 1. Quyết định cần chốt (blocker)
- [ ] **Gmail: IMAP hay Gmail API?** Cả hai đều cần restricted scope → Google verification (~6 tuần) + **CASA hằng năm** (~540–1.800 USD). Gmail API cho sẵn snippet, category, history sync, batch modify. → Code qua interface `MailProvider` để đổi được.
- [ ] Ngân sách + lịch CASA. Testing mode: tối đa 100 user trọn đời project, refresh token hết hạn 7 ngày.
- [ ] Không hứa "digest đúng 7h sáng" (iOS BG ~30s, giờ do OS quyết).
- [ ] Dữ liệu train: **không** dùng nhãn của user Gmail để train model chung. Model nền train từ dữ liệu tổng hợp/công khai; cá nhân hoá on-device.
- [ ] "Open-rate" → **"tỉ lệ đã đọc"** (chỉ có cờ `\Seen`).

## 2. Kiến trúc
```
Flutter UI (Riverpod) ──commands──▶ Action Executor (queue + undo log)
     ▲ streams                              │
     │                                      ▼
  Local DB (drift/SQLite WAL+FTS5) ◀── Sync Engine (isolate) ──▶ MailProvider adapter ──▶ IMAP (Gmail/Outlook/iCloud)
     ▲                                                              ▲ token
     │                                                         Auth Manager (google_sign_in, flutter_appauth, secure storage)
  AI layer (rule → LiteRT model → Apple FM/Gemini Nano)
     │ (opt-in)
  PII Scrubber ──HTTPS──▶ LLM proxy (stateless, no log, App Attest) ──▶ LLM (Haiku / Flash-Lite, paid tier)
```
UI không gọi sync trực tiếp: thao tác → Action Executor, hiển thị ← stream từ DB.

## 3. Provider matrix
| | Gmail | Outlook.com / M365 | iCloud |
|---|---|---|---|
| Auth | OAuth2 XOAUTH2 | OAuth2 XOAUTH2 | App-specific password |
| Scope / host | `https://mail.google.com/` · imap.gmail.com:993 | `https://outlook.office.com/IMAP.AccessAsUser.All`, `SMTP.Send`, `offline_access` · outlook.office365.com:993 | imap.mail.me.com:993 · smtp.mail.me.com:587 |
| Lib | `google_sign_in` 7.x (Android không còn custom URI scheme) | `flutter_appauth` | — |
| CONDSTORE/QRESYNC | Có / Không | chưa xác minh | Có / Có |
| MOVE/UIDPLUS | Có/Có | chưa xác minh | chưa xác minh |
| QUOTA | Có (chung Drive/Photos) | chưa xác minh | không ổn định |
| Custom keyword | dùng `X-GM-LABELS` | **Không** | chưa xác minh |
| Giới hạn | tải 2.500 MB/ngày | TLS ≥1.2 | ? |
→ Spike S1 lấp các ô "chưa xác minh".

## 4. Sync engine
- First sync: `CAPABILITY` → `ENABLE CONDSTORE/QRESYNC` → `LIST` special-use → `SELECT` → `UID SEARCH ALL` → batch 500 UID **mới nhất trước**.
- FETCH: `UID FLAGS RFC822.SIZE INTERNALDATE BODYSTRUCTURE BODY.PEEK[HEADER.FIELDS (FROM TO CC SUBJECT DATE MESSAGE-ID IN-REPLY-TO LIST-ID LIST-UNSUBSCRIBE LIST-UNSUBSCRIBE-POST PRECEDENCE AUTO-SUBMITTED AUTHENTICATION-RESULTS DKIM-SIGNATURE CONTENT-TYPE REPLY-TO)]` (+ `X-GM-MSGID X-GM-THRID X-GM-LABELS` cho Gmail).
- Snippet pha 2: `BODY.PEEK[<part>]<0.1024>` chỉ cho mail rule chưa phân loại được. **Luôn PEEK** (không đặt `\Seen`).
- Gmail: sync `[Gmail]/All Mail` (key X-GM-MSGID) + Spam + Trash.
- Incremental: QRESYNC → VANISHED; CONDSTORE → `CHANGEDSINCE`; không có → diff UID + `FETCH 1:* (UID FLAGS)`.
- UIDVALIDITY đổi → stale + resync, match theo Message-ID/X-GM-MSGID, giữ dữ liệu AI.
- Batch action: dải UID, `UID MOVE`; fallback `COPY` + `STORE \Deleted` + `UID EXPUNGE` (cần UIDPLUS). Gmail xoá = MOVE `[Gmail]/Trash`.
- Undo: ghi `actions_log` trước; dùng `COPYUID`; fallback `UID SEARCH HEADER Message-ID`.
- ≤ 2 kết nối/tài khoản; backoff + jitter; đếm byte Gmail/ngày, dừng ~2.000 MB.

## 5. Data model (drift)
`accounts`, `folders`, `messages` (uid, gm_msgid, sender_id, subject, snippet, date, size, flags, gm_labels, list_id, unsub_*, dkim_ok, category, category_conf, protected, expires_at), `senders`, `tags`, `message_tags`, `actions_log`, `rules`, `labels_training` (local only), `summaries_cache`, `embeddings` (int8 256-d) + `messages_fts` (FTS5), `ai_transparency_log`. 100k mail ≈ 130–180 MB.

## 6. AI pipeline
1. **Rule (Dart):** List-Unsubscribe/List-Id, Precedence, Auto-Submitted, từ điển domain VN (sàn TMĐT, ngân hàng, hãng bay), regex OTP/hoá đơn/HĐĐT. Gmail thử `X-GM-RAW "category:promotions"` (spike S2).
2. **On-device:** EmbeddingGemma 308M (int8, 256-d) qua LiteRT + head 10 lớp; chỉ embed 3–8k mẫu khó, theo cụm sender, khi sạc. iOS 26.1+: Apple Foundation Models (content tagging). Android: Gemini Nano (ML Kit GenAI, foreground only).
3. **Cloud LLM (opt-in):** phân loại bù, NL → DSL, catch-up map-reduce, digest, trích xuất, RAG. PII scrub trên máy; Protected list không bao giờ gửi. Chi phí ~$0,09 (Haiku) – $0,25 (Flash-Lite)/user hoạt động/tháng.

## 7. Backend tối thiểu
LLM proxy stateless (Cloudflare Workers / Cloud Run), App Attest / Play Integrity, không log body, quota theo thiết bị. Website + domain + privacy policy cho Google verification. **Không** push server, **không** unsubscribe service ở MVP.

## 8. Compliance checklist
Google Limited Use · Apple 5.1.2(i) (consent trước khi gửi data cho AI bên thứ ba), 5.1.1, 2.5.4 · Play Data safety · Luật BVDLCN VN 2025 + NĐ 356/2025 (hồ sơ chuyển dữ liệu ra nước ngoài) · token trong Keychain/Keystore, tắt Android auto-backup · RFC 8058 chỉ khi `dkim=pass`, không unsubscribe mail Spam.

## 9. Spike Phase 0 (~29 ngày công)
| # | Mục tiêu | Tiêu chí đạt |
|---|---|---|
| S0 | Nộp Google verification, báo giá CASA | Đã nộp |
| S1 | Dump capability 3 provider × 2 loại TK | Lấp hết ô "chưa xác minh" |
| S2 | Gmail category qua X-GM-RAW | Khớp ≥ 95% |
| S3 | Hiệu năng enough_mail 100k header | < 15 phút, RAM < 300 MB |
| S4 | OAuth E2E + token trong background | OK cả 2 OS |
| S5 | Background thực tế 7 ngày | Có số liệu |
| S6 | Classifier tiếng Việt | Macro-F1 ≥ 0,85 |
| S7 | Apple FM / Gemini Nano tiếng Việt | Chấp nhận được |
| S8 | Undo 5k mail × 3 provider | Đúng 100% |
| S9 | Unsubscribe 30 newsletter | 0 false positive |
| S10 | Chi phí LLM | ≤ $0,15/user/tháng, không rò PII |
