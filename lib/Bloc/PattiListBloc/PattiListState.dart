import 'package:equatable/equatable.dart';
import 'package:mobi_user/Bloc/PattiListBloc/PattiModel.dart';

abstract class PattiListState extends Equatable {}

class InitialPattiState extends PattiListState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadingPattiState extends PattiListState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadedPattiState extends PattiListState {
  final PattiModel model;
  LoadedPattiState(this.model);
  @override
  // TODO: implement props
  List<Object?> get props => [model];
}

class ErrorPattiState extends PattiListState {
  final String error;
  ErrorPattiState(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
