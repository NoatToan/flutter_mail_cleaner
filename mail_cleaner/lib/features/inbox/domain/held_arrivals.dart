/// Ids of mail that just arrived *above* what the list already shows.
///
/// While the user is scrolled down, inserting rows above the viewport pushes
/// every visible row down (the list "jumps" on each sync batch). Instead the
/// list keeps those arrivals out until the user goes back to the top (or taps
/// the "N new" pill), Gmail-style.
///
/// [shownIds] is what the list rendered last time, [nextIds] the new query
/// result in display order. An id is held when it was not shown before and
/// sits before the first id that was (the anchor). Rows that were shown keep
/// updating in place; arrivals below the anchor are inserted normally since
/// they don't move anything on screen above them.
Set<int> heldArrivals({
  required List<int> shownIds,
  required List<int> nextIds,
}) {
  if (shownIds.isEmpty) return const {};
  final shown = shownIds.toSet();
  final anchor = nextIds.indexWhere(shown.contains);
  // Nothing in common (everything shown was archived/deleted): there is no
  // position to keep, show the new list as is.
  if (anchor <= 0) return const {};
  return nextIds.take(anchor).toSet();
}
