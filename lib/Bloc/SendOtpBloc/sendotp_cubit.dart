import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:planner_celebrity/Bloc/SendOtpBloc/sendotp_model.dart';
import 'package:planner_celebrity/Bloc/SendOtpBloc/sendotp_state.dart';
import 'package:planner_celebrity/main.dart';

import '../../Utility/const.dart';

class SendOtpCubit extends Cubit<SendOtpState> {
  SendOtpCubit() : super(SendOtpInitial());
  sendOtp(String phone) async {
    try {
      emit(SendOtpLoadingState());
      // var headers = {'Authorization': pref.getString(sharedPrefAPITokenKey) ?? ""};

      // var data = json.encode({"id": bidId});
      final _resp = await repository.postRequest("${sendOtpApiUrl}", {"mobile": phone});
      final resp = jsonDecode(_resp.data);
      log("Send OTP Response: ${_resp.data}");

      final result = jsonDecode(jsonEncode(resp));
      if (_resp.statusCode == 200) {
        if (result["success"]) {
          emit(SendOtpLoadedState(sendOtpModelFromJson(_resp.data)));
        } else {
          emit(SendOtpErrorState(result["message"]));
        }
      } else {
        emit(SendOtpErrorState(result["message"]));
        log("Message=> \n Status Code =>${_resp.statusCode} \n Response =>${_resp.data} ");
      }
    } catch (e, stk) {
      log("Message=> \n error $e, stk $stk");
      emit(SendOtpErrorState(e.toString()));
      throw Exception(e);
    }
  }
}
