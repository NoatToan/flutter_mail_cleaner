import 'dart:async';
import 'dart:math';

import 'package:ai_smart_mail/core/mail/mail_provider.dart';
import 'package:dio/dio.dart';

/// Shared HTTP plumbing for the REST mail transports (Gmail API, Microsoft
/// Graph): bearer auth, retry with backoff on 429/5xx (honouring
/// `Retry-After`), and mapping every failure onto [MailFailure] so the sync
/// engine and action executor handle them exactly like IMAP errors.
class RestMailHttp {
  RestMailHttp(
    this._dio, {
    required this.accessToken,
    this.extraHeaders = const {},
    this.maxAttempts = 4,
    Future<void> Function(Duration)? sleep,
  }) : _sleep = sleep ?? Future<void>.delayed;

  final Dio _dio;
  final String accessToken;
  final Map<String, String> extraHeaders;
  final int maxAttempts;
  final Future<void> Function(Duration) _sleep;

  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, dynamic>? query,
    Map<String, String> headers = const {},
  }) => _send('GET', url, query: query, headers: headers);

  Future<Map<String, dynamic>> post(
    String url, {
    Object? body,
    Map<String, String> headers = const {},
  }) => _send('POST', url, body: body, headers: headers);

  Future<Map<String, dynamic>> patch(String url, {Object? body}) =>
      _send('PATCH', url, body: body);

  Future<Map<String, dynamic>> _send(
    String method,
    String url, {
    Map<String, dynamic>? query,
    Object? body,
    Map<String, String> headers = const {},
  }) async {
    var attempt = 0;
    while (true) {
      attempt++;
      try {
        final response = await _dio.request<Object?>(
          url,
          data: body,
          queryParameters: query,
          options: Options(
            method: method,
            headers: {
              'Authorization': 'Bearer $accessToken',
              ...extraHeaders,
              ...headers,
            },
            contentType: body == null ? null : Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );
        final data = response.data;
        return data is Map<String, dynamic> ? data : const {};
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        final retryable =
            status == 429 ||
            (status != null && status >= 500) ||
            (status == null && _isTransport(e));
        if (retryable && attempt < maxAttempts) {
          await _sleep(_backoff(attempt, e.response));
          continue;
        }
        throw _toFailure(e);
      }
    }
  }

  bool _isTransport(DioException e) => switch (e.type) {
    DioExceptionType.connectionError ||
    DioExceptionType.connectionTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.sendTimeout => true,
    _ => false,
  };

  Duration _backoff(int attempt, Response<Object?>? response) {
    final retryAfter = int.tryParse(
      response?.headers.value('retry-after') ?? '',
    );
    if (retryAfter != null) return Duration(seconds: min(retryAfter, 30));
    return Duration(
      milliseconds: 400 * pow(2, attempt).toInt() + Random().nextInt(300),
    );
  }

  MailFailure _toFailure(DioException e) {
    final status = e.response?.statusCode;
    final message = _errorMessage(e.response?.data) ?? e.message ?? '$status';
    if (status == 401) return MailFailure.authentication(message);
    if (status == 403) {
      // Gmail/Graph answer 403 both for missing scopes and rate limits.
      return message.toLowerCase().contains('rate')
          ? MailFailure.network(message)
          : MailFailure.authentication(message);
    }
    if (status == 429) return MailFailure.network(message);
    if (status == null) return MailFailure.network(message);
    return MailFailure.server(message);
  }

  /// `{"error": {"message": ...}}` (Gmail and Graph both use this shape).
  String? _errorMessage(Object? body) {
    if (body is! Map) return null;
    final error = body['error'];
    if (error is Map && error['message'] is String) {
      return error['message'] as String;
    }
    return error is String ? error : null;
  }
}

/// Runs [task] for every item with at most [concurrency] in flight, keeping
/// the results in input order.
Future<List<R>> mapPooled<T, R>(
  List<T> items,
  Future<R> Function(T item) task, {
  int concurrency = 8,
}) async {
  final results = List<R?>.filled(items.length, null);
  var next = 0;
  Future<void> worker() async {
    while (next < items.length) {
      final index = next++;
      results[index] = await task(items[index]);
    }
  }

  await Future.wait([
    for (var i = 0; i < min(concurrency, items.length); i++) worker(),
  ]);
  return results.cast<R>();
}
