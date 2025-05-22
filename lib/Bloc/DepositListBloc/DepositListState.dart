import 'package:equatable/equatable.dart';
import '../../model/DepositModel.dart';

abstract class DepositListState extends Equatable{}
class DepositInitState extends DepositListState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class DepositLoadingState extends DepositListState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class DepositLoadedState extends DepositListState{
  final DepositModel model;
  DepositLoadedState(this.model);
  @override
  // TODO: implement props
  List<Object?> get props => [model];
}
class DepositErrorState extends DepositListState{
  final String error;
  DepositErrorState(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}