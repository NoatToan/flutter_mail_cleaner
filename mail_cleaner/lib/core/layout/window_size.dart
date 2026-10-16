import 'package:flutter/widgets.dart';

/// Width-based breakpoints (TECH_SPEC §2a). Layout decisions use these, never
/// the OS — an iPad or Android tablet gets the wide layout too.
enum WindowSize {
  compact,
  medium,
  expanded,
  large;

  static WindowSize fromWidth(double width) {
    if (width < 600) return WindowSize.compact;
    if (width < 1024) return WindowSize.medium;
    if (width < 1440) return WindowSize.expanded;
    return WindowSize.large;
  }

  static WindowSize of(BuildContext context) =>
      fromWidth(MediaQuery.sizeOf(context).width);

  bool get isCompact => this == WindowSize.compact;
  bool get showsSidebar => index >= WindowSize.expanded.index;
  bool get showsReadingPane => index >= WindowSize.expanded.index;
}
