import 'package:base_flutter_repo/core/constant/api/api_config.dart';
import 'package:dio/dio.dart';

class ApiService {
  late Dio _dio;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectionTimeOut,
        receiveTimeout: ApiConfig.receiveTimeOut,
        sendTimeout: ApiConfig.sendTimeOut,
      ),
    );

    _addInterceptors();
  }

  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  void _addInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {},

        onRequest: (options, handler) {},

        onError: (error, handler) {},
      ),
    );
  }
}
