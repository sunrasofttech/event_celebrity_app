import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utility/const.dart';
import '../../main.dart';
import 'subscription_model.dart';
import 'subscription_state.dart';

class GetSubscriptionsCubit extends Cubit<GetSubscriptionsState> {
  GetSubscriptionsCubit() : super(GetSubscriptionsInitial());

  Future<void> fetchSubscriptions() async {
    emit(GetSubscriptionsLoading());
    try {
      var _pref = await SharedPreferences.getInstance();
      var headers = {'Authorization': _pref.getString(sharedPrefAPITokenKey) ?? ""};
      final resp = await repository.postRequest(getAllSubscriptionApiUrl, {}, header: headers);
      final result = jsonDecode(resp.data);
      log("GetSubscriptionsCubit API response : $result");
      if (resp.statusCode == 200) {
        if (result["status"]) {
          emit(GetSubscriptionsLoaded(subscriptionModelFromJson(resp.data)));
        } else {
          emit(GetSubscriptionsError(result["error"]));
        }
      } else {
        emit(GetSubscriptionsError(result["message"]));
      }
    } catch (e, s) {
      log("GetSubscriptionsCubit API response : $e, $s");
      emit(GetSubscriptionsError(e.toString()));
    }
  }
}
