import 'package:equatable/equatable.dart';

import 'RedJodiModel.dart';

abstract class RedJodiState extends Equatable {}

class RedJodiInitialState extends RedJodiState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class RedJodiLoadingState extends RedJodiState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class RedJodiLoadedState extends RedJodiState {
  final RedJodiModel model;
  RedJodiLoadedState(this.model);
  @override
  // TODO: implement props
  List<Object?> get props => [model];
}

class RedJodiHalfLoadedState extends RedJodiState {
  final RedJodiModel model;
  RedJodiHalfLoadedState(this.model);
  @override
  // TODO: implement props
  List<Object?> get props => [model];
}

class RedJodiErrorState extends RedJodiState {
  final String error;
  RedJodiErrorState(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
