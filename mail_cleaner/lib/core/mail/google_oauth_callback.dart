/// Outcome of parsing the loopback redirect's query string (RFC 8252 §7.3 —
/// never trust the response without checking `state` first).
sealed class GoogleCallbackResult {
  const GoogleCallbackResult();
}

class GoogleCallbackSuccess extends GoogleCallbackResult {
  const GoogleCallbackSuccess(this.code);
  final String code;
}

class GoogleCallbackError extends GoogleCallbackResult {
  const GoogleCallbackError(this.error, {this.errorDescription});
  final String error;
  final String? errorDescription;
}

/// `state` didn't match what this attempt generated — reject outright rather
/// than trusting a mismatched callback (could be a stray/forged request to
/// the loopback port).
class GoogleCallbackStateMismatch extends GoogleCallbackResult {
  const GoogleCallbackStateMismatch();
}

/// Parses one loopback HTTP callback request URI into a [GoogleCallbackResult].
/// Pure/synchronous so it's testable without a real HTTP server.
GoogleCallbackResult parseGoogleCallback(
  Uri requestUri, {
  required String expectedState,
}) {
  final params = requestUri.queryParameters;
  final state = params['state'];
  if (state == null || state != expectedState) {
    return const GoogleCallbackStateMismatch();
  }
  final error = params['error'];
  if (error != null && error.isNotEmpty) {
    return GoogleCallbackError(
      error,
      errorDescription: params['error_description'],
    );
  }
  final code = params['code'];
  if (code == null || code.isEmpty) {
    return const GoogleCallbackError('missing_code');
  }
  return GoogleCallbackSuccess(code);
}
