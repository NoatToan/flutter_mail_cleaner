import 'package:ai_smart_mail/core/mail/google_token_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio;

void main() {
  setUpAll(() {
    registerFallbackValue(Options());
  });

  late MockDio dio;
  late GoogleTokenClient client;

  setUp(() {
    dio = MockDio();
    client = GoogleTokenClient(
      dio,
      clientId: 'client-123',
      clientSecret: 'secret-xyz',
    );
  });

  Response<Map<String, dynamic>> okResponse(Map<String, dynamic> data) =>
      Response(
        data: data,
        statusCode: 200,
        requestOptions: RequestOptions(path: 'https://oauth2.googleapis.com/token'),
      );

  group('exchangeCode', () {
    test('posts form-urlencoded data to the token endpoint and parses it', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          'https://oauth2.googleapis.com/token',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => okResponse({
          'access_token': 'access-1',
          'refresh_token': 'refresh-1',
          'id_token': 'id-1',
          'expires_in': 3600,
        }),
      );

      final result = await client.exchangeCode(
        code: 'auth-code',
        codeVerifier: 'verifier-1',
        redirectUri: 'http://127.0.0.1:1234',
      );

      expect(result.accessToken, 'access-1');
      expect(result.refreshToken, 'refresh-1');
      expect(result.idToken, 'id-1');
      expect(result.expiresIn, 3600);

      final captured = verify(
        () => dio.post<Map<String, dynamic>>(
          any(),
          data: captureAny(named: 'data'),
          options: any(named: 'options'),
        ),
      ).captured.single as Map<String, dynamic>;
      expect(captured['code'], 'auth-code');
      expect(captured['code_verifier'], 'verifier-1');
      expect(captured['client_id'], 'client-123');
      expect(captured['client_secret'], 'secret-xyz');
      expect(captured['grant_type'], 'authorization_code');
      expect(captured['redirect_uri'], 'http://127.0.0.1:1234');
    });

    test('maps a token-endpoint error body to GoogleTokenException', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: 'x'),
          response: Response(
            data: {'error': 'invalid_grant', 'error_description': 'expired'},
            statusCode: 400,
            requestOptions: RequestOptions(path: 'x'),
          ),
        ),
      );

      await expectLater(
        client.exchangeCode(
          code: 'c',
          codeVerifier: 'v',
          redirectUri: 'http://127.0.0.1:1',
        ),
        throwsA(
          isA<GoogleTokenException>()
              .having((e) => e.error, 'error', 'invalid_grant')
              .having((e) => e.description, 'description', 'expired'),
        ),
      );
    });

    test('a network failure with no response body maps to network_error', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(requestOptions: RequestOptions(path: 'x'), message: 'timeout'),
      );

      await expectLater(
        client.exchangeCode(
          code: 'c',
          codeVerifier: 'v',
          redirectUri: 'http://127.0.0.1:1',
        ),
        throwsA(
          isA<GoogleTokenException>().having((e) => e.error, 'error', 'network_error'),
        ),
      );
    });
  });

  group('refresh', () {
    test('posts the refresh_token grant', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => okResponse({'access_token': 'access-2', 'expires_in': 1800}),
      );

      final result = await client.refresh('refresh-token-1');

      expect(result.accessToken, 'access-2');
      expect(result.refreshToken, isNull);
      expect(result.expiresIn, 1800);

      final captured = verify(
        () => dio.post<Map<String, dynamic>>(
          any(),
          data: captureAny(named: 'data'),
          options: any(named: 'options'),
        ),
      ).captured.single as Map<String, dynamic>;
      expect(captured['grant_type'], 'refresh_token');
      expect(captured['refresh_token'], 'refresh-token-1');
    });
  });
}
