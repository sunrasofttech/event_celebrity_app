import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:planner_celebrity/Bloc/get_profile/get_profile_model.dart';
import 'package:planner_celebrity/Utility/const.dart';
import 'package:planner_celebrity/main.dart';

part 'get_profile_state.dart';

class GetProfileCubit extends Cubit<GetProfileState> {
  GetProfileCubit() : super(GetProfileInitial());

  getProfile() async {
    try {
      emit(GetProfileLoadingState());
      final resp = await repository.getRequest(
        "${Constants.baseUrl}/api/celebrity/profile",

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
          emit(GetProfileLoadedState(GetProfileModel.fromJson(resp.data)));
        } else {
          emit(GetProfileErrorState(result["message"]));
        }
      } else {
        if (result["message"] == "Login limit exceeded contact admin") {
          emit(GetProfileErrorState(result["error"]));
        } else {
          emit(GetProfileErrorState(result["message"]));
        }
      }
    } catch (e, stk) {
      log("Catch Error on Login : $e, $stk");
    }
  }
}
