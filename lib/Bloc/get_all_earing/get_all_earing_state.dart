part of 'get_all_earing_cubit.dart';

sealed class GetAllEaringState extends Equatable {
  const GetAllEaringState();
}

final class GetAllEaringInitialState extends GetAllEaringState {
  @override
  List<Object> get props => [];
}

final class GetAllEaringLoadedState extends GetAllEaringState {
  final GetAllEaringModel model;
  GetAllEaringLoadedState(this.model);
  @override
  List<Object> get props => [];
}

final class GetAllEaringLoadingState extends GetAllEaringState {
  @override
  List<Object> get props => [];
}

final class GetAllEaringErrorState extends GetAllEaringState {
  final String error;
  GetAllEaringErrorState(this.error);
  @override
  List<Object> get props => [error];
}
