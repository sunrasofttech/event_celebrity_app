import 'package:equatable/equatable.dart';

abstract class PanaByAnkEvent extends Equatable {}

class PanaByAnkListEvent extends PanaByAnkEvent {
  final String shortCode;
  final String digit;
  PanaByAnkListEvent(this.shortCode, this.digit);
  @override
  // TODO: implement props
  List<Object?> get props => [shortCode, digit];
}
