import 'dart:convert';

import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/demo_mail_provider.dart';
import 'package:ai_smart_mail/core/mail/gmail_api_mail_provider.dart';
import 'package:ai_smart_mail/core/mail/google_token_refresher.dart';
import 'package:ai_smart_mail/core/mail/graph_mail_provider.dart';
import 'package:ai_smart_mail/core/mail/imap_mail_provider.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';
import 'package:ai_smart_mail/core/mail/oauth_tokens.dart';
import 'package:ai_smart_mail/core/mail/remote_id_store.dart';
import 'package:ai_smart_mail/core/mail/rest_mail_http.dart';
import 'package:ai_smart_mail/core/mail/web_oauth_token_refresher.dart';
import 'package:ai_smart_mail/core/storage/credentials_store.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mail_provider_factory.g.dart';

/// Builds the right [MailProvider] for an account (TECH_SPEC §2: one adapter
/// per account). `authKind == none` (or `provider == demo`) always resolves
/// to [DemoMailProvider] so "Dùng thử với hộp thư mẫu" runs through the same
/// sync/classify pipeline as a real account.
class MailProviderFactory {
  MailProviderFactory(
    this._credentials,
    this._googleTokenRefresher, {
    this._webTokenRefresher,
    this._remoteIds,
    Dio? dio,
  }) : _dio = dio ?? Dio();

  final CredentialsStore _credentials;
  final GoogleTokenRefresher _googleTokenRefresher;
  final WebOAuthTokenRefresher? _webTokenRefresher;
  final RemoteIdStore? _remoteIds;
  final Dio _dio;

  /// Demo "servers" live only in memory, so the same instance must be reused
  /// across sync + action-executor calls for an account — otherwise every
  /// call would regenerate a fresh mailbox and silently undo prior moves.
  final Map<String, DemoMailProvider> _demoCache = {};

  Future<MailProvider> create(AccountRow account) async {
    if (account.provider == MailProviderType.demo ||
        account.authKind == AuthKind.none) {
      return _demoCache.putIfAbsent(
        account.id,
        () => DemoMailProvider(
          accountId: account.id,
          providerType: account.provider,
          selfEmail: account.email,
        ),
      );
    }

    final isGmail = account.provider == MailProviderType.gmail;

    if (account.authKind == AuthKind.oauthApi) {
      return await _createRest(account);
    }

    if (account.authKind == AuthKind.oauth) {
      final raw = await _credentials.readOAuthTokens(account.id);
      if (raw == null) {
        throw const MailFailure.authentication(
          'Thiếu thông tin đăng nhập, vui lòng kết nối lại tài khoản.',
        );
      }
      var tokens = OAuthTokens.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      if (isGmail) {
        // Refreshes (and persists) a new access token when this one is
        // within 5 min of expiring; throws + marks the account `error` on
        // `invalid_grant` so Settings › Tài khoản can offer "Đăng nhập lại".
        tokens = await _googleTokenRefresher.ensureFreshTokens(
          account.id,
          tokens,
        );
      } else if (tokens.isExpired) {
        // Outlook: no refresh-token exchange yet — an expired access token
        // surfaces as an auth failure asking the user to reconnect.
        throw const MailFailure.authentication(
          'Phiên đăng nhập đã hết hạn, vui lòng kết nối lại tài khoản.',
        );
      }
      return ImapMailProvider(
        host: account.imapHost,
        port: account.imapPort,
        email: account.email,
        oauthAccessToken: tokens.accessToken,
        isGmail: isGmail,
      );
    }

    final password = await _credentials.readPassword(account.id);
    if (password == null) {
      throw const MailFailure.authentication(
        'Thiếu mật khẩu, vui lòng kết nối lại tài khoản.',
      );
    }
    return ImapMailProvider(
      host: account.imapHost,
      port: account.imapPort,
      email: account.email,
      password: password,
      isGmail: isGmail,
    );
  }

  /// Gmail API / Microsoft Graph account (connected from the web build).
  Future<MailProvider> _createRest(AccountRow account) async {
    final raw = await _credentials.readOAuthTokens(account.id);
    final refresher = _webTokenRefresher;
    final ids = _remoteIds;
    if (raw == null || refresher == null || ids == null) {
      throw const MailFailure.authentication(
        'Thiếu thông tin đăng nhập, vui lòng kết nối lại tài khoản.',
      );
    }
    final tokens = await refresher.ensureFreshTokens(
      account,
      OAuthTokens.fromJson(jsonDecode(raw) as Map<String, dynamic>),
    );
    return switch (account.provider) {
      MailProviderType.gmail => GmailApiMailProvider(
        accountId: account.id,
        http: RestMailHttp(_dio, accessToken: tokens.accessToken),
        ids: ids,
      ),
      MailProviderType.outlook => GraphMailProvider(
        accountId: account.id,
        http: RestMailHttp(
          _dio,
          accessToken: tokens.accessToken,
          extraHeaders: GraphMailProvider.preferImmutableIds,
        ),
        ids: ids,
      ),
      _ => throw const MailFailure.unsupported(
        'Nhà cung cấp này chưa hỗ trợ kết nối qua API.',
      ),
    };
  }
}

@Riverpod(keepAlive: true)
MailProviderFactory mailProviderFactory(Ref ref) => MailProviderFactory(
  ref.watch(credentialsStoreProvider),
  ref.watch(googleTokenRefresherProvider),
  webTokenRefresher: ref.watch(webOAuthTokenRefresherProvider),
  remoteIds: ref.watch(remoteIdStoreProvider),
);
