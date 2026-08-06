import 'package:finonex_task/models/auth/_auth.dart';
import 'package:synchronized/synchronized.dart';

class AuthModelImpl extends AuthModel {
  AuthModelImpl({
    required this._authStorage,
    required this._authService,
  });

  final AuthStorage _authStorage;
  final AuthService _authService;

  final Lock _getTokenLock = Lock();

  @override
  Future<String?> getToken() {
    return _getTokenLock.synchronized(() async {
      final TokenData? storedData = await _authStorage.getToken();
      if (storedData != null && !storedData.isExpired) {
        print('AuthModelImpl, returning stored token.');
        return storedData.token;
      }

      // In this case logged out and expired is the same.
      // TODO(genix): try-catch
      final LoginResponse loginResponse = await _authService.login('trader', 'password123');
      await _authStorage.setToken(
        TokenData(
          token: loginResponse.token,
          expiresIn: loginResponse.expiresIn,
        ),
      );
      print('AuthModelImpl, returning fresh token.');
      return loginResponse.token;
    });
  }
}
