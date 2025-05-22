import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utility/const.dart';
import 'OddEvenEvent.dart';
import 'OddEvenModel.dart';
import 'OddEvenState.dart';

class OddEvenBloc extends Bloc<OddEvenEvent, OddEvenState> {
  OddEvenBloc() : super(OddEvenInitialState()) {
    on<OddEvenListEvent>((event, emit) async {
      try {
        emit(OddEvenLoadingState());
        SharedPreferences pref = await SharedPreferences.getInstance();
        String uid = pref.getString("key").toString();
        log("this is Odd Even list event :- ${event.shortCode}");
        var headers = {
          'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
        };
        final resp = await repository.postRequest(
          oddEvenApi,
          {"type": event.shortCode},
          header: headers,
        );
        final result = jsonDecode(resp.body);
        log("this is Odd Even list event response:- $result");
        if (resp.statusCode == 200) {
          if (result["status"]) {
            emit(OddEvenLoadedState(oddEvenModelFromJson(resp.body)));
          } else {
            emit(OddEvenErrorState(result["message"]));
          }
        } else {
          log("Error in api ${resp.body}");
          emit(OddEvenErrorState(result["message"]));
        }
      } catch (e, stk) {
        log("Error in OddEven api:- $e, $stk");
        emit(OddEvenInitialState());
      }
    });
  }
}
