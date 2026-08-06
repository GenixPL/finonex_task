import 'package:finonex_task/models/auth/_auth.dart';

abstract class AuthStorage {
  Future<TokenData?> getToken();

  Future<void> setToken(TokenData tokenData);

  Future<void> deleteToken();
}
