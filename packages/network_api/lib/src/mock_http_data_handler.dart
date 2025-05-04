import 'dart:async';
import 'dart:math';

import 'package:http/http.dart';
import 'package:http/testing.dart' show MockClient;

class MockHttpDataHandler {
  MockHttpDataHandler._();

  static const user = 'user';

  static final BaseClient httpClient = MockClient((request) async {

      if (request.headers[user]?.isEmpty ?? true) throw ClientException('Auth');
      final length = _ResponseCode.values.length;
      final code = Random().nextInt(length + 1) + (length - 1);
      await Future<void>.delayed(const Duration(seconds: 1));

      if (code > length + 1) throw TimeoutException('Timed-out');
      final response = _ResponseCode.values.elementAt(code - (length - 1));

      final body = response.whenConst(
        success: response._success, error: null,
      );

      return Response(body!, code * 100, request: request);
    },
  );
}

enum _ResponseCode {
  success,
  error;

  const _ResponseCode();

  R whenConst<R>({
    required R success,
    required R error,
  }) {
    switch (this) {
      case _ResponseCode.success:
        return success;
      case _ResponseCode.error:
        return error;
    }
  }

  String get _success => '''
   {
      "resourceId": ${Random().nextInt(1000000)},
      "bikeDescription": "description for MetroBee ebike",
      "bikeImageUrl": "https://files.fazua.com/media/images/press_dt_8Fuq1nc.width-4096.jpegquality-50.jpg"
    }
''';

}
