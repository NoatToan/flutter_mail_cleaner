# AI Smart Mail (Mail Cleaner) — Product Brief

> Bản gọn để code. Bản đầy đủ (bảng đối thủ, sơ đồ, mock-up, MoSCoW dropdown) nằm trong Claude Docs:
> https://claude.ai/code/artifact/20654471-10ad-46b9-889d-14e5e055b6b9 (tab "Mail Cleaner App — Phân tích đối thủ & Use cases")

## Định vị
App Flutter đa nền tảng — **macOS, iOS, Android** — gom **Gmail, Outlook, iCloud** vào một hộp thư hợp nhất kiểu iOS Mail,
và dùng AI để **dọn inbox** (Smart Scan kiểu CleanMyMac), **tự gắn tag**, **tóm tắt newsletter**.
- Privacy-first: mail/header/index **không rời máy**; cloud LLM chỉ khi user opt-in, đã xoá PII.
- Kết nối bằng **IMAP** (OAuth2 XOAUTH2 cho Gmail/Outlook, app-specific password cho iCloud). POP3 bị loại.
- Nguyên tắc AI: AI *đề xuất* → user *duyệt*; mọi hành động có Undo; AI luôn giải thích lý do.

## Đối thủ (tóm tắt)
Clean Email (~$30/năm), Mailstrom (~$60/năm, web), SaneBox ($7–36/tháng), Leave Me Alone (~$90/năm, unsubscribe),
Cleanfox (free, bán dữ liệu thống kê), Unroll.me (free, scandal dữ liệu 2017). Khoảng trống: **mobile-first + on-device AI + LLM tóm tắt/đề xuất + hiểu ngữ cảnh VN**.

## Personas
- **A (MVP)** — người dùng cá nhân quá tải, Gmail gần đầy 15 GB, mua sắm online nhiều.
- **B** — dân văn phòng đa tài khoản (Gmail + Outlook công ty + iCloud).
- **C** — freelancer/chủ shop nhỏ, cần tách hoá đơn/khách khỏi promo.

## Use cases (25) — Must = MVP
| ID | Epic | Use case | AI làm gì | Ưu tiên |
|---|---|---|---|---|
| UC-01 | Kết nối | Thêm Gmail/Outlook bằng OAuth | Nhận diện provider từ email | Must |
| UC-02 | Kết nối | Thêm iCloud bằng app-specific password | Trợ lý từng bước, đọc lỗi login | Must |
| UC-03 | Kết nối | Quét header lần đầu có tiến độ | Phân loại ngay khi quét | Must |
| UC-04 | Hiểu inbox | Inbox Health Score + dashboard dung lượng | Nhận xét bằng lời | Must |
| UC-05 | Hiểu inbox | Top senders (số lượng, dung lượng, tỉ lệ **đã đọc**) | Xếp hạng "độ vô ích" | Must |
| UC-06 | Hiểu inbox | Phân loại 10 nhóm | Rule + on-device ML, LLM cho ca khó | Must |
| UC-24 | Hiểu inbox | Auto-tag đa nhãn (Tài chính, HR, News, Promotion + tag tự tạo bằng lời) | Gắn nhiều tag + độ tin cậy, học từ sửa tag | Must |
| UC-07 | Dọn dẹp | AI Cleanup Plan 1 chạm | Gom đề xuất + lý do + confidence | Must |
| UC-25 | Dọn dẹp | **Storage Smart Scan** kiểu CleanMyMac | An toàn / Nên xem lại / Được bảo vệ; tick sẵn mục an toàn | Must |
| UC-08 | Dọn dẹp | Swipe review theo sender | Chip gợi ý; swipe = nhãn học (chỉ local) | Must |
| UC-09 | Dọn dẹp | Lệnh ngôn ngữ tự nhiên | LLM → JSON DSL → preview → chạy | Should |
| UC-10 | Dọn dẹp | Đính kèm lớn | Đoán file lỗi thời | Should |
| UC-11 | Dọn dẹp | Tự dọn OTP/mail hết hạn | Nhận diện "half-life" ngắn | Must (chạy khi mở app) |
| UC-12 | Dọn dẹp | Undo + lịch sử | — | Must |
| UC-13 | Unsubscribe | Unsubscribe 1 chạm (RFC 8058 / mailto) | Zombie subscription | Should |
| UC-14 | Unsubscribe | Rollup newsletter | LLM tóm tắt | Should |
| UC-23 | Unsubscribe | **Subscription Catch-up** (tóm tắt cả loạt chưa đọc) | Map-reduce, gộp tin trùng, dẫn nguồn | Should |
| UC-15 | Giữ sạch | AI gợi ý rule từ hành vi | | Should |
| UC-16 | Giữ sạch | Screener sender mới | | Could |
| UC-17 | AI đọc hộ | Daily Digest (best-effort) | Tóm tắt + ưu tiên | Should |
| UC-18 | AI đọc hộ | Trích xuất việc cần làm | | Could |
| UC-19 | AI đọc hộ | Tìm kiếm ngữ nghĩa | Embedding on-device | Could |
| UC-20 | AI đọc hộ | Chat với inbox | RAG local | Later |
| UC-21 | An toàn | Protected list (ngân hàng, hợp đồng, hoá đơn, thuế) | Chạy trước mọi đề xuất xoá | Must |
| UC-22 | An toàn | Chế độ AI on-device / cloud + log minh bạch | | Must |

**Mới thêm theo design:** Trang chủ = **hộp thư hợp nhất kiểu iOS Mail** (Tất cả hộp thư đến + xem riêng từng provider), màn **Hộp thư** (mailboxes + hộp thư thông minh theo tag), màn **Đọc mail** có thẻ AI tóm tắt.

## Nền tảng & thứ tự phát hành
| Nền tảng | Kiểu giao diện | Thứ tự |
|---|---|---|
| **macOS** (13+) | Cửa sổ 3 cột kiểu Apple Mail: sidebar · danh sách · đọc mail; Cài đặt là cửa sổ riêng; phím tắt | **1 — làm trước** |
| iOS (17+) | Tab bar 5 tab, large title (design/screens) | 2 |
| Android (API 26+) | Cùng luồng iOS, theo Material 3 | 3 |

Core logic (domain, sync, AI rule, DB) **dùng chung 100%**; chỉ lớp presentation thích ứng theo kích thước màn hình (xem TECH_SPEC §2a).

## Roadmap
- **Phase 0 — Spike (1–2 tuần):** kết nối 3 provider, đo fetch 50–100k header, rule engine thô, **nộp Google verification ngay**.
- **Phase 1 — MVP (4–6 tuần):** các use case Must, Smart Scan + swipe, beta ≤ 100 test user.
- **Phase 2:** UC-09, 10, 13–15, 17, 23 (cần LLM). Cổng: xong Google CASA → mở public.
- **Phase 3:** UC-16, 18–20, cân nhắc backend push.

## Metrics
North Star: số mail được dọn/user trong tuần đầu + Undo rate thấp. Theo dõi: time-to-first-clean, AI acceptance rate, Undo rate, D7/D30, drop-off onboarding theo provider (đặc biệt iCloud).
