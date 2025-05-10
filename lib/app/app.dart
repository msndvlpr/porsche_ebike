import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porsche_ebike_code_challenge/bike_dashboard/view/bike_dashboard_screen.dart';
import '../user_login/view/login_screen.dart';


class App extends StatelessWidget {

  const App({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: LoginScreen()
        );
  }
}
