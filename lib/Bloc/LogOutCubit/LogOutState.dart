import 'package:equatable/equatable.dart';

abstract class LogOutState extends Equatable {}

class LogOutInitialState extends LogOutState {
  @override
  List<Object> get props => [];
}

class LogOutLoadingState extends LogOutState {
  @override
  List<Object> get props => [];
}

class LogOutLoadedState extends LogOutState {
  final String refer;
  LogOutLoadedState(this.refer);

  @override
  List<String> get props => [refer];
}

class LogOutErrorState extends LogOutState {
  final String error;
  LogOutErrorState(this.error);
  @override
  List<Object> get props => [error];
}
