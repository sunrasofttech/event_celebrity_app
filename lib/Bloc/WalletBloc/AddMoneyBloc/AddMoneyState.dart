import 'package:equatable/equatable.dart';

abstract class AddMoneyState extends Equatable {}

class AddMoneyInitState extends AddMoneyState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddMoneyLoadingState extends AddMoneyState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddMoneyLoadedState extends AddMoneyState {
  final String message;

  AddMoneyLoadedState(this.message);
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class AddMoneyErrState extends AddMoneyState {
  final String error;
  AddMoneyErrState(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
