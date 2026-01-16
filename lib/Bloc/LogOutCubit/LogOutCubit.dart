import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner_celebrity/main.dart';

import '../../Utility/const.dart';
import 'LogOutState.dart';

class LogOutCubit extends Cubit<LogOutState> {
  LogOutCubit() : super(LogOutInitialState());

  logOutApiCall() async {
    try {
      emit(LogOutLoadingState());
      var headers = {'Authorization': pref.getString(sharedPrefAPITokenKey) ?? ""};
      final resp = await repository.postRequest(logOutApi, {}, header: headers);
      final result = jsonDecode(resp.body);
      if (resp.statusCode == 200) {
        emit(LogOutLoadedState("Logout successful"));
      } else {
        emit(LogOutErrorState(result["error"]));
      }
    } catch (e) {
      emit(LogOutErrorState(e.toString()));
    }
  }
}
