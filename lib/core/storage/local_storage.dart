import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static LocalStorage? _instance;
  late SharedPreferences _prefs;

  LocalStorage._();

  static LocalStorage get instance {
    _instance ??= LocalStorage._();
    return _instance!;
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const _keyUserId = 'user_id';
  static const _keyToken = 'user_token';
  static const _keyUserName = 'user_name';

  Future<void> saveAuth({
    required String id,
    required String token,
    String name = '',
  }) async {
    await _prefs.setString(_keyUserId, id);
    await _prefs.setString(_keyToken, token);
    await _prefs.setString(_keyUserName, name);
  }

  Future<void> clearAuth() async {
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyToken);
    await _prefs.remove(_keyUserName);
  }

  String get userId => _prefs.getString(_keyUserId) ?? '';
  String get token => _prefs.getString(_keyToken) ?? '';
  String get userName => _prefs.getString(_keyUserName) ?? '';
  bool get isLoggedIn => token.isNotEmpty;
}
