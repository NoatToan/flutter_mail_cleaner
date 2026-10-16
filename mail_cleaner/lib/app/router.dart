import 'package:ai_smart_mail/app/routes.dart';
import 'package:ai_smart_mail/features/ai_command/presentation/screens/ai_command_screen.dart';
import 'package:ai_smart_mail/features/catch_up/presentation/screens/catch_up_screen.dart';
import 'package:ai_smart_mail/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:ai_smart_mail/features/inbox/presentation/screens/inbox_screen.dart';
import 'package:ai_smart_mail/features/inbox/presentation/screens/mailboxes_screen.dart';
import 'package:ai_smart_mail/features/onboarding/presentation/screens/add_account_screen.dart';
import 'package:ai_smart_mail/features/onboarding/presentation/screens/scanning_screen.dart';
import 'package:ai_smart_mail/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:ai_smart_mail/features/senders/presentation/screens/sender_detail_screen.dart';
import 'package:ai_smart_mail/features/senders/presentation/screens/sender_review_screen.dart';
import 'package:ai_smart_mail/features/senders/presentation/screens/senders_screen.dart';
import 'package:ai_smart_mail/features/settings/presentation/screens/settings_screen.dart';
import 'package:ai_smart_mail/features/shell/presentation/providers/sidebar_providers.dart';
import 'package:ai_smart_mail/features/shell/presentation/screens/app_shell.dart';
import 'package:ai_smart_mail/features/smart_scan/presentation/screens/clean_done_screen.dart';
import 'package:ai_smart_mail/features/smart_scan/presentation/screens/scan_review_screen.dart';
import 'package:ai_smart_mail/features/tags/presentation/screens/tags_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

/// Developer launch option: `--dart-define=INITIAL_ROUTE=/dashboard`.
const _initialRoute = String.fromEnvironment('INITIAL_ROUTE', defaultValue: AppRoutes.inbox);

/// Route table only (rule: routing stays thin). Each slice owns its screens.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final hasAccounts = ValueNotifier<bool?>(null);
  ref
    ..listen(
      hasAccountsProvider,
      (_, next) => hasAccounts.value = next.value,
      fireImmediately: true,
    )
    ..onDispose(hasAccounts.dispose);

  final router = GoRouter(
    initialLocation: _initialRoute,
    refreshListenable: hasAccounts,
    redirect: (context, state) {
      final known = hasAccounts.value;
      if (known == null) return null;
      final onboarding =
          state.matchedLocation == AppRoutes.welcome ||
          state.matchedLocation.startsWith('/onboarding');
      if (!known && !onboarding) return AppRoutes.welcome;
      if (known && state.matchedLocation == AppRoutes.welcome) {
        return AppRoutes.inbox;
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', redirect: (_, _) => AppRoutes.inbox),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (_, _) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.addAccount,
        builder: (_, _) => const AddAccountScreen(),
      ),
      GoRoute(
        path: AppRoutes.scanning,
        builder: (_, _) => const ScanningScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.uri, child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (_, _) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.inbox,
            builder: (_, state) => InboxScreen(
              accountId: state.uri.queryParameters['account'],
              filter: state.uri.queryParameters['filter'],
              tagKey: state.uri.queryParameters['tag'],
            ),
            routes: [
              GoRoute(
                path: 'message/:id',
                builder: (_, state) => InboxScreen(
                  accountId: state.uri.queryParameters['account'],
                  filter: state.uri.queryParameters['filter'],
                  tagKey: state.uri.queryParameters['tag'],
                  selectedMessageId: int.tryParse(
                    state.pathParameters['id'] ?? '',
                  ),
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.mailboxes,
            builder: (_, _) => const MailboxesScreen(),
          ),
          GoRoute(
            path: AppRoutes.smartScan,
            builder: (_, _) => const ScanReviewScreen(),
            routes: [
              GoRoute(path: 'done', builder: (_, _) => const CleanDoneScreen()),
            ],
          ),
          GoRoute(
            path: AppRoutes.senders,
            builder: (_, _) => const SendersScreen(),
            routes: [
              GoRoute(
                path: 'review',
                builder: (_, _) => const SenderReviewScreen(),
              ),
              GoRoute(
                path: ':email',
                builder: (_, state) =>
                    SenderDetailScreen(email: state.pathParameters['email'] ?? ''),
              ),
            ],
          ),
          GoRoute(path: AppRoutes.tags, builder: (_, _) => const TagsScreen()),
          GoRoute(
            path: AppRoutes.catchUp,
            builder: (_, state) =>
                CatchUpScreen(senderEmail: state.uri.queryParameters['sender']),
          ),
          GoRoute(
            path: AppRoutes.aiCommand,
            builder: (_, _) => const AiCommandScreen(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (_, _) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
