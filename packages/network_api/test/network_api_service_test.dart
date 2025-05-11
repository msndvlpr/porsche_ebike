import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_api/network_api_service.dart';

class MockHttpClient extends Mock implements Client {}

void main() {
  late MockHttpClient mockHttpClient;
  late NetworkApiService networkApiService;

  const jsonBody200Response = '''
   {
          'resourceId': 454645,
          'bikeDescription':
          'Conquer the concrete jungle with effortless speed and style. Glide through traffic, beat rush-hour, and make every ride a breeze.',
          'bikeImageUrl': 'https://files.fazua.com/media/images/mobility-2.width-2880.jpegquality-50.jpg',
          'bikeModel': 'MetroBee'
    }''';

  const jsonBody200TokenResponse = '''{"token":"some-jwt-token"}''';
  const testBaseUrl = 'some-mocked-testing-url';

  setUp(() {
    mockHttpClient = MockHttpClient();
    networkApiService = NetworkApiService(baseUrl: testBaseUrl);
  });

  group('NetworkApiService', () {

    test(
        'should respond 200 with BikeAssetData when bike asset endpoint ts called',
        () async {
      when(() => mockHttpClient.get(Uri.parse('$testBaseUrl/api/bike-asset')))
          .thenAnswer((invocation) async {
        return Response(jsonBody200Response, 200);
      });
      final data = networkApiService.getBikeAssetData('bikeId', 'bikeType', 'userAuthId', 'token');
      expect(data, isNotNull);
      expect(data, isA<Future<dynamic>>());
      data.then((result){
        expect(result, isA<BikeAssetData>());
      });
    });

    test(
        'should respond 200 with success token when login endpoint ts called with credentials',
            () async {
          when(() => mockHttpClient.post(Uri.parse('$testBaseUrl/api/login')))
              .thenAnswer((invocation) async {
            return Response(jsonBody200TokenResponse, 200);
          });
          final data = networkApiService.postUserLoginData('user-credentials');
          expect(data, isNotNull);
          expect(data, isA<Future<String>>());
          data.then((result) {
            expect(result, contains('token'));
          });
        });
  });

}
