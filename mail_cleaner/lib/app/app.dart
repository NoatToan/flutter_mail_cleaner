import 'package:ai_smart_mail/app/router.dart';
import 'package:ai_smart_mail/core/platform/window_title_bar.dart';
import 'package:ai_smart_mail/core/sync/sync_providers.dart';
import 'package:ai_smart_mail/core/theme/app_theme.dart';
import 'package:ai_smart_mail/features/shell/presentation/widgets/app_menu_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiSmartMailApp extends ConsumerWidget {
  const AiSmartMailApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(autoSyncProvider);
    return MaterialApp.router(
      title: 'AI Smart Mail',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: ref.watch(routerProvider),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) => AppMenuBar(child: WindowTitleBar(child: child!)),
    );
  }
}
