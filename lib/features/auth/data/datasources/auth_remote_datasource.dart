import 'package:dio/dio.dart';
import 'package:project_alisons/core/network/api_client.dart';
import 'package:project_alisons/core/network/api_constants.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final Dio _dio = ApiClient.instance.dio;

  Future<UserModel> login({
    required String emailPhone,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiConstants.loginEndpoint,
      queryParameters: {
        'email_phone': emailPhone,
        'password': password,
      },
    );

    final data = response.data;
    if (data['success'] != 1) {
      throw Exception(data['message'] ?? 'Login failed');
    }

    return UserModel.fromJson(data);
  }
}
