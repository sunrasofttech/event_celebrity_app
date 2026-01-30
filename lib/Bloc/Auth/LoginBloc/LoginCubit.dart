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
      final resp = await repository.postRequest(
        loginApi,
        {"emailOrMobile": mobile, "password": pass},
        header: {'Content-Type': 'application/json'},
      );
      final Map<String, dynamic> result = jsonDecode(jsonEncode(resp.data));
      log("--- $result");
      if (resp.statusCode == 200) {
        if (result["status"]) {
          emit(LoadedState(LoginModel.fromJson(resp.data)));
        } else {
          emit(ErrorState(result["message"]));
        }
      } else {
        if (result["message"] == "Login limit exceeded contact admin") {
          emit(LimitReachState(result["error"]));
        } else {
          emit(ErrorState(result["message"]));
        }
      }
    } catch (e, stk) {
      log("Catch Error on Login : $e, $stk");
      emit(InitialState());
    }
  }
}
