import 'package:base_flutter_repo/core/constant/app/cached_data_key.dart';
import 'package:base_flutter_repo/services/cache/token_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CacheClient implements TokenManager {
  final FlutterSecureStorage storage;
  CacheClient({required this.storage});

  @override
  Future<String?> getAccessToken() async {
    return await storage.read(key: CachedDataKey.accessToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await storage.read(key: CachedDataKey.refreshToken);
  }

  @override
  Future<void> saveAccessToken(String token) async {
    await storage.write(key: CachedDataKey.accessToken, value: token);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await storage.write(key: CachedDataKey.refreshToken, value: token);
  }

  @override
  Future<void> clearToken() async {
    await Future.wait([
      storage.delete(key: CachedDataKey.accessToken),
      storage.delete(key: CachedDataKey.refreshToken),
    ]);
  }
}
