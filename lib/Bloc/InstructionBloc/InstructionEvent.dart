import 'package:equatable/equatable.dart';

abstract class InstructionEvent extends Equatable{}

class FetchInstructionEvent extends InstructionEvent{
  final String type;
  FetchInstructionEvent(this.type);
  @override
  // TODO: implement props
  List<Object?> get props => [type];
}

