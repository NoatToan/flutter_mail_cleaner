/// Maps a Google OAuth/token-endpoint error code to a Vietnamese message
/// that's safe to show directly to the end user.
String googleOAuthErrorMessage(String errorCode) => switch (errorCode) {
  'access_denied' => 'Bạn đã huỷ đăng nhập Google.',
  'missing_code' => 'Không nhận được mã xác thực từ Google.',
  'invalid_grant' =>
    'Phiên đăng nhập Google đã hết hạn hoặc bị thu hồi. Vui lòng đăng nhập lại.',
  'invalid_client' =>
    'Cấu hình ứng dụng Google không hợp lệ — xem docs/OAUTH_GOOGLE.md.',
  'server_error' => 'Máy chủ Google gặp lỗi. Vui lòng thử lại.',
  'temporarily_unavailable' =>
    'Dịch vụ Google tạm thời không khả dụng. Vui lòng thử lại.',
  'network_error' => 'Không kết nối được tới Google. Kiểm tra lại mạng.',
  _ => 'Đăng nhập Google thất bại ($errorCode).',
};
