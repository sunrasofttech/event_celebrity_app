import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:planner_celebrity/Utility/const.dart';
import 'package:planner_celebrity/main.dart';
part 'update_notification_state.dart';

class UpdateNotificationCubit extends Cubit<UpdateNotificationState> {
  UpdateNotificationCubit() : super(UpdateNotificationInitial());

  updateNotification({
    required bool enableAll,
    required bool orderEmail,
    required bool orderPush,
    required bool orderSms,
    required bool orderWhatsapp,
    required bool promotionEmail,
    required bool promotionPush,
    required bool promotionSms,
    required bool promotionWhatsapp,
  }) async {
    try {
      emit(UpdateNotificationLoadingState());

      final token = await pref.getString(sharedPrefAPITokenKey);

      final resp = await repository.patchMultipart(
        withFormData: false,
        "${Constants.baseUrl}/api/celebrity/notification-settings",
        {
          "enable_all": enableAll,
          "order_email": orderEmail,
          "order_push": orderPush,
          "order_sms": orderSms,
          "order_whatsapp": orderWhatsapp,
          "promotion_email": promotionEmail,
          "promotion_push": promotionPush,
          "promotion_sms": promotionSms,
          "promotion_whatsapp": promotionWhatsapp,
        },
        header: {"Authorization": "Bearer $token"},
      );

      final Map<String, dynamic> result = jsonDecode(jsonEncode(resp.data));

      log("GET CELEBRITIES RESPONSE: $result");

      if (resp.statusCode == 200) {
        if (result["status"] == true) {
          emit(UpdateNotificationLoadedState());
        } else {
          emit(UpdateNotificationErrorState(repository.errorMessage(result)));
        }
      } else {
        emit(UpdateNotificationErrorState(repository.errorMessage(result)));
      }
    } catch (e, stk) {
      log("GetCelebrities Catch Error: $e\n$stk");
      emit(UpdateNotificationErrorState("Something went wrong"));
    }
  }
}
