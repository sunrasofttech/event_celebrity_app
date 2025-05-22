import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable{}
class GeneratePayment extends PaymentEvent{
  final String amount;
  GeneratePayment(this.amount);
  @override
  // TODO: implement props
  List<Object?> get props => [amount];

}
