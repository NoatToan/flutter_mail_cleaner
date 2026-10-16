import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/features/shell/data/sidebar_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sidebar_providers.g.dart';

@Riverpod(keepAlive: true)
SidebarRepository sidebarRepository(Ref ref) =>
    SidebarRepository(ref.watch(appDatabaseProvider));

@riverpod
Stream<List<SidebarAccount>> sidebarAccounts(Ref ref) =>
    ref.watch(sidebarRepositoryProvider).watchAccounts();

@riverpod
Stream<List<SidebarTag>> sidebarTags(Ref ref) =>
    ref.watch(sidebarRepositoryProvider).watchTags();

@Riverpod(keepAlive: true)
Stream<bool> hasAccounts(Ref ref) =>
    ref.watch(sidebarRepositoryProvider).watchHasAccounts();
