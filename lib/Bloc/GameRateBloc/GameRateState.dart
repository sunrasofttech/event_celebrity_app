import 'package:equatable/equatable.dart';
import 'package:mobi_user/Bloc/GameRateBloc/GameRateModel.dart';

abstract class GameRateState extends Equatable {}

class InitialState extends GameRateState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadingState extends GameRateState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadedState extends GameRateState {
  final GameRateModel model;
  LoadedState(this.model);
  @override
  // TODO: implement props
  List<Object?> get props => [model];
}

class ErrorState extends GameRateState {
  final String error;
  ErrorState(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
