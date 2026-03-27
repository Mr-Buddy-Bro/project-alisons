import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.token,
    required super.name,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final customer = (json['customerdata'] as Map<String, dynamic>?) ?? json;

    return UserModel(
      id: customer['id']?.toString() ?? json['id']?.toString() ?? '',
      token:
          customer['token']?.toString() ?? json['token']?.toString() ?? '',
      name: customer['name']?.toString() ?? json['name']?.toString() ?? '',
      email: customer['email']?.toString() ?? json['email']?.toString() ?? '',
    );
  }
}
