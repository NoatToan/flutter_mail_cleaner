import 'dart:convert';

import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/google_oauth_errors.dart';
import 'package:ai_smart_mail/core/mail/google_token_client.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';
import 'package:ai_smart_mail/core/mail/oauth_tokens.dart';
import 'package:ai_smart_mail/core/storage/credentials_store.dart';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'google_token_refresher.g.dart';

/// Keeps a Gmail OAuth account's access token fresh before every IMAP
/// connect (XOAUTH2 — TECH_SPEC §3). Refreshes when the token expires within
/// 5 minutes, and is single-flight per account so a concurrent sync run and
/// an action-executor connect for the same account don't both race Google's
/// token endpoint.
///
/// On `invalid_grant` (consent revoked, or the Google "Testing" verification
/// mode's 7-day refresh-token expiry — TECH_SPEC §1) the account is marked
/// `syncState=error` with a clear message; Settings › Tài khoản (and any
/// other error affordance) reads that back and offers "Đăng nhập lại", which
/// re-runs the Google sign-in flow (`GoogleOAuthFlow`) and replaces just the
/// stored tokens.
class GoogleTokenRefresher {
  GoogleTokenRefresher({
    required this._tokenClient,
    required this._credentials,
    required this._db,
  });

  final GoogleTokenClient _tokenClient;
  final CredentialsStore _credentials;
  final AppDatabase _db;

  static const refreshBuffer = Duration(minutes: 5);

  final Map<String, Future<OAuthTokens>> _inFlight = {};

  /// Returns tokens guaranteed valid for at least [refreshBuffer], refreshing
  /// and persisting first if [current] is already within that window.
  /// Throws [MailFailure.authentication] (after marking the account `error`)
  /// when the refresh token itself is no longer usable.
  Future<OAuthTokens> ensureFreshTokens(
    String accountId,
    OAuthTokens current,
  ) {
    if (!current.isExpiringWithin(refreshBuffer)) {
      return Future.value(current);
    }
    final existing = _inFlight[accountId];
    if (existing != null) return existing;
    final future = _refresh(accountId, current);
    _inFlight[accountId] = future;
    return future.whenComplete(() => _inFlight.remove(accountId));
  }

  Future<OAuthTokens> _refresh(String accountId, OAuthTokens current) async {
    final refreshToken = current.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      const message = 'Thiếu refresh token, vui lòng đăng nhập lại Google.';
      await _markReauthRequired(accountId, message);
      throw const MailFailure.authentication(message);
    }
    try {
      final response = await _tokenClient.refresh(refreshToken);
      final updated = OAuthTokens(
        accessToken: response.accessToken,
        // Google doesn't always return a new refresh token on refresh —
        // keep the current one when it doesn't.
        refreshToken: response.refreshToken ?? refreshToken,
        accessTokenExpiry: DateTime.now().add(
          Duration(seconds: response.expiresIn),
        ),
      );
      await _credentials.saveOAuthTokens(
        accountId,
        jsonEncode(updated.toJson()),
      );
      return updated;
    } on GoogleTokenException catch (e) {
      final message = googleOAuthErrorMessage(e.error);
      await _markReauthRequired(accountId, message);
      throw MailFailure.authentication(message);
    }
  }

  Future<void> _markReauthRequired(String accountId, String message) =>
      (_db.update(_db.accounts)..where((a) => a.id.equals(accountId))).write(
        AccountsCompanion(
          syncState: const Value(SyncState.error),
          lastError: Value(message),
        ),
      );
}

@Riverpod(keepAlive: true)
GoogleTokenRefresher googleTokenRefresher(Ref ref) => GoogleTokenRefresher(
  tokenClient: ref.watch(googleTokenClientProvider),
  credentials: ref.watch(credentialsStoreProvider),
  db: ref.watch(appDatabaseProvider),
);
