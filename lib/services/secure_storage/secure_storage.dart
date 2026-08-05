abstract class SecureStorage {
  Future<String?> getKey(String key);

  Future<void> setKey({
    required String key,
    required String value,
  });
}
