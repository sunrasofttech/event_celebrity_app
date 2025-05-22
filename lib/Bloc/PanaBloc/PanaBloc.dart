import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/PanaBloc/PanaEvent.dart';
import 'package:mobi_user/Bloc/PanaBloc/PanaState.dart';
import 'package:mobi_user/main.dart';
import 'package:mobi_user/model/PanaModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utility/const.dart';

class PanaBloc extends Bloc<PanaEvent, PanaState> {
  PanaBloc() : super(PanaInitialState()) {
    on<PanaListEvent>((event, emit) async {
      try {
        emit(PanaLoadingState());
        SharedPreferences pref = await SharedPreferences.getInstance();
        String uid = pref.getString("key").toString();
        log("this is pana list event :- ${event.shortCode}, ${event.digit}");
        var headers = {
          'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
        };
        final resp = await repository.postRequest(
          searchDigitApi,
          {"tableName": event.shortCode, "digit": event.digit},
          header: headers,
        );
        final result = jsonDecode(resp.body);
        log("this is pana list event response:- $result");
        if (resp.statusCode == 200) {
          if (result["status"]) {
            emit(PanaLoadedState(panaModelFromJson(resp.body)));
          } else {
            emit(PanaErrorState(result["msg"]));
          }
        } else {
          log("Error in api ${resp.body}");
        }
      } catch (e, stk) {
        log("Error in PanaListEvent api:- $e, $stk");
        emit(PanaInitialState());
      }
    });
  }
}
