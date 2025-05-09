import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:network_api/network_api_service.dart';
import 'package:network_api/src/mock_http_login_handler.dart';
import 'model/bike_asset_data.dart';

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class NetworkApiService {

  final String baseUrl;
  NetworkApiService({this.baseUrl = "some-mocked-base-url"});

  Future<dynamic> getBikeAssetData(String bikeId, String bikeType, String userId, String token) async {
    try {
      final queryParams = {'bikeId': bikeId, 'bikeType': bikeType};
      final uri = Uri.https(baseUrl, '/api/bike-asset', queryParams);
      final headers = {"User": userId, 'Authorization': 'Bearer $token'};
      final timeOut = const Duration(seconds: 10);
      final response = await MockHttpDataHandler.httpClient.get(uri, headers: headers).timeout(timeOut);

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
