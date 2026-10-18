import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// A canned reply for [FakeHttpAdapter].
typedef FakeReply = ({int status, Object? body, Map<String, String> headers});

FakeReply reply(
  Object? body, {
  int status = 200,
  Map<String, String>? headers,
}) => (status: status, body: body, headers: headers ?? const {});

/// One request seen by [FakeHttpAdapter].
class RecordedRequest {
  RecordedRequest(this.method, this.uri, this.body, this.headers);
  final String method;
  final Uri uri;
  final Object? body;
  final Map<String, dynamic> headers;
}

/// In-memory HTTP for REST transport tests (no real network): routes are
/// matched on `METHOD path` (query ignored); unknown routes answer 404.
class FakeHttpAdapter implements HttpClientAdapter {
  final Map<String, FakeReply Function(RecordedRequest)> routes = {};
  final List<RecordedRequest> requests = [];

  void on(
    String method,
    String path,
    FakeReply Function(RecordedRequest) handler,
  ) => routes['$method $path'] = handler;

  List<RecordedRequest> sent(String method, String path) => [
    for (final r in requests)
      if (r.method == method && r.uri.path == path) r,
  ];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    Object? body;
    if (requestStream != null) {
      final bytes = await requestStream.expand((c) => c).toList();
      final text = utf8.decode(bytes);
      body = text.isEmpty ? null : jsonDecode(text);
    }
    final request = RecordedRequest(
      options.method,
      options.uri,
      body,
      options.headers,
    );
    requests.add(request);
    final handler = routes['${options.method} ${options.uri.path}'];
    final r =
        handler?.call(request) ?? reply({'error': 'not found'}, status: 404);
    return ResponseBody.fromString(
      jsonEncode(r.body ?? {}),
      r.status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
        for (final MapEntry(:key, :value) in r.headers.entries) key: [value],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio fakeDio(FakeHttpAdapter adapter) => Dio()..httpClientAdapter = adapter;
