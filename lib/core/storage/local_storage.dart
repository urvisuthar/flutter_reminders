import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final SharedPreferences _prefs;

  LocalStorage(this._prefs);

  static const _userIdKey = 'user_id';
  static const _usernameKey = 'username';
  static const _emailKey = 'email';

  Future<void> saveUser({
    int? userId,
    String? username,
    String? email,
  }) async {
    if (userId != null) await _prefs.setInt(_userIdKey, userId);
    if (username != null) await _prefs.setString(_usernameKey, username);
    if (email != null) await _prefs.setString(_emailKey, email);
  }

  int? getUserId() => _prefs.getInt(_userIdKey);
  String? getUsername() => _prefs.getString(_usernameKey);
  String? getEmail() => _prefs.getString(_emailKey);

  Future<void> clear() async {
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_usernameKey);
    await _prefs.remove(_emailKey);
  }
}