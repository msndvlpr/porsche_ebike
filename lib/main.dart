import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/app.dart';
import 'app/observers.dart';
import 'package:desktop_window/desktop_window.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('de_DE', null);

  Size size = await DesktopWindow.getWindowSize();
  await DesktopWindow.setWindowSize(Size(size.width, size.height));
  await DesktopWindow.setMinWindowSize(Size(size.width, size.height));

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



