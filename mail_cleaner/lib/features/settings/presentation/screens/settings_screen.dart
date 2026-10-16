import 'package:ai_smart_mail/core/layout/window_size.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/features/settings/presentation/widgets/accounts_tab.dart';
import 'package:ai_smart_mail/features/settings/presentation/widgets/ai_privacy_tab.dart';
import 'package:ai_smart_mail/features/settings/presentation/widgets/general_tab.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum _SettingsTab { aiPrivacy, accounts, general }

/// Settings (UC-21, UC-22): on expanded/large, a 720×620 centered
/// preferences panel with tabs (design: Settings.dc.html); on compact, one
/// scrollable grouped list with the same three sections stacked.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  _SettingsTab _tab = _SettingsTab.aiPrivacy;

  @override
  Widget build(BuildContext context) {
    final wide = !WindowSize.of(context).isCompact;
    if (wide) return _buildWide(context);
    return _buildCompact(context);
  }

  Widget _buildWide(BuildContext context) {
    final tokens = AppTokens.of(context);
    return ColoredBox(
      color: tokens.subtleSurface,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppPane.settingsWidth, maxHeight: 620),
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            elevation: 8,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpace.md),
                  child: Text(
                    'settings.title'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpace.sm),
                  child: _TabSelector(tab: _tab, onChanged: (t) => setState(() => _tab = t)),
                ),
                Divider(height: 1, color: tokens.divider),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpace.lg),
                    child: _tabContent(_tab),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompact(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('settings.title'.tr())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpace.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _GroupLabel('settings.tab_ai_privacy'.tr(), tokens),
            const AiPrivacyTab(),
            const SizedBox(height: AppSpace.xl),
            _GroupLabel('settings.tab_accounts'.tr(), tokens),
            const AccountsTab(),
            const SizedBox(height: AppSpace.xl),
            _GroupLabel('settings.tab_general'.tr(), tokens),
            const GeneralTab(),
          ],
        ),
      ),
    );
  }

  Widget _tabContent(_SettingsTab tab) => switch (tab) {
    _SettingsTab.aiPrivacy => const AiPrivacyTab(),
    _SettingsTab.accounts => const AccountsTab(),
    _SettingsTab.general => const GeneralTab(),
  };
}

class _TabSelector extends StatelessWidget {
  const _TabSelector({required this.tab, required this.onChanged});

  final _SettingsTab tab;
  final ValueChanged<_SettingsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _TabButton(
          icon: Icons.auto_awesome_outlined,
          label: 'settings.tab_ai_privacy'.tr(),
          selected: tab == _SettingsTab.aiPrivacy,
          onTap: () => onChanged(_SettingsTab.aiPrivacy),
        ),
        _TabButton(
          icon: Icons.mail_outline,
          label: 'settings.tab_accounts'.tr(),
          selected: tab == _SettingsTab.accounts,
          onTap: () => onChanged(_SettingsTab.accounts),
        ),
        _TabButton(
          icon: Icons.tune,
          label: 'settings.tab_general'.tr(),
          selected: tab == _SettingsTab.general,
          onTap: () => onChanged(_SettingsTab.general),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? Theme.of(context).colorScheme.primary
        : AppTokens.of(context).protected;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg, vertical: AppSpace.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: AppSpace.xxs),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.label, this.tokens);

  final String label;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpace.sm),
    child: Text(
      label,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: tokens.protected),
    ),
  );
}
