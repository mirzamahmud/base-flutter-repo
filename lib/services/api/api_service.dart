import 'dart:io';

import 'package:base_flutter_repo/core/constant/api/api_config.dart';
import 'package:base_flutter_repo/core/global/enums/request_type.dart';
import 'package:base_flutter_repo/core/global/model/api_response.dart';
import 'package:base_flutter_repo/services/api/api_client.dart';
import 'package:dio/dio.dart';

class ApiService {
  late final Dio _dio;
  late final ApiClient _client;

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
  }

  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  /// ==========================================================================
  /// Interceptors
  /// ==========================================================================
  void _addInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          handler.next(response);
        },

        onRequest: (options, handler) {
          handler.next(options);
        },

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
}

// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';

// import 'package:dio/dio.dart';

// class ApiService {
//   late final Dio _dio;
//   late final TokenStore _tokenStore;

//   bool _isRefreshing = false;
//   final List<void Function(String)> _refreshWaitQueue = [];

//   ApiService._internal(this._tokenStore) {
//     _dio = Dio(
//       BaseOptions(
//         baseUrl: ApiConfig.baseUrl,
//         connectTimeout: ApiConfig.connectionTimeOut,
//         receiveTimeout: ApiConfig.receiveTimeOut,
//         sendTimeout: ApiConfig.sendTimeOut,
//       ),
//     );

//     _addInterceptors();
//   }

//   static ApiService? _instance;
//   factory ApiService(TokenStore tokenStore) {
//     _instance ??= ApiService._internal(tokenStore);
//     return _instance!;
//   }

//   // ---------------------------------------------------------------------------
//   // Interceptors
//   // ---------------------------------------------------------------------------
//   void _addInterceptors() {
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           // 1) Internet check
//           final hasNet = await ConnectivityChecker.hasInternet();
//           if (!hasNet) {
//             log(
//               "[DIO][NO INTERNET] ${options.method} ${options.uri}",
//               name: "ApiService",
//             );
//             return handler.reject(
//               DioException(
//                 requestOptions: options,
//                 type: DioExceptionType.unknown,
//                 error: SocketException("No internet connection"),
//               ),
//             );
//           }

//           // 2) Attach token if exists
//           final token = await _tokenStore.getAccessToken();
//           if (token != null && token.isNotEmpty) {
//             options.headers["Authorization"] = "Bearer $token";
//             log(
//               "[DIO][AUTH] Token attached",
//               name: "ApiService",
//             );
//           } else {
//             log(
//               "[DIO][AUTH] No token found",
//               name: "ApiService",
//             );
//           }

//           // 3) Logs
//           log(
//             "[DIO][REQ] ${options.method} ${options.uri}\n"
//             "Headers: ${options.headers}\n"
//             "Query: ${options.queryParameters}\n"
//             "Data: ${options.data}",
//             name: "ApiService",
//           );

//           return handler.next(options);
//         },

//         onResponse: (response, handler) {
//           // Logs
//           log(
//             "[DIO][RES] ${response.statusCode} ${response.requestOptions.uri}\n"
//             "Data: ${response.data}",
//             name: "ApiService",
//           );
//           return handler.next(response);
//         },

//         onError: (error, handler) async {
//           final status = error.response?.statusCode;
//           final req = error.requestOptions;

//           log(
//             "[DIO][ERR] $status ${req.method} ${req.uri}\n"
//             "Error: ${error.message}\n"
//             "Data: ${error.response?.data}",
//             name: "ApiService",
//           );

//           // 4) If 401 -> refresh token
//           if (status == 401) {
//             final refreshed = await _handle401AndRefresh(error);
//             if (refreshed != null) {
//               return handler.resolve(refreshed);
//             }
//           }

//           return handler.next(error);
//         },
//       ),
//     );
//   }

//   // ---------------------------------------------------------------------------
//   // 401 handler: Refresh + Retry
//   // ---------------------------------------------------------------------------
//   Future<Response?> _handle401AndRefresh(DioException error) async {
//     final refreshToken = await _tokenStore.getRefreshToken();
//     if (refreshToken == null || refreshToken.isEmpty) {
//       log("[DIO][REFRESH] No refresh token -> logout", name: "ApiService");
//       await _tokenStore.clear();
//       return null;
//     }

//     // If already refreshing, queue this request
//     if (_isRefreshing) {
//       log("[DIO][REFRESH] Already refreshing -> wait queue", name: "ApiService");
//       final completer = Completer<Response?>();
//       _refreshWaitQueue.add((newToken) async {
//         try {
//           final retryRes = await _retryRequest(error.requestOptions, newToken);
//           completer.complete(retryRes);
//         } catch (e) {
//           completer.complete(null);
//         }
//       });
//       return completer.future;
//     }

//     _isRefreshing = true;

//     try {
//       log("[DIO][REFRESH] Start refresh", name: "ApiService");

//       final newTokens = await _refreshTokenCall(refreshToken);

//       if (newTokens == null) {
//         log("[DIO][REFRESH] Refresh failed -> logout", name: "ApiService");
//         await _tokenStore.clear();
//         return null;
//       }

//       final newAccess = newTokens.accessToken;
//       final newRefresh = newTokens.refreshToken;

//       await _tokenStore.saveAccessToken(newAccess);
//       if (newRefresh != null) {
//         await _tokenStore.saveRefreshToken(newRefresh);
//       }

//       log("[DIO][REFRESH] Success -> retry request", name: "ApiService");

//       // retry current request
//       final retryResponse = await _retryRequest(error.requestOptions, newAccess);

//       // release queued requests
//       for (final cb in _refreshWaitQueue) {
//         cb(newAccess);
//       }
//       _refreshWaitQueue.clear();

//       return retryResponse;
//     } catch (e) {
//       log("[DIO][REFRESH] Exception: $e", name: "ApiService");
//       await _tokenStore.clear();
//       return null;
//     } finally {
//       _isRefreshing = false;
//     }
//   }

//   // ---------------------------------------------------------------------------
//   // Refresh API call
//   // ---------------------------------------------------------------------------
//   Future<_Tokens?> _refreshTokenCall(String refreshToken) async {
//     try {
//       // IMPORTANT:
//       // refresh call must NOT use old Authorization header.
//       final dioRefresh = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

//       final res = await dioRefresh.post(
//         "/auth/refresh", // তোমার refresh endpoint
//         data: {"refreshToken": refreshToken},
//       );

//       if (res.statusCode == 200) {
//         // adjust keys based on your backend response
//         return _Tokens(
//           accessToken: res.data["accessToken"],
//           refreshToken: res.data["refreshToken"],
//         );
//       }
//       return null;
//     } catch (_) {
//       return null;
//     }
//   }

//   // ---------------------------------------------------------------------------
//   // Retry helper
//   // ---------------------------------------------------------------------------
//   Future<Response> _retryRequest(RequestOptions req, String newToken) {
//     final options = Options(
//       method: req.method,
//       headers: Map<String, dynamic>.from(req.headers)
//         ..["Authorization"] = "Bearer $newToken",
//       responseType: req.responseType,
//       contentType: req.contentType,
//       followRedirects: req.followRedirects,
//       validateStatus: req.validateStatus,
//       receiveDataWhenStatusError: req.receiveDataWhenStatusError,
//     );

//     return _dio.request(
//       req.path,
//       data: req.data,
//       queryParameters: req.queryParameters,
//       options: options,
//       cancelToken: req.cancelToken,
//       onReceiveProgress: req.onReceiveProgress,
//       onSendProgress: req.onSendProgress,
//     );
//   }
// }

// // -----------------------------------------------------------------------------
// // Token model
// // -----------------------------------------------------------------------------
// class _Tokens {
//   final String accessToken;
//   final String? refreshToken;
//   _Tokens({required this.accessToken, this.refreshToken});
// }
