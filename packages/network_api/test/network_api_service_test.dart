/*import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_api/network_api_service.dart';

class MockHttpClient extends Mock implements Client {}

void main() {
  late MockHttpClient mockHttpClient;
  late NetworkApiService networkApiService;

  const jsonBody200Response = '''
 {
      "id": 52972,
      "feedback": "Please modify the price.",
      "valuatedAt": "2023-01-05T14:08:40.456Z",
      "requestedAt": "2023-01-05T14:08:40.456Z",
      "createdAt": "2023-01-05T14:08:40.456Z",
      "updatedAt": "2023-01-05T14:08:42.153Z",
      "make": "Toyota",
      "model": "GT 86 Basis",
      "externalId": "DE003-018601450020008",
      "_fk_sellerUser": "25475e37-6973-483b-9b15-cfee721fc29f",
      "price": 327,
      "positiveCustomerFeedback": false,
      "_fk_uuid_auction": "3e255ad2-36d4-4048-a962-5e84e27bfa6e",
      "inspectorRequestedAt": "2023-01-05T14:08:40.456Z",
      "origin": "AUCTION",
      "estimationRequestId": "3a295387d07f"
    }''';
  const jsonBody300Response = '''[
     {
        "make": "Toyota",
        "model": "GT 86 Basis",
        "containerName": "DE - Cp2 2.0 EU5, 2012 - 2015",
        "similarity": 53,
        "externalId": "DE001-018601450020001"
    },
    {
        "make": "Toyota",
        "model": "GT 86 Basis",
        "containerName": "DE - Cp2 2.0 EU6, (EURO 6), 2015 - 2017",
        "similarity": 50,
        "externalId": "DE002-018601450020001"
    },
    {
        "make": "Toyota",
        "model": "GT 86 Basis",
        "containerName": "DE - Cp2 2.0 EU6, Basis, 2017 - 2020",
        "similarity": 0,
        "externalId": "DE003-018601450020001"
    }
]''';
  const jsonBody400Response = '''{
  "msgKey": "maintenance",
  "params": { "delaySeconds": "3" },
  "message": "Please try again in 3 seconds"
  }''';

  const jsonBody200TokenResponse = '''{"token":"some-jwt-token"}''';
  const testBaseUrl = 'some-mocked-testing-url';

  setUp(() {
    mockHttpClient = MockHttpClient();
    networkApiService = NetworkApiService(baseUrl: testBaseUrl);
  });

  group('getAuctionData', () {

    test(
        'GIVEN NetworkApiService as the http handler api WHEN http get method is called with a vin THEN should respond 200 with data',
        () async {
      when(() => mockHttpClient.get(Uri.parse('$testBaseUrl/api/vin-lookup')))
          .thenAnswer((invocation) async {
        return Response(jsonBody200Response, 200);
      });
      final data = networkApiService.getAuctionData('vin', 'user-id', 'token');
      expect(data, isNotNull);
      expect(data, isA<Future<dynamic>>());
      data.then((result){
        expect(result, isA<AuctionData>());
      });
    });

    test(
        'GIVEN NetworkApiService as the http handler api WHEN http get method is called with a vin THEN should respond 300 with multiple choice data',
            () async {
          when(() => mockHttpClient.get(Uri.parse('$testBaseUrl/api/vin-lookup')))
              .thenAnswer((invocation) async {
            return Response(jsonBody300Response, 300);
          });
          final data = networkApiService.getAuctionData('vin', 'user-id', 'token');
          expect(data, isNotNull);
          expect(data, isA<Future<dynamic>>());
          data.then((result){
            expect(result, isA<VehicleOptionItems>());
          });
        });

    test(
        'GIVEN NetworkApiService as the http handler api WHEN http get method is called with a vin THEN should respond 400 with error response',
            () async {
          when(() => mockHttpClient.get(Uri.parse('$testBaseUrl/api/vin-lookup')))
              .thenAnswer((invocation) async {
            return Response(jsonBody400Response, 400);
          });
          final data = networkApiService.getAuctionData('vin', 'user-id', 'token');
          expect(data, isNotNull);
          expect(data, isA<Future<dynamic>>());
          data.then((result){
            expect(result, isA<ErrorResponse>());
          });
        });

  });

  group('getAuctionVehicle', () {

    test(
        'GIVEN NetworkApiService as the http handler api WHEN http get method is called with an external id THEN should respond 200 with data',
            () async {
          when(() => mockHttpClient.get(Uri.parse('$testBaseUrl/api/vehicle-auction')))
              .thenAnswer((invocation) async {
            return Response(jsonBody200Response, 200);
          });
          final data = networkApiService.getAuctionVehicle('ein', 'user-id', 'token');
          expect(data, isNotNull);
          expect(data, isA<Future<dynamic>>());
          data.then((result){
            expect(result, isA<AuctionData>());
          });
        });

    test(
        'GIVEN NetworkApiService as the http handler api WHEN http get method is called with an external id THEN should respond 400 with error response',
            () async {
          when(() => mockHttpClient.get(Uri.parse('$testBaseUrl/api/vehicle-auction')))
              .thenAnswer((invocation) async {
            return Response(jsonBody400Response, 400);
          });
          final data = networkApiService.getAuctionData('ein', 'user-id', 'token');
          expect(data, isNotNull);
          expect(data, isA<Future<dynamic>>());
          data.then((result){
            expect(result, isA<ErrorResponse>());
          });
        });

  });

  group('postUserAuthenticationInfo', ()
  {
    test(
        'GIVEN NetworkApiService as the http handler api WHEN http get method is called with user credentials THEN should respond 200 with token',
            () async {
          when(() => mockHttpClient.post(Uri.parse('$testBaseUrl/api/login')))
              .thenAnswer((invocation) async {
            return Response(jsonBody200TokenResponse, 200);
          });
          final data = networkApiService.postUserAuthenticationInfo('user-credentials');
          expect(data, isNotNull);
          expect(data, isA<Future<String>>());
          data.then((result) {
            expect(result, contains('token'));
          });
        });
  });
}
*/