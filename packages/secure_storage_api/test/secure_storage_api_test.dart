import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:secure_storage_api/secure_storage_api.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {

  late MockFlutterSecureStorage mockStorage;
  late SecureStorageApi secureStorageApi;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    secureStorageApi = SecureStorageApi(flutterSecureStorage: mockStorage);
  });

  group('read', (){

    test('GIVEN SecureStorageApi as the local storage api WHEN key is given and data already stored in THEN should retrieve data successfully', () async {
      const key = 'testKey';
      const value = 'testValue';
      when(() => mockStorage.read(key: key)).thenAnswer((_) async => value);

      final result = await secureStorageApi.read(key);

      expect(result, equals(value));
      verify(() => mockStorage.read(key: key)).called(1);
    });

    test('GIVEN SecureStorageApi as the local storage api WHEN key is given and data doesnt exist THEN should return null', () async {
      const key = 'testKey';
      when(() => mockStorage.read(key: key)).thenAnswer((_) async => null);

      final result = await secureStorageApi.read(key);

      expect(result, isNull);
      verify(() => mockStorage.read(key: key)).called(1);
    });

  });

  group('write', (){

    test('GIVEN SecureStorageApi as the local storage api WHEN key and data are given THEN should store data successfully', () async {
      const key = 'testKey';
      const value = 'testValue';
      when(() => mockStorage.write(key: key, value: value)).thenAnswer((_) async {});

      await secureStorageApi.write(key, value);

      verify(() => mockStorage.write(key: key, value: value)).called(1);
    });
  });

  group('clearAll', (){

    test('GIVEN SecureStorageApi as the local storage api WHEN key is given and some data already stored in THEN should remove all data', () async {
      when(() => mockStorage.deleteAll()).thenAnswer((_) async {});

      await secureStorageApi.clearAll();

      verify(() => mockStorage.deleteAll()).called(1);
    });
  });




}
