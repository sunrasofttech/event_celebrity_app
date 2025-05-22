import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/Auth/RegisterBloc/RegisterModel.dart';
import 'package:mobi_user/Utility/const.dart';

import '../../../main.dart';
import 'RegisterState.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(InitialState());

  signUp({
    required String username,
    required String email,
    required String mobile,
    required String pass,
    required String refer,
    required String source,
  }) async {
    try {
      log("Username=>$username Phone No=>$mobile & $pass=>$pass Refer $refer");
      emit(LoadingState());
      var data = {
        "name": username,
        // "email": email,
        "mobile": mobile,
        "password": pass,
        "source": source,
        "deviceToken": pref.getString(sharedPrefFCMTokenKey),
      };
      final resp = await repository.postRequest(registerApi, data);
      final Map<String, dynamic> result = jsonDecode(resp.body);
      if (resp.statusCode == 200) {
        if (result["status"]) {
          emit(LoadedState(registerModelFromJson(resp.body)));
        } else {
          emit(ErrorState(result["error"]));
        }
      } else {
        emit(ErrorState(result["error"]));
        repository.failureMessage(
          url: resp.request!.url.toString(),
          data: resp.body,
          statusCode: resp.statusCode.toString(),
        );
      }
    } catch (e, stk) {
      log("Catch error on register $e, $stk");
      emit(InitialState());
    }
  }
}
