import 'dart:async';
import 'dart:convert';

import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/google_oauth_flow.dart';
import 'package:ai_smart_mail/core/mail/google_token_client.dart';
import 'package:ai_smart_mail/core/storage/credentials_store.dart';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gmail_reauth_controller.g.dart';

class GmailReauthState {
  const GmailReauthState({
    this.accountId,
    this.isRunning = false,
    this.errorMessage,
  });

  /// Which account the current/last attempt was for — only one "Đăng nhập
  /// lại" flow runs at a time app-wide, so the UI uses this to show the
  /// spinner/error on the right account tile.
  final String? accountId;
  final bool isRunning;
  final String? errorMessage;

  GmailReauthState copyWith({
    String? accountId,
    bool? isRunning,
    String? errorMessage,
    bool clearError = false,
  }) => GmailReauthState(
    accountId: accountId ?? this.accountId,
    isRunning: isRunning ?? this.isRunning,
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
  );
}

/// "Đăng nhập lại" for a Gmail OAuth account whose tokens were revoked or
/// expired (Google invalid_grant — TECH_SPEC §1's Testing-mode 7-day refresh
/// token, or the user revoking access at myaccount.google.com). Re-runs
/// [GoogleOAuthFlow] for the SAME account id/email, replacing only its
/// stored tokens and clearing the error state — mail/sync data is kept.
///
/// Surfaced from Settings › Tài khoản; exposed here (core/mail, not
/// features/settings) so the sidebar/inbox error affordance can wire up the
/// same action without duplicating the flow.
@riverpod
class GmailReauthController extends _$GmailReauthController {
  GoogleOAuthFlow? _activeFlow;

  @override
  GmailReauthState build() => const GmailReauthState();

  Future<void> reauthorize({
    required String accountId,
    required String email,
  }) async {
    state = state.copyWith(
      accountId: accountId,
      isRunning: true,
      clearError: true,
    );
    final flow = GoogleOAuthFlow(tokenClient: ref.read(googleTokenClientProvider));
    _activeFlow = flow;
    try {
      final result = await flow.run(loginHint: email);
      if (result.email != email) {
        state = state.copyWith(
          isRunning: false,
          errorMessage:
              'Bạn vừa đăng nhập bằng ${result.email}, khác với tài khoản '
              '$email đang kết nối. Vui lòng chọn đúng tài khoản Google.',
        );
        return;
      }
      await ref
          .read(credentialsStoreProvider)
          .saveOAuthTokens(accountId, jsonEncode(result.tokens.toJson()));
      final db = ref.read(appDatabaseProvider);
      await (db.update(
        db.accounts,
      )..where((a) => a.id.equals(accountId))).write(
        const AccountsCompanion(
          syncState: Value(SyncState.idle),
          lastError: Value(null),
        ),
      );
      state = state.copyWith(isRunning: false);
    } on GoogleOAuthFailure catch (e) {
      state = state.copyWith(
        isRunning: false,
        errorMessage: e.cancelled ? null : e.message,
        clearError: e.cancelled,
      );
    } finally {
      _activeFlow = null;
    }
  }

  /// "Huỷ" while waiting on the browser.
  void cancel() => unawaited(_activeFlow?.cancel());
}
