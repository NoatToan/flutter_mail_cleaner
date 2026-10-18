import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'credentials_store.g.dart';

/// Secrets never go through `AppSettings`/drift — only the Keychain
/// (Keystore on Android). One entry per account: password/app-specific
/// password, or OAuth2 refresh+access tokens (JSON-encoded by the caller).
class CredentialsStore {
  CredentialsStore()
    : _storage = FlutterSecureStorage(
        mOptions: defaultTargetPlatform == TargetPlatform.macOS && !kIsWeb
            // Unsigned dev builds fail with -34018 unless this is off
            // (see TECH_SPEC / codebase-map): falls back to the legacy
            // Keychain instead of requiring Keychain Sharing entitlements.
            ? const MacOsOptions(usesDataProtectionKeychain: false)
            : const MacOsOptions(),
      );

  final FlutterSecureStorage _storage;

  String _passwordKey(String accountId) => 'account.$accountId.password';
  String _oauthKey(String accountId) => 'account.$accountId.oauth';

  Future<void> savePassword(String accountId, String password) =>
      _storage.write(key: _passwordKey(accountId), value: password);

  Future<String?> readPassword(String accountId) =>
      _storage.read(key: _passwordKey(accountId));

  /// JSON string: `{"accessToken":..,"refreshToken":..,"accessExpiry":..}`.
  Future<void> saveOAuthTokens(String accountId, String json) =>
      _storage.write(key: _oauthKey(accountId), value: json);

  Future<String?> readOAuthTokens(String accountId) =>
      _storage.read(key: _oauthKey(accountId));

  static const _pendingOAuthKey = 'oauth.pending';

  /// Web OAuth in flight (PKCE verifier + state), JSON-encoded by the caller.
  /// Survives the full-page redirect to the provider and back.
  Future<void> savePendingOAuth(String json) =>
      _storage.write(key: _pendingOAuthKey, value: json);

  Future<String?> readPendingOAuth() => _storage.read(key: _pendingOAuthKey);

  Future<void> deletePendingOAuth() => _storage.delete(key: _pendingOAuthKey);

  Future<void> deleteAccount(String accountId) async {
    await _storage.delete(key: _passwordKey(accountId));
    await _storage.delete(key: _oauthKey(accountId));
  }
}

@Riverpod(keepAlive: true)
CredentialsStore credentialsStore(Ref ref) => CredentialsStore();
