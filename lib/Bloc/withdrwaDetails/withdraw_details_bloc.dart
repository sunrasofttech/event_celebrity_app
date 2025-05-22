import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/withdrwaDetails/withdraw_details_event.dart';
import 'package:mobi_user/Bloc/withdrwaDetails/withdraw_details_state.dart';
import 'package:mobi_user/error/api_failures.dart';
import 'package:mobi_user/model/bankDetailsModel.dart';

import '../../Repository/paymentRepository.dart';

class WithdrawDetailsBloc extends Bloc<WithdrawDetailsEvent, WithdrawDetailsState> {
  WithdrawDetailsBloc() : super(WithdrawDetailsInitial()) {
    on<AddBankDetailsEvent>((event, emit) async {
      // TODO: implement event handler

      // TODO: implement event handler

      var data = await PaymentRepository().addAccount(
        bankAccount: event.bankAcc,
        upiPay: event.upiPay,
        ifsc: event.ifsc,
        paytm: event.paytm,
        placeholder: event.placeholder,
        phonePe: event.phonepe,
        bankName: event.bankName,
      );
      data.fold(
        // TODO: Need to show error here change it later on..

        (left) => emit(
          WithdrawRequested(message: left.failureMessage, isError: true),
        ),
        (right) {
          emit(
            WithdrawRequested(message: "done successfully", isError: false),
          );
        },
      );
      add(FetchBankDetailsEvent());
    });
    on<FetchBankDetailsEvent>((event, emit) async {
      // TODO: implement event handler

      // TODO: implement event handler

      var data = await PaymentRepository().getBankDetails();

      data.fold(
          // TODO: Need to show error here change it later on..
          (left) => emit(
                AccountAddedSuccessfullyState(bankDetails: BankDetailsModel.empty()),
              ), (right) {
        emit(AccountAddedSuccessfullyState(bankDetails: right));
      });
    });

    on<WithdrawPaymentEvent>((event, emit) async {
      // TODO: implement event handler

      // TODO: implement event handler

      var data = await PaymentRepository().withdrawPayment(account: event.account, amount: event.amount);
      data.fold(
          // TODO: Need to show error here change it later on..
          (left) => emit(
                WithdrawRequested(message: left.failureMessage, isError: true),
              ), (right) {
        emit(
          WithdrawRequested(message: "Withdrawal Request Submitted Successfully", isError: false),
        );
      });
    });
  }
}
