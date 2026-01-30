import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:planner_celebrity/Utility/const.dart';
import 'package:planner_celebrity/main.dart';

part 'set_availbilty_state.dart';

class SetAvailbiltyCubit extends Cubit<SetAvailbiltyState> {
  SetAvailbiltyCubit() : super(SetAvailbiltyInitialState());

  setAvailability(List<String> date, String status) async {
    try {
      emit(SetAvailbiltyLoadingState());
      final resp = await repository.postRequest(
        setAviApi,
        {"dates": date, "status": status},

        header: {
          'Content-Type': 'application/json',
          'Authorization':
              "Bearer ${pref.getString(sharedPrefAPITokenKey) ?? ""}",
        },
      );
      final Map<String, dynamic> result = jsonDecode(jsonEncode(resp.data));
      log("--- $result");
      if (resp.statusCode == 200) {
        if (result["status"]) {
          emit(SetAvailbiltyLoadedState());
        } else {
          emit(SetAvailbiltyErrorState(result["message"]));
        }
      } else {
        if (result["message"] == "Login limit exceeded contact admin") {
          emit(SetAvailbiltyErrorState(result["error"]));
        } else {
          emit(SetAvailbiltyErrorState(result["message"]));
        }
      }
    } catch (e, stk) {
      log("Catch Error on Login : $e, $stk");
      emit(SetAvailbiltyInitialState());
    }
  }
}
