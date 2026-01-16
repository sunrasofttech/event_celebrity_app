import 'package:equatable/equatable.dart';
import 'ReferModel.dart';
abstract class ReferState extends Equatable{}
class InitialState extends ReferState {
  @override
  List<Object> get props => [];
}
class LoadingState extends ReferState {
  @override
  List<ReferModel> get props => [];
}
class LoadedState extends ReferState {
  final ReferModel refer;
  LoadedState(this.refer);

  @override
  List<ReferModel> get props => [refer];
}
class ErrorState extends ReferState {
  final String error;
  ErrorState(this.error);
  @override
  List<Object> get props => [error];
}

