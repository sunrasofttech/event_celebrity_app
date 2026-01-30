part of 'get_all_events_cubit.dart';

sealed class GetAllEventsState extends Equatable {}

final class GetAllEventsInitial extends GetAllEventsState {
  @override
  List<Object?> get props => [];
}

final class GetAllEventsLoadingState extends GetAllEventsState {
  @override
  List<Object?> get props => [];
}

final class GetAllEventsLoadedState extends GetAllEventsState {
  final GetAllUpComingEventModel model;
  GetAllEventsLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetAllEventsErrorState extends GetAllEventsState {
  final String error;
  GetAllEventsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}