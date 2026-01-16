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
      var headers = {'Authorization': pref.getString(sharedPrefAPITokenKey) ?? ""};
      final resp = await repository.postRequest(settingApi, {}, header: headers);
      final result = jsonDecode(resp.body);
      log("Settings API response : $result");
      if (resp.statusCode == 200) {
        if (result["status"]) {
          emit(SettingLoadedState(settingModelFromJson(resp.body)));
        } else {
          emit(SettingErrorState(result["error"]));
        }
      } else {
        emit(SettingErrorState(result["message"]));
        repository.failureMessage(
          url: resp.request!.url.toString(),
          data: resp.body,
          statusCode: resp.statusCode.toString(),
        );
      }
    } catch (e, stk) {
      print("------------->>>>>> catch error on setting $e, stk $stk");
      emit(SettingInitState());
    }
  }
}
