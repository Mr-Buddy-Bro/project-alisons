import 'package:dio/dio.dart';
import 'package:project_alisons/core/network/api_client.dart';
import 'package:project_alisons/core/network/api_constants.dart';
import 'package:project_alisons/core/errors/app_exception.dart';
import 'package:project_alisons/core/errors/error_mapper.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final Dio _dio = ApiClient.instance.dio;

  Future<UserModel> login({
    required String emailPhone,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.loginEndpoint,
        queryParameters: {
          'email_phone': emailPhone,
          'password': password,
        },
      );

      if (response.data is! Map<String, dynamic>) {
        throw const AppException('Invalid response from server.');
      }
      final data = response.data as Map<String, dynamic>;

      if (!_isSuccess(data['success'])) {
        throw AppException(data['message']?.toString() ?? 'Login failed');
      }

      final user = UserModel.fromJson(data);
      if (user.id.isEmpty || user.token.isEmpty) {
        throw const AppException('Login failed. Please try again.');
      }
      return user;
    } on DioException catch (e) {
      throw AppException(ErrorMapper.message(e));
    } catch (e) {
      throw AppException(ErrorMapper.message(e, fallback: 'Login failed'));
    }
  }

  bool _isSuccess(dynamic value) => value == 1 || value == '1' || value == true;
}
