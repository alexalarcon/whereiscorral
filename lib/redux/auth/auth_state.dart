import 'package:firebase_auth/firebase_auth.dart';

import 'auth.model.dart';

class AuthState {
  final bool isError;
  final String errorMessage;
  final bool isLoading;
  final bool isLogin;

  final AuthModel auth;
  final User? user;
  final Map<String, dynamic>? claims;

  AuthState(
    this.isError,
    this.errorMessage,
    this.isLoading,
    this.auth,
    this.user,
    this.claims,
    this.isLogin,
  );

  factory AuthState.initial() =>
      AuthState(false, "", false, AuthModel(), null, {}, false);

  AuthState copyWith({
    bool? isError,
    String? errorMessage,
    bool? isLoading,
    bool? isLogin,
    AuthModel? auth,
    User? user,
    Map<String, dynamic>? claims,
  }) {
    return AuthState(
      isError ?? this.isError,
      errorMessage ?? this.errorMessage,
      isLoading ?? this.isLoading,
      auth ?? this.auth,
      user ?? this.user,
      claims ?? this.claims,
      isLogin ?? this.isLogin,
    );
  }
}
