import 'package:equatable/equatable.dart';
import 'package:planner_celebrity/Bloc/Auth/RegisterBloc/RegisterModel.dart';

abstract class RegisterState extends Equatable {}

class InitialState extends RegisterState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends RegisterState {
  @override
  List<Object?> get props => [];
}

class LoadedState extends RegisterState {
  final RegisterModel model;
  LoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class ErrorState extends RegisterState {
  final String error;
  ErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
