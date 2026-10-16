#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Generates the 15 macOS .dc.html mockups for Mail Cleaner, sharing one sidebar/toolbar chrome."""
import os

OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "screens-macos")
os.makedirs(OUT, exist_ok=True)

# ---------- tokens ----------
ACCENT = "#0A66D6"
ACCENT_DK = "#084FA8"
SAFE = "#157A41"
REVIEW = "#B25400"
PROTECT = "#6C6C70"
DANGER = "#B3261E"
GMAIL = "#C5221F"
OUTLOOK = "#0A66D6"
ICLOUD = "#4B49C8"
SIDEBAR_BG = "#F6F6F7"
SIDEBAR_BORDER = "#D7D7D9"
TOOLBAR_BG = "#FBFBFC"
DIVIDER = "#E2E2E4"
TEXT = "#1C1C1E"
SUBTEXT = "#6C6C70"
HEADER_GRAY = "#8E8E93"

ICON = {
  "inbox": '<path d="M3 13l2.5-8h13L21 13v6a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1z"></path><path d="M3 13h5l1.5 3h5L16 13h5"></path>',
  "sparkle1": '<path d="M12 3l1.8 4.7L18.5 9.5l-4.7 1.8L12 16l-1.8-4.7L5.5 9.5l4.7-1.8z"></path>',
  "sparkle2": '<path d="M12 3l1.8 4.7L18.5 9.5l-4.7 1.8L12 16l-1.8-4.7L5.5 9.5l4.7-1.8z"></path><path d="M19 15l.8 2.2L22 18l-2.2.8L19 21l-.8-2.2L16 18l2.2-.8z"></path>',
  "people": '<circle cx="9" cy="8" r="3.5"></circle><path d="M2.5 20c0-3.6 2.9-6 6.5-6s6.5 2.4 6.5 6"></path><path d="M16 4.5a3.5 3.5 0 0 1 0 7M18 14.2c2.1.7 3.5 2.8 3.5 5.8"></path>',
  "tag": '<path d="M3 12V4a1 1 0 0 1 1-1h8l9 9-9 9z"></path><circle cx="7.5" cy="7.5" r="1.5"></circle>',
  "gear": '<circle cx="12" cy="12" r="3"></circle><path d="M12 2.5v3M12 18.5v3M2.5 12h3M18.5 12h3M5.3 5.3l2.1 2.1M16.6 16.6l2.1 2.1M5.3 18.7l2.1-2.1M16.6 7.4l2.1-2.1"></path>',
  "chevron-right": '<path d="M9 5l7 7-7 7"></path>',
  "chevron-left": '<path d="M15 5l-7 7 7 7"></path>',
  "chevron-up": '<path d="M5 15l7-7 7 7"></path>',
  "chevron-down": '<path d="M5 9l7 7 7-7"></path>',
  "check": '<path d="M5 12.5l4.5 4.5L19 7.5"></path>',
  "archive": '<rect x="3" y="4" width="18" height="5" rx="1"></rect><path d="M5 9v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V9M10 13h4"></path>',
  "trash": '<path d="M4 7h16M9 7V4h6v3M6 7l1 13h10l1-13"></path>',
  "shield": '<rect x="5" y="11" width="14" height="10" rx="2"></rect><path d="M8 11V8a4 4 0 0 1 8 0v3"></path>',
  "newspaper": '<path d="M5 4h11a2 2 0 0 1 2 2v14H7a2 2 0 0 1-2-2z"></path><path d="M9 8h5M9 12h5"></path>',
  "search": '<circle cx="11" cy="11" r="6.5"></circle><path d="M16 16l4.5 4.5"></path>',
  "unsub": '<rect x="3" y="5" width="18" height="14" rx="2"></rect><path d="M4 20L20 4"></path>',
  "reply": '<path d="M10 8L5 13l5 5"></path><path d="M5 13h9a5 5 0 0 1 5 5v1"></path>',
  "undo": '<path d="M9 14L4 9l5-5"></path><path d="M4 9h10a6 6 0 0 1 0 12h-3"></path>',
  "compose": '<path d="M20 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h6"></path><path d="M17.5 3.5l3 3L12 15l-4 1 1-4z"></path>',
  "filter": '<circle cx="12" cy="12" r="9.5"></circle><path d="M7.5 9.5h9M9 12.5h6M10.5 15.5h3"></path>',
  "sidebar": '<rect x="3" y="4" width="18" height="16" rx="2"></rect><path d="M9.5 4v16"></path>',
  "mail": '<rect x="3" y="5" width="18" height="14" rx="2"></rect><path d="M3 7l9 6 9-6"></path>',
  "refresh": '<path d="M20 12a8 8 0 1 1-2.3-5.7"></path><path d="M20 4v5h-5"></path>',
  "more": '<circle cx="12" cy="12" r="9.5"></circle><circle cx="8" cy="12" r="0.8" fill="currentColor"></circle><circle cx="12" cy="12" r="0.8" fill="currentColor"></circle><circle cx="16" cy="12" r="0.8" fill="currentColor"></circle>',
  "plus": '<path d="M12 5v14M5 12h14"></path>',
  "mic": '<rect x="9" y="3" width="6" height="11" rx="3"></rect><path d="M5 11a7 7 0 0 0 14 0M12 18v3"></path>',
  "folder": '<rect x="3" y="6" width="18" height="13" rx="2"></rect><path d="M3 10h18M7 15h3"></path>',
  "wifi-off": '<path d="M3 12a9 9 0 1 0 3-6.7"></path><path d="M3 4v4.5h4.5"></path>',
  "device": '<rect x="6" y="2.5" width="12" height="19" rx="2.5"></rect><path d="M10.5 18.5h3"></path>',
}

def svg(name, w=16, h=16, stroke="currentColor", sw=1.8, extra=""):
    return (f'<svg aria-hidden="true" width="{w}" height="{h}" viewBox="0 0 24 24" fill="none" '
            f'stroke="{stroke}" stroke-width="{sw}" stroke-linecap="round" stroke-linejoin="round" {extra}>{ICON[name]}</svg>')

# ---------- sidebar ----------
NAV_TOP = [dict(id="dashboard", href="Main.dc.html", icon="sparkle2", label="Tổng quan", count=None)]

NAV_MAILBOXES = [
    dict(id="inbox-all", href="Inbox.dc.html", icon="inbox", label="Tất cả hộp thư đến", count="48", iconColor=ACCENT),
    dict(id="gmail", href="Inbox.dc.html", badge="G", badgeColor=GMAIL, label="Gmail", count="21"),
    dict(id="outlook", href="Inbox.dc.html", badge="O", badgeColor=OUTLOOK, label="Outlook", count="17"),
    dict(id="icloud", href="Inbox.dc.html", badge="i", badgeColor=ICLOUD, label="iCloud", count="10"),
]

NAV_SMART = [
    dict(id="smart-scan", href="ScanReview.dc.html", icon="sparkle1", label="Cần dọn", count="3,2 GB", iconColor=SAFE, strong=True),
    dict(id="tag-finance", href="Tags.dc.html", dot="#1E3A8A", label="Tài chính", count="842"),
    dict(id="tag-hr", href="Tags.dc.html", dot="#6D28D9", label="HR", count="214"),
    dict(id="tag-news", href="CatchUp.dc.html", dot="#0F766E", label="News", count="2.108"),
    dict(id="tag-promo", href="Tags.dc.html", dot="#C2410C", label="Promotion", count="10.926"),
    dict(id="tag-trip", href="Tags.dc.html", dot="#0E7490", label="Chuyến đi", count="46"),
]

NAV_TOOLS = [
    dict(id="senders", href="Senders.dc.html", icon="people", label="Người gửi", count=None),
    dict(id="tags", href="Tags.dc.html", icon="tag", label="Tags", count=None),
    dict(id="ai-command", href="AICommand.dc.html", icon="sparkle2", label="Lệnh AI", count=None),
    dict(id="catchup", href="CatchUp.dc.html", icon="newspaper", label="Bắt kịp", count=None),
]

def nav_row(item, active_id):
    on = item["id"] == active_id
    bg = ACCENT if on else "transparent"
    fg = "#FFFFFF" if on else TEXT
    sub = "rgba(255,255,255,0.8)" if on else SUBTEXT
    weight = "600" if on else "500" if item.get("strong") else "400"
    if item.get("icon"):
        icon_color = "#FFFFFF" if on else item.get("iconColor", SUBTEXT)
        leading = f'<span style="width:16px;height:16px;display:flex;align-items:center;justify-content:center;flex:none">{svg(item["icon"], 15, 15, stroke=icon_color, sw=1.9)}</span>'
    elif item.get("badge"):
        leading = (f'<span style="width:16px;height:16px;border-radius:4px;background:{item["badgeColor"]};color:#fff;'
                   f'font-size:9px;font-weight:700;display:flex;align-items:center;justify-content:center;flex:none">{item["badge"]}</span>')
    elif item.get("dot"):
        leading = f'<span style="width:7px;height:7px;border-radius:3.5px;background:{item["dot"]};flex:none;margin:0 4.5px"></span>'
    else:
        leading = '<span style="width:16px;flex:none"></span>'
    count_html = f'<span style="font-size:11px;color:{sub};font-variant-numeric:tabular-nums;flex:none">{item["count"]}</span>' if item.get("count") else ""
    return (f'<a href="{item["href"]}" style="height:26px;border-radius:6px;display:flex;align-items:center;gap:7px;'
            f'padding:0 8px;margin:0 6px;text-decoration:none;color:{fg};background:{bg};font-size:12.5px;font-weight:{weight}">'
            f'{leading}<span style="flex:1;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">{item["label"]}</span>{count_html}</a>')

def section_header(label):
    return (f'<div style="height:22px;display:flex;align-items:center;padding:0 14px;margin-top:10px;'
            f'font-size:10.5px;font-weight:600;color:{HEADER_GRAY};text-transform:uppercase;letter-spacing:0.3px">{label}</div>')

def sidebar(active_id):
    rows = []
    for it in NAV_TOP:
        rows.append(nav_row(it, active_id))
    rows.append(section_header("Hộp thư"))
    for it in NAV_MAILBOXES:
        rows.append(nav_row(it, active_id))
    rows.append(section_header("Hộp thư thông minh"))
    for it in NAV_SMART:
        rows.append(nav_row(it, active_id))
    rows.append(section_header("Công cụ"))
    for it in NAV_TOOLS:
        rows.append(nav_row(it, active_id))
    rows_html = "".join(rows)
    return f'''<div style="position:absolute;top:0;left:0;bottom:0;width:224px;min-width:180px;max-width:320px;background:{SIDEBAR_BG};border-right:1px solid {SIDEBAR_BORDER};display:flex;flex-direction:column;flex:none">
    <div style="height:52px;flex:none;display:flex;align-items:center;padding:0 0 0 20px;gap:8px;-webkit-app-region:drag">
      <span style="width:12px;height:12px;border-radius:6px;background:#FF5F57;border:0.5px solid rgba(0,0,0,0.12)"></span>
      <span style="width:12px;height:12px;border-radius:6px;background:#FEBC2E;border:0.5px solid rgba(0,0,0,0.12)"></span>
      <span style="width:12px;height:12px;border-radius:6px;background:#28C840;border:0.5px solid rgba(0,0,0,0.12)"></span>
    </div>
    <div style="flex:1;overflow:hidden;padding:2px 0 8px;display:flex;flex-direction:column;gap:2px">{rows_html}</div>
    <div style="height:44px;flex:none;border-top:1px solid {DIVIDER};display:flex;align-items:center;padding:0 10px;gap:8px">
      <span style="width:24px;height:24px;border-radius:12px;background:linear-gradient(135deg, {ACCENT}, {SAFE});color:#fff;font-size:11px;font-weight:700;display:flex;align-items:center;justify-content:center;flex:none">T</span>
      <span style="flex:1;font-size:12px;color:{TEXT};white-space:nowrap;overflow:hidden;text-overflow:ellipsis">Toàn Nguyễn</span>
      <a href="Settings.dc.html" aria-label="Cài đặt" style="width:24px;height:24px;border-radius:6px;display:flex;align-items:center;justify-content:center;color:{SUBTEXT};text-decoration:none;flex:none">{svg("gear", 15, 15, stroke=SUBTEXT, sw=1.8)}</a>
    </div>
  </div>'''

# ---------- shells ----------
WIN_W, WIN_H = 1360, 860
DLG_W, DLG_H = 680, 540

PAGE_HEAD = '''<!doctype html>
<html lang="vi">
<head>
<meta charset="utf-8">
<title>{title}</title>
<script src="./support.js"></script>
</head>
<body>
<x-dc>
<helmet>
<style>
body{{margin:0}}
a{{color:#0A66D6}}a:hover{{color:#084FA8}}
::-webkit-scrollbar{{width:10px;height:10px}}
::-webkit-scrollbar-thumb{{background:rgba(0,0,0,0.18);border-radius:5px;border:2px solid transparent;background-clip:padding-box}}
</style>
</helmet>
'''

PAGE_TAIL_STATIC = '''
</x-dc>
<script type="text/x-dc" data-dc-script data-props='{{"$preview":{{"width":{w},"height":{h}}}}}'>
class Component extends DCLogic {{
renderVals() {{ return {{}}; }}
}}
</script>
</body>
</html>
'''

def window_shell(title, active_id, toolbar_html, body_html):
    inner = f'''<div style="width:{WIN_W}px;height:{WIN_H}px;box-sizing:border-box;background:#FFFFFF;font-family:-apple-system,'SF Pro Text',system-ui,sans-serif;color:{TEXT};position:relative;overflow:hidden;border-radius:10px;box-shadow:0 30px 70px rgba(0,0,0,0.35)">
  {sidebar(active_id)}
  <div style="position:absolute;top:0;left:224px;right:0;bottom:0;display:flex;flex-direction:column;min-width:560px">
    <div style="height:52px;flex:none;border-bottom:1px solid {DIVIDER};background:{TOOLBAR_BG};display:flex;align-items:center;padding:0 16px;gap:10px;box-sizing:border-box">
      {toolbar_html}
    </div>
    <div style="flex:1;display:flex;overflow:hidden;min-height:0">
      {body_html}
    </div>
  </div>
  <div aria-hidden="true" style="position:absolute;inset:0;border-radius:10px;box-shadow:inset 0 0 0 1px rgba(0,0,0,0.08);pointer-events:none"></div>
</div>'''
    return PAGE_HEAD.format(title=title) + inner + PAGE_TAIL_STATIC.format(w=WIN_W, h=WIN_H)

def dialog_shell(title, top_left_html, top_right_html, body_html, w=DLG_W, h=DLG_H):
    inner = f'''<div style="width:{w}px;height:{h}px;box-sizing:border-box;background:#FFFFFF;font-family:-apple-system,'SF Pro Text',system-ui,sans-serif;color:{TEXT};position:relative;overflow:hidden;border-radius:10px;box-shadow:0 30px 70px rgba(0,0,0,0.35);display:flex;flex-direction:column">
    <div style="height:52px;flex:none;display:flex;align-items:center;justify-content:space-between;padding:0 14px 0 20px;box-sizing:border-box;-webkit-app-region:drag">
      <div style="display:flex;align-items:center;gap:12px">
        <div style="display:flex;align-items:center;gap:8px">
          <span style="width:12px;height:12px;border-radius:6px;background:#FF5F57;border:0.5px solid rgba(0,0,0,0.12)"></span>
          <span style="width:12px;height:12px;border-radius:6px;background:#FEBC2E;border:0.5px solid rgba(0,0,0,0.12)"></span>
          <span style="width:12px;height:12px;border-radius:6px;background:#28C840;border:0.5px solid rgba(0,0,0,0.12)"></span>
        </div>
        {top_left_html}
      </div>
      {top_right_html}
    </div>
    <div style="flex:1;overflow:auto;min-height:0">{body_html}</div>
  </div>'''
    return PAGE_HEAD.format(title=title) + inner + PAGE_TAIL_STATIC.format(w=w, h=h)

def write(name, html):
    path = os.path.join(OUT, name)
    with open(path, "w", encoding="utf-8") as f:
        f.write(html)
    print("wrote", path)

# =====================================================================
# Shared small components
# =====================================================================

def toolbar_btn(icon, label, color=ACCENT, w=28, h=28, sw=1.8):
    return (f'<button aria-label="{label}" style="width:{w}px;height:{h}px;border:none;background:transparent;color:{color};'
            f'cursor:pointer;display:flex;align-items:center;justify-content:center;border-radius:6px;flex:none">{svg(icon, 17, 17, stroke=color, sw=sw)}</button>')

def search_field(placeholder="Tìm kiếm", width=220):
    return (f'<label style="height:28px;width:{width}px;border-radius:7px;background:rgba(118,118,128,0.12);display:flex;'
            f'align-items:center;gap:6px;padding:0 8px;color:{SUBTEXT};flex:none;box-sizing:border-box">'
            f'{svg("search", 13, 13, stroke=SUBTEXT, sw=2.2)}<span style="font-size:12px;color:{SUBTEXT}">{placeholder}</span></label>')

def ask_ai_pill():
    return (f'<a href="AICommand.dc.html" style="height:26px;padding:0 10px;border-radius:13px;background:#E3EEFC;color:#0A5BC4;'
            f'display:flex;align-items:center;gap:5px;text-decoration:none;font-size:12px;font-weight:600;flex:none">'
            f'{svg("sparkle2", 13, 13, stroke="#0A5BC4", sw=2)}<span>Hỏi AI</span></a>')

MAILS = [
    dict(a="gmail", color=GMAIL, badge="G", sender="Ngân hàng ACB", time="09:41", subject="Sao kê thẻ tín dụng kỳ 10/2026",
         preview="Sao kê thẻ đuôi 4821 kỳ 15/09 – 14/10 đã sẵn sàng. Hạn thanh toán: 05/11.", unread=True, tag="Tài chính"),
    dict(a="outlook", color=OUTLOOK, badge="O", sender="Phòng Nhân sự", time="09:12", subject="Chào mừng Toàn — lịch onboarding tuần đầu",
         preview="Thứ Hai 9:00 nhận thiết bị tại tầng 5, 10:30 gặp team Product.", unread=True, tag="HR"),
    dict(a="gmail", color=GMAIL, badge="G", sender="Tech Brief VN", time="08:30", subject="Số #143: Startup AI Việt chuyển sang mô hình nhỏ",
         preview="Giá thuê GPU giảm gần 30% trong quý; nhiều đội chuyển sang suy luận trên thiết bị.", unread=True, tag="News", selected=True),
    dict(a="gmail", color=GMAIL, badge="G", sender="Shopee", time="08:05", subject="Flash Sale 16.10 — giảm đến 50%",
         preview="Săn deal 0Đ từ 0h, freeship mọi đơn từ 0Đ.", unread=False, tag="Promotion"),
    dict(a="outlook", color=OUTLOOK, badge="O", sender="Minh Anh", time="07:48", subject="Re: Review UI màn Smart Scan",
         preview="Mình thấy nút Dọn nên hiện dung lượng đang chọn, Chiều nay sync 15 phút nhé?", unread=True, tag=""),
    dict(a="icloud", color=ICLOUD, badge="i", sender="Vietjet Air", time="Hôm qua", subject="Xác nhận đặt chỗ SGN → HAN, 24/10",
         preview="Mã đặt chỗ: [MÃ ĐẶT CHỖ]. Chuyến bay khởi hành 07:15.", unread=True, tag="Chuyến đi"),
    dict(a="icloud", color=ICLOUD, badge="i", sender="Grab", time="Hôm qua", subject="Biên nhận chuyến GrabCar của bạn",
         preview="Cảm ơn bạn đã đi cùng Grab. Tổng cộng 86.000đ.", unread=False, tag=""),
    dict(a="gmail", color=GMAIL, badge="G", sender="VCB Digibank", time="Hôm qua", subject="Mã OTP xác thực giao dịch",
         preview="Mã OTP của bạn có hiệu lực trong 5 phút.", unread=False, tag=""),
]
TAG_COLORS = {"Tài chính": ("#E6ECF8", "#1E3A8A"), "HR": ("#EFE7FB", "#5B21B6"), "News": ("#E0F2EF", "#0F5F58"),
              "Promotion": ("#FCEEDF", "#9A4700"), "Chuyến đi": ("#E0F0F5", "#0E6178")}

def mail_row(m, width=360):
    on = m.get("selected")
    rowbg = "#D7E6FB" if on else "#FFFFFF"
    weight = "600" if m["unread"] else "400"
    tag_html = ""
    if m["tag"]:
        bg, fg = TAG_COLORS[m["tag"]]
        tag_html = f'<span style="height:16px;padding:0 6px;border-radius:5px;background:{bg};color:{fg};font-size:10px;font-weight:600;display:flex;align-items:center;flex:none">{m["tag"]}</span>'
    unread_dot = f'<span style="width:7px;height:7px;border-radius:3.5px;background:{ACCENT};flex:none;margin-top:6px"></span>' if m["unread"] else '<span style="width:7px;flex:none"></span>'
    return f'''<a href="MailDetail.dc.html" style="display:flex;gap:8px;padding:9px 12px;text-decoration:none;color:{TEXT};border-bottom:1px solid #ECECEE;background:{rowbg};box-sizing:border-box">
    {unread_dot}
    <span style="width:14px;height:14px;border-radius:4px;background:{m["color"]};color:#fff;font-size:8px;font-weight:700;display:flex;align-items:center;justify-content:center;flex:none;margin-top:2px">{m["badge"]}</span>
    <span style="flex:1;display:flex;flex-direction:column;gap:2px;min-width:0">
      <span style="display:flex;justify-content:space-between;gap:6px"><span style="font-size:12.5px;font-weight:{weight};white-space:nowrap;overflow:hidden;text-overflow:ellipsis">{m["sender"]}</span><span style="font-size:11px;color:{SUBTEXT};flex:none">{m["time"]}</span></span>
      <span style="display:flex;justify-content:space-between;gap:6px"><span style="font-size:12px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;flex:1">{m["subject"]}</span>{tag_html}</span>
      <span style="font-size:11.5px;color:{SUBTEXT};line-height:15px;overflow:hidden;display:-webkit-box;-webkit-line-clamp:1;-webkit-box-orient:vertical">{m["preview"]}</span>
    </span>
  </a>'''

def list_pane(width=360, scope_pill="Tất cả", show_ai_banner=True):
    scopes = ["Tất cả", "Gmail", "Outlook", "iCloud"]
    scope_html = "".join(
        f'<span style="height:24px;padding:0 10px;border-radius:12px;background:{"#1C1C1E" if s==scope_pill else "#EDEDEF"};color:{"#fff" if s==scope_pill else "#1C1C1E"};font-size:11.5px;font-weight:600;display:flex;align-items:center">{s}</span>'
        for s in scopes)
    cats = ["Chính", "Giao dịch", "Cập nhật", "Khuyến mãi"]
    cat_html = "".join(
        f'<span style="height:22px;padding:0 8px;border-radius:6px;background:#fff;box-shadow:inset 0 0 0 1px #D9D9DC;color:#0A4FA8;font-size:10.5px;font-weight:600;display:flex;align-items:center">{c}</span>'
        for c in cats)
    banner = ""
    if show_ai_banner:
        banner = (f'<a href="ScanReview.dc.html" style="margin:8px 10px 0;height:36px;border-radius:9px;background:#EEF4FD;display:flex;align-items:center;gap:8px;'
                  f'padding:0 10px;text-decoration:none;color:#0A3F87;flex:none">{svg("sparkle1",14,14,stroke=ACCENT,sw=2)}'
                  f'<span style="flex:1;font-size:11.5px"><b>AI:</b> 312 mail khuyến mãi có thể dọn</span>'
                  f'<span style="font-size:11.5px;font-weight:600;color:{ACCENT}">Xem</span></a>')
    rows = "".join(mail_row(m) for m in MAILS)
    return f'''<div style="width:{width}px;min-width:280px;max-width:480px;flex:none;border-right:1px solid {DIVIDER};display:flex;flex-direction:column;background:#fff;overflow:hidden">
    <div style="padding:8px 10px 0;display:flex;flex-direction:column;gap:8px;flex:none">
      <div style="display:flex;gap:6px">{scope_html}</div>
      <div style="display:flex;gap:6px;flex-wrap:wrap">{cat_html}</div>
    </div>
    {banner}
    <div style="flex:1;overflow-y:auto;margin-top:8px">{rows}</div>
  </div>'''

def empty_reading_pane(text="Chọn một mail để xem"):
    return f'''<div style="flex:1;display:flex;align-items:center;justify-content:center;background:#FAFAFB;color:{SUBTEXT};font-size:13px">{text}</div>'''

def reading_pane():
    return f'''<div style="flex:1;overflow-y:auto;background:#fff;padding:28px 40px;box-sizing:border-box">
    <div style="max-width:640px;display:flex;flex-direction:column;gap:16px">
      <div style="display:flex;gap:12px;align-items:flex-start">
        <span style="width:40px;height:40px;border-radius:20px;background:#0F766E;color:#fff;font-size:14px;font-weight:700;display:flex;align-items:center;justify-content:center;flex:none">TB</span>
        <div style="flex:1;display:flex;flex-direction:column;gap:3px;min-width:0">
          <div style="display:flex;justify-content:space-between;align-items:baseline"><span style="font-size:14px;font-weight:600">Tech Brief VN</span><span style="font-size:12px;color:{SUBTEXT}">08:30</span></div>
          <div style="display:flex;align-items:center;gap:6px;font-size:12px;color:{SUBTEXT}">
            <span>Tới: tôi</span>
            <span style="height:17px;padding:0 6px 0 3px;border-radius:5px;background:#FBE9E8;color:#A61B18;font-size:10.5px;font-weight:600;display:flex;align-items:center;gap:3px">
              <span style="width:12px;height:12px;border-radius:3px;background:{GMAIL};color:#fff;font-size:8px;font-weight:700;display:flex;align-items:center;justify-content:center">G</span>Gmail</span>
            <span style="height:17px;padding:0 6px;border-radius:5px;background:#E0F2EF;color:#0F5F58;font-size:10.5px;font-weight:600;display:flex;align-items:center">News</span>
          </div>
        </div>
      </div>
      <h1 style="margin:0;font-size:19px;line-height:24px;font-weight:700">Số #143: Startup AI Việt chuyển sang mô hình nhỏ</h1>
      <section style="background:#EEF4FD;border-radius:12px;padding:12px 14px;display:flex;flex-direction:column;gap:8px">
        <div style="display:flex;align-items:center;justify-content:space-between">
          <span style="display:flex;align-items:center;gap:6px;font-size:12.5px;font-weight:600;color:#0A3F87">{svg("sparkle1",14,14,stroke=ACCENT,sw=2.2)}AI tóm tắt</span>
          <span style="display:flex;align-items:center;gap:5px;font-size:11px;color:#3C3C43">{svg("shield",12,12,stroke=ACCENT,sw=2.4)}Trên máy</span>
        </div>
        <ul style="margin:0;padding:0 0 0 16px;display:flex;flex-direction:column;gap:3px;font-size:12.5px;line-height:17px;color:#1C1C1E">
          <li>Giá thuê GPU giảm gần 30% trong quý III.</li>
          <li>Nhiều startup chuyển sang mô hình nhỏ chạy trên điện thoại.</li>
          <li>Không có việc cần bạn xử lý — chỉ để đọc.</li>
        </ul>
      </section>
      <div style="display:flex;flex-direction:column;gap:10px;font-size:13.5px;line-height:20px;color:#1C1C1E">
        <p style="margin:0">Chào bạn,</p>
        <p style="margin:0">Tuần này, chi phí thuê GPU trên các nền tảng đám mây tiếp tục giảm. Theo khảo sát với 40 đội AI trong nước, hơn một nửa đã thử đưa phần suy luận xuống thiết bị người dùng.</p>
        <p style="margin:0">Xu hướng rõ ở các ứng dụng cần quyền riêng tư: trợ lý ghi chú, phân loại email, nhận dạng hoá đơn. Mô hình 1–3 tỉ tham số nay chạy mượt trên điện thoại tầm trung.</p>
        <p style="margin:0;color:{SUBTEXT}">Đọc tiếp trong số này: Fintech gọi vốn vòng A, lịch sự kiện tháng 11…</p>
      </div>
    </div>
  </div>'''

def toolbar_mail_actions():
    return "".join([
        toolbar_btn("chevron-up", "Mail trước"), toolbar_btn("chevron-down", "Mail sau"),
        f'<span style="width:1px;height:20px;background:{DIVIDER};flex:none;margin:0 4px"></span>',
        toolbar_btn("archive", "Lưu trữ"), toolbar_btn("trash", "Xoá", color=DANGER),
        toolbar_btn("tag", "Gắn tag"), toolbar_btn("unsub", "Huỷ đăng ký", color=REVIEW), toolbar_btn("reply", "Trả lời"),
    ])

# =====================================================================
# 1) Inbox.dc.html — home list, no selection
# =====================================================================
toolbar = (f'{toolbar_btn("sidebar","Ẩn/hiện sidebar", color=SUBTEXT)}'
           f'<span style="font-size:15px;font-weight:600;flex:none">Tất cả hộp thư đến</span>'
           f'<span style="flex:1"></span>{search_field()}{ask_ai_pill()}{toolbar_btn("compose","Soạn mail mới")}')
mails_no_select = [dict(m) for m in MAILS]
for m in mails_no_select: m.pop("selected", None)
body = f'{list_pane()}{empty_reading_pane()}'
write("Inbox.dc.html", window_shell("Hộp thư đến", "inbox-all", toolbar, body))

# =====================================================================
# 2) MailDetail.dc.html — list + full reading pane (selection open)
# =====================================================================
toolbar = (f'{toolbar_btn("chevron-left","Quay lại hộp thư", color=ACCENT)}'
           f'<span style="font-size:13px;color:{ACCENT};flex:none">Hộp thư đến</span>'
           f'<span style="flex:1"></span>{toolbar_mail_actions()}')
body = f'{list_pane()}{reading_pane()}'
write("MailDetail.dc.html", window_shell("Đọc mail", "inbox-all", toolbar, body))

# =====================================================================
# 3) Mailboxes.dc.html — folder management / edit view
# =====================================================================
def folder_group(name, badge, color, folders):
    rows = "".join(
        f'''<div style="display:flex;align-items:center;gap:10px;padding:8px 12px;border-bottom:1px solid #ECECEE">
        {svg(f[2], 16, 16, stroke=color, sw=1.8)}<span style="flex:1;font-size:12.5px">{f[0]}</span>
        <span style="font-size:12px;color:{SUBTEXT};font-variant-numeric:tabular-nums">{f[1]}</span>
        {svg("chevron-right", 11, 11, stroke="#C4C4C7", sw=3)}</div>''' for f in folders)
    return f'''<div style="display:flex;flex-direction:column;gap:6px">
    <div style="display:flex;align-items:center;gap:8px;padding:0 4px">
      <span style="width:20px;height:20px;border-radius:5px;background:{color};color:#fff;font-size:11px;font-weight:700;display:flex;align-items:center;justify-content:center">{badge}</span>
      <span style="font-size:13px;font-weight:600">{name}</span>
    </div>
    <div style="background:#fff;border-radius:10px;overflow:hidden;box-shadow:0 0 0 1px #ECECEE">{rows}</div>
  </div>'''

gmail_folders = [("Hộp thư đến", "21", "inbox"), ("Đã gửi", "", "mail"), ("Lưu trữ", "", "archive"), ("Thùng rác", "7.908", "trash")]
outlook_folders = [("Hộp thư đến", "17", "inbox"), ("Đã gửi", "", "mail"), ("Lưu trữ", "", "archive")]
icloud_folders = [("Hộp thư đến", "10", "inbox"), ("Đã gửi", "", "mail")]

left = f'''<div style="width:420px;min-width:300px;flex:none;border-right:1px solid {DIVIDER};overflow-y:auto;padding:16px;box-sizing:border-box;display:flex;flex-direction:column;gap:16px;background:#FAFAFB">
  <div style="font-size:11px;color:{HEADER_GRAY};text-transform:uppercase;font-weight:600">Quản lý hộp thư &amp; thư mục</div>
  {folder_group("Gmail", "G", GMAIL, gmail_folders)}
  {folder_group("Outlook", "O", OUTLOOK, outlook_folders)}
  {folder_group("iCloud", "i", ICLOUD, icloud_folders)}
</div>'''

smart_rows = [("Tài chính", "#1E3A8A", "842", True), ("HR", "#6D28D9", "214", True), ("News", "#0F766E", "2.108", False), ("Promotion", "#C2410C", "10.926", False)]
smart_html = "".join(
    f'''<div style="display:flex;align-items:center;gap:10px;padding:10px 14px;border-bottom:1px solid #ECECEE">
    <span style="width:26px;height:26px;border-radius:6px;background:{c};display:flex;align-items:center;justify-content:center;flex:none">{svg("tag",14,14,stroke="#fff",sw=2.2)}</span>
    <span style="flex:1;display:flex;flex-direction:column"><span style="font-size:13px">{n}</span>{f'<span style="font-size:11px;color:{SUBTEXT};display:flex;align-items:center;gap:3px">{svg("shield",10,10,stroke=SUBTEXT,sw=3)}Được bảo vệ</span>' if p else ""}</span>
    <span style="font-size:12.5px;color:{SUBTEXT};font-variant-numeric:tabular-nums">{cnt}</span></div>'''
    for n, c, cnt, p in smart_rows)
right = f'''<div style="flex:1;overflow-y:auto;padding:24px 32px;box-sizing:border-box;display:flex;flex-direction:column;gap:18px">
  <div>
    <div style="font-size:19px;font-weight:700;margin-bottom:4px">Hộp thư thông minh</div>
    <div style="font-size:12.5px;color:{SUBTEXT}">Gom mail theo tag AI tự gắn, dùng chung cho mọi tài khoản.</div>
  </div>
  <div style="background:#fff;border-radius:12px;overflow:hidden;box-shadow:0 0 0 1px #ECECEE;max-width:460px">{smart_html}</div>
  <a href="ScanReview.dc.html" style="max-width:460px;background:#fff;border-radius:12px;min-height:48px;display:flex;align-items:center;gap:12px;padding:0 14px;text-decoration:none;color:#000;box-shadow:0 0 0 1px #ECECEE">
    <span style="width:24px;height:24px;border-radius:6px;background:{SAFE};display:flex;align-items:center;justify-content:center;flex:none">{svg("sparkle1",13,13,stroke="#fff",sw=2.4)}</span>
    <span style="flex:1;font-size:13px">Cần dọn</span><span style="font-size:13px;font-weight:600;color:{SAFE}">3,2 GB</span>
    {svg("chevron-right",12,12,stroke="#C4C4C7",sw=3)}
  </a>
</div>'''
toolbar = (f'{toolbar_btn("sidebar","Ẩn/hiện sidebar", color=SUBTEXT)}<span style="font-size:15px;font-weight:600">Quản lý hộp thư</span>'
           f'<span style="flex:1"></span><span style="font-size:12px;color:{ACCENT};font-weight:600">Xong</span>')
write("Mailboxes.dc.html", window_shell("Hộp thư", "inbox-all", toolbar, left + right))

# =====================================================================
# 4) Senders.dc.html
# =====================================================================
SENDERS = [
    dict(name="Shopee", initial="S", bg="#C2410C", count="1.240", pct="80%", read="2%", readColor=DANGER, mb="312 MB", selected=True),
    dict(name="Lazada", initial="L", bg="#1D4ED8", count="986", pct="80%", read="4%", readColor=DANGER, mb="240 MB"),
    dict(name="Tech Brief VN", initial="T", bg="#0F766E", count="742", pct="60%", read="11%", readColor=DANGER, mb="190 MB"),
    dict(name="Ngân hàng ACB", initial="A", bg="#1E3A8A", count="618", pct="50%", read="88%", readColor=SAFE, mb="120 MB"),
    dict(name="Grab", initial="G", bg="#15803D", count="540", pct="44%", read="23%", readColor=REVIEW, mb="98 MB"),
    dict(name="LinkedIn", initial="in", bg="#0A5BC4", count="502", pct="40%", read="9%", readColor=DANGER, mb="80 MB"),
    dict(name="Phòng Nhân sự", initial="HR", bg="#6D28D9", count="214", pct="17%", read="97%", readColor=SAFE, mb="40 MB"),
]
rows = []
for s in SENDERS:
    on = s.get("selected")
    rowbg = "#D7E6FB" if on else "#fff"
    rows.append(f'''<a href="SwipeReview.dc.html" style="display:flex;align-items:center;gap:10px;padding:9px 12px;text-decoration:none;color:#000;border-bottom:1px solid #ECECEE;background:{rowbg}">
    <span style="width:30px;height:30px;border-radius:15px;background:{s["bg"]};color:#fff;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center;flex:none">{s["initial"]}</span>
    <span style="flex:1;display:flex;flex-direction:column;gap:3px;min-width:0">
      <span style="display:flex;justify-content:space-between;gap:6px"><span style="font-size:12.5px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">{s["name"]}</span><span style="font-size:11.5px;font-weight:600;font-variant-numeric:tabular-nums">{s["count"]}</span></span>
      <span style="display:flex;align-items:center;gap:6px"><span style="flex:1;height:3px;border-radius:1.5px;background:#EDEDF0;overflow:hidden"><span style="display:block;height:100%;width:{s["pct"]};background:{ACCENT}"></span></span><span style="font-size:10.5px;color:{s["readColor"]};width:52px;text-align:right;flex:none">đọc {s["read"]}</span></span>
    </span></a>''')
sender_list = f'''<div style="width:360px;min-width:260px;max-width:480px;flex:none;border-right:1px solid {DIVIDER};display:flex;flex-direction:column;overflow:hidden">
  <div style="padding:10px 12px;display:flex;flex-direction:column;gap:8px;flex:none">
    {search_field("Tìm người gửi", 300)}
    <div role="tablist" style="height:26px;border-radius:7px;background:rgba(118,118,128,0.12);padding:2px;display:grid;grid-template-columns:repeat(3,1fr);box-sizing:border-box">
      <button style="border:none;border-radius:6px;background:#fff;box-shadow:0 1px 3px rgba(0,0,0,0.12);font:inherit;font-size:11px;font-weight:600;cursor:pointer">Số lượng</button>
      <button style="border:none;border-radius:6px;background:transparent;font:inherit;font-size:11px;cursor:pointer">Dung lượng</button>
      <button style="border:none;border-radius:6px;background:transparent;font:inherit;font-size:11px;cursor:pointer">Tỉ lệ đọc</button>
    </div>
  </div>
  <div style="flex:1;overflow-y:auto">{"".join(rows)}</div>
</div>'''

sender_detail = f'''<div style="flex:1;overflow-y:auto;padding:28px 36px;box-sizing:border-box;display:flex;flex-direction:column;gap:16px;max-width:620px">
  <div style="display:flex;align-items:center;gap:14px">
    <div style="width:52px;height:52px;border-radius:26px;background:#C2410C;color:#fff;font-size:20px;font-weight:700;display:flex;align-items:center;justify-content:center;flex:none">S</div>
    <div style="display:flex;flex-direction:column;gap:2px"><span style="font-size:19px;font-weight:700">Shopee</span><span style="font-size:12.5px;color:{SUBTEXT}">no-reply@mail.shopee.vn</span></div>
  </div>
  <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:10px">
    <div style="background:#F2F2F7;border-radius:10px;padding:10px"><div style="font-size:18px;font-weight:700;font-variant-numeric:tabular-nums">1.240</div><div style="font-size:11px;color:{SUBTEXT}">mail</div></div>
    <div style="background:#F2F2F7;border-radius:10px;padding:10px"><div style="font-size:18px;font-weight:700;font-variant-numeric:tabular-nums">312 MB</div><div style="font-size:11px;color:{SUBTEXT}">dung lượng</div></div>
    <div style="background:#FDE8E7;border-radius:10px;padding:10px"><div style="font-size:18px;font-weight:700;color:{DANGER};font-variant-numeric:tabular-nums">2%</div><div style="font-size:11px;color:#8C1D18">đã đọc</div></div>
  </div>
  <div style="border-radius:12px;background:#EEF4FD;padding:12px;display:flex;flex-direction:column;gap:8px">
    <div style="display:flex;align-items:center;justify-content:space-between">
      <span style="display:flex;align-items:center;gap:6px;height:24px;padding:0 10px;border-radius:12px;background:{ACCENT};color:#fff;font-size:11.5px;font-weight:600">{svg("sparkle1",12,12,stroke="#fff",sw=2.4)}Gợi ý: Huỷ đăng ký + xoá</span>
      <span style="font-size:11.5px;color:#0A4FA8;font-weight:600">Tin cậy 94%</span>
    </div>
    <span style="font-size:12.5px;line-height:17px;color:#1C1C1E">Bạn chưa đọc mail nào từ người gửi này trong 6 tháng. Không có hoá đơn hay mã đơn hàng.</span>
  </div>
  <div style="display:flex;gap:10px">
    <button style="height:34px;padding:0 14px;border-radius:8px;border:none;background:#FDE8E7;color:{DANGER};font:inherit;font-size:12.5px;font-weight:600;cursor:pointer;display:flex;align-items:center;gap:6px">{svg("trash",14,14,stroke=DANGER,sw=2)}Xoá hết</button>
    <button style="height:34px;padding:0 14px;border-radius:8px;border:none;background:{ACCENT};color:#fff;font:inherit;font-size:12.5px;font-weight:600;cursor:pointer;display:flex;align-items:center;gap:6px">{svg("unsub",14,14,stroke="#fff",sw=2)}Huỷ đăng ký</button>
    <button style="height:34px;padding:0 14px;border-radius:8px;border:none;background:#F2F2F7;color:#1C1C1E;font:inherit;font-size:12.5px;font-weight:600;cursor:pointer">Giữ</button>
  </div>
</div>'''
toolbar = (f'{toolbar_btn("sidebar","Ẩn/hiện sidebar", color=SUBTEXT)}<span style="font-size:15px;font-weight:600">Người gửi</span>'
           f'<span style="font-size:11.5px;color:{SUBTEXT}">214 người gửi · 28.750 mail</span><span style="flex:1"></span>'
           f'<a href="SwipeReview.dc.html" style="font-size:12.5px;color:{ACCENT};font-weight:600;text-decoration:none">Duyệt nhanh</a>')
write("Senders.dc.html", window_shell("Người gửi", "senders", toolbar, sender_list + sender_detail))

# =====================================================================
# 5) Tags.dc.html
# =====================================================================
AI_TAGS = [("Tài chính", "#1E3A8A", "842", True, True), ("HR", "#6D28D9", "214", True, True),
           ("News", "#0F766E", "2.108", False, False), ("Promotion", "#C2410C", "10.926", False, False)]
tag_rows = "".join(
    f'''<div style="display:flex;align-items:center;gap:10px;padding:10px 14px;border-bottom:1px solid #ECECEE;{'background:#D7E6FB;' if sel else ''}">
    <span style="width:26px;height:26px;border-radius:6px;background:{c};display:flex;align-items:center;justify-content:center;flex:none">{svg("tag",14,14,stroke="#fff",sw=2.2)}</span>
    <span style="flex:1;display:flex;flex-direction:column"><span style="font-size:13px">{n}</span>{f'<span style="font-size:11px;color:{SUBTEXT};display:flex;align-items:center;gap:3px">{svg("shield",10,10,stroke=SUBTEXT,sw=3)}Được bảo vệ</span>' if p else ""}</span>
    <span style="font-size:12.5px;color:{SUBTEXT};font-variant-numeric:tabular-nums">{cnt}</span></div>'''
    for n, c, cnt, p, sel in AI_TAGS)
custom_rows = f'''<div style="display:flex;align-items:center;gap:10px;padding:10px 14px">
  <span style="width:26px;height:26px;border-radius:6px;background:#0E7490;display:flex;align-items:center;justify-content:center;flex:none">{svg("tag",14,14,stroke="#fff",sw=2.2)}</span>
  <span style="flex:1;display:flex;flex-direction:column;min-width:0"><span style="font-size:13px">Chuyến đi</span><span style="font-size:11px;color:{SUBTEXT};white-space:nowrap;overflow:hidden;text-overflow:ellipsis">"vé máy bay, đặt phòng, lịch trình"</span></span>
  <span style="font-size:12.5px;color:{SUBTEXT};font-variant-numeric:tabular-nums">46</span></div>'''

tag_list = f'''<div style="width:340px;min-width:260px;max-width:440px;flex:none;border-right:1px solid {DIVIDER};display:flex;flex-direction:column;overflow-y:auto">
  <div style="padding:10px 14px 2px;font-size:11px;color:{HEADER_GRAY};text-transform:uppercase;font-weight:600">Tự động bởi AI</div>
  <div style="margin:4px 10px;background:#fff;border-radius:10px;overflow:hidden;box-shadow:0 0 0 1px #ECECEE">{tag_rows}</div>
  <div style="padding:10px 14px 2px;font-size:11px;color:{HEADER_GRAY};text-transform:uppercase;font-weight:600">Tag của bạn</div>
  <div style="margin:4px 10px;background:#fff;border-radius:10px;overflow:hidden;box-shadow:0 0 0 1px #ECECEE">{custom_rows}</div>
</div>'''

tag_creator = f'''<div style="flex:1;overflow-y:auto;padding:28px 36px;box-sizing:border-box;display:flex;flex-direction:column;gap:14px;max-width:560px">
  <div style="font-size:19px;font-weight:700">Tạo tag bằng lời</div>
  <div style="background:#fff;border-radius:12px;padding:14px 16px;display:flex;flex-direction:column;gap:12px;box-shadow:0 0 0 1px #ECECEE">
    <label style="font-size:11.5px;color:{SUBTEXT}">Mô tả loại mail bạn muốn gom</label>
    <textarea rows="2" style="border:none;outline:none;resize:none;font:inherit;font-size:13.5px;line-height:18px;color:#000;padding:0;background:transparent">Hoá đơn điện, nước, internet hằng tháng</textarea>
    <div style="display:flex;align-items:center;gap:8px;flex-wrap:wrap">
      <span style="height:24px;padding:0 10px;border-radius:12px;background:#EEF4FD;color:#0A4FA8;font-size:11.5px;font-weight:600;display:flex;align-items:center;gap:4px">{svg("sparkle1",12,12,stroke="#0A4FA8",sw=2.4)}Khớp 128 mail</span>
      <span style="font-size:11.5px;color:{SUBTEXT}">EVN, Sawaco, FPT Telecom…</span>
    </div>
    <button style="height:34px;border-radius:9px;border:none;background:{ACCENT};color:#fff;font:inherit;font-size:13px;font-weight:600;cursor:pointer;align-self:flex-start;padding:0 16px">Tạo tag "Hoá đơn tiện ích"</button>
  </div>
  <div style="font-size:11.5px;color:{SUBTEXT};line-height:16px">Tag tự tạo chạy hoàn toàn trên máy, không gửi nội dung mail ra ngoài. AI học thêm mỗi khi bạn sửa tag thủ công.</div>
</div>'''
toolbar = (f'{toolbar_btn("sidebar","Ẩn/hiện sidebar", color=SUBTEXT)}<span style="font-size:15px;font-weight:600">Tags</span>'
           f'<span style="flex:1"></span>{toolbar_btn("plus","Tạo tag mới")}')
write("Tags.dc.html", window_shell("Tags", "tags", toolbar, tag_list + tag_creator))

# =====================================================================
# 6) Main.dc.html — dashboard
# =====================================================================
def account_bar(label, badge, color, pct, pctcolor):
    return f'''<div style="display:flex;align-items:center;gap:10px;padding:9px 14px">
    <div style="width:26px;height:26px;border-radius:6px;background:{color};color:#fff;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;flex:none">{badge}</div>
    <div style="flex:1;display:flex;flex-direction:column;gap:4px">
      <div style="display:flex;justify-content:space-between;font-size:12.5px"><span>{label}</span><span style="color:{pctcolor};font-weight:600;font-variant-numeric:tabular-nums">{pct}</span></div>
      <div style="height:5px;border-radius:2.5px;background:#E5E5EA;overflow:hidden"><div style="width:{pct};height:100%;background:{pctcolor}"></div></div>
    </div>
  </div>'''

dash = f'''<div style="flex:1;overflow-y:auto;padding:24px 28px;box-sizing:border-box">
  <div style="display:grid;grid-template-columns:2fr 1fr;gap:16px;max-width:1040px">
    <div style="border-radius:16px;padding:20px;background:linear-gradient(145deg, #0A5BC4 0%, #0B7A8C 100%);color:#fff;display:flex;flex-direction:column;gap:12px;grid-row:span 2">
      <div style="display:flex;align-items:center;gap:6px;font-size:11.5px;font-weight:600;text-transform:uppercase;letter-spacing:0.4px;opacity:0.92">{svg("sparkle1",14,14,stroke="#fff",sw=2.2)}Smart Scan</div>
      <div><div style="font-size:13px;opacity:0.92">Có thể giải phóng</div><div style="font-size:40px;line-height:44px;font-weight:800;font-variant-numeric:tabular-nums">3,2 GB</div>
      <div style="font-size:12px;opacity:0.9">7.940 mail · 5 nhóm an toàn hoặc nên xem lại</div></div>
      <a href="ScanReview.dc.html" style="margin-top:auto;height:38px;border-radius:10px;background:#fff;color:#0A5BC4;display:flex;align-items:center;justify-content:center;text-decoration:none;font-size:13px;font-weight:600">Xem &amp; dọn</a>
    </div>
    <div style="background:#fff;border-radius:14px;padding:16px;display:flex;align-items:center;gap:14px;box-shadow:0 0 0 1px #ECECEE">
      <div style="position:relative;width:64px;height:64px;flex:none">
        <svg width="64" height="64" viewBox="0 0 76 76"><circle cx="38" cy="38" r="32" fill="none" stroke="#E5E5EA" stroke-width="8"></circle><circle cx="38" cy="38" r="32" fill="none" stroke="{SAFE}" stroke-width="8" stroke-linecap="round" stroke-dasharray="144.8 201" transform="rotate(-90 38 38)"></circle></svg>
        <div style="position:absolute;inset:0;display:flex;flex-direction:column;align-items:center;justify-content:center"><span style="font-size:19px;font-weight:700">72</span><span style="font-size:9px;color:{SUBTEXT}">/100</span></div>
      </div>
      <div style="flex:1;display:flex;flex-direction:column;gap:4px">
        <div style="display:flex;justify-content:space-between;align-items:baseline"><span style="font-size:13px;font-weight:600">Sức khoẻ hộp thư</span><span style="font-size:11px;font-weight:600;color:{SAFE}">Khá · +6</span></div>
        <div style="display:flex;gap:10px;font-size:11px;color:{SUBTEXT}"><span>4.812 chưa đọc</span><span>38% quảng cáo</span></div>
      </div>
    </div>
    <div style="background:#fff;border-radius:14px;overflow:hidden;box-shadow:0 0 0 1px #ECECEE">
      {account_bar("Gmail", "G", "#D93025", "92%", DANGER)}
      <div style="height:1px;background:#ECECEE;margin-left:50px"></div>{account_bar("Outlook", "O", "#0F6CBD", "41%", SUBTEXT)}
      <div style="height:1px;background:#ECECEE;margin-left:50px"></div>{account_bar("iCloud", "i", "#3A3A3C", "63%", REVIEW)}
    </div>
  </div>
  <div style="display:grid;grid-template-columns:repeat(3,160px);gap:10px;margin-top:16px">
    <a href="SwipeReview.dc.html" style="background:#fff;border-radius:12px;padding:14px;display:flex;flex-direction:column;gap:8px;text-decoration:none;color:#000;box-shadow:0 0 0 1px #ECECEE">{svg("people",20,20,stroke=ACCENT,sw=1.9)}<span style="font-size:12px;font-weight:600">Duyệt người gửi</span></a>
    <a href="CatchUp.dc.html" style="background:#fff;border-radius:12px;padding:14px;display:flex;flex-direction:column;gap:8px;text-decoration:none;color:#000;box-shadow:0 0 0 1px #ECECEE">{svg("newspaper",20,20,stroke=ACCENT,sw=1.9)}<span style="font-size:12px;font-weight:600">Tóm tắt bản tin</span></a>
    <a href="Tags.dc.html" style="background:#fff;border-radius:12px;padding:14px;display:flex;flex-direction:column;gap:8px;text-decoration:none;color:#000;box-shadow:0 0 0 1px #ECECEE">{svg("tag",20,20,stroke=ACCENT,sw=1.9)}<span style="font-size:12px;font-weight:600">Gắn tag tự động</span></a>
  </div>
</div>'''
toolbar = (f'{toolbar_btn("sidebar","Ẩn/hiện sidebar", color=SUBTEXT)}<span style="font-size:15px;font-weight:600">Tổng quan</span>'
           f'<span style="font-size:11.5px;color:{SUBTEXT}">3 tài khoản · quét lần cuối 2 phút trước</span><span style="flex:1"></span>{ask_ai_pill()}')
write("Main.dc.html", window_shell("Tổng quan", "dashboard", toolbar, dash))

# =====================================================================
# 7) ScanReview.dc.html
# =====================================================================
SAFE_ITEMS = [("Promo cũ > 6 tháng", "Shopee, Lazada và 40 nơi khác · 3.412 mail", "1,1 GB", True),
              ("Newsletter bỏ đọc", "Tech Brief VN và 11 bản tin · 2.108 mail", "640 MB", True),
              ("OTP hết hạn", "Mã xác thực cũ hơn 7 ngày · 1.906 mail", "12 MB", True),
              ("Thông báo cũ", "Mạng xã hội, giao hàng · 482 mail", "10 MB", True)]
REVIEW_ITEMS = [("Đính kèm lớn", "86 mail có tệp trên 10 MB", "1,2 GB", False),
                ("Thư mục Spam", "Spam cũ hơn 30 ngày · 640 mail", "150 MB", False),
                ("Mail trùng lặp", "312 bản sao giống hệt nhau", "80 MB", False)]

def scan_row(name, desc, size, checked):
    box = (f'<span style="width:18px;height:18px;border-radius:9px;background:{ACCENT};display:flex;align-items:center;justify-content:center;flex:none">{svg("check",11,11,stroke="#fff",sw=3.4)}</span>'
           if checked else f'<span style="width:18px;height:18px;border-radius:9px;border:1.5px solid #AEAEB2;box-sizing:border-box;flex:none"></span>')
    return f'''<div style="display:flex;align-items:center;gap:10px;padding:10px 14px;border-bottom:1px solid #ECECEE">{box}
    <span style="flex:1;display:flex;flex-direction:column;min-width:0"><span style="font-size:13px">{name}</span><span style="font-size:11px;color:{SUBTEXT};white-space:nowrap;overflow:hidden;text-overflow:ellipsis">{desc}</span></span>
    <span style="font-size:12.5px;font-weight:600;font-variant-numeric:tabular-nums">{size}</span></div>'''

col_left = f'''<div style="flex:1;min-width:360px;display:flex;flex-direction:column;gap:6px">
  <div style="display:flex;align-items:center;gap:6px;font-size:11.5px;color:{SAFE};text-transform:uppercase;font-weight:600">{svg("shield",13,13,stroke=SAFE,sw=2.6)}An toàn để xoá</div>
  <div style="background:#fff;border-radius:12px;overflow:hidden;box-shadow:0 0 0 1px #ECECEE">{"".join(scan_row(*x) for x in SAFE_ITEMS)}</div>
</div>'''
col_right = f'''<div style="flex:1;min-width:360px;display:flex;flex-direction:column;gap:6px">
  <div style="display:flex;align-items:center;gap:6px;font-size:11.5px;color:{REVIEW};text-transform:uppercase;font-weight:600">{svg("filter",13,13,stroke=REVIEW,sw=2.6)}Nên xem lại</div>
  <div style="background:#fff;border-radius:12px;overflow:hidden;box-shadow:0 0 0 1px #ECECEE">{"".join(scan_row(*x) for x in REVIEW_ITEMS)}</div>
  <a href="Settings.dc.html" style="margin-top:8px;background:#fff;border-radius:12px;min-height:46px;display:flex;align-items:center;gap:10px;padding:0 14px;text-decoration:none;color:#000;box-shadow:0 0 0 1px #ECECEE">
    <span style="flex:1;display:flex;flex-direction:column"><span style="font-size:12.5px">Tài chính · HR · Hợp đồng</span><span style="font-size:11px;color:{SUBTEXT}">1.204 mail · không bao giờ tự động xoá</span></span>
    {svg("chevron-right",12,12,stroke="#C4C4C7",sw=3)}</a>
</div>'''

body = f'''<div style="flex:1;display:flex;flex-direction:column;overflow:hidden">
  <div style="flex:1;overflow-y:auto;padding:20px 24px;box-sizing:border-box">
    <div style="background:#fff;border-radius:12px;padding:14px 16px;display:flex;flex-direction:column;gap:10px;box-shadow:0 0 0 1px #ECECEE;max-width:760px;margin-bottom:16px">
      <div style="display:flex;align-items:baseline;justify-content:space-between"><span style="font-size:12.5px;color:{SUBTEXT}">Có thể giải phóng</span><span style="font-size:24px;font-weight:800;font-variant-numeric:tabular-nums">3,2 GB</span></div>
      <div style="display:flex;height:7px;border-radius:3.5px;overflow:hidden;gap:2px;background:#E5E5EA"><span style="width:54%;background:{SAFE}"></span><span style="width:46%;background:{REVIEW}"></span></div>
      <div style="display:flex;gap:16px;font-size:11.5px;color:#3C3C43">
        <span style="display:flex;align-items:center;gap:5px"><span style="width:7px;height:7px;border-radius:3.5px;background:{SAFE}"></span>An toàn 1,75 GB</span>
        <span style="display:flex;align-items:center;gap:5px"><span style="width:7px;height:7px;border-radius:3.5px;background:{REVIEW}"></span>Nên xem lại 1,47 GB</span>
      </div>
    </div>
    <div style="display:flex;gap:16px;flex-wrap:wrap">{col_left}{col_right}</div>
  </div>
  <div style="flex:none;padding:10px 24px;border-top:1px solid {DIVIDER};background:{TOOLBAR_BG};display:flex;align-items:center;justify-content:space-between">
    <span style="font-size:11.5px;color:{SUBTEXT}">Đã chọn 4 nhóm · vào Thùng rác, hoàn tác 30 ngày</span>
    <a href="CleanDone.dc.html" style="height:34px;padding:0 20px;border-radius:9px;background:{ACCENT};color:#fff;display:flex;align-items:center;justify-content:center;text-decoration:none;font-size:13px;font-weight:600">Dọn 1,75 GB</a>
  </div>
</div>'''
toolbar = (f'{toolbar_btn("sidebar","Ẩn/hiện sidebar", color=SUBTEXT)}<span style="font-size:15px;font-weight:600">Smart Scan</span>'
           f'<span style="flex:1"></span>{toolbar_btn("refresh","Quét lại")}')
write("ScanReview.dc.html", window_shell("Smart Scan – Kết quả", "smart-scan", toolbar, body))

# =====================================================================
# 8) SwipeReview.dc.html
# =====================================================================
card = f'''<article style="width:460px;border-radius:18px;background:#fff;box-shadow:0 16px 40px rgba(0,0,0,0.14);padding:24px;box-sizing:border-box;display:flex;flex-direction:column;gap:16px;position:relative">
  <div style="display:flex;align-items:center;gap:14px">
    <div style="width:52px;height:52px;border-radius:26px;background:#C2410C;color:#fff;font-size:20px;font-weight:700;display:flex;align-items:center;justify-content:center;flex:none">S</div>
    <div style="display:flex;flex-direction:column;gap:2px"><span style="font-size:19px;font-weight:700">Shopee</span><span style="font-size:12.5px;color:{SUBTEXT}">no-reply@mail.shopee.vn</span></div>
  </div>
  <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:8px">
    <div style="background:#F2F2F7;border-radius:10px;padding:10px"><div style="font-size:17px;font-weight:700;font-variant-numeric:tabular-nums">1.240</div><div style="font-size:11px;color:{SUBTEXT}">mail</div></div>
    <div style="background:#F2F2F7;border-radius:10px;padding:10px"><div style="font-size:17px;font-weight:700;font-variant-numeric:tabular-nums">312 MB</div><div style="font-size:11px;color:{SUBTEXT}">dung lượng</div></div>
    <div style="background:#FDE8E7;border-radius:10px;padding:10px"><div style="font-size:17px;font-weight:700;color:{DANGER};font-variant-numeric:tabular-nums">2%</div><div style="font-size:11px;color:#8C1D18">đã đọc</div></div>
  </div>
  <div style="display:flex;flex-direction:column;gap:6px">
    <span style="font-size:11px;color:{SUBTEXT};text-transform:uppercase">Mail gần đây</span>
    <div style="display:flex;justify-content:space-between;gap:10px;font-size:12.5px"><span style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis">Flash Sale 10.10 — giảm đến 50%</span><span style="color:{SUBTEXT};flex:none">Hôm qua</span></div>
    <div style="display:flex;justify-content:space-between;gap:10px;font-size:12.5px"><span style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis">Voucher freeship dành riêng cho bạn</span><span style="color:{SUBTEXT};flex:none">T2</span></div>
  </div>
  <div style="border-radius:12px;background:#EEF4FD;padding:12px;display:flex;flex-direction:column;gap:6px">
    <div style="display:flex;align-items:center;justify-content:space-between">
      <span style="display:flex;align-items:center;gap:6px;height:24px;padding:0 10px;border-radius:12px;background:{ACCENT};color:#fff;font-size:11.5px;font-weight:600">{svg("sparkle1",12,12,stroke="#fff",sw=2.4)}Gợi ý: Huỷ đăng ký + xoá</span>
      <span style="font-size:11.5px;color:#0A4FA8;font-weight:600">Tin cậy 94%</span>
    </div>
    <span style="font-size:12px;line-height:16px;color:#1C1C1E">Bạn chưa đọc mail nào từ người gửi này trong 6 tháng.</span>
  </div>
</article>'''

actions = "".join(f'''<button style="display:flex;flex-direction:column;align-items:center;gap:6px;border:none;background:transparent;font:inherit;cursor:pointer">
  <span style="width:52px;height:52px;border-radius:26px;background:{bg};box-shadow:0 2px 8px rgba(0,0,0,0.1);display:flex;align-items:center;justify-content:center;color:{fg}">{svg(icon,22,22,stroke=fg,sw=2)}</span>
  <span style="font-size:11.5px;color:{"#0A4FA8" if icon=="unsub" else "#3C3C43"};font-weight:{"600" if icon=="unsub" else "400"}">{label}</span></button>'''
  for icon, label, bg, fg in [("trash","Xoá","#fff",DANGER), ("archive","Lưu trữ","#fff",REVIEW), ("unsub","Huỷ ĐK",ACCENT,"#fff"), ("check","Giữ","#fff",SAFE)])

body = f'''<div style="flex:1;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:18px;background:#FAFAFB;position:relative">
  <div aria-hidden="true" style="position:absolute;top:24px;left:24px;right:24px;height:4px;border-radius:2px;background:#E5E5EA;overflow:hidden"><div style="width:12.5%;height:100%;background:{ACCENT}"></div></div>
  {card}
  <div style="display:flex;gap:18px;font-size:11.5px;color:{SUBTEXT}"><span>← Xoá</span><span>↑ Lưu trữ</span><span>⌘U Huỷ ĐK</span><span>Giữ →</span></div>
  <div style="display:flex;gap:22px">{actions}</div>
</div>'''
toolbar = (f'{toolbar_btn("sidebar","Ẩn/hiện sidebar", color=SUBTEXT)}<span style="font-size:15px;font-weight:600">Duyệt người gửi</span>'
           f'<span style="font-size:11.5px;color:{SUBTEXT};font-variant-numeric:tabular-nums">3 / 24</span><span style="flex:1"></span>{toolbar_btn("undo","Hoàn tác thao tác trước")}')
write("SwipeReview.dc.html", window_shell("Duyệt theo người gửi", "senders", toolbar, body))

# =====================================================================
# 9) CatchUp.dc.html
# =====================================================================
left = f'''<div style="flex:1;min-width:420px;overflow-y:auto;padding:24px 28px;box-sizing:border-box;display:flex;flex-direction:column;gap:16px">
  <div style="display:flex;align-items:center;gap:12px">
    <span style="width:44px;height:44px;border-radius:11px;background:#0F766E;color:#fff;font-size:17px;font-weight:700;display:flex;align-items:center;justify-content:center;flex:none">TB</span>
    <div><div style="font-size:19px;font-weight:700">Tech Brief VN</div><div style="font-size:11.5px;color:{SUBTEXT}">18 số chưa đọc · 14/08 – 15/10</div></div>
  </div>
  <div style="display:flex;flex-direction:column;gap:6px">
    <div style="font-size:11px;color:{SUBTEXT};text-transform:uppercase">AI &amp; phần cứng · 7 bài</div>
    <div style="background:#fff;border-radius:12px;overflow:hidden;box-shadow:0 0 0 1px #ECECEE">
      <div style="padding:10px 14px;display:flex;flex-direction:column;gap:6px"><span style="font-size:12.5px;line-height:17px">Chip AI cho điện thoại tầm trung ra mắt, chạy mô hình 3B tham số.</span>
        <a href="#" style="align-self:flex-start;height:20px;padding:0 7px;border-radius:5px;background:#F2F2F7;color:#0A4FA8;font-size:10.5px;font-weight:600;text-decoration:none;display:flex;align-items:center">Số #142 · 02/10</a></div>
      <div style="height:1px;background:#ECECEE"></div>
      <div style="padding:10px 14px;display:flex;flex-direction:column;gap:6px"><span style="font-size:12.5px;line-height:17px">Giá thuê GPU giảm; nhiều đội chuyển sang suy luận trên thiết bị.</span>
        <span style="display:flex;gap:6px"><a href="#" style="height:20px;padding:0 7px;border-radius:5px;background:#F2F2F7;color:#0A4FA8;font-size:10.5px;font-weight:600;text-decoration:none;display:flex;align-items:center">Số #138 · 18/09</a><a href="#" style="height:20px;padding:0 7px;border-radius:5px;background:#F2F2F7;color:#0A4FA8;font-size:10.5px;font-weight:600;text-decoration:none;display:flex;align-items:center">Số #141 · 29/09</a></span></div>
    </div>
  </div>
  <div style="display:flex;flex-direction:column;gap:6px">
    <div style="font-size:11px;color:{SUBTEXT};text-transform:uppercase">Khởi nghiệp Việt · 6 bài</div>
    <div style="background:#fff;border-radius:12px;overflow:hidden;box-shadow:0 0 0 1px #ECECEE">
      <div style="padding:10px 14px;display:flex;flex-direction:column;gap:6px"><span style="font-size:12.5px;line-height:17px">Fintech nội địa gọi vốn vòng A 12 triệu USD, mở rộng sang ví trả sau.</span>
        <a href="#" style="align-self:flex-start;height:20px;padding:0 7px;border-radius:5px;background:#F2F2F7;color:#0A4FA8;font-size:10.5px;font-weight:600;text-decoration:none;display:flex;align-items:center">Số #136 · 11/09</a></div>
    </div>
  </div>
</div>'''
right = f'''<div style="width:340px;min-width:280px;flex:none;border-left:1px solid {DIVIDER};background:#FAFAFB;overflow-y:auto;padding:24px 20px;box-sizing:border-box;display:flex;flex-direction:column;gap:14px">
  <div style="background:#fff;border-radius:12px;padding:14px 16px;display:flex;flex-direction:column;gap:8px;box-shadow:0 0 0 1px #ECECEE">
    <div style="display:flex;align-items:center;justify-content:space-between"><span style="font-size:11px;font-weight:700;color:#0A4FA8;letter-spacing:0.3px">TL;DR</span><span style="display:flex;align-items:center;gap:4px;font-size:10.5px;color:{SAFE};font-weight:600">{svg("shield",11,11,stroke=SAFE,sw=2.8)}Trên máy</span></div>
    <ul style="margin:0;padding:0 0 0 16px;display:flex;flex-direction:column;gap:5px;font-size:12px;line-height:16px">
      <li>Giá GPU cho thuê giảm gần 30% trong quý, startup chuyển sang mô hình nhỏ.</li>
      <li>Ba quỹ ngoại rót vốn vòng A cho fintech và logistics nội địa.</li>
      <li>Cảnh báo lừa đảo OTP qua tin nhắn giả danh ngân hàng tăng mạnh.</li>
    </ul>
  </div>
  <button style="height:36px;border-radius:9px;border:none;background:{ACCENT};color:#fff;font:inherit;font-size:12.5px;font-weight:600;cursor:pointer">Đánh dấu đã đọc tất cả 18 số</button>
  <div style="display:grid;grid-template-columns:1fr 1fr;gap:8px">
    <button style="height:34px;border-radius:9px;border:none;background:#E3EEFC;color:#0A5BC4;font:inherit;font-size:12px;font-weight:600;cursor:pointer">Archive</button>
    <button style="height:34px;border-radius:9px;border:none;background:#FCEEDF;color:#9A4700;font:inherit;font-size:12px;font-weight:600;cursor:pointer">Unsubscribe</button>
  </div>
</div>'''
toolbar = (f'{toolbar_btn("sidebar","Ẩn/hiện sidebar", color=SUBTEXT)}<span style="font-size:15px;font-weight:600">Bắt kịp</span>'
           f'<span style="flex:1"></span>{toolbar_btn("more","Thêm tuỳ chọn")}')
write("CatchUp.dc.html", window_shell("Tóm tắt bản tin", "catchup", toolbar, left + right))

# =====================================================================
# 10) AICommand.dc.html — command palette overlay
# =====================================================================
backdrop = f'''<div style="position:absolute;inset:0;background:rgba(0,0,0,0.32);display:flex;align-items:flex-start;justify-content:center;padding-top:90px;z-index:5">
  <div role="dialog" aria-label="Lệnh AI" style="width:620px;max-height:600px;background:#fff;border-radius:14px;box-shadow:0 24px 60px rgba(0,0,0,0.35);display:flex;flex-direction:column;overflow:hidden">
    <div style="padding:14px 18px;border-bottom:1px solid {DIVIDER};display:flex;align-items:center;gap:8px">
      {svg("sparkle2",17,17,stroke=ACCENT,sw=2)}<span style="font-size:14px;font-weight:600">Lệnh AI</span><span style="flex:1"></span>
      <a href="Main.dc.html" style="font-size:12.5px;color:{ACCENT};text-decoration:none">Huỷ (esc)</a>
    </div>
    <div style="padding:14px 18px;display:flex;flex-direction:column;gap:14px;overflow-y:auto">
      <div style="background:#F2F2F7;border-radius:10px;padding:10px 12px;display:flex;gap:8px;align-items:flex-start">
        <textarea rows="2" style="flex:1;border:none;outline:none;resize:none;font:inherit;font-size:13.5px;line-height:18px;color:#000;background:transparent;padding:0">Xoá hết mail Shopee cũ hơn 3 tháng trừ hoá đơn</textarea>
        <button aria-label="Nói lệnh" style="width:30px;height:30px;border-radius:15px;border:none;background:#E3EEFC;color:#0A5BC4;cursor:pointer;display:flex;align-items:center;justify-content:center;flex:none">{svg("mic",15,15,stroke="#0A5BC4",sw=2)}</button>
      </div>
      <div style="display:flex;flex-direction:column;gap:8px">
        <span style="font-size:10.5px;color:{SUBTEXT};text-transform:uppercase">AI hiểu là</span>
        <div style="display:flex;flex-wrap:wrap;gap:6px">
          <span style="height:26px;padding:0 10px;border-radius:13px;background:#fff;box-shadow:inset 0 0 0 1px #D1D1D6;font-size:12px;display:flex;align-items:center;gap:4px"><span style="color:{SUBTEXT}">Từ:</span><b>Shopee</b></span>
          <span style="height:26px;padding:0 10px;border-radius:13px;background:#fff;box-shadow:inset 0 0 0 1px #D1D1D6;font-size:12px;display:flex;align-items:center;gap:4px"><span style="color:{SUBTEXT}">Cũ hơn:</span><b>3 tháng</b></span>
          <span style="height:26px;padding:0 10px;border-radius:13px;background:#E4F3EA;box-shadow:inset 0 0 0 1px #A7D7B8;color:#0F5C2E;font-size:12px;display:flex;align-items:center;gap:4px"><span>Trừ:</span><b>Hoá đơn, đơn hàng</b></span>
          <span style="height:26px;padding:0 10px;border-radius:13px;background:#FDE8E7;box-shadow:inset 0 0 0 1px #F2B8B5;color:#8C1D18;font-size:12px;display:flex;align-items:center;gap:4px"><span>Hành động:</span><b>Vào Thùng rác</b></span>
        </div>
      </div>
      <div style="background:#fff;border-radius:10px;box-shadow:inset 0 0 0 1px #ECECEE;overflow:hidden">
        <div style="padding:10px 14px;display:flex;align-items:baseline;justify-content:space-between"><span style="font-size:13px;font-weight:600">Khớp <span style="font-variant-numeric:tabular-nums">1.284</span> mail</span><span style="font-size:12px;color:{SUBTEXT}">286 MB</span></div>
        <div style="height:1px;background:#ECECEE"></div>
        <div style="padding:8px 14px;display:flex;flex-direction:column;gap:6px;font-size:12px">
          <div style="display:flex;justify-content:space-between;gap:10px"><span>Siêu sale 7.7 — freeship 0Đ</span><span style="color:{SUBTEXT}">07/07</span></div>
          <div style="display:flex;justify-content:space-between;gap:10px"><span>Bạn có 3 voucher sắp hết hạn</span><span style="color:{SUBTEXT}">21/06</span></div>
          <a href="#" style="color:{ACCENT};text-decoration:none">Xem cả 1.284 mail</a>
        </div>
        <div style="height:1px;background:#ECECEE"></div>
        <div style="padding:8px 14px;display:flex;align-items:center;gap:6px;font-size:11.5px;color:{SAFE}">{svg("shield",13,13,stroke=SAFE,sw=2.6)}Giữ lại 37 hoá đơn và xác nhận đơn hàng</div>
      </div>
    </div>
    <div style="padding:12px 18px;border-top:1px solid {DIVIDER};display:flex;flex-direction:column;gap:6px">
      <button style="height:38px;border-radius:9px;border:none;background:{ACCENT};color:#fff;font:inherit;font-size:13px;font-weight:600;cursor:pointer">Chạy · 1.284 mail</button>
      <span style="font-size:11px;color:{SUBTEXT};text-align:center">Phân tích lệnh trên máy · hoàn tác được trong 30 ngày</span>
    </div>
  </div>
</div>'''
toolbar = (f'{toolbar_btn("sidebar","Ẩn/hiện sidebar", color=SUBTEXT)}<span style="font-size:15px;font-weight:600">Tất cả hộp thư đến</span><span style="flex:1"></span>{search_field()}')
body = f'<div style="position:relative;flex:1;display:flex">{list_pane()}{empty_reading_pane()}{backdrop}</div>'
write("AICommand.dc.html", window_shell("Lệnh AI", "ai-command", toolbar, body))

# =====================================================================
# 11) Settings.dc.html — separate Preferences window
# =====================================================================
PREFS_W, PREFS_H = 720, 620
def pref_tab(icon, label, active):
    color = ACCENT if active else SUBTEXT
    return f'''<div style="display:flex;flex-direction:column;align-items:center;gap:3px;padding:6px 14px;border-radius:7px;{"background:#fff;box-shadow:0 1px 3px rgba(0,0,0,0.12);" if active else ""}">
    {svg(icon,18,18,stroke=color,sw=1.8)}<span style="font-size:10px;color:{color};font-weight:{"600" if active else "500"}">{label}</span></div>'''

ai_mode = f'''<div style="display:flex;flex-direction:column;gap:6px">
  <div style="font-size:11px;color:{HEADER_GRAY};text-transform:uppercase;font-weight:600;padding:0 2px">Chế độ AI</div>
  <div style="background:#fff;border-radius:10px;overflow:hidden;box-shadow:0 0 0 1px #ECECEE">
    <div style="display:flex;align-items:center;gap:10px;padding:12px 14px">
      <span style="width:26px;height:26px;border-radius:6px;background:{SAFE};display:flex;align-items:center;justify-content:center;flex:none">{svg("device",14,14,stroke="#fff",sw=2)}</span>
      <span style="flex:1;display:flex;flex-direction:column"><span style="font-size:13px">Chỉ trên máy</span><span style="font-size:11px;color:{SUBTEXT}">Không gửi nội dung mail ra khỏi máy</span></span>
      {svg("check",15,15,stroke=ACCENT,sw=2.8)}
    </div>
    <div style="height:1px;background:#ECECEE;margin-left:50px"></div>
    <div style="display:flex;align-items:center;gap:10px;padding:12px 14px">
      <span style="width:26px;height:26px;border-radius:6px;background:{ACCENT};display:flex;align-items:center;justify-content:center;flex:none">{svg("sparkle1",14,14,stroke="#fff",sw=2.2)}</span>
      <span style="flex:1;display:flex;flex-direction:column"><span style="font-size:13px">Cho phép cloud AI</span><span style="font-size:11px;color:{SUBTEXT}">Tóm tắt dài chính xác hơn · cần bạn đồng ý</span></span>
    </div>
  </div>
  <div style="font-size:11px;line-height:15px;color:{SUBTEXT};padding:0 2px">Khi bật cloud AI, chỉ đoạn trích đã ẩn danh được gửi đi và mỗi lần gửi đều ghi vào nhật ký.</div>
</div>'''

def toggle_row(label, on=True):
    thumb_pos = "flex-end" if on else "flex-start"
    bg = "#1F9D55" if on else "#D1D1D6"
    return f'''<div style="display:flex;align-items:center;gap:10px;padding:9px 14px">
    <span style="flex:1;font-size:13px">{label}</span>
    <span style="width:38px;height:22px;border-radius:11px;background:{bg};padding:2px;display:flex;justify-content:{thumb_pos};box-sizing:border-box"><span style="width:18px;height:18px;border-radius:9px;background:#fff;box-shadow:0 1px 3px rgba(0,0,0,0.2)"></span></span>
  </div>'''

privacy = f'''<div style="background:#fff;border-radius:10px;overflow:hidden;box-shadow:0 0 0 1px #ECECEE">
  {toggle_row("Ẩn email, số điện thoại", True)}<div style="height:1px;background:#ECECEE;margin-left:14px"></div>
  {toggle_row("Hỏi trước khi xoá &gt; 500 mail", True)}<div style="height:1px;background:#ECECEE;margin-left:14px"></div>
  <a href="#" style="min-height:40px;display:flex;align-items:center;gap:8px;padding:0 14px;text-decoration:none;color:#000"><span style="flex:1;font-size:13px">Nhật ký minh bạch</span><span style="font-size:12.5px;color:{SUBTEXT}">0 lần gửi cloud</span>{svg("chevron-right",11,11,stroke="#C4C4C7",sw=3)}</a>
  <div style="height:1px;background:#ECECEE;margin-left:14px"></div>
  <a href="#" style="min-height:40px;display:flex;align-items:center;gap:8px;padding:0 14px;text-decoration:none;color:#000"><span style="flex:1;font-size:13px">Danh sách bảo vệ</span><span style="font-size:12.5px;color:{SUBTEXT}">3 nhóm · 8 người</span>{svg("chevron-right",11,11,stroke="#C4C4C7",sw=3)}</a>
</div>'''

def account_row(badge, color, email, last=False):
    return f'''<a href="#" style="min-height:40px;display:flex;align-items:center;gap:10px;padding:0 14px;text-decoration:none;color:#000">
    <span style="width:24px;height:24px;border-radius:6px;background:{color};color:#fff;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center;flex:none">{badge}</span>
    <span style="flex:1;font-size:13px">{email}</span>{svg("chevron-right",11,11,stroke="#C4C4C7",sw=3)}</a>'''

accounts = f'''<div style="display:flex;flex-direction:column;gap:6px">
  <div style="font-size:11px;color:{HEADER_GRAY};text-transform:uppercase;font-weight:600;padding:0 2px">Tài khoản đã kết nối</div>
  <div style="background:#fff;border-radius:10px;overflow:hidden;box-shadow:0 0 0 1px #ECECEE">
    {account_row("G", "#D93025", "toan.n@gmail.com")}<div style="height:1px;background:#ECECEE;margin-left:48px"></div>
    {account_row("O", "#0F6CBD", "toan@outlook.com")}<div style="height:1px;background:#ECECEE;margin-left:48px"></div>
    {account_row("i", "#3A3A3C", "toan@icloud.com")}<div style="height:1px;background:#ECECEE;margin-left:48px"></div>
    <a href="AddAccount.dc.html" style="min-height:40px;display:flex;align-items:center;gap:10px;padding:0 14px;text-decoration:none;color:{ACCENT}">{svg("plus",16,16,stroke=ACCENT,sw=2.2)}<span style="font-size:13px">Thêm tài khoản</span></a>
  </div>
</div>'''

settings_inner = f'''<div style="width:{PREFS_W}px;height:{PREFS_H}px;box-sizing:border-box;background:#F2F2F7;font-family:-apple-system,'SF Pro Text',system-ui,sans-serif;color:{TEXT};position:relative;overflow:hidden;border-radius:10px;box-shadow:0 30px 70px rgba(0,0,0,0.35);display:flex;flex-direction:column">
  <div style="height:52px;flex:none;display:flex;align-items:center;padding:0 16px;gap:8px;-webkit-app-region:drag;background:#FBFBFC;border-bottom:1px solid {DIVIDER}">
    <span style="width:12px;height:12px;border-radius:6px;background:#FF5F57;border:0.5px solid rgba(0,0,0,0.12)"></span>
    <span style="width:12px;height:12px;border-radius:6px;background:#FEBC2E;border:0.5px solid rgba(0,0,0,0.12)"></span>
    <span style="width:12px;height:12px;border-radius:6px;background:#28C840;border:0.5px solid rgba(0,0,0,0.12)"></span>
    <span style="flex:1;text-align:center;font-size:13px;font-weight:600;margin-right:40px">Cài đặt</span>
  </div>
  <div style="flex:none;display:flex;justify-content:center;gap:6px;padding:10px;background:#FBFBFC;border-bottom:1px solid {DIVIDER}">
    {pref_tab("sparkle2", "AI & Riêng tư", True)}{pref_tab("inbox", "Tài khoản", False)}{pref_tab("gear", "Chung", False)}
  </div>
  <div style="flex:1;overflow-y:auto;padding:20px 28px;box-sizing:border-box;display:flex;flex-direction:column;gap:18px;max-width:560px">
    {ai_mode}{privacy}{accounts}
  </div>
</div>'''
write("Settings.dc.html", PAGE_HEAD.format(title="Cài đặt") + settings_inner + PAGE_TAIL_STATIC.format(w=PREFS_W, h=PREFS_H))

# =====================================================================
# Onboarding dialogs: Welcome, AddAccount, Scanning, CleanDone
# =====================================================================

# 12) Welcome.dc.html
welcome_body = f'''<div style="padding:28px 44px 30px;display:flex;flex-direction:column;align-items:center;gap:0;box-sizing:border-box;height:100%">
  <div style="height:150px;display:flex;align-items:center;justify-content:center;position:relative;flex:none">
    <div aria-hidden="true" style="position:absolute;width:150px;height:150px;border-radius:75px;background:radial-gradient(circle, #E3EEFC 0%, rgba(227,238,252,0) 70%)"></div>
    <div style="position:relative;width:118px;height:82px;border-radius:16px;background:linear-gradient(145deg, #0A5BC4, #0B7A8C);box-shadow:0 10px 22px rgba(10,91,196,0.28);display:flex;align-items:center;justify-content:center">
      <svg width="64" height="44" viewBox="0 0 92 64" fill="none" stroke="#fff" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="4" width="84" height="56" rx="10"></rect><path d="M6 8l40 28 40-28"></path></svg>
      <div style="position:absolute;right:-10px;top:-10px;width:32px;height:32px;border-radius:16px;background:{SAFE};border:3px solid #fff;display:flex;align-items:center;justify-content:center">{svg("check",15,15,stroke="#fff",sw=3)}</div>
    </div>
  </div>
  <div style="display:flex;flex-direction:column;gap:6px;text-align:center">
    <h1 style="margin:0;font-size:24px;font-weight:700">AI Smart Mail</h1>
    <p style="margin:0;font-size:13px;line-height:18px;color:#3C3C43;max-width:420px">Gom Gmail, Outlook và iCloud về một chỗ trên Mac. AI phân loại, gắn tag và dọn rác giúp bạn.</p>
  </div>
  <div style="display:flex;flex-direction:column;gap:14px;margin-top:22px;width:100%;max-width:440px">
    <div style="display:flex;gap:12px;align-items:flex-start"><div style="width:32px;height:32px;border-radius:8px;background:#E3EEFC;display:flex;align-items:center;justify-content:center;flex:none">{svg("device",17,17,stroke="#0A5BC4",sw=2)}</div><div><span style="font-size:13px;font-weight:600">Dữ liệu ở lại trên máy</span><div style="font-size:12px;line-height:16px;color:{SUBTEXT}">Mail được phân tích ngay trên Mac. Không máy chủ nào lưu nội dung thư.</div></div></div>
    <div style="display:flex;gap:12px;align-items:flex-start"><div style="width:32px;height:32px;border-radius:8px;background:#E4F3EA;display:flex;align-items:center;justify-content:center;flex:none">{svg("shield",17,17,stroke=SAFE,sw=2)}</div><div><span style="font-size:13px;font-weight:600">Cloud AI chỉ khi bạn cho phép</span><div style="font-size:12px;line-height:16px;color:{SUBTEXT}">Mặc định tắt. Bật lên sẽ hỏi rõ từng lần và có nhật ký minh bạch.</div></div></div>
    <div style="display:flex;gap:12px;align-items:flex-start"><div style="width:32px;height:32px;border-radius:8px;background:#FCEEDF;display:flex;align-items:center;justify-content:center;flex:none">{svg("undo",17,17,stroke=REVIEW,sw=2)}</div><div><span style="font-size:13px;font-weight:600">Xoá là hoàn tác được</span><div style="font-size:12px;line-height:16px;color:{SUBTEXT}">Mail bị dọn nằm trong Thùng rác 30 ngày. Mail tài chính, HR luôn được bảo vệ.</div></div></div>
  </div>
  <div style="margin-top:auto;display:flex;flex-direction:column;gap:10px;align-items:stretch;width:100%;max-width:440px">
    <a href="AddAccount.dc.html" style="height:40px;border-radius:9px;background:{ACCENT};color:#fff;display:flex;align-items:center;justify-content:center;text-decoration:none;font-size:13.5px;font-weight:600">Kết nối hộp thư</a>
    <p style="margin:0;font-size:11px;line-height:15px;color:{SUBTEXT};text-align:center">Tiếp tục nghĩa là bạn đồng ý với <a href="#" style="color:{ACCENT};text-decoration:none">Điều khoản</a> và <a href="#" style="color:{ACCENT};text-decoration:none">Chính sách quyền riêng tư</a>.</p>
  </div>
</div>'''
write("Welcome.dc.html", dialog_shell("Chào mừng", "", "", welcome_body))

# 13) AddAccount.dc.html
step = lambda n, html: f'<div style="display:flex;gap:10px;align-items:flex-start"><span style="width:20px;height:20px;border-radius:10px;background:{ACCENT};color:#fff;font-size:11px;font-weight:700;display:flex;align-items:center;justify-content:center;flex:none">{n}</span><span style="font-size:12px;line-height:17px">{html}</span></div>'
add_account_body = f'''<div style="padding:16px 28px 24px;display:flex;flex-direction:column;gap:14px;box-sizing:border-box">
  <div><h1 style="margin:0;font-size:22px;font-weight:700">Thêm tài khoản</h1><p style="margin:2px 0 0;font-size:12.5px;color:{SUBTEXT}">Kết nối qua IMAP. Mật khẩu được lưu trong Keychain của máy.</p></div>
  <div style="background:#F7F7F8;border-radius:10px;overflow:hidden;box-shadow:0 0 0 1px #ECECEE">
    <div style="display:flex;align-items:center;gap:10px;padding:10px 14px"><span style="width:26px;height:26px;border-radius:6px;background:#D93025;color:#fff;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center;flex:none">G</span><span style="flex:1;display:flex;flex-direction:column"><span style="font-size:13px">Gmail</span><span style="font-size:11px;color:{SAFE}">Đã kết nối · toan.n@gmail.com</span></span>{svg("check",17,17,stroke=SAFE,sw=2.6)}</div>
    <div style="height:1px;background:#ECECEE;margin-left:50px"></div>
    <div style="display:flex;align-items:center;gap:10px;padding:10px 14px"><span style="width:26px;height:26px;border-radius:6px;background:#0F6CBD;color:#fff;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center;flex:none">O</span><span style="flex:1;font-size:13px">Outlook / Microsoft 365</span>{svg("chevron-right",12,12,stroke="#C4C4C7",sw=3)}</div>
    <div style="height:1px;background:#ECECEE;margin-left:50px"></div>
    <div style="display:flex;align-items:center;gap:10px;padding:10px 14px;background:#fff"><span style="width:26px;height:26px;border-radius:6px;background:#3A3A3C;color:#fff;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center;flex:none">i</span><span style="flex:1;font-size:13px;font-weight:600">iCloud Mail</span>{svg("chevron-down",12,12,stroke="#C4C4C7",sw=3)}</div>
  </div>
  <div style="display:flex;flex-direction:column;gap:6px">
    <div style="font-size:10.5px;color:{HEADER_GRAY};text-transform:uppercase;font-weight:600">Tạo mật khẩu cho ứng dụng</div>
    <div style="background:#fff;border-radius:10px;padding:12px 14px;display:flex;flex-direction:column;gap:9px;box-shadow:0 0 0 1px #ECECEE">
      {step(1, 'Mở <a href="#" style="color:' + ACCENT + ';text-decoration:none;font-weight:600">account.apple.com</a> và đăng nhập Apple ID.')}
      {step(2, 'Vào <b>Đăng nhập và bảo mật</b> › <b>Mật khẩu cho ứng dụng</b>.')}
      {step(3, 'Bấm <b>+</b>, đặt tên "AI Smart Mail", rồi sao chép mã 16 ký tự.')}
      {step(4, 'Dán vào ô bên dưới. Mật khẩu Apple ID thật không bao giờ được dùng.')}
    </div>
  </div>
  <div style="background:#fff;border-radius:10px;overflow:hidden;box-shadow:0 0 0 1px #ECECEE">
    <div style="display:flex;align-items:center;min-height:38px;padding:0 14px;gap:10px"><label style="width:80px;font-size:12.5px;flex:none">Email</label><input value="toan@icloud.com" style="flex:1;border:none;outline:none;font:inherit;font-size:12.5px;background:transparent;height:38px"></div>
    <div style="height:1px;background:#ECECEE;margin-left:14px"></div>
    <div style="display:flex;align-items:center;min-height:38px;padding:0 14px;gap:10px"><label style="width:80px;font-size:12.5px;flex:none">Mật khẩu</label><input placeholder="xxxx-xxxx-xxxx-xxxx" style="flex:1;border:none;outline:none;font:inherit;font-size:12.5px;font-variant-numeric:tabular-nums;background:transparent;height:38px">
      <button style="height:24px;padding:0 9px;border-radius:12px;border:none;background:#E3EEFC;color:#0A5BC4;font:inherit;font-size:11px;font-weight:600;cursor:pointer">Dán</button></div>
  </div>
  <a href="Scanning.dc.html" style="height:38px;border-radius:9px;background:{ACCENT};color:#fff;display:flex;align-items:center;justify-content:center;text-decoration:none;font-size:13px;font-weight:600">Kết nối iCloud</a>
</div>'''
top_left = f'<a href="Welcome.dc.html" style="display:flex;align-items:center;gap:2px;text-decoration:none;color:{ACCENT};font-size:12.5px;margin-left:4px">{svg("chevron-left",15,15,stroke=ACCENT,sw=2.6)}Quay lại</a>'
write("AddAccount.dc.html", dialog_shell("Thêm tài khoản", top_left, "", add_account_body))

# 14) Scanning.dc.html
scanning_body = f'''<div style="padding:16px 28px 24px;display:flex;flex-direction:column;align-items:center;gap:14px;box-sizing:border-box;height:100%">
  <div style="display:flex;align-items:center;gap:8px"><h1 style="margin:0;font-size:17px;font-weight:700">Đang quét 3 hộp thư</h1></div>
  <p style="margin:0;font-size:12px;color:{SUBTEXT};font-variant-numeric:tabular-nums">Đã đọc tiêu đề 18.402 / 28.750 mail</p>
  <div style="position:relative;width:170px;height:170px">
    <svg width="170" height="170" viewBox="0 0 240 240">
      <circle cx="120" cy="120" r="104" fill="none" stroke="#E5E5EA" stroke-width="16"></circle>
      <circle cx="120" cy="120" r="104" fill="none" stroke="url(#scanGrad)" stroke-width="16" stroke-linecap="round" stroke-dasharray="418 654" transform="rotate(-90 120 120)"></circle>
      <defs><linearGradient id="scanGrad" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="{ACCENT}"></stop><stop offset="1" stop-color="{SAFE}"></stop></linearGradient></defs>
    </svg>
    <div style="position:absolute;inset:0;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:1px">
      <span style="font-size:11px;color:{SUBTEXT}">Đã tìm thấy</span><span style="font-size:30px;font-weight:800;font-variant-numeric:tabular-nums;color:{SAFE}">2,14 GB</span><span style="font-size:11px;color:{SUBTEXT}">64% hoàn tất</span>
    </div>
  </div>
  <div style="width:100%;max-width:440px;display:flex;flex-direction:column;gap:12px">
    <div style="background:#fff;border-radius:10px;overflow:hidden;box-shadow:0 0 0 1px #ECECEE">
      <div style="display:flex;align-items:center;gap:10px;padding:9px 14px"><span style="width:26px;height:26px;border-radius:6px;background:#D93025;color:#fff;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center;flex:none">G</span><span style="flex:1;font-size:13px">Gmail</span><span style="font-size:12px;color:{SAFE};font-weight:600;display:flex;align-items:center;gap:3px">{svg("check",13,13,stroke=SAFE,sw=2.8)}Xong</span></div>
      <div style="height:1px;background:#ECECEE;margin-left:50px"></div>
      <div style="display:flex;align-items:center;gap:10px;padding:9px 14px"><span style="width:26px;height:26px;border-radius:6px;background:#0F6CBD;color:#fff;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center;flex:none">O</span><span style="flex:1;display:flex;flex-direction:column;gap:4px"><span style="display:flex;justify-content:space-between;font-size:13px"><span>Outlook</span><span style="font-size:11px;color:{SUBTEXT}">58%</span></span><span style="height:4px;border-radius:2px;background:#E5E5EA;overflow:hidden;display:block"><span style="display:block;width:58%;height:100%;background:{ACCENT}"></span></span></span></div>
      <div style="height:1px;background:#ECECEE;margin-left:50px"></div>
      <div style="display:flex;align-items:center;gap:10px;padding:9px 14px"><span style="width:26px;height:26px;border-radius:6px;background:#3A3A3C;color:#fff;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center;flex:none">i</span><span style="flex:1;font-size:13px">iCloud</span><span style="font-size:12px;color:{SUBTEXT}">Đang chờ</span></div>
    </div>
    <a href="ScanReview.dc.html" style="height:36px;border-radius:9px;background:#E3EEFC;color:#0A5BC4;display:flex;align-items:center;justify-content:center;text-decoration:none;font-size:12.5px;font-weight:600">Xem kết quả tạm thời</a>
  </div>
</div>'''
top_left = f'<span style="display:flex;align-items:center;gap:5px;height:22px;padding:0 9px;border-radius:11px;background:#E4F3EA;color:{SAFE};font-size:10.5px;font-weight:600;margin-left:4px">{svg("shield",12,12,stroke=SAFE,sw=2.6)}Xử lý trên máy</span>'
top_right = f'<a href="Main.dc.html" style="font-size:12.5px;color:{ACCENT};text-decoration:none">Huỷ</a>'
write("Scanning.dc.html", dialog_shell("Đang quét", top_left, top_right, scanning_body))

# 15) CleanDone.dc.html
clean_done_body = f'''<div style="padding:16px 32px 24px;display:flex;flex-direction:column;align-items:center;gap:6px;box-sizing:border-box;text-align:center">
  <div style="width:64px;height:64px;border-radius:32px;background:#E4F3EA;display:flex;align-items:center;justify-content:center;margin-bottom:4px">
    <div style="width:46px;height:46px;border-radius:23px;background:{SAFE};display:flex;align-items:center;justify-content:center">{svg("check",24,24,stroke="#fff",sw=3)}</div>
  </div>
  <span style="font-size:13px;color:#3C3C43">Đã giải phóng</span>
  <span style="font-size:36px;font-weight:800;font-variant-numeric:tabular-nums;color:{SAFE}">1,75 GB</span>
  <span style="font-size:12px;color:{SUBTEXT}">7.908 mail đã chuyển vào Thùng rác</span>
  <div style="width:100%;max-width:440px;display:flex;flex-direction:column;gap:12px;margin-top:14px;text-align:left">
    <div style="background:#fff;border-radius:10px;padding:12px 14px;display:flex;flex-direction:column;gap:9px;box-shadow:0 0 0 1px #ECECEE">
      <div style="display:flex;align-items:center;gap:8px"><span style="width:26px;height:26px;border-radius:6px;background:#D93025;color:#fff;font-size:12px;font-weight:700;display:flex;align-items:center;justify-content:center;flex:none">G</span><span style="flex:1;font-size:13px;font-weight:600">Dung lượng Gmail</span><span style="font-size:13px;font-weight:700"><span style="color:{SUBTEXT};text-decoration:line-through;font-weight:500">92%</span> → <span style="color:{SAFE}">79%</span></span></div>
      <div style="display:flex;flex-direction:column;gap:4px">
        <div style="display:flex;align-items:center;gap:8px;font-size:11px;color:{SUBTEXT}"><span style="width:40px">Trước</span><span style="flex:1;height:6px;border-radius:3px;background:#E5E5EA;overflow:hidden;display:block"><span style="display:block;width:92%;height:100%;background:#AEAEB2"></span></span></div>
        <div style="display:flex;align-items:center;gap:8px;font-size:11px;color:{SAFE};font-weight:600"><span style="width:40px">Sau</span><span style="flex:1;height:6px;border-radius:3px;background:#E5E5EA;overflow:hidden;display:block"><span style="display:block;width:79%;height:100%;background:{SAFE}"></span></span></div>
      </div>
    </div>
    <div style="background:#fff;border-radius:10px;overflow:hidden;box-shadow:0 0 0 1px #ECECEE">
      <div style="display:flex;justify-content:space-between;align-items:center;min-height:34px;padding:0 14px;font-size:12.5px"><span>Promo cũ</span><span style="color:{SUBTEXT}">1,1 GB</span></div>
      <div style="height:1px;background:#ECECEE;margin-left:14px"></div>
      <div style="display:flex;justify-content:space-between;align-items:center;min-height:34px;padding:0 14px;font-size:12.5px"><span>Newsletter bỏ đọc</span><span style="color:{SUBTEXT}">640 MB</span></div>
      <div style="height:1px;background:#ECECEE;margin-left:14px"></div>
      <div style="display:flex;justify-content:space-between;align-items:center;min-height:34px;padding:0 14px;font-size:12.5px"><span>OTP và thông báo cũ</span><span style="color:{SUBTEXT}">22 MB</span></div>
    </div>
    <div style="display:grid;grid-template-columns:1fr 1fr;gap:10px">
      <button style="height:36px;border-radius:9px;border:none;background:#E3EEFC;color:#0A5BC4;font:inherit;font-size:12.5px;font-weight:600;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:5px">{svg("undo",14,14,stroke="#0A5BC4",sw=2.4)}Hoàn tác</button>
      <button style="height:36px;border-radius:9px;border:none;background:#FDE8E7;color:{DANGER};font:inherit;font-size:12.5px;font-weight:600;cursor:pointer">Dọn Thùng rác</button>
    </div>
    <a href="Main.dc.html" style="height:36px;border-radius:9px;background:{ACCENT};color:#fff;display:flex;align-items:center;justify-content:center;text-decoration:none;font-size:12.5px;font-weight:600">Về Tổng quan</a>
  </div>
</div>'''
top_right = f'<a href="Main.dc.html" style="font-size:12.5px;color:{ACCENT};font-weight:600;text-decoration:none">Xong</a>'
write("CleanDone.dc.html", dialog_shell("Dọn xong", "", top_right, clean_done_body))

print("Done:", len(os.listdir(OUT)), "files")
