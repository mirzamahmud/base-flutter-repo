class ApiResponse {
  final bool isSuccess;
  final String? message;
  final Object? responseData;

  ApiResponse({required this.isSuccess, this.message, this.responseData});

  ApiResponse copyWith({
    bool? isSuccess,
    String? message,
    String? responseData,
  }) => ApiResponse(
    isSuccess: isSuccess ?? this.isSuccess,
    message: message ?? this.message,
    responseData: responseData ?? this.responseData,
  );

  @override
  String toString() {
    return 'ApiResponse(isSuccess: $isSuccess, message: $message, data: $responseData)';
  }
}
