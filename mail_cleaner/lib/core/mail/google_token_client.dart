import 'package:ai_smart_mail/core/config/google_oauth_config.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'google_token_client.g.dart';

/// `https://oauth2.googleapis.com/token` response (code exchange or refresh).
class GoogleTokenResponse {
  const GoogleTokenResponse({
    required this.accessToken,
    required this.expiresIn,
    this.refreshToken,
    this.idToken,
  });

  factory GoogleTokenResponse.fromJson(Map<String, dynamic> json) =>
      GoogleTokenResponse(
        accessToken: json['access_token'] as String,
        expiresIn: (json['expires_in'] as num?)?.toInt() ?? 3600,
        refreshToken: json['refresh_token'] as String?,
        idToken: json['id_token'] as String?,
      );

  final String accessToken;
  final int expiresIn;
  final String? refreshToken;
  final String? idToken;
}

/// A Google token-endpoint error response (`{"error": "...", "error_description": "..."}`).
class GoogleTokenException implements Exception {
  const GoogleTokenException(this.error, {this.description});
  final String error;
  final String? description;
  @override
  String toString() => description ?? error;
}

/// Thin wrapper over a shared [Dio] instance for Google's token endpoint —
/// authorization-code exchange and refresh-token grant both go through here
/// (house rule: never `Dio()` ad hoc per call site).
class GoogleTokenClient {
  GoogleTokenClient(
    this._dio, {
    required this.clientId,
    required this.clientSecret,
  });

  final Dio _dio;
  final String clientId;
  final String clientSecret;

  static const _tokenEndpoint = 'https://oauth2.googleapis.com/token';

  /// Authorization-code grant — PKCE `code_verifier` stands in for a client
  /// secret's usual role, but Google still requires the (non-confidential,
  /// for installed apps) `client_secret` on Desktop-app clients.
  Future<GoogleTokenResponse> exchangeCode({
    required String code,
    required String codeVerifier,
    required String redirectUri,
  }) => _post({
    'code': code,
    'client_id': clientId,
    'client_secret': clientSecret,
    'redirect_uri': redirectUri,
    'grant_type': 'authorization_code',
    'code_verifier': codeVerifier,
  });

  Future<GoogleTokenResponse> refresh(String refreshToken) => _post({
    'refresh_token': refreshToken,
    'client_id': clientId,
    'client_secret': clientSecret,
    'grant_type': 'refresh_token',
  });

  Future<GoogleTokenResponse> _post(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _tokenEndpoint,
        data: data,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      return GoogleTokenResponse.fromJson(response.data!);
    } on DioException catch (e) {
      final body = e.response?.data;
      if (body is Map && body['error'] != null) {
        throw GoogleTokenException(
          body['error'] as String,
          description: body['error_description'] as String?,
        );
      }
      throw GoogleTokenException('network_error', description: e.message);
    }
  }
}

@Riverpod(keepAlive: true)
Dio googleHttpClient(Ref ref) => Dio();

@Riverpod(keepAlive: true)
GoogleTokenClient googleTokenClient(Ref ref) => GoogleTokenClient(
  ref.watch(googleHttpClientProvider),
  clientId: GoogleOAuthConfig.clientId,
  clientSecret: GoogleOAuthConfig.clientSecret,
);
