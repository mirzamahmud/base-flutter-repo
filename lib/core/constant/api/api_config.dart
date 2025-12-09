class _ApiConfig {
  static const String domain = 'https://api.escuelajs.co/';
  static const String apiVersion = 'api/v1';
  static const String baseUrl = '$domain$apiVersion';

  static const Duration connectionTimeOut = Duration(seconds: 10);
  static const Duration receiveTimeOut = Duration(seconds: 10);
  static const Duration sendTimeOut = Duration(seconds: 10);
}

class ApiConfig extends _ApiConfig {
  static String get baseUrl => _ApiConfig.baseUrl;
  static Duration get connectionTimeOut => _ApiConfig.connectionTimeOut;
  static Duration get receiveTimeOut => _ApiConfig.receiveTimeOut;
  static Duration get sendTimeOut => _ApiConfig.sendTimeOut;
}
