import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Material 3 theme. All component styling lives here so feature widgets can
/// use stock Flutter widgets (ListTile, FilledButton, Card, Chip, Switch…)
/// without ad-hoc styling.
abstract final class AppTheme {
  static bool get isDesktop =>
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux;

  static ThemeData light() => _build(Brightness.light, AppTokens.light);
  static ThemeData dark() => _build(Brightness.dark, AppTokens.dark);

  static ThemeData _build(Brightness brightness, AppTokens tokens) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppPalette.accent,
          brightness: brightness,
        ).copyWith(
          primary: brightness == Brightness.light
              ? AppPalette.accent
              : const Color(0xFF5AA0F2),
          error: tokens.danger,
          surface: brightness == Brightness.light
              ? Colors.white
              : const Color(0xFF1C1C1E),
          outlineVariant: tokens.divider,
        );
    final desktop = isDesktop;
    final text = _textTheme(desktop, scheme.onSurface);
    final buttonHeight = desktop ? 36.0 : 50.0;
    final buttonRadius = BorderRadius.circular(desktop ? AppRadius.md - 1 : AppRadius.lg);
    final buttonShape = RoundedRectangleBorder(borderRadius: buttonRadius);
    final buttonText = text.labelLarge?.copyWith(height: 1.2, fontWeight: FontWeight.w600);
    final buttonPadding = EdgeInsets.symmetric(horizontal: desktop ? AppSpace.lg : AppSpace.xl);
    Color overlay(Set<WidgetState> s, Color base) => s.contains(WidgetState.pressed)
        ? base.withValues(alpha: 0.16)
        : s.contains(WidgetState.hovered)
        ? base.withValues(alpha: 0.08)
        : Colors.transparent;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      textTheme: text,
      visualDensity: desktop ? VisualDensity.compact : VisualDensity.standard,
      materialTapTargetSize: desktop
          ? MaterialTapTargetSize.shrinkWrap
          : MaterialTapTargetSize.padded,
      scaffoldBackgroundColor: scheme.surface,
      dividerTheme: DividerThemeData(
        color: tokens.divider,
        thickness: 1,
        space: 1,
      ),
      extensions: [tokens],
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.toolbar,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: desktop ? AppPane.toolbarHeight : kToolbarHeight,
        titleTextStyle: text.titleMedium,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: scheme.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md + 2),
          side: BorderSide(color: tokens.divider),
        ),
      ),
      listTileTheme: ListTileThemeData(
        dense: desktop,
        contentPadding: EdgeInsets.symmetric(
          horizontal: desktop ? AppSpace.md : AppSpace.lg,
        ),
        selectedTileColor: tokens.selectedRow,
        selectedColor: scheme.onSurface,
        iconColor: scheme.primary,
        titleTextStyle: text.bodyLarge,
        subtitleTextStyle: text.bodySmall?.copyWith(color: tokens.protected),
        minVerticalPadding: desktop ? AppSpace.xs : AppSpace.sm,
        horizontalTitleGap: AppSpace.md,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(0, buttonHeight)),
          padding: WidgetStatePropertyAll(buttonPadding),
          shape: WidgetStatePropertyAll(buttonShape),
          textStyle: WidgetStatePropertyAll(buttonText),
          backgroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.disabled)
                ? scheme.onSurface.withValues(alpha: 0.12)
                : scheme.primary,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.disabled)
                ? scheme.onSurface.withValues(alpha: 0.38)
                : scheme.onPrimary,
          ),
          overlayColor: WidgetStateProperty.resolveWith((s) => overlay(s, Colors.white)),
          elevation: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.disabled)
                ? 0
                : s.contains(WidgetState.hovered)
                ? 4
                : 2,
          ),
          shadowColor: WidgetStatePropertyAll(scheme.primary.withValues(alpha: 0.45)),
          animationDuration: const Duration(milliseconds: 120),
        ),
      ),
      // Secondary actions: tinted (accent-on-accent-wash) instead of a hairline
      // border so they read as buttons next to the primary one.
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(0, buttonHeight)),
          padding: WidgetStatePropertyAll(buttonPadding),
          shape: WidgetStatePropertyAll(buttonShape),
          textStyle: WidgetStatePropertyAll(buttonText),
          backgroundColor: WidgetStatePropertyAll(scheme.primary.withValues(alpha: 0.09)),
          foregroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.disabled)
                ? scheme.onSurface.withValues(alpha: 0.38)
                : scheme.primary,
          ),
          side: WidgetStatePropertyAll(
            BorderSide(color: scheme.primary.withValues(alpha: 0.18)),
          ),
          overlayColor: WidgetStateProperty.resolveWith((s) => overlay(s, scheme.primary)),
          elevation: const WidgetStatePropertyAll(0),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: buttonText,
          minimumSize: Size(0, desktop ? 28 : 44),
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm),
          shape: buttonShape,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          iconSize: desktop ? 18 : 24,
          minimumSize: Size.square(desktop ? 28 : 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        side: BorderSide(color: tokens.divider),
        labelStyle: text.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.xs),
        showCheckmark: false,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          textStyle: text.labelMedium,
          visualDensity: VisualDensity.compact,
          selectedBackgroundColor: scheme.surface,
          backgroundColor: tokens.subtleSurface,
          side: BorderSide(color: tokens.divider),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: tokens.subtleSurface,
        isDense: desktop,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpace.md,
          vertical: AppSpace.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm + 1),
          borderSide: BorderSide.none,
        ),
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(tokens.subtleSurface),
        constraints: BoxConstraints(
          minHeight: desktop ? 28 : 40,
          maxWidth: 280,
        ),
        textStyle: WidgetStatePropertyAll(text.bodyMedium),
        hintStyle: WidgetStatePropertyAll(
          text.bodyMedium?.copyWith(color: tokens.protected),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm + 1),
          ),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: AppSpace.sm),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? const Color(0xFF1F9D55)
              : tokens.divider,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: const CircleBorder(),
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? scheme.primary
              : Colors.transparent,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        linearTrackColor: tokens.divider,
        linearMinHeight: 4,
        borderRadius: BorderRadius.circular(2),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: tokens.sidebar,
        indicatorColor: scheme.primary.withValues(alpha: 0.14),
        labelType: NavigationRailLabelType.all,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: tokens.toolbar,
        indicatorColor: scheme.primary.withValues(alpha: 0.14),
        labelTextStyle: WidgetStatePropertyAll(text.labelSmall),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        backgroundColor: scheme.surface,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      tooltipTheme: const TooltipThemeData(
        waitDuration: Duration(milliseconds: 500),
      ),
    );
  }

  /// macOS uses the 13pt desktop scale; touch devices (incl. mobile web)
  /// use a 15pt body — Gmail/Apple Mail list density. The full iOS 17pt
  /// scale made dense rows (mail list, pills, tabs) overflow on phones.
  static TextTheme _textTheme(bool desktop, Color color) {
    final s = desktop ? 1.0 : 15 / 13;
    TextStyle t(double size, FontWeight w, [double? height]) => TextStyle(
      fontSize: size * s,
      fontWeight: w,
      height: height,
      color: color,
      letterSpacing: 0,
      // Center glyphs (incl. Vietnamese diacritics) inside the line box so
      // button/chip labels sit optically centered.
      leadingDistribution: TextLeadingDistribution.even,
    );
    return TextTheme(
      displaySmall: t(36, FontWeight.w800, 1.1),
      headlineMedium: t(24, FontWeight.w700, 1.2),
      headlineSmall: t(19, FontWeight.w700, 1.25),
      titleLarge: t(17, FontWeight.w700),
      titleMedium: t(15, FontWeight.w600),
      titleSmall: t(13, FontWeight.w600),
      bodyLarge: t(13, FontWeight.w400, 1.4),
      bodyMedium: t(12.5, FontWeight.w400, 1.4),
      bodySmall: t(11.5, FontWeight.w400, 1.35),
      labelLarge: t(13, FontWeight.w600),
      labelMedium: t(11.5, FontWeight.w600),
      labelSmall: t(10.5, FontWeight.w600),
    );
  }
}
