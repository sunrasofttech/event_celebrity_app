import 'package:equatable/equatable.dart';

abstract class PattiListEvent extends Equatable {}

class FetchPattiEvent extends PattiListEvent {
  final String type;
  final String q;
  FetchPattiEvent(this.type, this.q);
  @override
  // TODO: implement props
  List<Object?> get props => [type, q];
}
