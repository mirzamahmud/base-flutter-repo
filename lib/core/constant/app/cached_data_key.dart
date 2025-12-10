class _CachedDataKey {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
}

class CachedDataKey extends _CachedDataKey {
  static String get accessToken => _CachedDataKey.accessToken;
  static String get refreshToken => _CachedDataKey.refreshToken;
}
