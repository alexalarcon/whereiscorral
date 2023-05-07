import 'locations.action.dart';
import 'locations.state.dart';

locationsReducer(LocationsState prevState, LocationsAction action) {
  final payload = action.locationsState;
  return prevState.copyWith(
      loading: payload.loading,
      location: payload.location,
      locations: payload.locations,
      error: payload.error);
}
