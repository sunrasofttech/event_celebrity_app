import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner_celebrity/Utility/const.dart';

import '../../../main.dart';
import 'LoginModel.dart';
import 'LoginState.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(InitialState());

  signIn(String mobile, String pass) async {
    try {
      log("Phone No=>$mobile & $pass=>$pass");
      emit(LoadingState());
      final resp = await repository.postRequest(loginApi, {
        "mobile": mobile,
        "password": pass,
        "deviceToken": pref.getString(sharedPrefFCMTokenKey).toString(),
      });
      final Map<String, dynamic> result = jsonDecode(resp.body);
      if (resp.statusCode == 200) {
        if (result["status"]) {
          emit(LoadedState(loginModelFromJson(resp.body)));
        } else {
          emit(ErrorState(result["error"]));
        }
      } else {
        if (result["error"] == "Login limit exceeded contact admin") {
          emit(LimitReachState(result["error"]));
        } else {
          emit(ErrorState(result["error"]));
          repository.failureMessage(
            url: resp.request!.url.toString(),
            data: resp.body,
            statusCode: resp.statusCode.toString(),
          );
        }
      }
    } catch (e, stk) {
      log("Catch Error on Login : $e, $stk");
      emit(InitialState());
    }
  }
}
