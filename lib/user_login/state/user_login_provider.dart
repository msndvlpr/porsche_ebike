import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final obscurePasswordProvider = StateProvider<bool>((ref) => true);

final authenticationRepositoryProvider = Provider<AuthenticationRepository>((ref) => AuthenticationRepository());

class UserAuthNotifier extends StateNotifier<UserAuthState> {
  UserAuthNotifier(this.authenticationRepository)
      : super(UserAuthDataStateInitial());

  final AuthenticationRepository authenticationRepository;

  Future<void> authenticateUser(String username, String password) async {
    state = UserAuthDataStateLoading();
    try {
      final data = await authenticationRepository.authenticateUserByCredentials(username, password);
      state = UserAuthDataStateSuccess(token: data);
    } catch (e) {
      state = UserAuthDataStateFailure(errorMessage: e.toString());
    }
  }
}

final userAuthProvider = StateNotifierProvider<UserAuthNotifier, UserAuthState>((ref) {
  return UserAuthNotifier(ref.read(authenticationRepositoryProvider));
});

sealed class UserAuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserAuthDataStateInitial extends UserAuthState {}

class UserAuthDataStateLoading extends UserAuthState {}

class UserAuthDataStateSuccess extends UserAuthState {
  final String token;

  UserAuthDataStateSuccess({required this.token});

  @override
  List<Object?> get props => [token];
}

class UserAuthDataStateFailure extends UserAuthState {
  final String errorMessage;

  UserAuthDataStateFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
