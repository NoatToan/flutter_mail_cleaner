/// Every top-level destination is deep-linkable (hard rule §1). Build paths
/// through these helpers instead of string literals.
abstract final class AppRoutes {
  static const welcome = '/welcome';
  static const addAccount = '/onboarding/add-account';
  static const scanning = '/onboarding/scanning';

  /// Web OAuth redirect target — must match `WebOAuthClient.callbackPath`
  /// and the redirect URIs registered with Google/Microsoft.
  static const oauthCallback = '/onboarding/oauth-callback';

  static const dashboard = '/dashboard';
  static const inbox = '/inbox';
  static const mailboxes = '/mailboxes';
  static const smartScan = '/smart-scan';
  static const cleanDone = '/smart-scan/done';
  static const senders = '/senders';
  static const senderReview = '/senders/review';
  static const tags = '/tags';
  static const catchUp = '/catch-up';
  static const aiCommand = '/ai-command';
  static const settings = '/settings';

  /// `/inbox?account=<id>&filter=<CategoryFilter.name>&tag=<tagKey>`
  static String inboxWith({
    String? accountId,
    String? filter,
    String? tagKey,
  }) => Uri(
    path: inbox,
    queryParameters: {'account': ?accountId, 'filter': ?filter, 'tag': ?tagKey},
  ).toString();

  static String message(int id) => '$inbox/message/$id';

  static String senderDetail(String email) =>
      '$senders/${Uri.encodeComponent(email)}';

  static String catchUpFor(String senderEmail) =>
      Uri(path: catchUp, queryParameters: {'sender': senderEmail}).toString();
}
