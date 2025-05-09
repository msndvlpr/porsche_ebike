import 'dart:async';
import 'dart:math';

import 'package:http/http.dart';
import 'package:http/testing.dart' show MockClient;

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart';
import 'package:http/testing.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart';
import 'package:http/testing.dart';

class MockHttpDataHandler {
  MockHttpDataHandler._();

  static const user = 'user';

  static final BaseClient httpClient = MockClient((request) async {
    // Ensure auth header exists
    if (request.headers[user]?.isEmpty ?? true) {
      throw ClientException('Auth');
    }

    // Simulate delay
    await Future<void>.delayed(const Duration(seconds: 1));

    // Parse query parameters
    final uri = request.url;
    final bikeType = uri.queryParameters['bikeType'];

    if (bikeType == null) {
      return Response('Missing query param: bikeType', 400);
    }

    // Build mock response
    final mockData = _mockResponseForBikeType(bikeType);
    if (mockData == null) {
      return Response('Unknown bikeType', 404);
    }

    return Response(jsonEncode(mockData), 200, request: request);
  });

  static Map<String, dynamic>? _mockResponseForBikeType(String bikeType) {
    final id = Random().nextInt(1000000);

    switch (bikeType) {
      case 'MetroBee':
        return {
          'resourceId': id,
          'bikeDescription':
          'Conquer the concrete jungle with effortless speed and style. Glide through traffic, beat rush-hour, and make every ride a breeze.',
          'bikeImageUrl':
          'https://files.fazua.com/media/images/press_dt_8Fuq1nc.width-4096.jpegquality-50.jpg',
        };
      case 'CliffHanger':
        return {
          'resourceId': id,
          'bikeDescription':
          'Tame the toughest trails with power and precision. CliffHanger is built for bold climbs, sharp turns, and riders who never back down.',
          'bikeImageUrl':
          'https://files.fazua.com/media/images/brands_porsche_8xrevmT.width-4096.jpegquality-50.jpg',
        };
      default:
        return null;
    }
  }
}


