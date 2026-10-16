import 'package:flutter/material.dart';

/// Single source of design tokens (design/README.md). Widgets never hardcode
/// colors or spacing — they read these via the theme or [AppTokens.of].
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.safe,
    required this.review,
    required this.protected,
    required this.danger,
    required this.aiSurface,
    required this.aiOnSurface,
    required this.sidebar,
    required this.toolbar,
    required this.divider,
    required this.selectedRow,
    required this.subtleSurface,
  });

  final Color safe;
  final Color review;
  final Color protected;
  final Color danger;
  final Color aiSurface;
  final Color aiOnSurface;
  final Color sidebar;
  final Color toolbar;
  final Color divider;
  final Color selectedRow;
  final Color subtleSurface;

  static const light = AppTokens(
    safe: Color(0xFF157A41),
    review: Color(0xFFB25400),
    protected: Color(0xFF6C6C70),
    danger: Color(0xFFB3261E),
    aiSurface: Color(0xFFEEF4FD),
    aiOnSurface: Color(0xFF0A3F87),
    sidebar: Color(0xFFF6F6F7),
    toolbar: Color(0xFFFBFBFC),
    divider: Color(0xFFE2E2E4),
    selectedRow: Color(0xFFD7E6FB),
    subtleSurface: Color(0xFFF2F2F7),
  );

  static const dark = AppTokens(
    safe: Color(0xFF4CC27A),
    review: Color(0xFFF0A04B),
    protected: Color(0xFF98989F),
    danger: Color(0xFFF2716A),
    aiSurface: Color(0xFF16263D),
    aiOnSurface: Color(0xFFB9D3F7),
    sidebar: Color(0xFF232325),
    toolbar: Color(0xFF2A2A2C),
    divider: Color(0xFF3A3A3C),
    selectedRow: Color(0xFF1F3A5F),
    subtleSurface: Color(0xFF2C2C2E),
  );

  static AppTokens of(BuildContext context) =>
      Theme.of(context).extension<AppTokens>() ?? light;

  @override
  AppTokens copyWith({
    Color? safe,
    Color? review,
    Color? protected,
    Color? danger,
    Color? aiSurface,
    Color? aiOnSurface,
    Color? sidebar,
    Color? toolbar,
    Color? divider,
    Color? selectedRow,
    Color? subtleSurface,
  }) => AppTokens(
    safe: safe ?? this.safe,
    review: review ?? this.review,
    protected: protected ?? this.protected,
    danger: danger ?? this.danger,
    aiSurface: aiSurface ?? this.aiSurface,
    aiOnSurface: aiOnSurface ?? this.aiOnSurface,
    sidebar: sidebar ?? this.sidebar,
    toolbar: toolbar ?? this.toolbar,
    divider: divider ?? this.divider,
    selectedRow: selectedRow ?? this.selectedRow,
    subtleSurface: subtleSurface ?? this.subtleSurface,
  );

  @override
  AppTokens lerp(AppTokens? other, double t) {
    if (other == null) return this;
    return AppTokens(
      safe: Color.lerp(safe, other.safe, t)!,
      review: Color.lerp(review, other.review, t)!,
      protected: Color.lerp(protected, other.protected, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      aiSurface: Color.lerp(aiSurface, other.aiSurface, t)!,
      aiOnSurface: Color.lerp(aiOnSurface, other.aiOnSurface, t)!,
      sidebar: Color.lerp(sidebar, other.sidebar, t)!,
      toolbar: Color.lerp(toolbar, other.toolbar, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      selectedRow: Color.lerp(selectedRow, other.selectedRow, t)!,
      subtleSurface: Color.lerp(subtleSurface, other.subtleSurface, t)!,
    );
  }
}

/// Spacing / radius / size scale. Use these instead of literal numbers.
abstract final class AppSpace {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

abstract final class AppRadius {
  static const double sm = 6;
  static const double md = 10;
  static const double lg = 14;
  static const double xl = 18;
}

/// Fixed pane widths from the macOS design; clamped by the layout at runtime.
abstract final class AppPane {
  static const double sidebar = 224;
  static const double sidebarMin = 180;
  static const double sidebarMax = 320;
  static const double list = 360;
  static const double listLarge = 400;
  static const double listMin = 280;
  static const double listMax = 480;
  static const double readingMaxWidth = 760;
  static const double toolbarHeight = 52;
  static const double dialogWidth = 680;
  static const double settingsWidth = 720;
}

/// Brand colors of mail providers, tags and categories. Keyed lookups so data
/// (DB rows) refer to a key, never a hex value.
abstract final class AppPalette {
  static const accent = Color(0xFF0A66D6);
  static const gmail = Color(0xFFC5221F);
  static const outlook = Color(0xFF0A66D6);
  static const icloud = Color(0xFF4B49C8);
  static const imap = Color(0xFF3A3A3C);
  static const demo = Color(0xFF0F766E);

  static const tagColors = <String, Color>{
    'navy': Color(0xFF1E3A8A),
    'purple': Color(0xFF6D28D9),
    'teal': Color(0xFF0F766E),
    'orange': Color(0xFFC2410C),
    'cyan': Color(0xFF0E7490),
    'green': Color(0xFF15803D),
    'blue': Color(0xFF1D4ED8),
    'pink': Color(0xFFBE185D),
    'gray': Color(0xFF52525B),
  };

  static Color tag(String key) => tagColors[key] ?? tagColors['gray']!;

  /// Deterministic avatar color for a sender, so it stays stable across runs.
  static Color avatarFor(String seed) {
    final colors = tagColors.values.toList();
    final hash = seed.codeUnits.fold<int>(
      0,
      (a, c) => (a * 31 + c) & 0x7fffffff,
    );
    return colors[hash % colors.length];
  }
}
