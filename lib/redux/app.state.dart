import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:whereiscorral/redux/locations/locations.action.dart';
import 'package:whereiscorral/redux/locations/locations.reducer.dart';
import 'package:whereiscorral/redux/locations/locations.state.dart';

import 'auth/auth_actions.dart';
import 'auth/auth_reducer.dart';
import 'auth/auth_state.dart';
import 'barNavigation/barNavigation.action.dart';
import 'barNavigation/barNavigation.reducer.dart';
import 'barNavigation/barNavigation.state.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is LocationsAction) {
    final actionState = locationsReducer(state.locationsState, action);
    return state.copyWith(
      locationsState: actionState,
      barNavigationState: state.barNavigationState,
      authState: state.authState,
    );
  }
  if (action is BarNavigationAction) {
    final actionState = barNavigationReducer(state.barNavigationState, action);
    return state.copyWith(
      locationsState: state.locationsState,
      barNavigationState: actionState,
      authState: state.authState,
    );
  }
  if (action is AuthStateAction) {
    final actionState = authReducer(state.authState, action);
    return state.copyWith(
      locationsState: state.locationsState,
      barNavigationState: state.barNavigationState,
      authState: actionState,
    );
  }

  return state;
}

class AppState {
  final LocationsState locationsState;
  final BarNavigationState barNavigationState;
  final AuthState authState;

  AppState({
    required this.locationsState,
    required this.barNavigationState,
    required this.authState,
  });

  factory AppState.initial() => AppState(
      locationsState: LocationsState.initial(),
      barNavigationState: BarNavigationState.initial(),
      authState: AuthState.initial());
  AppState copyWith({
    required LocationsState locationsState,
    required BarNavigationState barNavigationState,
    required AuthState authState,
  }) {
    //revisar cuando no traigan
    return AppState(
      locationsState: locationsState,
      barNavigationState: barNavigationState,
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
    final locationsState = LocationsState.initial();

    final barNavigationState = BarNavigationState.initial();

    final authState = AuthState.initial();

    _store = Store<AppState>(
      appReducer,
      middleware: [thunkMiddleware],
      initialState: AppState(
          locationsState: locationsState,
          barNavigationState: barNavigationState,
          authState: authState),
    );
  }
}
