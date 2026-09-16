import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wraps secure storage for the JWT issued by the backend on signup/login.
class TokenStorage {
  TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _tokenKey = 'auth_token';

  Future<void> saveToken(String token) => _storage.write(key: _tokenKey, value: token);

  Future<String?> readToken() => _storage.read(key: _tokenKey);

  Future<void> clearToken() => _storage.delete(key: _tokenKey);
}
