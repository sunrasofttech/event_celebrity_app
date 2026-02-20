import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner_celebrity/Bloc/SettingBloc/SettingModel.dart';
import 'package:planner_celebrity/Bloc/SettingBloc/SettingState.dart';
import 'package:planner_celebrity/Utility/const.dart';

import '../../main.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit() : super(SettingInitState()) {
    getSettingsApiCall();
  }

  getSettingsApiCall() async {
    try {
      emit(SettingLoadingState());

      var headers = {
        'Authorization': "Bearer ${pref.getString(sharedPrefAPITokenKey)}",
        "Content-Type": "application/json",
      };
      final resp = await repository.getRequest(
        "$settingApi",
        header: headers,
      );
      final result = jsonDecode(jsonEncode(resp.data));
      log("Settings API response : $result");
      if (resp.statusCode == 200) {
        if (result["status"]) {
          emit(SettingLoadedState(SettingModel.fromJson(resp.data)));
        } else {
          emit(
            SettingErrorState(
              result["error"]?.toString() ??
                  result["message"]?.toString() ??
                  "Something went wrong",
            ),
          );
        }
      } else {
        emit(
          SettingErrorState(
            result["error"]?.toString() ??
                result["message"]?.toString() ??
                "Something went wrong",
          ),
        );
      }
    } catch (e, stk) {
      print("------------->>>>>> catch error on setting $e, stk $stk");
      emit(SettingInitState());
    }
  }
}
