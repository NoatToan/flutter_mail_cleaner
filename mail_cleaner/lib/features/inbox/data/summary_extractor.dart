/// Cheap on-device "AI summary" for the reading pane's summary card: the
/// first ~3 sentences of the body, extracted with no network call. Slice C
/// owns the real newsletter catch-up summarizer — this is only the small
/// per-message card shown while reading one email.
List<String> extractSummaryBullets(String body, {int maxBullets = 3}) {
  final cleaned = body.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (cleaned.isEmpty) return const [];
  final sentences = cleaned
      .split(RegExp(r'(?<=[.!?…])\s+'))
      .map((s) => s.trim())
      .where((s) => s.length > 6)
      .toList();
  if (sentences.isEmpty) {
    return [if (cleaned.length > 160) '${cleaned.substring(0, 160)}…' else cleaned];
  }
  return sentences.take(maxBullets).toList();
}
