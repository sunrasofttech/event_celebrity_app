import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:mobi_user/Bloc/CheckBankBloc/CheckBankModel.dart';
import 'package:mobi_user/Bloc/CheckBankBloc/CheckBankState.dart';

import '../../Utility/const.dart';
import '../../main.dart';

class CheckBankCubit extends Cubit<CheckBankState> {
  CheckBankCubit() : super(CheckInitialState());
  fetchBankData(String uid, String type) async {
    emit(CheckLoadingState());
    try {
      log("UserId $uid");
      var headers = {
        'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
      };
      final resp = await post(
        Uri.parse("${checkBankDetailApi}/$uid"),
        headers: headers,
      );
      log("Check ---> ${resp.body}");

      final result = jsonDecode(resp.body);
      if (resp.statusCode == 200) {
        final availableModel = CheckBankModel(status: true, error: 0, success: 1, message: "Available");
        if (result["status"] == true) {
          log("Check");
          if (type == "bank" && result["data"]["accountNo"] != null && result["data"]["accountNo"] != "") {
            emit(CheckLoadedState(availableModel));
          } else if (type == "upi" && result["data"]["UPI"] != null && result["data"]["UPI"] != "") {
            emit(CheckLoadedState(availableModel));
          }
        } else {
          print("Error in api bro=>" + result["error"]);
          emit(CheckErrorState(result["error"]));
        }
      } else {
        emit(CheckErrorState(result["error"]));
        log("Error in api ${resp.body}");
      }
    } catch (e, stk) {
      emit(CheckInitialState());
      log("Catch Error in fetch api $e, $stk");
    }
  }
}
