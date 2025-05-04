import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageApi {

  final FlutterSecureStorage _flutterSecureStorage;

  SecureStorageApi({FlutterSecureStorage? flutterSecureStorage})
      : _flutterSecureStorage = flutterSecureStorage ?? FlutterSecureStorage();

  Future<String?> read(String key) async {
    return await _flutterSecureStorage.read(key: key);
  }

  Future<void> write(String key, String value) async {
    await _flutterSecureStorage.write(key: key, value: value);
  }

  Future<void> clearAll() async {
    await _flutterSecureStorage.deleteAll();
  }
}
