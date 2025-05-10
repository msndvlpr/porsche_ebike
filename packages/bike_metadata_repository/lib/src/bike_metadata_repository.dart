import 'package:network_api/network_api_service.dart';
import 'package:secure_storage_api/secure_storage_api.dart';
import 'constants.dart';


class BikeMetadataRepository {

  final NetworkApiService _networkApiService;
  final SecureStorageApi _secureStorageApi;

  BikeMetadataRepository({
    NetworkApiService? networkApiService,
    SecureStorageApi? secureStorageApi
  })
      : _networkApiService = networkApiService ?? NetworkApiService(),
        _secureStorageApi = secureStorageApi ?? SecureStorageApi();

  Future<BikeAssetData> getBikeMetadataById(String bikeId, String bikeType) async {

    /// Retrieve already stored user id and network token from local storage for authorised backend communication
    final userId = await _secureStorageApi.read(storageKeyUserId);
    final token = await _secureStorageApi.read(storageKeyToken);

    try {
      final data = await _networkApiService.getBikeAssetData(bikeId, bikeType, userId!, token!);
      return data;

    } on NetworkException {
      rethrow;

    } catch (e) {
      rethrow;
    }
  }

  Future<bool> triggerBikeConnectedEvent(String timeStamp, String bikeId, String bikeType) async {

    final userId = await _secureStorageApi.read(storageKeyUserId);
    final token = await _secureStorageApi.read(storageKeyToken);

    try {
      final data = await _networkApiService.triggerBikeConnectedEvent(timeStamp, bikeId, bikeType, userId!, token!);
      return data;

    } on NetworkException {
      rethrow;

    } catch (e) {
      rethrow;
    }
  }

}
