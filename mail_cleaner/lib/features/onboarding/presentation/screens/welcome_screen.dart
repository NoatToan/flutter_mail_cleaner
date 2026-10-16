import 'dart:async';

import 'package:ai_smart_mail/app/routes.dart';
import 'package:ai_smart_mail/core/sync/sync_providers.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/features/onboarding/presentation/providers/add_account_providers.dart';
import 'package:ai_smart_mail/features/onboarding/presentation/widgets/onboarding_scaffold.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// First onboarding screen (design: Welcome.dc.html). Explains the privacy
/// model, then routes to AddAccount or straight into the demo mailbox.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    final state = ref.watch(addAccountControllerProvider);

    ref.listen(addAccountControllerProvider, (prev, next) {
      if (next.createdAccountIds.isNotEmpty &&
          (prev == null || prev.createdAccountIds.isEmpty)) {
        for (final id in next.createdAccountIds) {
          unawaited(ref.read(syncRunnerProvider.notifier).start(id));
        }
        context.go(AppRoutes.scanning);
      }
    });

    return OnboardingScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpace.xxl,
          AppSpace.lg,
          AppSpace.xxl,
          AppSpace.xl,
        ),
        child: Column(
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [theme.colorScheme.primary, tokens.safe],
                ),
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: const Icon(
                Icons.mark_email_read_outlined,
                color: Colors.white,
                size: 44,
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            Text(
              'onboarding.welcome_title'.tr(),
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpace.sm),
            Text(
              'onboarding.welcome_subtitle'.tr(),
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpace.xl),
            _FeatureRow(
              icon: Icons.lock_outline,
              iconColor: theme.colorScheme.primary,
              title: 'onboarding.feature_local_title'.tr(),
              body: 'onboarding.feature_local_body'.tr(),
            ),
            const SizedBox(height: AppSpace.md),
            _FeatureRow(
              icon: Icons.shield_outlined,
              iconColor: tokens.safe,
              title: 'onboarding.feature_cloud_title'.tr(),
              body: 'onboarding.feature_cloud_body'.tr(),
            ),
            const SizedBox(height: AppSpace.md),
            _FeatureRow(
              icon: Icons.undo_rounded,
              iconColor: tokens.review,
              title: 'onboarding.feature_undo_title'.tr(),
              body: 'onboarding.feature_undo_body'.tr(),
            ),
            const SizedBox(height: AppSpace.xl),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.go(AppRoutes.addAccount),
                child: Text('onboarding.connect_cta'.tr()),
              ),
            ),
            const SizedBox(height: AppSpace.sm),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: state.isConnecting
                    ? null
                    : () => ref
                          .read(addAccountControllerProvider.notifier)
                          .createDemoAccounts(),
                icon: state.isConnecting
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.science_outlined, size: 16),
                label: Text('onboarding.try_demo_cta'.tr()),
              ),
            ),
            const SizedBox(height: AppSpace.sm),
            Text(
              'onboarding.terms_notice'.tr(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: tokens.protected,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.sm + 2),
          ),
          child: Icon(icon, size: 17, color: iconColor),
        ),
        const SizedBox(width: AppSpace.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleSmall),
              Text(body, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
