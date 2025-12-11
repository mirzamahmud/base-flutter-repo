import 'dart:io';

import 'package:base_flutter_repo/core/constant/api/api_config.dart';
import 'package:base_flutter_repo/core/global/enums/request_type.dart';
import 'package:base_flutter_repo/core/global/enums/token_type.dart';
import 'package:base_flutter_repo/core/global/model/api_response.dart';
import 'package:base_flutter_repo/core/utils/network/internet_connectivity_checker.dart';
import 'package:base_flutter_repo/services/api/api_client.dart';
import 'package:base_flutter_repo/services/cache/cache_service.dart';
import 'package:dio/dio.dart';

class ApiService {
  late final Dio _dio;
  late final ApiClient _client;
  late final CacheService _cacheService;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectionTimeOut,
        receiveTimeout: ApiConfig.receiveTimeOut,
        sendTimeout: ApiConfig.sendTimeOut,
        headers: {'Content-Type': 'application/json', 'Accept': '*/*'},
      ),
    );

    _addInterceptors();
    _client = ApiClient(dio: _dio);
    _cacheService = CacheService();
  }

  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  /// ==========================================================================
  /// Interceptors
  /// ==========================================================================
  void _addInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Check Internet
          final bool hasInternet =
              await InternetConnectivityChecker.hasInternet();
          _checkInternetConnection(
            hasInternet,
            options: options,
            handler: handler,
          );

          // Check Token
          final token = await _cacheService.fetchToken(
            tokenType: TokenType.ACCESS_TOKEN,
          );

          _checkToken(token, options: options, handler: handler);

          handler.next(options);
        },

        onResponse: (response, handler) async {},

        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }

  /// ==========================================================================
  /// Calling APIs
  /// ==========================================================================
  Future<ApiResponse> onRequest({
    required RequestType requestType,
    required String endpoint,
    Object? requestData,
    Map<String, dynamic>? queryParams,
  }) async {
    switch (requestType) {
      // GET REQUEST
      case RequestType.GET:
        return await _client.get(
          endpoint: endpoint,
          data: requestData,
          queryParams: queryParams,
        );

      // POST REQUEST
      case RequestType.POST:
        return await _client.post(
          endpoint: endpoint,
          data: requestData,
          queryParams: queryParams,
        );

      // PUT REQUEST
      case RequestType.PUT:
        return await _client.put(
          endpoint: endpoint,
          data: requestData,
          queryParams: queryParams,
        );

      // PATCH REQUEST
      case RequestType.PATCH:
        return await _client.patch(
          endpoint: endpoint,
          data: requestData,
          queryParams: queryParams,
        );

      // DELETE REQUEST
      case RequestType.DELETE:
        return await _client.delete(
          endpoint: endpoint,
          data: requestData,
          queryParams: queryParams,
        );
    }
  }

  Future<ApiResponse> onRequestFormData({
    required String endpoint,
    required String formKey,
    File? file,
    List<File>? files,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final Map<String, dynamic> formMap = {};

      if (data != null && data.isNotEmpty) {
        formMap.addAll(data);
      }

      // Single file upload
      if (file != null) {
        final fileName = file.path.split('/').last;
        formMap[formKey] = await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        );
      }

      // Multiple files upload
      if (files != null && files.isNotEmpty) {
        formMap[formKey] = await Future.wait(
          files.map((f) async {
            final fileName = f.path.split('/').last;
            return MultipartFile.fromFile(f.path, filename: fileName);
          }),
        );
      }

      final formData = FormData.fromMap(formMap);

      final response = await _dio.post(
        endpoint,
        data: formData,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        return ApiResponse(
          isSuccess: true,
          message: response.statusMessage,
          responseData: response.data,
        );
      } else {
        return ApiResponse(
          isSuccess: false,
          message: response.statusMessage,
          responseData: null,
        );
      }
    } catch (e) {
      return ApiResponse(isSuccess: false, message: '');
    }
  }

  /// ==========================================================================
  /// Check Internet Connection
  /// ==========================================================================
  void _checkInternetConnection(
    bool hasInternet, {
    required RequestOptions options,
    required RequestInterceptorHandler handler,
  }) {
    if (!hasInternet) {}
  }

  /// ==========================================================================
  /// Check Token
  /// ==========================================================================
  void _checkToken(
    String? token, {
    required RequestOptions options,
    required RequestInterceptorHandler handler,
  }) {
    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    } else {}
  }
}
