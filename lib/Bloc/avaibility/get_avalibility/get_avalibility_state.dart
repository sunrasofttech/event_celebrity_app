part of 'get_avalibility_cubit.dart';

sealed class GetAvalibilityState extends Equatable {
  const GetAvalibilityState();
}

final class GetAvalibilityInitialState extends GetAvalibilityState {
  @override
  List<Object> get props => [];
}

final class GetAvalibilityLoadingState extends GetAvalibilityState {
  @override
  List<Object> get props => [];
}

final class GetAvalibilityLoadedState extends GetAvalibilityState {
  final GetAvailabilityModel model;
  GetAvalibilityLoadedState(this.model);
  @override
  List<Object> get props => [];
}

final class GetAvalibilityErrorState extends GetAvalibilityState {
  final String error;
  GetAvalibilityErrorState(this.error);
  @override
  List<Object> get props => [error];
}
