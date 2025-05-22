import 'package:equatable/equatable.dart';

import '../../model/InstructionModel.dart';
abstract class InstructionState extends Equatable{}
class InstructionInitState extends InstructionState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class InstructionLoadingState extends InstructionState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class InstructionLoadedState extends InstructionState{
  final InstructionModel model;
  InstructionLoadedState(this.model);
  @override
  // TODO: implement props
  List<Object?> get props => [model];
}
class InstructionLoadedDataState extends InstructionState{
  final InstructionModel model;
  InstructionLoadedDataState(this.model);
  @override
  // TODO: implement props
  List<Object?> get props => [model];
}
class InstructionErrorState extends InstructionState{
  final String message;
  InstructionErrorState(this.message);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}