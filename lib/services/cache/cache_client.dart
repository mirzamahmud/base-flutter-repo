import 'package:base_flutter_repo/core/constant/app/cached_data_key.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CacheClient {
  final FlutterSecureStorage storage;
  CacheClient({required this.storage});

  Future<String?> getAccessToken() async {
    return await storage.read(key: CachedDataKey.accessToken);
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: CachedDataKey.refreshToken);
  }

  Future<void> saveAccessToken(String token) async {
    await storage.write(key: CachedDataKey.accessToken, value: token);
  }

  Future<void> saveRefreshToken(String token) async {
    await storage.write(key: CachedDataKey.refreshToken, value: token);
  }

  Future<void> clearToken() async {
    await Future.wait([
      storage.delete(key: CachedDataKey.accessToken),
      storage.delete(key: CachedDataKey.refreshToken),
    ]);
  }
}
