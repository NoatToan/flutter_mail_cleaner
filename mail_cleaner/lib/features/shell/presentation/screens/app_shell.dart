import 'package:ai_smart_mail/app/routes.dart';
import 'package:ai_smart_mail/core/layout/window_size.dart';
import 'package:ai_smart_mail/core/theme/app_theme.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/features/shell/presentation/widgets/app_sidebar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Adaptive navigation chrome (TECH_SPEC §2a):
/// expanded/large → source-list sidebar; medium → NavigationRail;
/// compact → bottom NavigationBar with the 5 iOS tabs.
class AppShell extends StatelessWidget {
  const AppShell({required this.location, required this.child, super.key});

  final Uri location;
  final Widget child;

  static const List<(String, IconData, String)> _tabs = [
    (AppRoutes.inbox, Icons.inbox_outlined, 'shell.tab_inbox'),
    (AppRoutes.dashboard, Icons.auto_awesome_outlined, 'shell.tab_cleanup'),
    (AppRoutes.senders, Icons.people_outline, 'shell.senders'),
    (AppRoutes.tags, Icons.sell_outlined, 'shell.tags'),
    (AppRoutes.settings, Icons.settings_outlined, 'shell.settings'),
  ];

  int get _tabIndex {
    final path = location.path;
    final i = _tabs.indexWhere((t) => path.startsWith(t.$1));
    if (i >= 0) return i;
    if (path.startsWith(AppRoutes.smartScan) ||
        path.startsWith(AppRoutes.catchUp)) {
      return 1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final size = WindowSize.of(context);
    final tokens = AppTokens.of(context);

    if (size.showsSidebar) {
      return Scaffold(
        body: Row(
          children: [
            SizedBox(
              width: size == WindowSize.large
                  ? AppPane.sidebar + 16
                  : AppPane.sidebar,
              child: AppSidebar(location: location),
            ),
            VerticalDivider(width: 1, color: tokens.divider),
            Expanded(child: child),
          ],
        ),
      );
    }

    final destinations = [
      for (final t in _tabs) (icon: Icon(t.$2), label: t.$3.tr()),
    ];

    if (size == WindowSize.medium) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              // Clears the macOS traffic lights.
              leading: SizedBox(height: AppTheme.isDesktop ? AppSpace.xl : 0),
              selectedIndex: _tabIndex,
              onDestinationSelected: (i) => context.go(_tabs[i].$1),
              destinations: [
                for (final d in destinations)
                  NavigationRailDestination(icon: d.icon, label: Text(d.label)),
              ],
            ),
            VerticalDivider(width: 1, color: tokens.divider),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(bottom: false, child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => context.go(_tabs[i].$1),
        destinations: [
          for (final d in destinations)
            NavigationDestination(icon: d.icon, label: d.label),
        ],
      ),
    );
  }
}
