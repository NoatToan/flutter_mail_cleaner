import 'dart:async';
import 'dart:convert';

import 'package:ai_smart_mail/core/config/google_oauth_config.dart';
import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/core/mail/demo_mail_provider.dart'
    show DemoMailProvider;
import 'package:ai_smart_mail/core/mail/google_oauth_flow.dart';
import 'package:ai_smart_mail/core/mail/google_token_client.dart';
import 'package:ai_smart_mail/core/mail/imap_mail_provider.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';
import 'package:ai_smart_mail/core/mail/oauth_tokens.dart';
import 'package:ai_smart_mail/core/mail/web_oauth_client.dart';
import 'package:ai_smart_mail/core/mail/web_oauth_flow.dart';
import 'package:ai_smart_mail/core/storage/credentials_store.dart';
import 'package:ai_smart_mail/features/onboarding/domain/login_error_hint.dart';
import 'package:drift/drift.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'add_account_providers.g.dart';

/// Provider tiles shown on the AddAccount screen (design order: Gmail,
/// Outlook, iCloud, generic IMAP).
enum AddAccountOption { gmail, outlook, icloud, imap }

/// Which connect path a pending/last error belongs to — Gmail offers two
/// (Google sign-in, and the "Cách khác" app-password fallback) at once.
enum ConnectAttempt { none, password, outlook, google }

/// Set at build time: `flutter run --dart-define=OUTLOOK_CLIENT_ID=...`.
/// Outlook OAuth stays visibly disabled (never faked) until this is set.
const _outlookClientId = String.fromEnvironment('OUTLOOK_CLIENT_ID');

bool get isOutlookOAuthConfigured => _outlookClientId.isNotEmpty;

/// Zero end-user setup (docs/OAUTH_GOOGLE.md): the developer bakes in
/// `GOOGLE_CLIENT_ID`/`GOOGLE_CLIENT_SECRET` at build time via
/// `--dart-define-from-file=config/oauth.json`. Same disabled-with-a-hint
/// pattern as [isOutlookOAuthConfigured] when it isn't set, rather than
/// crashing on the first tap.
bool get isGoogleOAuthConfigured => GoogleOAuthConfig.isConfigured;

const _outlookRedirectUri = 'com.aismartmail.app:/oauthredirect';
const _outlookScopes = [
  'openid',
  'offline_access',
  'https://outlook.office.com/IMAP.AccessAsUser.All',
  'https://outlook.office.com/SMTP.Send',
];
const _outlookServiceConfig = AuthorizationServiceConfiguration(
  authorizationEndpoint:
      'https://login.microsoftonline.com/consumers/oauth2/v2.0/authorize',
  tokenEndpoint:
      'https://login.microsoftonline.com/consumers/oauth2/v2.0/token',
);

class AddAccountState {
  const AddAccountState({
    this.selected,
    this.isConnecting = false,
    this.isWaitingGoogleBrowser = false,
    this.errorMessage,
    this.errorHintKey,
    this.lastAttempt = ConnectAttempt.none,
    this.createdAccountIds = const [],
    this.reconnected = false,
  });

  final AddAccountOption? selected;
  final bool isConnecting;

  /// True while the loopback server is waiting for the Google consent
  /// callback — shows "Đang chờ bạn xác nhận trong trình duyệt…" + Huỷ
  /// instead of the normal connecting spinner.
  final bool isWaitingGoogleBrowser;
  final String? errorMessage;
  final String? errorHintKey;
  final ConnectAttempt lastAttempt;
  final List<String> createdAccountIds;

  /// The web callback renewed an existing account's tokens instead of
  /// adding one (Settings › "Đăng nhập lại").
  final bool reconnected;

  AddAccountState copyWith({
    AddAccountOption? selected,
    bool? isConnecting,
    bool? isWaitingGoogleBrowser,
    String? errorMessage,
    String? errorHintKey,
    ConnectAttempt? lastAttempt,
    bool clearError = false,
    List<String>? createdAccountIds,
    bool? reconnected,
  }) => AddAccountState(
    selected: selected ?? this.selected,
    isConnecting: isConnecting ?? this.isConnecting,
    isWaitingGoogleBrowser:
        isWaitingGoogleBrowser ?? this.isWaitingGoogleBrowser,
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    errorHintKey: clearError ? null : (errorHintKey ?? this.errorHintKey),
    lastAttempt: lastAttempt ?? this.lastAttempt,
    createdAccountIds: createdAccountIds ?? this.createdAccountIds,
    reconnected: reconnected ?? this.reconnected,
  );
}

String defaultHostFor(AddAccountOption option) => switch (option) {
  AddAccountOption.gmail => 'imap.gmail.com',
  AddAccountOption.outlook => 'outlook.office365.com',
  AddAccountOption.icloud => 'imap.mail.me.com',
  AddAccountOption.imap => '',
};

MailProviderType _providerTypeOf(AddAccountOption option) => switch (option) {
  AddAccountOption.gmail => MailProviderType.gmail,
  AddAccountOption.outlook => MailProviderType.outlook,
  AddAccountOption.icloud => MailProviderType.icloud,
  AddAccountOption.imap => MailProviderType.imap,
};

@riverpod
class AddAccountController extends _$AddAccountController {
  static const _uuid = Uuid();

  @override
  AddAccountState build() => const AddAccountState();

  GoogleOAuthFlow? _activeGoogleFlow;

  void selectProvider(AddAccountOption option) => state = state.copyWith(
    selected: option,
    clearError: true,
    lastAttempt: ConnectAttempt.none,
  );

  /// Validates by actually logging in over IMAP before anything is saved
  /// (UC-02) — the server's own error text is surfaced to `state.errorMessage`.
  Future<void> connectWithPassword({
    required String email,
    required String password,
    String? host,
    int? port,
  }) async {
    final option = state.selected;
    if (option == null) return;
    state = state.copyWith(
      isConnecting: true,
      clearError: true,
      lastAttempt: ConnectAttempt.password,
    );

    final resolvedHost = (host == null || host.isEmpty)
        ? defaultHostFor(option)
        : host;
    final resolvedPort = port ?? 993;
    final provider = ImapMailProvider(
      host: resolvedHost,
      port: resolvedPort,
      email: email,
      password: password,
      isGmail: option == AddAccountOption.gmail,
    );
    try {
      await provider.connect();
      await provider.disconnect();
    } on MailFailure catch (e) {
      state = state.copyWith(
        isConnecting: false,
        errorMessage: e.message,
        errorHintKey: loginErrorHintKey(e.message, host: resolvedHost),
      );
      return;
    }

    final accountId = _uuid.v4();
    final db = ref.read(appDatabaseProvider);
    await db
        .into(db.accounts)
        .insert(
          AccountsCompanion.insert(
            id: accountId,
            provider: _providerTypeOf(option),
            authKind: AuthKind.password,
            email: email,
            imapHost: Value(resolvedHost),
            imapPort: Value(resolvedPort),
          ),
        );
    await ref.read(credentialsStoreProvider).savePassword(accountId, password);
    state = state.copyWith(isConnecting: false, createdAccountIds: [accountId]);
  }

  /// Outlook personal accounts require OAuth2 (TECH_SPEC §3). [email] is
  /// asked for up front because IMAP XOAUTH2 needs it alongside the access
  /// token, and flutter_appauth doesn't hand back the account's address.
  Future<void> connectOutlookOAuth({required String email}) async {
    if (!isOutlookOAuthConfigured) return;
    state = state.copyWith(
      isConnecting: true,
      clearError: true,
      lastAttempt: ConnectAttempt.outlook,
    );
    try {
      const appAuth = FlutterAppAuth();
      final result = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _outlookClientId,
          _outlookRedirectUri,
          serviceConfiguration: _outlookServiceConfig,
          scopes: _outlookScopes,
        ),
      );
      final accessToken = result.accessToken;
      if (accessToken == null) {
        state = state.copyWith(
          isConnecting: false,
          errorMessage: 'Không nhận được access token từ Microsoft.',
        );
        return;
      }

      final host = defaultHostFor(AddAccountOption.outlook);
      final provider = ImapMailProvider(
        host: host,
        port: 993,
        email: email,
        oauthAccessToken: accessToken,
      );
      try {
        await provider.connect();
        await provider.disconnect();
      } on MailFailure catch (e) {
        state = state.copyWith(
          isConnecting: false,
          errorMessage: e.message,
          errorHintKey: loginErrorHintKey(
            e.message,
            host: 'outlook.office365.com',
          ),
        );
        return;
      }

      final accountId = _uuid.v4();
      final db = ref.read(appDatabaseProvider);
      await db
          .into(db.accounts)
          .insert(
            AccountsCompanion.insert(
              id: accountId,
              provider: MailProviderType.outlook,
              authKind: AuthKind.oauth,
              email: email,
              imapHost: Value(host),
            ),
          );
      final tokens = OAuthTokens(
        accessToken: accessToken,
        refreshToken: result.refreshToken,
        accessTokenExpiry: result.accessTokenExpirationDateTime,
      );
      await ref
          .read(credentialsStoreProvider)
          .saveOAuthTokens(accountId, jsonEncode(tokens.toJson()));
      state = state.copyWith(
        isConnecting: false,
        createdAccountIds: [accountId],
      );
    } on Exception catch (e) {
      state = state.copyWith(isConnecting: false, errorMessage: e.toString());
    }
  }

  /// "Đăng nhập với Google" — RFC 8252 loopback + PKCE (see
  /// lib/core/mail/google_oauth_flow.dart). No email prompt up front: unlike
  /// Outlook, the account's address comes back from the `id_token` once the
  /// user picks it in the browser.
  Future<void> connectGoogleOAuth() async {
    state = state.copyWith(
      isWaitingGoogleBrowser: true,
      clearError: true,
      lastAttempt: ConnectAttempt.google,
    );
    final flow = GoogleOAuthFlow(
      tokenClient: ref.read(googleTokenClientProvider),
    );
    _activeGoogleFlow = flow;
    final GoogleOAuthSuccess result;
    try {
      result = await flow.run();
    } on GoogleOAuthFailure catch (e) {
      _activeGoogleFlow = null;
      state = e.cancelled
          ? state.copyWith(isWaitingGoogleBrowser: false, clearError: true)
          : state.copyWith(
              isWaitingGoogleBrowser: false,
              errorMessage: e.message,
            );
      return;
    }
    _activeGoogleFlow = null;

    state = state.copyWith(isWaitingGoogleBrowser: false, isConnecting: true);
    final host = defaultHostFor(AddAccountOption.gmail);
    final provider = ImapMailProvider(
      host: host,
      port: 993,
      email: result.email,
      oauthAccessToken: result.tokens.accessToken,
      isGmail: true,
    );
    try {
      await provider.connect();
      await provider.disconnect();
    } on MailFailure catch (e) {
      state = state.copyWith(
        isConnecting: false,
        errorMessage: e.message,
        errorHintKey: loginErrorHintKey(e.message, host: host),
      );
      return;
    }

    final accountId = _uuid.v4();
    final db = ref.read(appDatabaseProvider);
    await db
        .into(db.accounts)
        .insert(
          AccountsCompanion.insert(
            id: accountId,
            provider: MailProviderType.gmail,
            authKind: AuthKind.oauth,
            email: result.email,
            imapHost: Value(host),
          ),
        );
    await ref
        .read(credentialsStoreProvider)
        .saveOAuthTokens(accountId, jsonEncode(result.tokens.toJson()));
    state = state.copyWith(isConnecting: false, createdAccountIds: [accountId]);
  }

  /// Web: "Đăng nhập với Google/Microsoft" — leaves the app for the
  /// provider's consent page (full-page redirect). The page navigates away
  /// on success, so the spinner simply stays up until it does.
  Future<void> connectWithWebOAuth(WebOAuthProvider provider) async {
    state = state.copyWith(
      isConnecting: true,
      clearError: true,
      lastAttempt: provider == WebOAuthProvider.google
          ? ConnectAttempt.google
          : ConnectAttempt.outlook,
    );
    try {
      final config = await ref.read(webOAuthConfigProvider.future);
      await ref.read(webOAuthFlowProvider).start(provider, config);
    } on WebOAuthException catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(isConnecting: false, errorMessage: e.toString());
    }
  }

  /// `/onboarding/oauth-callback`: finishes a web sign-in started by
  /// [connectWithWebOAuth] or by Settings' "Đăng nhập lại". Signing in again
  /// with an already-connected mailbox renews its tokens instead of adding a
  /// duplicate account.
  Future<void> completeWebOAuth(Uri callback) async {
    state = state.copyWith(isConnecting: true, clearError: true);
    final WebOAuthResult result;
    try {
      result = await ref.read(webOAuthFlowProvider).complete(callback);
    } on WebOAuthException catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isConnecting: false,
        errorMessage: e.error == 'access_denied'
            ? 'Bạn đã huỷ đăng nhập.'
            : e.toString(),
      );
      return;
    } on MailFailure catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(isConnecting: false, errorMessage: e.message);
      return;
    }

    final db = ref.read(appDatabaseProvider);
    final type = result.provider.mailProvider;
    final reauthId = result.reauthAccountId;
    final existing =
        await (db.select(db.accounts)..where(
              (a) => reauthId != null
                  ? a.id.equals(reauthId)
                  : a.provider.equalsValue(type) &
                        a.authKind.equalsValue(AuthKind.oauthApi) &
                        a.email.equals(result.email),
            ))
            .getSingleOrNull();
    final accountId = existing?.id ?? _uuid.v4();
    // Tokens first: inserting the account flips `hasAccounts`, and sync may
    // start before this method returns.
    await ref
        .read(credentialsStoreProvider)
        .saveOAuthTokens(accountId, jsonEncode(result.tokens.toJson()));
    if (existing == null) {
      await db
          .into(db.accounts)
          .insert(
            AccountsCompanion.insert(
              id: accountId,
              provider: type,
              authKind: AuthKind.oauthApi,
              email: result.email,
            ),
          );
    } else {
      await (db.update(
        db.accounts,
      )..where((a) => a.id.equals(accountId))).write(
        const AccountsCompanion(
          syncState: Value(SyncState.idle),
          lastError: Value(null),
        ),
      );
    }
    if (!ref.mounted) return;
    state = state.copyWith(
      isConnecting: false,
      createdAccountIds: [accountId],
      reconnected: existing != null,
    );
  }

  /// "Huỷ" while waiting on the Google consent browser tab.
  void cancelGoogleOAuth() {
    unawaited(_activeGoogleFlow?.cancel());
  }

  /// "Dùng thử với hộp thư mẫu" — 3 demo accounts served by [DemoMailProvider]
  /// through the exact same sync pipeline (TECH_SPEC onboarding note).
  Future<void> createDemoAccounts() async {
    state = state.copyWith(isConnecting: true, clearError: true);
    final db = ref.read(appDatabaseProvider);
    const demos = [
      (
        'demo-gmail',
        MailProviderType.gmail,
        'toan.demo@gmail.com',
        'Toàn (mẫu Gmail)',
      ),
      (
        'demo-outlook',
        MailProviderType.outlook,
        'toan.demo@outlook.com',
        'Toàn (mẫu Outlook)',
      ),
      (
        'demo-icloud',
        MailProviderType.icloud,
        'toan.demo@icloud.com',
        'Toàn (mẫu iCloud)',
      ),
    ];
    final createdIds = <String>[];
    for (final (id, providerType, email, name) in demos) {
      final existing = await (db.select(
        db.accounts,
      )..where((a) => a.id.equals(id))).getSingleOrNull();
      if (existing == null) {
        await db
            .into(db.accounts)
            .insert(
              AccountsCompanion.insert(
                id: id,
                provider: providerType,
                authKind: AuthKind.none,
                email: email,
                displayName: Value(name),
              ),
            );
      }
      createdIds.add(id);
    }
    // The first insert flips `hasAccounts`, so the router may already have
    // left Welcome and disposed this controller (sync is started by
    // sync_providers for the new accounts either way).
    if (!ref.mounted) return;
    state = state.copyWith(isConnecting: false, createdAccountIds: createdIds);
  }
}
