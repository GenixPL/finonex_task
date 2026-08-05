import 'package:finonex_task/models/_models.dart';

class AuthStorageInMemory extends AuthStorage {
  TokenData? _tokenData;

  @override
  Future<TokenData?> getToken() async {
    return _tokenData;
  }

  @override
  Future<void> setToken(TokenData? tokenData) async {
    _tokenData = tokenData;
  }
}
