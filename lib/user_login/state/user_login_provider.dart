import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final obscurePasswordProvider = StateProvider<bool>((ref) => true);

final authenticationRepositoryProvider = Provider<AuthenticationRepository>((ref) => AuthenticationRepository());

class UserAuthNotifier extends AsyncNotifier<String> {
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<String> build() {
    _authenticationRepository = ref.read(authenticationRepositoryProvider);
    return Future.value(null);
  }

  Future<void> authenticateUser(String username, String password) async {
    state = const AsyncValue.loading();
    try {
      final token = await _authenticationRepository.authenticateUserByCredentials(username, password);
      state = AsyncValue.data(token);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final userAuthProvider = AsyncNotifierProvider<UserAuthNotifier, String>(() {
  return UserAuthNotifier();
});


