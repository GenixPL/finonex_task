import 'package:finonex_task/models/_models.dart';

abstract class AuthStorage {
  Future<TokenData?> getToken();

  Future<void> setToken(TokenData tokenData);
}
