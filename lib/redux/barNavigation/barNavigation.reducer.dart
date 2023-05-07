import 'barNavigation.state.dart';
import 'barNavigation.action.dart';

barNavigationReducer(BarNavigationState prevState, BarNavigationAction action) {
  final payload = action.actionState;
  return prevState.copyWith(
      loading: payload.loading,
      barNavigation: payload.barNavigation,
      barNavigations: payload.barNavigations,
      error: payload.error);
}
