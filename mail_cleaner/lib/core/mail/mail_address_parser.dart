/// A parsed `Name <email>` address.
typedef ParsedMailAddress = ({String name, String email});

final _angle = RegExp(r'^\s*(.*?)\s*<([^>]+)>\s*$');

/// Parses one already-decoded address header value: `"Name" <a@b>`,
/// `Name <a@b>` or a bare `a@b`. REST APIs hand back decoded headers, so no
/// RFC 2047 handling is needed here.
ParsedMailAddress parseMailAddress(String value) {
  final match = _angle.firstMatch(value);
  if (match == null) return (name: '', email: value.trim().toLowerCase());
  var name = match.group(1)!.trim();
  if (name.length >= 2 && name.startsWith('"') && name.endsWith('"')) {
    name = name.substring(1, name.length - 1).replaceAll(r'\"', '"');
  }
  return (name: name, email: match.group(2)!.trim().toLowerCase());
}

/// Splits a comma-separated address list, ignoring commas inside quotes.
List<ParsedMailAddress> parseMailAddressList(String value) {
  final parts = <String>[];
  final current = StringBuffer();
  var quoted = false;
  for (final char in value.split('')) {
    if (char == '"') quoted = !quoted;
    if (char == ',' && !quoted) {
      parts.add(current.toString());
      current.clear();
    } else {
      current.write(char);
    }
  }
  parts.add(current.toString());
  return [
    for (final p in parts)
      if (p.trim().isNotEmpty) parseMailAddress(p),
  ];
}
