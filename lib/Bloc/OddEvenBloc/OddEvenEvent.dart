import 'package:equatable/equatable.dart';

abstract class OddEvenEvent extends Equatable {}

class OddEvenListEvent extends OddEvenEvent {
  final String shortCode;
  OddEvenListEvent(this.shortCode );
  @override
  // TODO: implement props
  List<Object?> get props => [shortCode ];
}
