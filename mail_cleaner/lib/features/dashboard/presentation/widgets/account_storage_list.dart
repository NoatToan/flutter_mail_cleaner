import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/core/widgets/account_badge.dart';
import 'package:ai_smart_mail/features/dashboard/data/dashboard_repository.dart';
import 'package:ai_smart_mail/features/dashboard/data/vi_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Per-account storage bars (design: `Main.dc.html`). Shows a real percentage
/// when the provider reports a quota; otherwise shows the estimated used
/// bytes with "ước tính" instead of fabricating a percentage against an
/// unknown total.
class AccountStorageList extends StatelessWidget {
  const AccountStorageList({required this.accounts, super.key});

  final List<AccountStorage> accounts;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < accounts.length; i++) ...[
            if (i > 0) const Divider(height: 1, indent: 50),
            _AccountStorageRow(storage: accounts[i]),
          ],
        ],
      ),
    );
  }
}

class _AccountStorageRow extends StatelessWidget {
  const _AccountStorageRow({required this.storage});

  final AccountStorage storage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    final ratio = storage.usedRatio;
    final barColor = ratio == null
        ? tokens.protected
        : ratio >= 0.85
        ? tokens.danger
        : ratio >= 0.6
        ? tokens.review
        : tokens.protected;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.lg,
        vertical: AppSpace.sm,
      ),
      child: Row(
        children: [
          AccountBadge(provider: storage.account.provider, size: 26),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      storage.account.email,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      ratio != null
                          ? formatPercent(ratio)
                          : 'dashboard.storage.estimated'.tr(
                              namedArgs: {'size': formatBytes(storage.usedBytes)},
                            ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: barColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpace.xs),
                if (ratio != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: 5,
                      backgroundColor: tokens.divider,
                      valueColor: AlwaysStoppedAnimation(barColor),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
