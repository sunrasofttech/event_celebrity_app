import 'package:equatable/equatable.dart';

abstract class CancelBidState extends Equatable {}

class CancelBidInitialState extends CancelBidState {
  @override
  List<Object?> get props => [];
}

class CancelBidLoadingState extends CancelBidState {
  @override
  List<Object?> get props => [];
}

class CancelBidLoadedState extends CancelBidState {
  final String model;
  CancelBidLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class CancelBidErrorState extends CancelBidState {
  final String error;
  CancelBidErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
