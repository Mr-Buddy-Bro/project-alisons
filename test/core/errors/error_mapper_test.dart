import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_alisons/core/errors/app_exception.dart';
import 'package:project_alisons/core/errors/error_mapper.dart';

void main() {
  group('ErrorMapper.message', () {
    test('returns AppException message as-is', () {
      const error = AppException('Custom app error');
      expect(ErrorMapper.message(error), 'Custom app error');
    });

    test('maps connection timeout to user-friendly message', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      expect(
        ErrorMapper.message(error),
        'Request timed out. Please try again.',
      );
    });

    test('uses API message from badResponse body when available', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 400,
          data: {'message': 'Invalid credentials'},
        ),
      );

      expect(ErrorMapper.message(error), 'Invalid credentials');
    });

    test('falls back for unknown generic errors', () {
      expect(
        ErrorMapper.message(Exception(''), fallback: 'Fallback message'),
        'Fallback message',
      );
    });
  });
}
