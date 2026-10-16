import 'package:intl/intl.dart';

/// Matches the design's list-row timestamps: `09:41` today, `Hôm qua`
/// yesterday, weekday name within the last week, else `dd/MM`.
String formatMessageTime(DateTime date, String localeCode, {DateTime? now}) {
  final n = now ?? DateTime.now();
  final today = DateTime(n.year, n.month, n.day);
  final that = DateTime(date.year, date.month, date.day);
  final diffDays = today.difference(that).inDays;
  if (diffDays == 0) return DateFormat.Hm(localeCode).format(date);
  if (diffDays == 1) {
    return localeCode == 'vi' ? 'Hôm qua' : 'Yesterday';
  }
  if (diffDays > 1 && diffDays < 7) {
    return DateFormat('EEEE', localeCode).format(date);
  }
  return DateFormat('dd/MM').format(date);
}
