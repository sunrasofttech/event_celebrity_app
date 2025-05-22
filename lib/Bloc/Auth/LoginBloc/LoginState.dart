import 'package:equatable/equatable.dart';
import 'package:mobi_user/Bloc/Auth/LoginBloc/LoginModel.dart';

abstract class LoginState extends Equatable {}

class InitialState extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoadedState extends LoginState {
  final LoginModel model;
  LoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class ErrorState extends LoginState {
  final String error;
  ErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
