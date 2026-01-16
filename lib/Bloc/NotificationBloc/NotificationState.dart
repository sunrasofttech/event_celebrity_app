import 'package:equatable/equatable.dart';
import 'package:planner_celebrity/Bloc/NotificationBloc/NotificationModel.dart';

abstract class NotificationState extends Equatable {}

class InitialState extends NotificationState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends NotificationState {
  @override
  List<Object?> get props => [];
}

class LoadedState extends NotificationState {
  final NotificationModel model;
  LoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class ErrorState extends NotificationState {
  final String error;
  ErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
