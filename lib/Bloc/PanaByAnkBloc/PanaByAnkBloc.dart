import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/PanaByAnkBloc/PanaByAnkState.dart';
import 'package:mobi_user/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utility/const.dart';
import 'PanaByAnkEvent.dart';
import 'PanaByAnkModel.dart';

class PanaByAnkBloc extends Bloc<PanaByAnkEvent, PanaByAnkState> {
  PanaByAnkBloc() : super(PanaByAnkInitialState()) {
    on<PanaByAnkListEvent>((event, emit) async {
      try {
        emit(PanaByAnkLoadingState());
        SharedPreferences pref = await SharedPreferences.getInstance();
        String uid = pref.getString("key").toString();
        log("this is pana by ank list event :- ${event.shortCode}, ${event.digit}");
        var headers = {
          'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
        };
        final resp = await repository.postRequest(
          panaListApi,
          {"type": event.shortCode, "digit": event.digit},
          header: headers,
        );
        final result = jsonDecode(resp.body);
        log("this is pana by ank list event response:- $result");
        if (resp.statusCode == 200) {
          if (result["status"]) {
            emit(PanaByAnkLoadedState(panaByAnkModelFromJson(resp.body)));
          } else {
            emit(PanaByAnkErrorState(result["msg"]));
          }
        } else {
          log("Error in api ${resp.body}");
        }
      } catch (e, stk) {
        log("Error in PanaListEvent api:- $e, $stk");
        emit(PanaByAnkInitialState());
      }
    });
  }
}
