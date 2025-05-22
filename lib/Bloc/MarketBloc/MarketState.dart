import 'package:equatable/equatable.dart';

import 'MarketModel.dart';

abstract class MarketState extends Equatable {}

class MarketInitState extends MarketState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MarketLoadingState extends MarketState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MarketLoadedState extends MarketState {
  final MarketModel market;
  MarketLoadedState(this.market);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MarketErrorState extends MarketState {
  final String error;
  MarketErrorState(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class MarketUnAuthorizedState extends MarketState {
  final MarketModel model;
  MarketUnAuthorizedState(this.model);
  @override
  // TODO: implement props
  List<Object?> get props => [model];
}

class InValidTokenState extends MarketState {
  final bool model;
  InValidTokenState(this.model);
  @override
  // TODO: implement props
  List<Object?> get props => [model];
}
