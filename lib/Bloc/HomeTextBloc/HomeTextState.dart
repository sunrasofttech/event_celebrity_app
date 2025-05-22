import 'package:equatable/equatable.dart';

import 'HomeTextModel.dart';

abstract class HomeTextState extends Equatable {}

class HomeTextInitState extends HomeTextState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class HomeTextLoadingState extends HomeTextState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class HomeTextLoadedState extends HomeTextState {
  final HomeTextModel model;
  HomeTextLoadedState(this.model);
  @override
  // TODO: implement props
  List<Object?> get props => [model];
}

class HomeTextErrorState extends HomeTextState {
  final String error;
  HomeTextErrorState(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
