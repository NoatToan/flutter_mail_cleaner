/// List-pane sort order (Gmail-style "Sắp xếp" menu). Stored by name in
/// shared_preferences, so only ever append values.
enum InboxSort {
  /// Newest first — the default, like every mail client.
  newest,
  oldest,

  /// Unread mail on top, each group newest first.
  unreadFirst,

  /// Sender name A→Z (then newest first).
  sender,

  /// Biggest messages first — handy when cleaning up storage.
  largest,
}
