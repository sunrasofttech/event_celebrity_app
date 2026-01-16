import 'package:equatable/equatable.dart';
import 'package:planner_celebrity/Bloc/CheckBankBloc/CheckBankModel.dart';

abstract class CheckBankState extends Equatable {}

class CheckInitialState extends CheckBankState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CheckLoadingState extends CheckBankState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CheckLoadedState extends CheckBankState {
  final CheckBankModel model;
  CheckLoadedState(this.model);
  @override
  // TODO: implement props
  List<Object?> get props => [model];
}

class CheckErrorState extends CheckBankState {
  final String error;
  CheckErrorState(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
