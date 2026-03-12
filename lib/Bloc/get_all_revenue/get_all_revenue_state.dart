part of 'get_all_revenue_cubit.dart';

sealed class GetAllRevenueState extends Equatable {}

final class GetAllRevenueInitial extends GetAllRevenueState {
  @override
  List<Object?> get props => [];
}


final class GetAllRevenueLoadingState extends GetAllRevenueState {
  @override
  List<Object?> get props => [];
}



final class GetAllRevenueLoadedState extends GetAllRevenueState {
  final GetAllRevenueModel model;
  GetAllRevenueLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}



final class GetAllRevenueErrorState extends GetAllRevenueState {
  final String error;
  GetAllRevenueErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
