import 'package:equatable/equatable.dart';

import '../../model/PanaModel.dart';
import 'PanaByAnkModel.dart';

abstract class PanaByAnkState extends Equatable {}

class PanaByAnkInitialState extends PanaByAnkState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class PanaByAnkLoadingState extends PanaByAnkState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class PanaByAnkLoadedState extends PanaByAnkState {
  final PanaByAnkModel model;
  PanaByAnkLoadedState(this.model);
  @override
  // TODO: implement props
  List<Object?> get props => [model];
}

class PanaByAnkHalfLoadedState extends PanaByAnkState {
  final PanaByAnkModel model;
  PanaByAnkHalfLoadedState(this.model);
  @override
  // TODO: implement props
  List<Object?> get props => [model];
}

class PanaByAnkErrorState extends PanaByAnkState {
  final String error;
  PanaByAnkErrorState(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
