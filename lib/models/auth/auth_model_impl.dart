import 'package:finonex_task/models/_models.dart';

class AuthModelImpl extends AuthModel {
  AuthModelImpl({
    required this._authStorage,
    required this._authService,
  });

  final AuthStorage _authStorage;
  final AuthService _authService;

  @override
  Future<String?> getToken() async {
    
  }
}
