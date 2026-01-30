part of 'get_profile_cubit.dart';

sealed class GetProfileState extends Equatable {}

final class GetProfileInitial extends GetProfileState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class GetProfileLoadingState extends GetProfileState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class GetProfileLoadedState extends GetProfileState {
  final GetProfileModel model;
  GetProfileLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetProfileErrorState extends GetProfileState {
  final String error;
  GetProfileErrorState(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}