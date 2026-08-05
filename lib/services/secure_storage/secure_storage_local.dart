import 'package:flutter/services.dart';
import 'package:finonex_task/services/secure_storage/_secure_storage.dart';

class SecureStorageLocal extends SecureStorage {
  static const _channel = MethodChannel('com.example.finonex_task/secure_storage');

  @override
  Future<String?> getKey(String key) async {
    try {
      return await _channel.invokeMethod<String?>('getKey', {'key': key});
    } on PlatformException catch (e) {
      print('Failed to get key: ${e.message}');
      return null;
    }
  }

  @override
  Future<void> setKey({
    required String key,
    required String value,
  }) async {
    try {
      await _channel.invokeMethod('setKey', {'key': key, 'value': value});
    } on PlatformException catch (e) {
      print('Failed to set key: ${e.message}');
    }
  }
}
