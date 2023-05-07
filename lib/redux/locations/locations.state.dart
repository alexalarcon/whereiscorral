import 'locations.model.dart';

class LocationsState {
  final bool loading;
  final String error;
  final List<LocationModel> locations;
  final LocationModel location;

  LocationsState(this.loading, this.error, this.locations, this.location);

  factory LocationsState.initial() =>
      LocationsState(false, '', const [], LocationModel());

  LocationsState copyWith({
    bool? loading,
    String? error,
    List<LocationModel>? locations,
    LocationModel? location,
  }) =>
      LocationsState(loading ?? this.loading, error ?? this.error,
          locations ?? this.locations, location ?? this.location);
}
