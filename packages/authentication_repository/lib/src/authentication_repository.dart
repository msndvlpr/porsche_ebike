import 'package:authentication_repository/src/rsa_crypto.dart';
import 'package:network_api/network_api_service.dart';
import 'package:secure_storage_api/secure_storage_api.dart';

import 'constants.dart';

class AuthenticationRepository {
  final NetworkApiService _networkApiService;
  final SecureStorageApi _secureStorageApi;

  AuthenticationRepository({
    NetworkApiService? networkApiService,
    SecureStorageApi? secureStorageApi
  })
      : _networkApiService = networkApiService ?? NetworkApiService(),
        _secureStorageApi = secureStorageApi ?? SecureStorageApi();

  Future<String> authenticateUserByCredentials(String username, String password) async {
    try {
      // Encrypt the username and password before sending to backend
      String encryptedUserCredentials = encryptData("$username:$password");

      final token = await _networkApiService.postUserLoginData(encryptedUserCredentials);
      if (token.isNotEmpty) {

        // Storing username and successful token resolution to the local secure storage
        await _secureStorageApi.write(storageKeyToken, token);
        await _secureStorageApi.write(storageKeyUserId, username);

        return token;
      } else {
        throw Exception("Error authenticating user, please try again shortly.");

      }
    } on NetworkException catch (e) {
      throw Exception(e.message);

    } on DataParsingException catch (_) {
      throw Exception('Error authenticating user, please contact the customer support team.');

    } catch (e) {
      throw Exception('Error authenticating user, please try again shortly.');

    }
  }
}

class DataParsingException implements Exception {
  final String message;

  DataParsingException(this.message);
}
