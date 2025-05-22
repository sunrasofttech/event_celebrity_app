import 'package:equatable/equatable.dart';

import '../../model/PanaModel.dart';

abstract class PanaState extends Equatable {}

class PanaInitialState extends PanaState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class PanaLoadingState extends PanaState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class PanaLoadedState extends PanaState {
  final PanaModel model;
  PanaLoadedState(this.model);
  @override
  // TODO: implement props
  List<Object?> get props => [model];
}

class PanaHalfLoadedState extends PanaState {
  final PanaModel model;
  PanaHalfLoadedState(this.model);
  @override
  // TODO: implement props
  List<Object?> get props => [model];
}

class PanaErrorState extends PanaState {
  final String error;
  PanaErrorState(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
