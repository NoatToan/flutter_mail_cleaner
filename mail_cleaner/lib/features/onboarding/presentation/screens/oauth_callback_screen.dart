import 'dart:async';

import 'package:ai_smart_mail/app/routes.dart';
import 'package:ai_smart_mail/core/sync/sync_providers.dart';
import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:ai_smart_mail/core/widgets/app_empty_state.dart';
import 'package:ai_smart_mail/features/onboarding/presentation/providers/add_account_providers.dart';
import 'package:ai_smart_mail/features/onboarding/presentation/widgets/onboarding_scaffold.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Web only: Google/Microsoft redirect back here (`?code=…&state=…`) after
/// consent. Finishes the sign-in, then continues to the scan (new account)
/// or Settings (re-authorised account).
class OAuthCallbackScreen extends ConsumerStatefulWidget {
  const OAuthCallbackScreen({required this.callback, super.key});

  final Uri callback;

  @override
  ConsumerState<OAuthCallbackScreen> createState() =>
      _OAuthCallbackScreenState();
}

class _OAuthCallbackScreenState extends ConsumerState<OAuthCallbackScreen> {
  @override
  void initState() {
    super.initState();
    // After the first frame: the controller is (re)built by `watch` in build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(
        ref
            .read(addAccountControllerProvider.notifier)
            .completeWebOAuth(widget.callback),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addAccountControllerProvider);
    ref.listen(addAccountControllerProvider, (prev, next) {
      if (next.createdAccountIds.isEmpty ||
          (prev?.createdAccountIds.isNotEmpty ?? false)) {
        return;
      }
      for (final id in next.createdAccountIds) {
        unawaited(ref.read(syncRunnerProvider.notifier).start(id));
      }
      context.go(next.reconnected ? AppRoutes.settings : AppRoutes.scanning);
    });

    final error = state.errorMessage;
    return OnboardingScaffold(
      child: Center(
        child: error == null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: AppSpace.md),
                  Text('onboarding.oauth_completing'.tr()),
                ],
              )
            : AppErrorState(
                message: '${'onboarding.oauth_failed_title'.tr()}\n$error',
                retryLabel: 'onboarding.oauth_back_to_add'.tr(),
                onRetry: () => context.go(AppRoutes.addAccount),
              ),
      ),
    );
  }
}
