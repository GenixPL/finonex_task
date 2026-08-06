import 'package:finonex_task/models/auth/_auth.dart';

class AuthStorageInMemory extends AuthStorage {
  TokenData? _tokenData;

  @override
  Future<TokenData?> getToken() async {
    return _tokenData;
  }

  @override
  Future<void> setToken(TokenData tokenData) async {
    _tokenData = tokenData;
  }

  @override
  Future<void> deleteToken() async {
    _tokenData = null;
  }
}
