import 'package:equatable/equatable.dart';

import 'OddEvenModel.dart';

abstract class OddEvenState extends Equatable {}

class OddEvenInitialState extends OddEvenState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OddEvenLoadingState extends OddEvenState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OddEvenLoadedState extends OddEvenState {
  final OddEvenModel model;
  OddEvenLoadedState(this.model);
  @override
  // TODO: implement props
  List<Object?> get props => [model];
}

class OddEvenHalfLoadedState extends OddEvenState {
  final OddEvenModel model;
  OddEvenHalfLoadedState(this.model);
  @override
  // TODO: implement props
  List<Object?> get props => [model];
}

class OddEvenErrorState extends OddEvenState {
  final String error;
  OddEvenErrorState(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
