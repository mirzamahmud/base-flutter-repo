class _ApiEndpoint {
  /// ==========================================================================
  /// Auth
  /// ==========================================================================
  static const String signInEndpoint = '/auth/login';

  /// ==========================================================================
  /// Refresh Token
  /// ==========================================================================
  static const String refreshTokenEndPoint = '/auth/refresh-token';

  /// ==========================================================================
  /// Profile
  /// ==========================================================================
  static const String profileEndpoint = '/auth/profile';

  /// ==========================================================================
  /// Others
  /// ==========================================================================
  static const String locationsEndpoint = '/locations';
  static const String productsEndpoint = '/products';
  static const String categoriesEndpoint = '/categories';

  /// ==========================================================================
  /// Files
  /// ==========================================================================
  static const String uploadFileEndpoint = '/files/upload';
  static const String filesEndpoint = '/files';
}

class ApiEndpoint extends _ApiEndpoint {
  static String get signInEndpoint => _ApiEndpoint.signInEndpoint;
  static String get refreshTokenEndpoint => _ApiEndpoint.refreshTokenEndPoint;
  static String get profileEndpoint => _ApiEndpoint.profileEndpoint;

  static String get locationEndpoint => _ApiEndpoint.locationsEndpoint;
  static String get productsEndpoint => _ApiEndpoint.productsEndpoint;
  static String get categoriesEndpoint => _ApiEndpoint.categoriesEndpoint;
  static String get uploadFileEndpoint => _ApiEndpoint.uploadFileEndpoint;
  static String get filesEndpoint => _ApiEndpoint.filesEndpoint;
}
