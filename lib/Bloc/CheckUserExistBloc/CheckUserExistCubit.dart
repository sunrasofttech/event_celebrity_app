import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

import '../../Utility/const.dart';
import '../../main.dart';
import 'CheckUserExitState.dart';

class CheckUserCubit extends Cubit<CheckUserState> {
  CheckUserCubit() : super(CheckUserInitialState());

  Future<void> checkUserExist(String mobile) async {
    emit(CheckUserLoadingState());
    try {
      log("Checking user with mobile: $mobile");
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
      };
      final body = jsonEncode({
        "mobile": mobile,
      });

      final response = await post(
        Uri.parse(checkUserExistApi),
        headers: headers,
        body: body,
      );

      log("API Response: ${response.body}");

      final result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final userType = result["user_type"];
        if (userType != null) {
          emit(CheckUserLoadedState(userType));
        } else {
          emit(CheckUserErrorState("Invalid response from server."));
        }
      } else {
        emit(CheckUserErrorState(result["error"] ?? "Unknown error occurred."));
        log("Error in API response: ${response.body}");
      }
    } catch (e, stk) {
      emit(CheckUserErrorState("Exception: $e"));
      log("Exception occurred while checking user: $e, $stk");
    }
  }
}
