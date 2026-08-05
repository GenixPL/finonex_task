import 'package:finonex_task/models/auth/auth_storage.dart';

class AuthStorageInMemory extends AuthStorage {
  String? _token;

  @override
  Future<String?> getToken() async {
    return _token;
  }
}
