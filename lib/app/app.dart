import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_storage_api/secure_storage_api.dart';

import '../theme/app_theme.dart';
import '../theme/theme_notifier.dart';
import '../user_login/view/login_screen.dart';

class App extends ConsumerWidget {

  //final AuctionRepository auctionRepository;
  final AuthenticationRepository authenticationRepository;
  final SecureStorageApi secureStorageApi;

  //todo
  App({/*required this.auctionRepository,*/
      required this.authenticationRepository,
      required this.secureStorageApi,
      super.key});

  //final auctionRepositoryProvider = Provider<AuctionRepository>((ref) => throw UnimplementedError());
  final authenticationRepositoryProvider = Provider<AuthenticationRepository>((ref) => throw UnimplementedError());
  final secureStorageApiProvider = Provider<SecureStorageApi>((ref) => throw UnimplementedError());
  final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) => ThemeNotifier());

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final themeMode = ref.watch(appThemeProvider);

    return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: LoginScreen()
        );
  }
}
