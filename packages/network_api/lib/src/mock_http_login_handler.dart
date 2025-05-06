import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart';
import 'package:http/testing.dart';

class MockHttpLoginHandler {
  MockHttpLoginHandler._();

  static const String _validToken = 'mocked_jwt_token';

  static final BaseClient httpClient = MockClient((request) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    if (request.url.path == '/api/login' && request.method == 'POST') {
      return _handleLoginRequest(request);

    } else {
      return Response(jsonEncode({'error': 'Requested service is not found'}), 404);
    }

  });


  static Future<Response> _handleLoginRequest(Request request) async {

    final Map<String, dynamic> body = jsonDecode(request.body);
    final String auth = body['auth'];

    // Simulate a checking the user authentication info whether is valid or not
    final credentialsMatched = true;
    if (credentialsMatched) {
      return Response(jsonEncode({'token': _validToken}), 200);
    } else {
      return Response(jsonEncode({'message': 'Incorrect username or password.'}), Random().nextBool() ? 401 : 403);
    }
  }
}


