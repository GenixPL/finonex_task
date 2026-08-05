import 'package:finonex_task/services/secure_storage/_secure_storage.dart';

class SecureStorageLocal extends SecureStorage {
  @override
  Future<String?> getKey(String key) async {}

  @override
  Future<void> setKey({
    required String key,
    required String value,
  }) async {}
}
