import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:planner_celebrity/Bloc/avaibility/get_avalibility/get_avalibility_model.dart';
import 'package:planner_celebrity/Utility/const.dart';
import 'package:planner_celebrity/main.dart';

part 'get_avalibility_state.dart';

class GetAvalibilityCubit extends Cubit<GetAvalibilityState> {
  GetAvalibilityCubit() : super(GetAvalibilityInitialState());

  GetAvailability({
    int? year,
    int? month,
  }) async {
    try {
      emit(GetAvalibilityLoadingState());

      final now = DateTime.now();
      final int selectedYear = year ?? now.year;
      final int selectedMonth = month ?? now.month;

      final resp = await repository.getRequest(
        "${Constants.baseUrl}/api/celebrity/getOwnAvailabilitytwo?year=$selectedYear&month=$selectedMonth",
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
          emit(
            GetAvalibilityLoadedState(GetAvailabilityModel.fromJson(resp.data)),
          );
        } else {
          emit(GetAvalibilityErrorState(result["message"]));
        }
      } else {
        if (result["message"] == "Login limit exceeded contact admin") {
          emit(GetAvalibilityErrorState(result["error"]));
        } else {
          emit(GetAvalibilityErrorState(result["message"]));
        }
      }
    } catch (e, stk) {
      log("Catch Error on Login : $e, $stk");
      emit(GetAvalibilityInitialState());
    }
  }
}
