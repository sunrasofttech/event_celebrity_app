import 'package:equatable/equatable.dart';
import 'package:planner_celebrity/Bloc/AccountBloc/AccountModel.dart';

abstract class AccountState extends Equatable {}

class InitialState extends AccountState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends AccountState {
  @override
  List<Object?> get props => [];
}

class LoadedState extends AccountState {
  final TransactionHistoryModel model;
  LoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class ErrorState extends AccountState {
  final String error;
  ErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
