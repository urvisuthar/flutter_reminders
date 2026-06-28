import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _secureStorage;

  TokenStorage(this._secureStorage);

  static const _accessTokenKey = 'access_token';
  static const _expiresInKey = 'expires_in';

  Future<void> saveTokens({
    required String accessToken,
    required int expiresIn,
  }) async {
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);
    final expiryTime = DateTime.now().add(Duration(seconds: expiresIn));
    await _secureStorage.write(
      key: _expiresInKey,
      value: expiryTime.toIso8601String(),
    );
  }

  Future<String?> getAccessToken() async {
    return _secureStorage.read(key: _accessTokenKey);
  }

  Future<String?> getExpiresIn() async {
    return _secureStorage.read(key: _expiresInKey);
  }

  Future<bool> isTokenValid() async {
    final expiryTimeStr = await getExpiresIn();
    if (expiryTimeStr == null) return false;

    final expiryTime = DateTime.parse(expiryTimeStr);
    return DateTime.now().isBefore(expiryTime);
  }

  Future<bool> isLoggedIn() async {
    final accessToken = await getAccessToken();
    if (accessToken == null || accessToken.isEmpty) return false;

    final tokenValid = await isTokenValid();
    if (!tokenValid) {
      print(
        '[Auth] Session expired (tokenInValid $tokenValid) — auto logout at ${DateTime.now()}',
      );
      await clear();
      return false;
    }

    return true;
  }

  Future<void> clear() async {
    await _secureStorage.deleteAll();
  }
}
