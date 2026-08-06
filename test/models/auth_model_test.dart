import 'package:finonex_task/models/auth/_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

class MockAuthService extends AuthService {
  MockAuthService() : super(http.Client(), baseUrl: '');

  int loginCallCount = 0;

  @override
  Future<LoginResponse> login(String username, String password) async {
    loginCallCount++;
    // Simulate some network delay to make concurrency more "real"
    await Future.delayed(const Duration(milliseconds: 100));
    return LoginResponse(token: 'token_$loginCallCount', expiresIn: 3600);
  }
}

void main() {
  late AuthModel authModel;
  late MockAuthService mockAuthService;
  late AuthStorageInMemory authStorage;

  setUp(() {
    mockAuthService = MockAuthService();
    authStorage = AuthStorageInMemory();
    authModel = AuthModelImpl(
      authStorage: authStorage,
      authService: mockAuthService,
    );
  });

  test('login -> 3 quick getToken requests result in only one request if token is still valid', () async {
    // 1. Log in initially
    await authModel.login();
    expect(mockAuthService.loginCallCount, 1);

    // 2. Perform 3 quick getToken requests concurrently
    final results = await Future.wait([
      authModel.getToken(),
      authModel.getToken(),
      authModel.getToken(),
    ]);

    // 3. Verify that all returned the same token and login was NOT called again
    expect(results[0], 'token_1');
    expect(results[1], 'token_1');
    expect(results[2], 'token_1');
    expect(mockAuthService.loginCallCount, 1);
  });

  test('3 quick getToken requests when token is expired result in only one login request', () async {
    // 1. Log in initially to set state to AuthState.user
    await authModel.login();
    expect(mockAuthService.loginCallCount, 1);

    // 2. Manually set an expired token in storage
    await authStorage.setToken(
      TokenData(
        token: 'expired_token',
        expiresIn: 3600,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    );

    // 3. Perform 3 quick getToken requests concurrently
    // Since the token is expired, one of these should trigger a login() refresh.
    // The lock should ensure only one refresh happens.
    final results = await Future.wait([
      authModel.getToken(),
      authModel.getToken(),
      authModel.getToken(),
    ]);

    // 4. Verify that all returned the NEW token from the refresh (token_2)
    // and login was called only twice in total (once initial, once refresh)
    expect(results[0], 'token_2');
    expect(results[1], 'token_2');
    expect(results[2], 'token_2');
    expect(mockAuthService.loginCallCount, 2);
  });
}
