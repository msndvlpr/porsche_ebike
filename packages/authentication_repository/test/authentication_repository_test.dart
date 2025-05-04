/*import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_api/network_api_service.dart';
import 'package:secure_storage_api/secure_storage_api.dart';

class MockNetworkApiService extends Mock implements NetworkApiService {}

class MockSecureStorageApi extends Mock implements SecureStorageApi {}

void main() {
  late MockNetworkApiService mockNetworkApiService;
  late MockSecureStorageApi mockSecureStorageApi;
  late AuthenticationRepository authenticationRepository;

  setUp(() {
    mockNetworkApiService = MockNetworkApiService();
    mockSecureStorageApi = MockSecureStorageApi();
    authenticationRepository = AuthenticationRepository(networkApiService: mockNetworkApiService, secureStorageApi: mockSecureStorageApi,
    );

    registerFallbackValue('fallback-value');
  });

  group('authenticateUserByCredentials', () {
    test(
      'GIVEN AuthenticationRepository WHEN username and password are provided THEN should get token from API service and return',
          () async {
        when(() => mockNetworkApiService.postUserAuthenticationInfo(any()))
            .thenAnswer((_) async => 'some-jwt-token');

        when(() => mockSecureStorageApi.write(any(), any()))
            .thenAnswer((_) async => Future.value());

        final data = await authenticationRepository.authenticateUserByCredentials('username', 'password');

        expect(data, isNotNull);
        expect(data, isA<String>());
        expect(data, contains('some-jwt-token'));

        verify(() => mockSecureStorageApi.write(storageKeyToken, 'some-jwt-token')).called(1);
        verify(() => mockSecureStorageApi.write(storageKeyUserId, 'username')).called(1);
      },
    );
  });
}
*/