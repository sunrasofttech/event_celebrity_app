import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner_celebrity/Utility/const.dart';
import 'package:planner_celebrity/main.dart';

import 'AddMoneyState.dart';

class AddMoneyCubit extends Cubit<AddMoneyState> {
  AddMoneyCubit() : super(AddMoneyInitState());

  addWalletMoney({required String uid, required String paymentStatus, required String merchantTxnId}) async {
    try {
      emit(AddMoneyLoadingState());
      var headers = {'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "", "Content-Type": "application/json"};
      Map<String, dynamic> body = {
        "userId": uid,
        "merchantTransactionId": merchantTxnId,
        "paymentStatus": paymentStatus,
      };
      final resp = await repository.postRequest(addMoneyToWalletApi, jsonEncode(body), header: headers);

      print("Response Param=>${body}");
      final result = jsonDecode(resp.data);
      print("this is add money response => $result, Status Code => ${resp.statusCode}");
      if (resp.statusCode == 200) {
        if (result["status"] == true) {
          emit(AddMoneyLoadedState(result["msg"]));
        } else {
          emit(AddMoneyErrState(result["msg"]));
        }
      } else if (resp.statusCode == 400) {
        print("Error 400");
        emit(AddMoneyErrState(result["msg"]));
        // repository.failureMessage(
        //   url: resp.request!.url.toString(),
        //   data: resp.body,
        //   statusCode: resp.statusCode.toString(),
        // );
      }
    } catch (e, stk) {
      print("Catch Error on Add Money Cubit:- $e, $stk");
      emit(AddMoneyInitState());
    }
  }
}
