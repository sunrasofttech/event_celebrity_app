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

      var headers = {
        'Authorization':
            "Bearer ${pref.getString(sharedPrefAPITokenKey) ?? ""}",
      };

      final resp = await repository.postRequest(logOutApi, {}, header: headers);

      // Check type
      Map<String, dynamic> result;
      if (resp.data is String) {
        result = jsonDecode(resp.data);
      } else if (resp.data is Map) {
        result = Map<String, dynamic>.from(resp.data);
      } else {
        throw Exception("Unexpected response type");
      }

      if (resp.statusCode == 200 && result["status"] == true) {
        emit(LogOutLoadedState(result["message"] ?? "Logout successful"));
      } else {
        String errorMessage = result["message"] ?? "Something went wrong";
        emit(LogOutErrorState(errorMessage));
      }
    } catch (e) {
      emit(LogOutErrorState(e.toString()));
    }
  }
}
