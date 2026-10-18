import 'dart:convert';

import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';
import 'package:ai_smart_mail/core/mail/oauth_tokens.dart';
import 'package:ai_smart_mail/core/mail/web_oauth_client.dart';
import 'package:ai_smart_mail/core/storage/credentials_store.dart';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'web_oauth_token_refresher.g.dart';

/// Keeps a REST-transport account's (Gmail API / Graph) access token fresh,
/// through the deployment's `/api/oauth-token` proxy. Same contract as
/// `GoogleTokenRefresher`: refreshes within 5 minutes of expiry, single-flight
/// per account, and on `invalid_grant` marks the account `error` so Settings
/// › Tài khoản offers "Đăng nhập lại".
class WebOAuthTokenRefresher {
  WebOAuthTokenRefresher({
    required this._client,
    required this._credentials,
    required this._db,
  });

  final WebOAuthClient _client;
  final CredentialsStore _credentials;
  final AppDatabase _db;

  static const refreshBuffer = Duration(minutes: 5);

  final Map<String, Future<OAuthTokens>> _inFlight = {};

  Future<OAuthTokens> ensureFreshTokens(
    AccountRow account,
    OAuthTokens current,
  ) {
    if (!current.isExpiringWithin(refreshBuffer)) {
      return Future.value(current);
    }
    final existing = _inFlight[account.id];
    if (existing != null) return existing;
    final future = _refresh(account, current);
    _inFlight[account.id] = future;
    return future.whenComplete(() => _inFlight.remove(account.id));
  }

  Future<OAuthTokens> _refresh(AccountRow account, OAuthTokens current) async {
    final provider = WebOAuthProvider.of(account.provider);
    final refreshToken = current.refreshToken;
    if (provider == null || refreshToken == null || refreshToken.isEmpty) {
      const message = 'Phiên đăng nhập đã hết hạn, vui lòng đăng nhập lại.';
      await _markReauthRequired(account.id, message);
      throw const MailFailure.authentication(message);
    }
    try {
      final fresh = await _client.refresh(provider, refreshToken);
      final updated = OAuthTokens(
        accessToken: fresh.accessToken,
        // Google keeps the old refresh token; Microsoft rotates it.
        refreshToken: fresh.refreshToken ?? refreshToken,
        accessTokenExpiry: fresh.accessTokenExpiry,
      );
      await _credentials.saveOAuthTokens(
        account.id,
        jsonEncode(updated.toJson()),
      );
      return updated;
    } on WebOAuthException catch (e) {
      if (!e.isInvalidGrant) throw MailFailure.network(e.toString());
      const message =
          'Quyền truy cập hộp thư đã bị thu hồi hoặc hết hạn, vui lòng đăng nhập lại.';
      await _markReauthRequired(account.id, message);
      throw const MailFailure.authentication(message);
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
WebOAuthTokenRefresher webOAuthTokenRefresher(Ref ref) =>
    WebOAuthTokenRefresher(
      client: ref.watch(webOAuthClientProvider),
      credentials: ref.watch(credentialsStoreProvider),
      db: ref.watch(appDatabaseProvider),
    );
