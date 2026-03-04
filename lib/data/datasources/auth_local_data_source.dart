import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  AuthLocalDataSource(this._preferences, this._secureStorage);

  static const _keyAuthorized = 'auth.is_authorized';
  static const _keyEmail = 'auth.email';
  static const _keyPassword = 'auth.password';

  final SharedPreferences _preferences;
  final FlutterSecureStorage _secureStorage;

  Future<void> saveCredentials({required String email, required String password}) async {
    await _secureStorage.write(key: _keyEmail, value: email);
    await _secureStorage.write(key: _keyPassword, value: password);
    await _preferences.setBool(_keyAuthorized, true);
  }

  Future<Map<String, String>?> readCredentials() async {
    final email = await _secureStorage.read(key: _keyEmail);
    final password = await _secureStorage.read(key: _keyPassword);
    if (email == null || password == null) {
      return null;
    }
    return {'email': email, 'password': password};
  }

  Future<void> clearCredentials() async {
    await _secureStorage.delete(key: _keyEmail);
    await _secureStorage.delete(key: _keyPassword);
    await _preferences.setBool(_keyAuthorized, false);
  }

  Future<bool> isAuthorized() async {
    return _preferences.getBool(_keyAuthorized) ?? false;
  }

  Future<void> setAuthorized(bool value) async {
    await _preferences.setBool(_keyAuthorized, value);
  }

  Future<String?> savedEmail() => _secureStorage.read(key: _keyEmail);
}
