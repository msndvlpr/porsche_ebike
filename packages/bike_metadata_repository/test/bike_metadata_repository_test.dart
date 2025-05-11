import 'package:bike_metadata_repository/bike_metadata_repository.dart';
import 'package:bike_metadata_repository/src/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_api/network_api_service.dart';
import 'package:secure_storage_api/secure_storage_api.dart';


void main() {
  late BikeMetadataRepository repo;

  setUp(() {
    repo = BikeMetadataRepository(
      networkApiService: FakeNetworkApiService(),
      secureStorageApi: FakeSecureStorageApi(),
    );
  });

  group('BikeMetadataRepo', () {

    test('getBikeMetadataById returns correct BikeAssetData', () async {
      final bike = await repo.getBikeMetadataById('bike123', 'CliffHanger');

      expect(bike.resourceId, 123456);
      expect(bike.bikeModel, 'CliffHanger');
      expect(bike.bikeImageUrl, 'http://image.jpg');
      expect(bike.bikeDescription, 'some bike description');
    });

    test('triggerBikeConnectedEvent returns true', () async {
      final result = await repo.triggerBikeConnectedEvent(
        '2025-05-11T10:00:00Z',
        'bike123',
        'CliffHanger',
      );

      expect(result, true);
    });
  });
}

class FakeSecureStorageApi implements SecureStorageApi {
  final Map<String, String> _storage = {
    storageKeyUserId: 'test-user-id',
    storageKeyToken: 'test-token',
  };

  @override
  Future<String?> read(String key) async => _storage[key];

  @override
  Future<void> write(String key, String value) {
    throw UnimplementedError();
  }
}

class FakeNetworkApiService implements NetworkApiService {

  @override
  Future<BikeAssetData> getBikeAssetData(String bikeId, String bikeType, String userId, String token) async {
    return BikeAssetData(
        resourceId: 123456,
        bikeModel: 'CliffHanger',
        bikeImageUrl: 'http://image.jpg',
        bikeDescription: 'some bike description');
  }

  @override
  Future<bool> triggerBikeConnectedEvent(String timeStamp, String bikeId, String bikeType, String userId, String token) async {
    return true;
  }

  @override
  String get baseUrl => "http://some-url";

  @override
  Future<String> postUserLoginData(String credentials) async {
    return "token";
  }
}

