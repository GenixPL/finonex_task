import 'package:finonex_task/models/auth/_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';

// TODO(genix): there should be an init taking into account previous session
class AuthModelImpl extends AuthModel {
  AuthModelImpl({
    required this._authStorage,
    required this._authService,
  });

  final AuthStorage _authStorage;
  final AuthService _authService;

  final BehaviorSubject<AuthState> _stateStream = BehaviorSubject.seeded(AuthState.noUser);
  final Lock _getTokenLock = Lock();

  @override
  ValueStream<AuthState> get stateStream => _stateStream.stream;

  @override
  Future<String?> getToken() async {
    return switch (stateStream.value) {
      AuthState.noUser => null,
      AuthState.user => _getTokenFromRepo(),
    };
  }

  @override
  Future<String?> login() async {
    print('AuthModelImpl, log in');
    await logout();

    final String? token = await _getTokenFromRepo();
    if (token == null) {
      return 'Failed to get the token!';
    }

    _stateStream.add(AuthState.user);
    return null;
  }

  @override
  Future<void> logout() async {
    print('AuthModelImpl, log out');
    await _authStorage.deleteToken();
    _stateStream.add(AuthState.noUser);
  }

  Future<String?> _getTokenFromRepo() async {
    return _getTokenLock.synchronized(() async {
      final TokenData? storedData = await _authStorage.getToken();
      if (storedData != null && !storedData.isExpired) {
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
      return loginResponse.token;
    });
  }
}
