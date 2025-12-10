import 'package:base_flutter_repo/core/global/enums/token_type.dart';
import 'package:base_flutter_repo/services/cache/cache_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CacheService {
  late final FlutterSecureStorage _storage;
  late final CacheClient _cacheClient;

  CacheService._internal() {
    _storage = FlutterSecureStorage();
    _cacheClient = CacheClient(storage: _storage);
  }

  static final CacheService _instance = CacheService._internal();

  factory CacheService() => _instance;

  Future<void> saveToken({
    required TokenType tokenType,
    required String token,
  }) async {
    switch (tokenType) {
      case TokenType.ACCESS_TOKEN:
        return await _cacheClient.saveAccessToken(token);

      case TokenType.REFRESH_TOKEN:
        return await _cacheClient.saveRefreshToken(token);
    }
  }

  Future<String?> fetchToken({required TokenType tokenType}) async {
    switch (tokenType) {
      case TokenType.ACCESS_TOKEN:
        return await _cacheClient.getAccessToken();
      case TokenType.REFRESH_TOKEN:
        return await _cacheClient.getRefreshToken();
    }
  }

  Future<void> clearAll() async {
    await Future.wait([_cacheClient.clearToken()]);
  }
}
