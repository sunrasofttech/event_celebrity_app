import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:mobi_user/Bloc/AccountBloc/AccountState.dart';

import '../../Utility/const.dart';
import '../../main.dart';
import 'AccountModel.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(InitialState());

  getHistory(int pageKey, String startDate, String endDate) async {
    log("Get History");
    String uid = await pref.getString("key").toString();
    var headers = {
      'Content-Type': "application/json",
      'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
    };
    emit(InitialState());
    try {
      emit(LoadingState());
      final resp = await http.post(
        Uri.parse(transactionHistoryApi),
        body: json.encode(
          {
            "userId": uid,
            "fromDate": startDate,
            "toDate": endDate,
            "page": pageKey,
          },
        ),
        headers: headers,
      );
      print("Data Body=> ${json.encode(
        {
          "userId": uid,
          "fromDate": startDate,
          "toDate": endDate,
          "page": pageKey,
        },
      )}");
      final result = jsonDecode(resp.body);
      if (resp.statusCode == 200) {
        if (result["status"]) {
          log("Response=> ${resp.body}");
          emit(LoadedState(transactionHistoryModelFromJson(resp.body)));
        } else {
          emit(ErrorState(result["error"]));
        }
      } else {
        repository.failureMessage(
          url: resp.request!.url.toString(),
          data: resp.body,
          statusCode: resp.statusCode.toString(),
        );
        emit(ErrorState(result["error"]));
      }
    } catch (e, stk) {
      log("Catch Error On Account Transaction => $e, $stk");
      emit(InitialState());
    }
  }
}
