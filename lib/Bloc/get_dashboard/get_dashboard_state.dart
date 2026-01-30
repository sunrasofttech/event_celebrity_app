part of 'get_dashboard_cubit.dart';

sealed class GetDashboardState extends Equatable {}

final class GetDashboardInitial extends GetDashboardState {
  @override
  List<Object?> get props => [];
}

final class GetDashboardLoadingState extends GetDashboardState {
  @override
  List<Object?> get props => [];
}



final class GetDashboardLoadedState extends GetDashboardState {
  final GetDashboardModel model;
  GetDashboardLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetDashboardErrorState extends GetDashboardState {
  final String error;
  GetDashboardErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
