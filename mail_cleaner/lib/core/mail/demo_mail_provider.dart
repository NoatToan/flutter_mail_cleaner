import 'dart:math';

import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';

/// One generated sample message plus the fields the sync engine/classifier
/// need. Intentionally a plain class (not Freezed) — this never leaves
/// [DemoMailProvider], it is turned into a [RemoteMessageHeader] immediately.
class _Seed {
  const _Seed({
    required this.fromName,
    required this.fromEmail,
    required this.subject,
    required this.snippet,
    required this.size,
    this.body,
    this.hasAttachments = false,
    this.listId,
    this.listUnsubscribe,
    this.listUnsubscribePost = false,
    this.precedence,
    this.autoSubmitted,
    this.dkimPass = true,
    this.readChance = 0.55,
  });

  final String fromName;
  final String fromEmail;
  final String subject;
  final String snippet;
  final int size;
  final String? body;
  final bool hasAttachments;
  final String? listId;
  final String? listUnsubscribe;
  final bool listUnsubscribePost;
  final String? precedence;
  final String? autoSubmitted;
  final bool? dkimPass;
  final double readChance;
}

/// Deterministic sample mailbox for "Dùng thử với hộp thư mẫu" (onboarding).
/// Runs through the exact same sync → classify → DB pipeline as a real IMAP
/// account — only the transport is fake — so Smart Scan, tags, senders and
/// search all work identically on demo data. Content is realistic Vietnamese
/// mail (banks, HR, newsletters, e-commerce, OTP, travel, spam) sized so the
/// totals read in GB, matching the Scanning/Smart Scan designs.
class DemoMailProvider implements MailProvider {
  DemoMailProvider({
    required this.accountId,
    required this.providerType,
    required this.selfEmail,
  }) {
    _generate();
  }

  final String accountId;
  final MailProviderType providerType;
  final String selfEmail;

  final Map<String, List<RemoteMessageHeader>> _byFolder = {};
  final Map<String, Map<int, String>> _bodiesByFolder = {};
  List<RemoteFolder> _folders = const [];

  /// FNV-1a over the account id — deterministic across runs/VMs, unlike
  /// [Object.hashCode]/[String.hashCode] which Dart may randomize per isolate.
  static int _stableHash(String input) {
    var hash = 0x811c9dc5;
    for (final unit in input.codeUnits) {
      hash = ((hash ^ unit) * 0x01000193) & 0xFFFFFFFF;
    }
    return hash;
  }

  @override
  Future<void> connect() async {}

  @override
  Future<void> disconnect() async {}

  @override
  Future<List<RemoteFolder>> listFolders() async => _folders;

  @override
  Stream<List<RemoteMessageHeader>> fetchHeaders(
    RemoteFolder folder, {
    int? afterUid,
    int batchSize = 500,
  }) async* {
    final all = _byFolder[folder.path] ?? const [];
    final filtered = afterUid == null
        ? all
        : all.where((m) => m.uid > afterUid).toList();
    final sorted = [...filtered]..sort((a, b) => b.uid.compareTo(a.uid));
    for (var i = 0; i < sorted.length; i += batchSize) {
      final end = min(i + batchSize, sorted.length);
      // Tiny delay so the Scanning screen's progress stream is observable
      // instead of completing a 3k-message sync in a single frame.
      await Future<void>.delayed(const Duration(milliseconds: 8));
      yield sorted.sublist(i, end);
    }
  }

  @override
  Future<String?> fetchBodyText(RemoteFolder folder, int uid) async =>
      _bodiesByFolder[folder.path]?[uid];

  @override
  Future<MoveResult> moveMessages(
    RemoteFolder from,
    RemoteFolder to,
    List<int> uids,
  ) async {
    final source = _byFolder[from.path];
    if (source == null || uids.isEmpty) return const MoveResult();
    final moved = <RemoteMessageHeader>[];
    source.removeWhere((m) {
      if (!uids.contains(m.uid)) return false;
      moved.add(m);
      return true;
    });
    _byFolder.putIfAbsent(to.path, () => []).addAll(moved);
    return MoveResult(uidMap: {for (final m in moved) m.uid: m.uid});
  }

  @override
  Future<void> setSeen(
    RemoteFolder folder,
    List<int> uids, {
    required bool seen,
  }) async {
    final list = _byFolder[folder.path];
    if (list == null) return;
    for (var i = 0; i < list.length; i++) {
      if (uids.contains(list[i].uid)) {
        list[i] = list[i].copyWith(isSeen: seen);
      }
    }
  }

  @override
  Future<QuotaInfo?> quota() async {
    final used = _byFolder.values
        .expand((l) => l)
        .fold<int>(0, (a, m) => a + m.size);
    const cap = 15 * 1024 * 1024 * 1024; // Gmail/iCloud-style free tier.
    return QuotaInfo(usedBytes: used, totalBytes: cap);
  }

  // ---------------------------------------------------------------------
  // Generation
  // ---------------------------------------------------------------------

  void _generate() {
    final rnd = Random(_stableHash(accountId));
    final now = DateTime.now();
    var nextUid = 1;
    final inbox = <RemoteMessageHeader>[];
    final bodies = <int, String>{};

    void add(_Seed seed, DateTime date) {
      final id = nextUid++;
      inbox.add(
        RemoteMessageHeader(
          uid: id,
          fromEmail: seed.fromEmail,
          fromName: seed.fromName,
          toLine: selfEmail,
          subject: seed.subject,
          snippet: seed.snippet,
          date: date,
          size: seed.size,
          isSeen: rnd.nextDouble() < seed.readChance,
          hasAttachments: seed.hasAttachments,
          messageIdHeader:
              '<${_stableHash('$accountId-$id')}@${seed.fromEmail.split('@').last}>',
          listId: seed.listId,
          listUnsubscribe: seed.listUnsubscribe,
          listUnsubscribePost: seed.listUnsubscribePost,
          precedence: seed.precedence,
          autoSubmitted: seed.autoSubmitted,
          dkimPass: seed.dkimPass,
        ),
      );
      if (seed.body != null) bodies[id] = seed.body!;
    }

    // 1) Tech Brief VN — weekly newsletter, 18 issues.
    for (var i = 18; i >= 1; i--) {
      add(
        _techBriefIssue(rnd, i),
        now.subtract(Duration(days: (18 - i) * 7, hours: rnd.nextInt(4))),
      );
    }
    // 2) Bank / finance.
    for (var i = 0; i < 60; i++) {
      add(
        _bankMessage(rnd, i),
        now.subtract(Duration(days: i * 2 + rnd.nextInt(2))),
      );
    }
    // 3) OTP — short half-life (UC-11).
    for (var i = 0; i < 140; i++) {
      add(
        _otpMessage(rnd, i),
        now.subtract(Duration(hours: i * 6 + rnd.nextInt(5))),
      );
    }
    // 4) HR.
    for (var i = 0; i < 25; i++) {
      add(
        _hrMessage(rnd, i),
        now.subtract(Duration(days: i * 4 + rnd.nextInt(3))),
      );
    }
    // 5) E-commerce promos — hundreds (Shopee/Lazada/Tiki).
    for (var i = 0; i < 420; i++) {
      add(
        _promoMessage(rnd, i),
        now.subtract(Duration(hours: i * 5 + rnd.nextInt(4))),
      );
    }
    // 6) Travel.
    for (var i = 0; i < 40; i++) {
      add(
        _travelMessage(rnd, i),
        now.subtract(Duration(days: i * 3 + rnd.nextInt(2))),
      );
    }
    // 7) Social / updates.
    for (var i = 0; i < 70; i++) {
      add(
        _socialMessage(rnd, i),
        now.subtract(Duration(days: i + rnd.nextInt(2))),
      );
    }
    // 8) Spam.
    for (var i = 0; i < 90; i++) {
      add(
        _spamMessage(rnd, i),
        now.subtract(Duration(hours: i * 7 + rnd.nextInt(6))),
      );
    }
    // 9) Large attachments scattered in — pushes totals into GB range.
    for (var i = 0; i < 25; i++) {
      add(
        _largeAttachmentMessage(rnd, i),
        now.subtract(Duration(days: i * 5 + rnd.nextInt(4))),
      );
    }
    // 10) A handful of exact duplicates (same sender+subject, different day).
    final dup = _promoMessage(rnd, 12345);
    for (var i = 0; i < 6; i++) {
      add(dup, now.subtract(Duration(days: 10 + i * 9)));
    }

    _byFolder['INBOX'] = inbox;
    _bodiesByFolder['INBOX'] = bodies;
    _byFolder['Sent'] = _sentMessages(rnd, now);
    _byFolder['Archive'] = _archiveMessages(rnd, now);
    _byFolder['Trash'] = _trashMessages(rnd, now);

    RemoteFolder folderOf(String path, String name, FolderRole role) {
      final list = _byFolder[path] ?? const [];
      return RemoteFolder(
        path: path,
        name: name,
        role: role,
        uidValidity: 1,
        uidNext: nextUid,
        totalCount: list.length,
        unreadCount: list.where((m) => !m.isSeen).length,
      );
    }

    _folders = [
      folderOf('INBOX', 'Hộp thư đến', FolderRole.inbox),
      folderOf('Sent', 'Đã gửi', FolderRole.sent),
      folderOf('Archive', 'Lưu trữ', FolderRole.archive),
      folderOf('Trash', 'Thùng rác', FolderRole.trash),
    ];
  }

  // -- category generators --------------------------------------------

  static const _techBriefTopics = [
    'Startup AI Việt chuyển sang mô hình nhỏ',
    'Giá thuê GPU giảm gần 30% trong quý',
    'Fintech trong nước gọi vốn vòng A',
    'Xu hướng suy luận AI trên thiết bị di động',
    'Tổng hợp sự kiện công nghệ tháng tới',
    'Chip nội địa và bài toán tự chủ phần cứng',
    'Thương mại điện tử livestream tăng trưởng mạnh',
    'Bảo mật dữ liệu cá nhân: điều cần biết',
  ];

  _Seed _techBriefIssue(Random rnd, int issue) {
    final topic = _techBriefTopics[rnd.nextInt(_techBriefTopics.length)];
    return _Seed(
      fromName: 'Tech Brief VN',
      fromEmail: 'newsletter@techbrief.vn',
      subject: 'Số #${100 + issue}: $topic',
      snippet:
          'Giá thuê GPU giảm, nhiều đội chuyển sang suy luận trên thiết bị…',
      size: 60 * 1024 + rnd.nextInt(90 * 1024),
      body:
          'Chào bạn,\n\nTuần này: $topic.\n\nTheo khảo sát với 40 đội AI '
          'trong nước, hơn một nửa đã thử đưa phần suy luận xuống thiết bị '
          'người dùng để bảo vệ quyền riêng tư.\n\nĐọc tiếp trong số này: '
          'Fintech gọi vốn vòng A, lịch sự kiện tháng tới…\n\n— Tech Brief VN',
      listId: '<techbrief.vn>',
      listUnsubscribe: '<https://techbrief.vn/unsub?u=1>, <mailto:unsub@techbrief.vn>',
      listUnsubscribePost: true,
      precedence: 'bulk',
    );
  }

  static const _banks = [
    ('Ngân hàng ACB', 'noreply@acb.com.vn'),
    ('VCB Digibank', 'noreply@vietcombank.com.vn'),
    ('Techcombank', 'noreply@techcombank.com.vn'),
    ('VIB MyVIB', 'noreply@vib.com.vn'),
  ];

  _Seed _bankMessage(Random rnd, int i) {
    final bank = _banks[i % _banks.length];
    final isStatement = i.isEven;
    final last4 = 1000 + rnd.nextInt(8999);
    final subject = isStatement
        ? 'Sao kê thẻ tín dụng kỳ ${_vnMonthYear(i)}'
        : 'Biến động số dư tài khoản ${_vnAccountTail(last4)}';
    final snippet = isStatement
        ? 'Sao kê thẻ đuôi $last4 đã sẵn sàng. Hạn thanh toán: ${_vnDatePlus(20)}.'
        : 'Tài khoản của bạn vừa phát sinh giao dịch ${_vnMoney(rnd, 50000, 8000000)}.';
    return _Seed(
      fromName: bank.$1,
      fromEmail: bank.$2,
      subject: subject,
      snippet: snippet,
      size: 40 * 1024 + rnd.nextInt(260 * 1024),
      hasAttachments: isStatement,
      body: '$snippet\n\nVui lòng không chia sẻ thông tin này với bất kỳ ai.',
      readChance: 0.75,
    );
  }

  static const _otpSenders = [
    ('ACB OTP', 'otp@acb.com.vn'),
    ('VCB Digibank', 'otp@vietcombank.com.vn'),
    ('MoMo', 'no-reply@momo.vn'),
    ('ZaloPay', 'no-reply@zalopay.vn'),
    ('Shopee', 'no-reply@shopee.vn'),
  ];

  _Seed _otpMessage(Random rnd, int i) {
    final sender = _otpSenders[i % _otpSenders.length];
    final code = 100000 + rnd.nextInt(899999);
    final subject = i.isEven
        ? 'Mã OTP xác thực giao dịch'
        : 'Mã xác minh đăng nhập của bạn';
    return _Seed(
      fromName: sender.$1,
      fromEmail: sender.$2,
      subject: subject,
      snippet: 'Mã OTP của bạn là $code, có hiệu lực trong 5 phút.',
      size: 2 * 1024 + rnd.nextInt(2 * 1024),
      body:
          'Mã xác thực của bạn là: $code\n\nMã có hiệu lực trong 5 phút. '
          'Không chia sẻ mã này với bất kỳ ai, kể cả nhân viên ngân hàng.',
      readChance: 0.9,
    );
  }

  static const _hrSubjects = [
    'Chào mừng bạn — lịch onboarding tuần đầu',
    'Phiếu lương tháng {m}/2026',
    'Cập nhật chính sách nghỉ phép năm 2026',
    'Thông báo lịch nghỉ lễ',
    'Khảo sát mức độ hài lòng nhân viên',
  ];

  _Seed _hrMessage(Random rnd, int i) {
    final template = _hrSubjects[i % _hrSubjects.length];
    final month = 1 + (i % 12);
    final subject = template.replaceAll('{m}', '$month');
    return _Seed(
      fromName: 'Phòng Nhân sự',
      fromEmail: 'hr@congty.vn',
      subject: subject,
      snippet: 'Thứ Hai 9:00 nhận thiết bị tại tầng 5, 10:30 gặp team Product.',
      size: 30 * 1024 + rnd.nextInt(120 * 1024),
      hasAttachments: subject.startsWith('Phiếu lương'),
      body: '$subject\n\nVui lòng xem chi tiết trong tệp đính kèm (nếu có) '
          'hoặc liên hệ phòng Nhân sự nếu cần hỗ trợ.',
      readChance: 0.7,
    );
  }

  static const _shops = [
    ('Shopee', 'noreply@shopee.vn', 'shopee.vn'),
    ('Lazada', 'noreply@lazada.vn', 'lazada.vn'),
    ('Tiki', 'noreply@tiki.vn', 'tiki.vn'),
  ];
  static const _promoSubjects = [
    'Flash Sale {d}.{m} — giảm đến {p}%',
    'Voucher {p}% chỉ hôm nay, nhanh tay săn!',
    'Đơn hàng #{code} đã được xác nhận',
    'Freeship toàn sàn — đừng bỏ lỡ',
    'Deal sốc cuối tuần: giảm đến {p}%',
  ];

  _Seed _promoMessage(Random rnd, int i) {
    final shop = _shops[i % _shops.length];
    final percent = 10 + rnd.nextInt(80);
    final day = 1 + rnd.nextInt(28);
    final month = 1 + rnd.nextInt(12);
    final code = 100000 + rnd.nextInt(899999);
    final subject = _promoSubjects[i % _promoSubjects.length]
        .replaceAll('{p}', '$percent')
        .replaceAll('{d}', '$day')
        .replaceAll('{m}', '$month')
        .replaceAll('{code}', '$code');
    return _Seed(
      fromName: shop.$1,
      fromEmail: shop.$2,
      subject: subject,
      snippet: 'Săn deal 0Đ từ 0h, freeship mọi đơn từ 0Đ.',
      size: 90 * 1024 + rnd.nextInt(900 * 1024),
      hasAttachments: rnd.nextBool(),
      listId: '<promo.${shop.$3}>',
      listUnsubscribe:
          '<https://${shop.$3}/unsubscribe?u=$code>, <mailto:unsub@${shop.$3}>',
      listUnsubscribePost: rnd.nextBool(),
      precedence: 'bulk',
      readChance: 0.25,
    );
  }

  static const _travelBrands = [
    ('Vietjet Air', 'booking@vietjetair.com'),
    ('Grab', 'noreply@grab.com'),
    ('Booking.com', 'noreply@booking.com'),
  ];

  _Seed _travelMessage(Random rnd, int i) {
    final brand = _travelBrands[i % _travelBrands.length];
    final subject = switch (brand.$1) {
      'Vietjet Air' => 'Xác nhận đặt chỗ SGN → HAN, ${_vnDatePlus(8 + i)}',
      'Grab' => 'Biên nhận chuyến GrabCar của bạn',
      _ => 'Xác nhận đặt phòng khách sạn',
    };
    return _Seed(
      fromName: brand.$1,
      fromEmail: brand.$2,
      subject: subject,
      snippet: brand.$1 == 'Grab'
          ? 'Cảm ơn bạn đã đi cùng Grab. Tổng cộng ${_vnMoney(rnd, 25000, 180000)}.'
          : 'Mã đặt chỗ: [MÃ ĐẶT CHỖ]. Vui lòng kiểm tra lại thông tin chuyến đi.',
      size: 40 * 1024 + rnd.nextInt(200 * 1024),
      hasAttachments: brand.$1 != 'Grab',
      readChance: 0.8,
    );
  }

  static const _socialTemplates = [
    '{n} đã xem hồ sơ của bạn',
    'Bạn có {n} thông báo mới trên LinkedIn',
    '{n} đã bình luận về bài viết của bạn',
  ];

  _Seed _socialMessage(Random rnd, int i) {
    final n = 1 + rnd.nextInt(12);
    final subject = _socialTemplates[i % _socialTemplates.length].replaceAll(
      '{n}',
      '$n',
    );
    return _Seed(
      fromName: 'LinkedIn',
      fromEmail: 'notifications@linkedin.com',
      subject: subject,
      snippet: 'Xem ngay trên LinkedIn.',
      size: 15 * 1024 + rnd.nextInt(40 * 1024),
      listId: '<linkedin.notifications>',
      listUnsubscribe: '<https://www.linkedin.com/unsub?u=$i>',
      precedence: 'bulk',
      autoSubmitted: 'auto-generated',
      readChance: 0.3,
    );
  }

  static const _spamSubjects = [
    'Bạn đã trúng thưởng 500.000.000đ!!!',
    'Đầu tư crypto lãi 40%/tháng, cam kết',
    'Hoá đơn chưa thanh toán — xem ngay',
    'Việc làm tại nhà lương 50 triệu/tháng',
  ];

  _Seed _spamMessage(Random rnd, int i) {
    return _Seed(
      fromName: 'Khuyến mãi',
      fromEmail: 'offer${i % 37}@mailer-promo${i % 5}.top',
      subject: _spamSubjects[i % _spamSubjects.length],
      snippet: 'Nhấn vào đây để nhận ngay phần thưởng của bạn.',
      size: 8 * 1024 + rnd.nextInt(30 * 1024),
      dkimPass: rnd.nextDouble() < 0.1 ? null : false,
      readChance: 0.02,
    );
  }

  _Seed _largeAttachmentMessage(Random rnd, int i) {
    final kind = i.isEven
        ? 'Hợp đồng dịch vụ (bản ký) — đính kèm'
        : 'Ảnh sự kiện công ty quý ${1 + i % 4}';
    return _Seed(
      fromName: i.isEven ? 'Phòng Pháp chế' : 'Ban Truyền thông',
      fromEmail: i.isEven ? 'phapche@congty.vn' : 'truyenthong@congty.vn',
      subject: kind,
      snippet: 'Tệp đính kèm dung lượng lớn, vui lòng tải khi có wifi.',
      size: (5 + rnd.nextInt(16)) * 1024 * 1024,
      hasAttachments: true,
      readChance: 0.6,
    );
  }

  List<RemoteMessageHeader> _sentMessages(Random rnd, DateTime now) => [
    for (var i = 0; i < 24; i++)
      RemoteMessageHeader(
        uid: i + 1,
        fromEmail: selfEmail,
        toLine: 'dongnghiep$i@congty.vn',
        subject: 'Re: Review UI màn Smart Scan',
        snippet: 'Mình thấy nút Dọn nên hiện dung lượng đang chọn.',
        date: now.subtract(Duration(days: i * 3)),
        size: 10 * 1024 + rnd.nextInt(20 * 1024),
        isSeen: true,
      ),
  ];

  List<RemoteMessageHeader> _archiveMessages(Random rnd, DateTime now) => [
    for (var i = 0; i < 50; i++)
      RemoteMessageHeader(
        uid: i + 1,
        fromEmail: _banks[i % _banks.length].$2,
        fromName: _banks[i % _banks.length].$1,
        toLine: selfEmail,
        subject: 'Sao kê thẻ tín dụng kỳ ${_vnMonthYear(i + 60)}',
        snippet: 'Đã lưu trữ.',
        date: now.subtract(Duration(days: 90 + i * 3)),
        size: 60 * 1024 + rnd.nextInt(80 * 1024),
        isSeen: true,
      ),
  ];

  List<RemoteMessageHeader> _trashMessages(Random rnd, DateTime now) => [
    for (var i = 0; i < 180; i++)
      RemoteMessageHeader(
        uid: i + 1,
        fromEmail: _shops[i % _shops.length].$2,
        fromName: _shops[i % _shops.length].$1,
        toLine: selfEmail,
        subject: 'Flash Sale đã kết thúc',
        snippet: 'Đã chuyển vào thùng rác.',
        date: now.subtract(Duration(days: 30 + i)),
        size: 60 * 1024 + rnd.nextInt(400 * 1024),
        isSeen: true,
      ),
  ];

  // -- small VN-locale formatting helpers -------------------------------

  static String _vnMonthYear(int offset) {
    final d = DateTime.now().subtract(Duration(days: offset * 30));
    return '${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  static String _vnDatePlus(int days) {
    final d = DateTime.now().add(Duration(days: days));
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
  }

  static String _vnAccountTail(int tail) => '****$tail';

  static String _vnMoney(Random rnd, int min, int max) {
    final amount = min + rnd.nextInt(max - min);
    final s = amount.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return '$bufđ';
  }
}
