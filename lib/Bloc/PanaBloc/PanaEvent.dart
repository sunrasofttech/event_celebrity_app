import 'package:equatable/equatable.dart';

abstract class PanaEvent extends Equatable {}

class PanaListEvent extends PanaEvent {
  final String shortCode;
  final String digit;
  PanaListEvent(this.shortCode, this.digit);
  @override
  // TODO: implement props
  List<Object?> get props => [shortCode, digit];
}
