import 'dart:async';
import 'dart:io';

/// Thrown when [GoogleLoopbackServer.close] is called before a callback
/// arrived (the user pressed "Huỷ").
class GoogleOAuthCancelledException implements Exception {
  const GoogleOAuthCancelledException();
}

/// RFC 8252 §7.3 loopback redirect listener: binds an ephemeral port on
/// `127.0.0.1`, accepts exactly one GET callback, serves a small Vietnamese
/// confirmation page, then stops. One instance per sign-in attempt.
class GoogleLoopbackServer {
  HttpServer? _server;
  final _callback = Completer<Uri>();

  /// Binds the server and returns the port it's listening on.
  Future<int> start() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _server = server;
    unawaited(_listen(server));
    return server.port;
  }

  Future<void> _listen(HttpServer server) async {
    await for (final request in server) {
      if (_callback.isCompleted) {
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
        continue;
      }
      final uri = request.requestedUri;
      final success =
          uri.queryParameters['error'] == null &&
          uri.queryParameters.containsKey('code');
      request.response
        ..statusCode = HttpStatus.ok
        ..headers.contentType = ContentType.html
        ..write(_pageHtml(success: success));
      await request.response.close();
      _callback.complete(uri);
      break;
    }
  }

  /// Resolves with the callback's full URI, or throws [TimeoutException] /
  /// [GoogleOAuthCancelledException].
  Future<Uri> waitForCallback({required Duration timeout}) =>
      _callback.future.timeout(timeout);

  /// Stops listening. Safe to call more than once. If no callback arrived
  /// yet, [waitForCallback] rejects with [GoogleOAuthCancelledException].
  Future<void> close() async {
    if (!_callback.isCompleted) {
      _callback.completeError(const GoogleOAuthCancelledException());
    }
    await _server?.close(force: true);
  }

  String _pageHtml({required bool success}) => '''
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="utf-8">
<title>AI Smart Mail</title>
<style>
body{font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;display:flex;
align-items:center;justify-content:center;height:100vh;margin:0;background:#f5f5f7;color:#1b1b1f}
.card{text-align:center;padding:32px 40px;border-radius:16px;background:#fff;
box-shadow:0 4px 24px rgba(0,0,0,.08);max-width:360px}
h1{font-size:18px;margin:0 0 8px}
p{font-size:14px;color:#55565c;margin:0}
</style>
</head>
<body>
<div class="card">
<h1>${success ? 'Đã kết nối — quay lại AI Smart Mail' : 'Đăng nhập không thành công'}</h1>
<p>${success ? 'Bạn có thể đóng tab này và quay lại ứng dụng.' : 'Vui lòng quay lại ứng dụng và thử lại.'}</p>
</div>
</body>
</html>
''';
}
