/// Vietnamese number/byte formatting (house rule: `NumberFormat.decimalPattern`
/// with '.' thousands separators, ',' decimals — "7.908", "3,2 GB").
///
/// Small and self-contained so each feature (dashboard/smart_scan/senders)
/// can own its copy without a cross-feature import; see the slice report for
/// why this isn't in `core/` (the owned-folders list for this slice doesn't
/// include a shared formatting home, so duplicating ~20 lines beat adding a
/// new core/ folder unilaterally).
library;

import 'package:intl/intl.dart';

final NumberFormat _count = NumberFormat.decimalPattern('vi');
final NumberFormat _oneDecimal = NumberFormat('0.0', 'vi');

/// "7.908"
String formatCount(num n) => _count.format(n);

const int _kb = 1024;
const int _mb = _kb * 1024;
const int _gb = _mb * 1024;

/// "3,2 GB" · "640 MB" · "12 KB" · "128 B" — GB always keeps one decimal
/// (sizes matter at that scale), MB/KB round to whole numbers.
String formatBytes(int bytes) {
  if (bytes <= 0) return '0 B';
  if (bytes >= _gb) return '${_oneDecimal.format(bytes / _gb)} GB';
  if (bytes >= _mb) return '${(bytes / _mb).round()} MB';
  if (bytes >= _kb) return '${(bytes / _kb).round()} KB';
  return '$bytes B';
}

/// "92%"
String formatPercent(double ratio) => '${(ratio * 100).round()}%';
