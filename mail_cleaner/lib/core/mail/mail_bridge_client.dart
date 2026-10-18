import 'package:ai_smart_mail/core/mail/mail_credentials.dart';
import 'package:ai_smart_mail/core/mail/mail_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mail_bridge_client.g.dart';

/// One mailbox as the bridge sees it: server + login.
class BridgeAccount {
  const BridgeAccount({
    required this.host,
    required this.port,
    required this.user,
    required this.credentials,
  });

  final String host;
  final int port;
  final String user;
  final MailCredentials credentials;

  Map<String, Object> toJson() => {
    'host': host,
    'port': port,
    'user': user,
    ...credentials.toJson(),
  };
}

/// Client for this deployment's `/api/mail` IMAP/SMTP bridge (the web
/// build's only mail transport — browsers can't open IMAP/SMTP sockets).
/// Every call is one IMAP or SMTP session on the server; failures come back
/// as the same [MailFailure] kinds the native IMAP provider throws.
class MailBridgeClient {
  MailBridgeClient(this._dio, {required this.origin});

  final Dio _dio;
  final Uri origin;

  Future<Map<String, dynamic>> call(
    String op,
    BridgeAccount account, [
    Map<String, Object?> params = const {},
  ]) async {
    try {
      final response = await _dio.postUri<Object?>(
        origin.replace(path: '/api/mail'),
        data: {'op': op, 'account': account.toJson(), ...params},
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
          receiveTimeout: const Duration(seconds: 70),
        ),
      );
      final data = response.data;
      return data is Map<String, dynamic> ? data : const {};
    } on DioException catch (e) {
      throw _toFailure(e);
    }
  }

  MailFailure _toFailure(DioException e) {
    final body = e.response?.data;
    final error = body is Map ? body['error'] : null;
    if (error is! Map) {
      return MailFailure.network(
        e.message ?? 'Không kết nối được máy chủ trung gian.',
      );
    }
    final message = error['message'] as String? ?? 'Lỗi máy chủ mail.';
    return switch (error['kind']) {
      'authentication' => MailFailure.authentication(message),
      'network' => MailFailure.network(message),
      'unsupported' => MailFailure.unsupported(message),
      _ => MailFailure.server(message),
    };
  }
}

@Riverpod(keepAlive: true)
MailBridgeClient mailBridgeClient(Ref ref) => MailBridgeClient(
  Dio(),
  origin: Uri.parse(kIsWeb ? Uri.base.origin : 'http://localhost'),
);
