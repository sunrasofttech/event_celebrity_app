import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/main.dart';

import '../../Utility/const.dart';
import 'NotificationModel.dart';
import 'NotificationState.dart';

class NotificationCubit extends Cubit<NotificationState> {
  List<NotificationModel> model = [];

  NotificationCubit() : super(InitialState());

  getNotification(int page, int pageSize) async {
    log("Pagination Call");
    emit(LoadingState());
    try {
      String uid = await pref.getString("key").toString();
      var headers = {
        'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
      };
      final resp = await repository.postRequest(
        notificationApi,
        {"userId": uid},
        header: headers,
      );
      final result = jsonDecode(resp.body);
      log("Response Here=> ${resp.body}");
      if (resp.statusCode == 200) {
        if (result["status"]) {
          emit(LoadedState(notificationModelFromJson(resp.body)));
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
      log("Catch getNotification Here=> $e, $stk");
      emit(InitialState());
    }
  }
}
