# Thiết kế — AI Smart Mail

## iOS (`screens/`)
15 artboard 390×844. Trang chủ: Inbox.dc.html (hộp thư hợp nhất). Luồng: Welcome → AddAccount → Scanning → ScanReview → CleanDone → Main (Dọn dẹp).
Tokens: nền #F2F2F7 · accent #0A66D6 · xanh "an toàn" #157A41 · cam "xem lại" #B25400 · xám "bảo vệ" #6C6C70 · đỏ #B3261E · Gmail #C5221F · Outlook #0A66D6 · iCloud #4B49C8 · font hệ thống, large title 34/700.
Xem bản tương tác: https://claude.ai/artifact/HpPJH6NnEnKC95pfgwa11s

## macOS (`screens-macos/`)
Cùng 15 màn, tên file trùng bản iOS. Sinh bằng `tools/gen_macos.py` (sửa script rồi chạy lại, đừng sửa tay file .dc.html).
- **Cửa sổ chính 1360×860** (11 màn): sidebar 224 (Tổng quan · Hộp thư · Hộp thư thông minh · Công cụ · tài khoản + Cài đặt) + toolbar 52 + nội dung.
  Hộp thư/Đọc mail dùng 3 cột: danh sách 360 + khung đọc (chữ tối đa 640).
- **Onboarding 680×540** (Welcome, AddAccount, Scanning, CleanDone): cửa sổ dialog riêng, chỉ có traffic lights.
- **Cài đặt 720×620**: cửa sổ Preferences riêng với tab AI & Riêng tư / Tài khoản / Chung.
- **Lệnh AI**: palette nổi 620 px giữa cửa sổ (⌘K), nền mờ.
- Khác iOS: chữ body 13, hàng sidebar 26, hover/selection kiểu macOS, phím tắt hiển thị (← Xoá, ↑ Lưu trữ, ⌘U Huỷ ĐK, Giữ →), action mail nằm trên toolbar thay vì bottom bar.
- Responsive: xem TECH_SPEC §2a (breakpoint compact/medium/expanded/large, min window 900×600).
