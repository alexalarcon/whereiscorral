import 'barNavigation.model.dart';

class BarNavigationState {
  final bool loading;
  final String error;
  final List<BarNavigationModel> barNavigations;
  final BarNavigationModel barNavigation;

  BarNavigationState(
      this.loading, this.error, this.barNavigations, this.barNavigation);

  factory BarNavigationState.initial() =>
      BarNavigationState(false, '', const [], BarNavigationModel());

  BarNavigationState copyWith({
    bool? loading,
    String? error,
    List<BarNavigationModel>? barNavigations,
    BarNavigationModel? barNavigation,
  }) =>
      BarNavigationState(
          loading ?? this.loading,
          error ?? this.error,
          barNavigations ?? this.barNavigations,
          barNavigation ?? this.barNavigation);
}
