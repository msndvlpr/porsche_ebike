import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:secure_storage_api/secure_storage_api.dart';


class FakeFlutterSecureStorage implements FlutterSecureStorage {
  final Map<String, String> _storage = {};

  @override
  Future<String?> read({required String key, IOSOptions? iOptions, AndroidOptions? aOptions,
    LinuxOptions? lOptions, WebOptions? webOptions, MacOsOptions? mOptions, WindowsOptions? wOptions}) async {
    return _storage[key];
  }

  @override
  Future<void> write({required String key, required String? value, IOSOptions? iOptions, AndroidOptions? aOptions,
    LinuxOptions? lOptions, WebOptions? webOptions, MacOsOptions? mOptions, WindowsOptions? wOptions}) async {
    if (value != null) {
      _storage[key] = value;
    }
  }

  // The rest of the interface is not used in your implementation, so you can throw UnimplementedError
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('SecureStorageApi', () {
    late SecureStorageApi secureStorageApi;
    late FakeFlutterSecureStorage fakeStorage;

    setUp(() {
      fakeStorage = FakeFlutterSecureStorage();
      secureStorageApi = SecureStorageApi(flutterSecureStorage: fakeStorage);
    });

    test('write() stores value in secure storage', () async {
      await secureStorageApi.write('token', '123abc');

      final value = await fakeStorage.read(key: 'token');
      expect(value, '123abc');
    });

    test('read() retrieves value from secure storage', () async {
      await fakeStorage.write(key: 'username', value: 'mohsen');

      final result = await secureStorageApi.read('username');
      expect(result, 'mohsen');
    });

    test('read() returns null for non-existent key', () async {
      final result = await secureStorageApi.read('nonexistent');
      expect(result, isNull);
    });
  });
}
