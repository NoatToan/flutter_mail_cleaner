import 'dart:convert';

import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/bridge_mail_provider.dart';
import 'package:ai_smart_mail/core/mail/demo_mail_provider.dart';
import 'package:ai_smart_mail/core/mail/google_token_refresher.dart';
import 'package:ai_smart_mail/core/mail/imap_mail_provider.dart';
import 'package:ai_smart_mail/core/mail/mail_bridge_client.dart';
import 'package:ai_smart_mail/core/mail/mail_credentials.dart';
import 'package:ai_smart_mail/core/mail/mail_endpoints.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';
import 'package:ai_smart_mail/core/mail/oauth_tokens.dart';
import 'package:ai_smart_mail/core/mail/web_oauth_token_refresher.dart';
import 'package:ai_smart_mail/core/storage/credentials_store.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mail_provider_factory.g.dart';

/// Builds the right [MailProvider] for an account (TECH_SPEC §2: one adapter
/// per account). `authKind == none` (or `provider == demo`) always resolves
/// to [DemoMailProvider] so "Dùng thử với hộp thư mẫu" runs through the same
/// sync/classify pipeline as a real account.
///
/// Every real account speaks IMAP (and SMTP, see `MailSender`): directly on
/// desktop/mobile, through the `/api/mail` bridge on the web, where browsers
/// can't open the sockets themselves.
class MailProviderFactory {
  MailProviderFactory(
    this._credentials,
    this._googleTokenRefresher, {
    this._webTokenRefresher,
    this._bridge,
    bool? useBridge,
  }) : _useBridge = useBridge ?? kIsWeb;

  final CredentialsStore _credentials;
  final GoogleTokenRefresher _googleTokenRefresher;
  final WebOAuthTokenRefresher? _webTokenRefresher;
  final MailBridgeClient? _bridge;
  final bool _useBridge;

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

    return connectionFor(
      host: imapHostFor(account),
      port: account.imapPort,
      email: account.email,
      credentials: await credentialsFor(account),
      isGmail: account.provider == MailProviderType.gmail,
    );
  }

  /// An IMAP connection for explicit login details — also used to check a
  /// login before the account is saved (UC-02). Direct IMAP on
  /// desktop/mobile, the `/api/mail` bridge on the web.
  MailProvider connectionFor({
    required String host,
    required int port,
    required String email,
    required MailCredentials credentials,
    bool isGmail = false,
  }) {
    if (_useBridge) {
      final bridge = _bridge;
      if (bridge == null) {
        throw const MailFailure.unsupported('Thiếu máy chủ trung gian IMAP.');
      }
      return BridgeMailProvider(
        client: bridge,
        account: BridgeAccount(
          host: host,
          port: port,
          user: email,
          credentials: credentials,
        ),
      );
    }
    return ImapMailProvider(
      host: host,
      port: port,
      email: email,
      password: credentials.password,
      oauthAccessToken: credentials.accessToken,
      isGmail: isGmail,
    );
  }

  /// The login for IMAP and SMTP: the stored (app) password, or an OAuth
  /// access token refreshed first when it is about to expire. Throws
  /// [MailFailure.authentication] when the user has to sign in again.
  Future<MailCredentials> credentialsFor(AccountRow account) async {
    if (account.authKind == AuthKind.password) {
      final password = await _credentials.readPassword(account.id);
      if (password == null) {
        throw const MailFailure.authentication(
          'Thiếu mật khẩu, vui lòng kết nối lại tài khoản.',
        );
      }
      return MailCredentials.password(password);
    }

    final raw = await _credentials.readOAuthTokens(account.id);
    if (raw == null) {
      throw const MailFailure.authentication(
        'Thiếu thông tin đăng nhập, vui lòng kết nối lại tài khoản.',
      );
    }
    var tokens = OAuthTokens.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    final webRefresher = _webTokenRefresher;
    if (_useBridge && webRefresher != null) {
      // Web sign-in tokens refresh through this deployment's token proxy.
      tokens = await webRefresher.ensureFreshTokens(account, tokens);
    } else if (account.provider == MailProviderType.gmail) {
      // Refreshes (and persists) a new access token when this one is
      // within 5 min of expiring; throws + marks the account `error` on
      // `invalid_grant` so Settings › Tài khoản can offer "Đăng nhập lại".
      tokens = await _googleTokenRefresher.ensureFreshTokens(
        account.id,
        tokens,
      );
    } else if (tokens.isExpired) {
      // Desktop Outlook: no refresh-token exchange yet — an expired access
      // token surfaces as an auth failure asking the user to reconnect.
      throw const MailFailure.authentication(
        'Phiên đăng nhập đã hết hạn, vui lòng kết nối lại tài khoản.',
      );
    }
    return MailCredentials.oauth(tokens.accessToken);
  }
}

@Riverpod(keepAlive: true)
MailProviderFactory mailProviderFactory(Ref ref) => MailProviderFactory(
  ref.watch(credentialsStoreProvider),
  ref.watch(googleTokenRefresherProvider),
  webTokenRefresher: ref.watch(webOAuthTokenRefresherProvider),
  bridge: ref.watch(mailBridgeClientProvider),
);
