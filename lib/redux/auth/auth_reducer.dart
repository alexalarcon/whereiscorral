import 'auth_actions.dart';
import 'auth_state.dart';

authReducer(AuthState prevState, AuthStateAction action) {
  final payload = action.authState;
  return prevState.copyWith(
    isError: payload.isError,
    isLoading: payload.isLoading,
    auth: payload.auth,
    user: payload.user,
    claims: payload.claims,
    errorMessage: payload.errorMessage,
    isLogin: payload.isLogin,
  );
}
