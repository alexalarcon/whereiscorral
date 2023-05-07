import '../App.state.dart';
import 'package:redux/redux.dart';

import 'barNavigation.model.dart';
import 'barNavigation.state.dart';

class BarNavigationAction {
  final BarNavigationState actionState;

  BarNavigationAction(this.actionState);

  @override
  String toString() {
    return 'BarNavigationAction { }';
  }
}

Future<void> barNavigationIndexAction(
    Store<AppState> store, currentIndex) async {
  BarNavigationModel barNavigation =
      store.state.barNavigationState.barNavigation;

  barNavigation.currentIndex = currentIndex;
  store.dispatch(BarNavigationAction(BarNavigationState(false, "",
      store.state.barNavigationState.barNavigations, barNavigation)));
}
