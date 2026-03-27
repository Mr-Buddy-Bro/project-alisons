import 'package:flutter_test/flutter_test.dart';
import 'package:project_alisons/features/auth/data/models/user_model.dart';

void main() {
  group('UserModel.fromJson', () {
    test('parses nested customerdata payload', () {
      final json = {
        'success': 1,
        'message': 'Login Success',
        'customerdata': {
          'id': 'Bb4',
          'name': 'test',
          'email': 'web@alisonsgroup.com',
          'token': 'abc123',
        },
      };

      final user = UserModel.fromJson(json);

      expect(user.id, 'Bb4');
      expect(user.name, 'test');
      expect(user.email, 'web@alisonsgroup.com');
      expect(user.token, 'abc123');
    });

    test('falls back to top-level keys when customerdata is missing', () {
      final json = {
        'id': 'u1',
        'name': 'Top Level User',
        'email': 'user@example.com',
        'token': 'token-1',
      };

      final user = UserModel.fromJson(json);

      expect(user.id, 'u1');
      expect(user.name, 'Top Level User');
      expect(user.email, 'user@example.com');
      expect(user.token, 'token-1');
    });
  });
}
