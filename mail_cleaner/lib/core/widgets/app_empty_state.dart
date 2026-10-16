import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';

/// Hard rule §5: a section with no data keeps its header and shows a visible
/// empty state instead of vanishing. Wrap the section body with this.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.isEmpty,
    required this.title,
    required this.child,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
    super.key,
  });

  final bool isEmpty;
  final String title;
  final String? message;
  final IconData icon;
  final Widget? action;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!isEmpty) return child;
    final theme = Theme.of(context);
    final tokens = AppTokens.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 36, color: tokens.protected),
            const SizedBox(height: AppSpace.md),
            Text(
              title,
              style: theme.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: AppSpace.xs),
              Text(
                message!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: tokens.protected,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: AppSpace.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Error counterpart for AsyncValue.error branches, with retry.
class AppErrorState extends StatelessWidget {
  const AppErrorState({
    required this.message,
    this.onRetry,
    this.retryLabel,
    super.key,
  });

  final String message;
  final VoidCallback? onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 32, color: tokens.danger),
            const SizedBox(height: AppSpace.sm),
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpace.md),
              OutlinedButton(
                onPressed: onRetry,
                child: Text(retryLabel ?? 'Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
