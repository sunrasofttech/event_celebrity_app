import 'package:equatable/equatable.dart';
import '../../model/bankDetailsModel.dart';

abstract class WithdrawDetailsState extends Equatable {}

class WithdrawDetailsInitial extends WithdrawDetailsState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AccountAddedSuccessfullyState extends WithdrawDetailsState {
  BankDetailsModel bankDetails;

  AccountAddedSuccessfullyState({required this.bankDetails});
  @override
  // TODO: implement props
  List<Object?> get props => [bankDetails];
}

class WithdrawRequested extends WithdrawDetailsState {
  String message;
  bool isError;

  WithdrawRequested({required this.message, required this.isError});
  @override
  // TODO: implement props
  List<Object?> get props => [message, isError];
}
