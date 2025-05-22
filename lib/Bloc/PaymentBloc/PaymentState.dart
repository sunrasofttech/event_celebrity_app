import 'package:equatable/equatable.dart';

import 'PaymentModel.dart';

abstract class PaymentState extends Equatable{}
class InitialState extends PaymentState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class LoadingState extends PaymentState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class LoadedState extends PaymentState{
  final PaymentModel model;
  LoadedState({required this.model});
  @override
  // TODO: implement props
  List<Object?> get props => [model];
}
class ErrorState extends PaymentState{
  final String error;
  ErrorState(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}