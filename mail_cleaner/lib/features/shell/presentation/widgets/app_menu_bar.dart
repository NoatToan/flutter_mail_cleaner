import 'package:ai_smart_mail/app/router.dart';
import 'package:ai_smart_mail/app/routes.dart';
import 'package:ai_smart_mail/core/sync/sync_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _OpenSettingsIntent extends Intent {
  const _OpenSettingsIntent();
}

class _OpenCommandIntent extends Intent {
  const _OpenCommandIntent();
}

/// macOS menu bar (AI Smart Mail · File · Edit · View · Mail · Window ·
/// Help) + the global ⌘K / ⌘, shortcuts. A no-op passthrough on every other
/// platform — `PlatformMenuBar` only renders a real menu bar on macOS, but
/// building one elsewhere is still harmless; the early return just avoids
/// doing the work.
///
/// Navigates through [routerProvider] directly (`router.go(...)`) rather than
/// `context.go()` — the [child] this wraps sits *above* `MaterialApp.router`'s
/// own `Router` widget (see `app.dart`'s `builder`), so `GoRouter.of(context)`
/// wouldn't find it from here.
class AppMenuBar extends ConsumerWidget {
  const AppMenuBar({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (defaultTargetPlatform != TargetPlatform.macOS) return child;

    final router = ref.watch(routerProvider);

    return PlatformMenuBar(
      menus: [
        PlatformMenu(
          label: 'AI Smart Mail',
          menus: [
            const PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.about),
            PlatformMenuItem(
              label: 'shell.menu_settings'.tr(),
              shortcut: const SingleActivator(LogicalKeyboardKey.comma, meta: true),
              onSelected: () => router.go(AppRoutes.settings),
            ),
            const PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.hide,
            ),
            const PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.hideOtherApplications,
            ),
            const PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.showAllApplications,
            ),
            const PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.quit),
          ],
        ),
        PlatformMenu(
          label: 'shell.menu_file'.tr(),
          menus: [
            PlatformMenuItem(
              label: 'shell.menu_add_account'.tr(),
              onSelected: () => router.go(AppRoutes.addAccount),
            ),
            PlatformMenuItem(
              label: 'shell.menu_sync'.tr(),
              shortcut: const SingleActivator(LogicalKeyboardKey.keyR, meta: true),
              onSelected: () => ref.read(autoSyncProvider.notifier).syncAll(),
            ),
          ],
        ),
        // Flutter has no PlatformProvidedMenuItemType for Cut/Copy/Paste/
        // Undo/Redo (only macOS app-level items like About/Quit/Hide are
        // "provided" — see PlatformProvidedMenuItemType in widgets/menu.dart).
        // Standard text-editing shortcuts (⌘C/⌘V/⌘X/⌘Z/⌘A) already work
        // inside any Flutter text field without this menu — these items
        // exist only so the Edit menu looks/reads like a native macOS app;
        // wiring them to the actually-focused field is a follow-up.
        PlatformMenu(
          label: 'shell.menu_edit'.tr(),
          menus: [
            PlatformMenuItem(
              label: 'shell.menu_undo'.tr(),
              shortcut: const SingleActivator(LogicalKeyboardKey.keyZ, meta: true),
              onSelected: () {},
            ),
            PlatformMenuItem(
              label: 'shell.menu_redo'.tr(),
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyZ,
                meta: true,
                shift: true,
              ),
              onSelected: () {},
            ),
            PlatformMenuItem(
              label: 'shell.menu_cut'.tr(),
              shortcut: const SingleActivator(LogicalKeyboardKey.keyX, meta: true),
              onSelected: () {},
            ),
            PlatformMenuItem(
              label: 'shell.menu_copy'.tr(),
              shortcut: const SingleActivator(LogicalKeyboardKey.keyC, meta: true),
              onSelected: () {},
            ),
            PlatformMenuItem(
              label: 'shell.menu_paste'.tr(),
              shortcut: const SingleActivator(LogicalKeyboardKey.keyV, meta: true),
              onSelected: () {},
            ),
            PlatformMenuItem(
              label: 'shell.menu_select_all'.tr(),
              shortcut: const SingleActivator(LogicalKeyboardKey.keyA, meta: true),
              onSelected: () {},
            ),
          ],
        ),
        PlatformMenu(
          label: 'shell.menu_view'.tr(),
          menus: [
            PlatformMenuItem(
              label: 'shell.menu_dashboard'.tr(),
              shortcut: const SingleActivator(LogicalKeyboardKey.digit1, meta: true),
              onSelected: () => router.go(AppRoutes.dashboard),
            ),
            PlatformMenuItem(
              label: 'shell.menu_inbox'.tr(),
              shortcut: const SingleActivator(LogicalKeyboardKey.digit2, meta: true),
              onSelected: () => router.go(AppRoutes.inbox),
            ),
            PlatformMenuItem(
              label: 'shell.menu_senders'.tr(),
              shortcut: const SingleActivator(LogicalKeyboardKey.digit3, meta: true),
              onSelected: () => router.go(AppRoutes.senders),
            ),
            PlatformMenuItem(
              label: 'shell.menu_tags'.tr(),
              shortcut: const SingleActivator(LogicalKeyboardKey.digit4, meta: true),
              onSelected: () => router.go(AppRoutes.tags),
            ),
          ],
        ),
        PlatformMenu(
          label: 'shell.menu_mail'.tr(),
          menus: [
            PlatformMenuItem(
              label: 'shell.menu_ai_command'.tr(),
              shortcut: const SingleActivator(LogicalKeyboardKey.keyK, meta: true),
              onSelected: () => router.go(AppRoutes.aiCommand),
            ),
            PlatformMenuItem(
              label: 'shell.menu_smart_scan'.tr(),
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyS,
                meta: true,
                shift: true,
              ),
              onSelected: () => router.go(AppRoutes.smartScan),
            ),
          ],
        ),
        PlatformMenu(
          label: 'shell.menu_window'.tr(),
          menus: const [
            PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.minimizeWindow),
            PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.zoomWindow),
          ],
        ),
        PlatformMenu(
          label: 'shell.menu_help'.tr(),
          menus: [
            // Placeholder — no help/docs destination exists yet.
            PlatformMenuItem(label: 'shell.menu_help'.tr(), onSelected: () {}),
          ],
        ),
      ],
      child: Shortcuts(
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.comma, meta: true): _OpenSettingsIntent(),
          SingleActivator(LogicalKeyboardKey.keyK, meta: true): _OpenCommandIntent(),
        },
        child: Actions(
          actions: {
            _OpenSettingsIntent: CallbackAction<_OpenSettingsIntent>(
              onInvoke: (_) {
                router.go(AppRoutes.settings);
                return null;
              },
            ),
            _OpenCommandIntent: CallbackAction<_OpenCommandIntent>(
              onInvoke: (_) {
                router.go(AppRoutes.aiCommand);
                return null;
              },
            ),
          },
          child: child,
        ),
      ),
    );
  }
}
