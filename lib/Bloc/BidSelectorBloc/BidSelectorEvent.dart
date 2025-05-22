import 'package:equatable/equatable.dart';

abstract class BidSelectorEvent extends Equatable{}
class InitEvent extends BidSelectorEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}
class SelectEvent extends BidSelectorEvent{
  final String marketType;
  SelectEvent(this.marketType);
  @override
  // TODO: implement props
  List<Object?> get props => [marketType];
}