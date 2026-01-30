import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:planner_celebrity/Bloc/get_all_earing/get_all_earing_model.dart';
import 'package:planner_celebrity/Utility/const.dart';
import 'package:planner_celebrity/main.dart';

part 'get_all_earing_state.dart';

class GetAllEaringCubit extends Cubit<GetAllEaringState> {
  GetAllEaringCubit() : super(GetAllEaringInitialState());
   getAllEaring() async {
    try {
      emit(GetAllEaringLoadingState());
      final resp = await repository.getRequest(
        getAllEaringApi,

        header: {
          'Content-Type': 'application/json',
          'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
        },
      );
      final Map<String, dynamic> result = jsonDecode(jsonEncode(resp.data));
      log("--- $result");
      if (resp.statusCode == 200) {
        if (result["status"]) {
          emit(
            GetAllEaringLoadedState(GetAllEaringModel.fromJson(resp.data)),
          );
        } else {
          emit(GetAllEaringErrorState(result["message"]));
        }
      } else {
        if (result["message"] == "Login limit exceeded contact admin") {
          emit(GetAllEaringErrorState(result["error"]));
        } else {
          emit(GetAllEaringErrorState(result["message"]));
        }
      }
    } catch (e, stk) {
      log("Catch Error on Login : $e, $stk");
      emit(GetAllEaringInitialState());
    }
  }
}
