import 'package:equatable/equatable.dart';



abstract class WithdrawDetailsEvent extends Equatable {}

class AddBankDetailsEvent extends WithdrawDetailsEvent {
  String bankAcc, paytm, phonepe, ifsc, upiPay,placeholder,bankName;

  AddBankDetailsEvent({
    required this.bankAcc,
    required this.paytm,
    required this.phonepe,
    required this.upiPay,
    required this.ifsc,
    required this.placeholder,
    required this.bankName,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WithdrawPaymentEvent extends WithdrawDetailsEvent {
  String amount, account;

  WithdrawPaymentEvent({
    required this.account,
    required this.amount,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [account, account];
}

class FetchBankDetailsEvent extends WithdrawDetailsEvent {
  FetchBankDetailsEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
