import 'package:project_alisons/core/storage/local_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<UserEntity> login({
    required String emailPhone,
    required String password,
  }) async {
    final user = await _dataSource.login(
      emailPhone: emailPhone,
      password: password,
    );
    await LocalStorage.instance.saveAuth(
      id: user.id,
      token: user.token,
      name: user.name,
    );
    return user;
  }
}
