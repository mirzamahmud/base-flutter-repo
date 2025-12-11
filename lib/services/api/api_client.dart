import 'package:base_flutter_repo/core/global/model/api_response.dart';
import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;
  ApiClient({required this.dio});

  Future<ApiResponse> get({
    required String endpoint,
    Object? data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await dio.get(
        endpoint,
        queryParameters: queryParams,
        data: data,
      );

      if (response.statusCode == 200) {
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

  Future<ApiResponse> post({
    required String endpoint,
    Object? data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await dio.post(
        endpoint,
        data: data,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(
          isSuccess: true,
          message: response.statusMessage,
          responseData: response.data,
        );
      } else {
        return ApiResponse(isSuccess: false, message: response.statusMessage);
      }
    } catch (e) {
      return ApiResponse(isSuccess: false, message: '');
    }
  }

  Future<ApiResponse> put({
    required String endpoint,
    Object? data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await dio.put(
        endpoint,
        data: data,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return ApiResponse(
          isSuccess: true,
          message: response.statusMessage,
          responseData: response.data,
        );
      } else {
        return ApiResponse(isSuccess: false, message: response.statusMessage);
      }
    } catch (e) {
      return ApiResponse(isSuccess: false, message: '');
    }
  }

  Future<ApiResponse> patch({
    required String endpoint,
    Object? data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return ApiResponse(
          isSuccess: true,
          message: response.statusMessage,
          responseData: response.data,
        );
      } else {
        return ApiResponse(isSuccess: false, message: response.statusMessage);
      }
    } catch (e) {
      return ApiResponse(isSuccess: false, message: '');
    }
  }

  Future<ApiResponse> delete({
    required String endpoint,
    Object? data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 ||
          response.statusCode == 202 ||
          response.statusCode == 204) {
        return ApiResponse(
          isSuccess: true,
          message: response.statusMessage,
          responseData: response.data,
        );
      } else {
        return ApiResponse(isSuccess: false, message: response.statusMessage);
      }
    } catch (e) {
      return ApiResponse(isSuccess: false, message: '');
    }
  }
}
