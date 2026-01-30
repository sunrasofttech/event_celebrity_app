import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner_celebrity/Utility/const.dart';

import '../../../main.dart';
import 'UserAppContentModel.dart';
import 'UserAppContentState.dart';

class GetUserAppContentCubit extends Cubit<GetUserAppContentState> {
  GetUserAppContentCubit() : super(GetUserAppContentInitialState());

  getUserAppContent() async {
    try {
      emit(GetUserAppContentLoadingState());

      final token = await pref.getString(sharedPrefAPITokenKey);

      final resp = await repository.getRequest(
        "${Constants.baseUrl}/api/user/app-content/celebrity",
        header: {"Authorization": "Bearer $token"},
      );

      final Map<String, dynamic> result = jsonDecode(jsonEncode(resp.data));
      log("USER APP CONTENT RESPONSE :- $result");

      if (resp.statusCode == 200) {
        if (result["status"] == true) {
          emit(
            GetUserAppContentLoadedState(UserAppContentModel.fromJson(result)),
          );
        } else {
          emit(GetUserAppContentErrorState(repository.errorMessage(result)));
        }
      } else {
        emit(GetUserAppContentErrorState(repository.errorMessage(result)));
      }
    } catch (e, stk) {
      print("Catch Error in User App Content: $e\n$stk");
      emit(GetUserAppContentErrorState("Something went wrong"));
      emit(GetUserAppContentInitialState());
    }
  }
}
