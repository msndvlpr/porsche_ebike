import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:network_api/src/mock_http_login_handler.dart';
import 'model/bike_asset_data.dart';

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class NetworkApiService {

  final String baseUrl;
  NetworkApiService({this.baseUrl = "some-mocked-base-url"});

  Future<dynamic> getBikeAssetData(String bikeId, String userId, String token) async {
    try {
      final queryParams = {'bikeId': bikeId};
      final uri = Uri.https(baseUrl, '/api/bike-asset', queryParams);
      final headers = {"User": userId, 'Authorization': 'Bearer $token'};
      final timeOut = const Duration(seconds: 10);
      final response = await MockHttpLoginHandler.httpClient.get(uri, headers: headers).timeout(timeOut);

      final jsonMap = jsonDecode(response.body);
      if (response.statusCode == 200) {

        return BikeAssetData.fromJson(jsonMap);

      } else {
        debugPrint('Error ${response.statusCode}: ${response.reasonPhrase}');
        throw NetworkException('An unknown error occurred, please try again shortly.');

      }
    } on SocketException catch(e) {
      debugPrint(e.message);
      throw NetworkException('No Internet connection, please check your network.');

    } on TimeoutException catch(e) {
      debugPrint(e.message!);
      throw NetworkException('The request took too long to process, please try again shortly.');

    } on HttpException catch(e) {
      debugPrint(e.message);
      throw NetworkException('Error loading the data, please try again shortly.');

    } catch (e) {
      debugPrint(e.toString());
      throw NetworkException('An unknown error occurred, please try again shortly.');

    }
  }

  /*Future<dynamic> getAuctionVehicle(String eid, String userId, String token) async {
    try {
      final queryParams = {'eid': eid};
      final uri = Uri.https(baseUrl, '/api/vehicle-auction', queryParams);
      final headers = {CosChallenge.user: userId, 'Authorization': 'Bearer $token'};
      final timeOut = const Duration(seconds: 10);
      final response = await CosChallenge.httpClient.get(uri, headers: headers).timeout(timeOut);

      final jsonMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Parse success JSON to AuctionData
        return AuctionData.fromJson(jsonMap);

      } else if (response.statusCode == 400) {
        // Parse error message and return an exception or return an error object
        return ErrorResponse.fromJson(jsonMap);

      } else {
        debugPrint('Error ${response.statusCode}: ${response.reasonPhrase}');
        throw NetworkException('An unknown error occurred, please try again shortly.');

      }
    } on SocketException catch(e) {
      debugPrint(e.message);
      throw NetworkException('No Internet connection, please check your network.');

    } on TimeoutException catch(e) {
      debugPrint(e.message);
      throw NetworkException('The request took too long to process, please try again shortly.');

    } on HttpException catch(e) {
      debugPrint(e.message);
      throw NetworkException('Error loading the data, please try again shortly.');

    } catch (e) {
      debugPrint(e.toString());
      throw NetworkException('An unknown error occurred, please try again shortly.');

    }
  }*/

  Future<String> postUserLoginData(String credentials) async {
    try {

      final body = jsonEncode({'auth': credentials});
      final uri = Uri.https(baseUrl, '/api/login');
      final headers = {'Content-Type': 'application/json'};
      final timeOut = const Duration(seconds: 10);
      final loginResponse = await MockHttpLoginHandler.httpClient.post(uri, headers: headers, body: body).timeout(timeOut);

      if (loginResponse.statusCode == 200) {
        final token = jsonDecode(loginResponse.body)['token'];
        return token;

      } else if (loginResponse.statusCode == 401 || loginResponse.statusCode == 403) {
        final error = jsonDecode(loginResponse.body)['message'];
        throw NetworkException(error);

      } else {
        debugPrint('Error ${loginResponse.statusCode}: ${loginResponse.reasonPhrase}');
        throw NetworkException('An unknown error occurred, please try again shortly.');

      }
    } on SocketException catch(e) {
      debugPrint(e.message);
      throw NetworkException('No Internet connection, please check your network.');

    } on TimeoutException catch(e) {
      debugPrint(e.message);
      throw NetworkException('The request took too long to process, please try again shortly.');

    } on HttpException catch(e) {
      debugPrint(e.message);
      throw NetworkException('Error loading the data, please try again shortly.');

    } catch (e) {
      debugPrint(e.toString());
      throw NetworkException('An unknown error occurred, please try again shortly.');

    }
  }
}
