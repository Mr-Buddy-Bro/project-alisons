import 'package:dio/dio.dart';
import 'app_exception.dart';

class ErrorMapper {
  static String message(dynamic error, {String fallback = 'Something went wrong'}) {
    if (error is AppException) return error.message;
    if (error is DioException) return _dioMessage(error);

    final value = error.toString().replaceFirst('Exception: ', '').trim();
    if (value.isEmpty || value == 'null') return fallback;
    return value;
  }

  static String _dioMessage(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;
    final apiMessage = _extractApiMessage(responseData);
    if (apiMessage != null && apiMessage.isNotEmpty) return apiMessage;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Request timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';
      case DioExceptionType.badCertificate:
        return 'Secure connection failed. Please try again later.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.badResponse:
        if (statusCode == 401 || statusCode == 403) {
          return 'Session expired. Please log in again.';
        }
        if (statusCode != null && statusCode >= 500) {
          return 'Server error. Please try again later.';
        }
        return 'Unable to process the request right now.';
      case DioExceptionType.unknown:
        return 'Unexpected network error. Please try again.';
    }
  }

  static String? _extractApiMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message']?.toString();
      if (message != null && message.trim().isNotEmpty) return message;
    }
    return null;
  }
}
