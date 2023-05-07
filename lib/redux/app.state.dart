import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'auth/auth_actions.dart';
import 'auth/auth_reducer.dart';
import 'auth/auth_state.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is AuthStateAction) {
    final actionState = authReducer(state.authState, action);
    return state.copyWith(
      authState: actionState,
    );
  }

  return state;
}

class AppState {
  final AuthState authState;

  AppState({
    required this.authState,
  });

  factory AppState.initial() => AppState(authState: AuthState.initial());
  AppState copyWith({
    required AuthState authState,
  }) {
    //revisar cuando no traigan
    return AppState(
      authState: authState,
    );
  }
}

class Redux {
  static Store<AppState> _store = AppState.initial() as Store<AppState>;

  static Store<AppState> get store {
    return _store;
  }

  static Future<void> init() async {
    final authState = AuthState.initial();

    _store = Store<AppState>(
      appReducer,
      middleware: [thunkMiddleware],
      initialState: AppState(authState: authState),
    );
  }
}
