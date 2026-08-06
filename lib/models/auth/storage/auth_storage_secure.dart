import 'dart:convert';

import 'package:finonex_task/models/auth/_auth.dart';
import 'package:finonex_task/services/secure_storage/_secure_storage.dart';

class AuthStorageSecure extends AuthStorage {
  AuthStorageSecure({
    required this._secureStorage,
  });

  static const String _tokenKey = 'token';

  final SecureStorage _secureStorage;

  @override
  Future<TokenData?> getToken() async {
    final stored = await _secureStorage.getKey(_tokenKey);
    if (stored == null) {
      return null;
    }

    try {
      return TokenData.fromJson(jsonDecode(stored));
    } catch (e) {
      print('getToken, error: $e');
      return null;
    }
  }

  @override
  Future<void> setToken(TokenData tokenData) async {
    await _secureStorage.setKey(
      key: _tokenKey,
      value: jsonEncode(tokenData.toJson()),
    );
  }

  @override
  Future<void> deleteToken() async {
    _secureStorage.deleteKey(_tokenKey);
  }
}
