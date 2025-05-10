import 'dart:developer';
import 'dart:ui';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:secure_storage_api/secure_storage_api.dart';
import 'app/app.dart';
import 'app/observers.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('de_DE', null);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    log(error.toString(), stackTrace: stack);
    return true;
  };


  runApp(ProviderScope(
    observers: [
      Observers()
    ],
    child: App()));
}



