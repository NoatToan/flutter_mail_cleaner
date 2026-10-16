import 'package:ai_smart_mail/core/layout/window_size.dart';
import 'package:ai_smart_mail/core/theme/app_theme.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Shared chrome for Welcome/AddAccount/Scanning (design: a 680×540 dialog
/// card on macOS, full screen on compact). Keeps ~28pt clear at the top so
/// nothing sits under the macOS traffic lights.
class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({required this.child, this.onBack, super.key});

  final Widget child;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final size = WindowSize.of(context);
    final tokens = AppTokens.of(context);
    final topClear = AppTheme.isDesktop ? AppSpace.xl + AppSpace.sm : AppSpace.lg;

    final card = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: size.isCompact ? AppSpace.sm : topClear),
        if (onBack != null)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
              child: TextButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios_new, size: 14),
                label: Text('onboarding.back'.tr()),
              ),
            ),
          ),
        Expanded(child: child),
      ],
    );

    if (size.isCompact) {
      return Scaffold(body: SafeArea(child: card));
    }

    return Scaffold(
      backgroundColor: tokens.subtleSurface,
      body: Center(
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          clipBehavior: Clip.antiAlias,
          elevation: 12,
          child: SizedBox(
            width: AppPane.dialogWidth,
            height: 540,
            child: card,
          ),
        ),
      ),
    );
  }
}
