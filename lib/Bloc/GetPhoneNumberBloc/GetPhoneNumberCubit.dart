import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/GetPhoneNumberBloc/GetPhoneNumberState.dart';
import 'package:mobi_user/Utility/const.dart';

import '../../main.dart';

class GetPhoneNumberCubit extends Cubit<GetPhoneNumberState> {
  GetPhoneNumberCubit() : super(GetPhoneNumberInitState()) {
    getGetPhoneNumbersApiCall();
  }

  getGetPhoneNumbersApiCall() async {
    try {
      emit(GetPhoneNumberLoadingState());
      var headers = {
        'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
      };
      final resp = await repository.postRequest(getPhoneNumberApi, {}, header: headers);
      final result = jsonDecode(resp.body);
      log("GetPhoneNumbers API response : $result");
      if (resp.statusCode == 200) {
        if (result["status"]) {
          emit(GetPhoneNumberLoadedState(result["data"][0]["phone"]));
        } else {
          emit(GetPhoneNumberErrorState(result["error"]));
        }
      } else {
        emit(GetPhoneNumberErrorState(result["message"]));
        repository.failureMessage(
          url: resp.request!.url.toString(),
          data: resp.body,
          statusCode: resp.statusCode.toString(),
        );
      }
    } catch (e) {
      emit(GetPhoneNumberInitState());
    }
  }
}
