import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:planner_celebrity/Bloc/get_dashboard/get_dashboard_model.dart';
import 'package:planner_celebrity/Utility/const.dart';
import 'package:planner_celebrity/main.dart';

part 'get_dashboard_state.dart';

class GetDashboardCubit extends Cubit<GetDashboardState> {
  GetDashboardCubit() : super(GetDashboardInitial());

  getDash() async {
    try {
      emit(GetDashboardLoadingState());
      final resp = await repository.getRequest(
        "${Constants.baseUrl}/api/celebrity/getDashboardDatatwo",

        header: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${pref.getString(sharedPrefAPITokenKey) ?? ""}",
        },
      );
      final Map<String, dynamic> result = jsonDecode(jsonEncode(resp.data));
      log("--- $result");
      if (resp.statusCode == 200) {
        if (result["status"]) {
          emit(GetDashboardLoadedState(GetDashboardModel.fromJson(resp.data)));
        } else {
          emit(GetDashboardErrorState(result["message"]));
        }
      } else {
        if (result["message"] == "Login limit exceeded contact admin") {
          emit(GetDashboardErrorState(result["error"]));
        } else {
          emit(GetDashboardErrorState(result["message"]));
        }
      }
    } catch (e, stk) {
      log("Catch Error on Login : $e, $stk");
    }
  }
}
