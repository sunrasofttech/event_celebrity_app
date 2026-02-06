import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:planner_celebrity/Utility/const.dart';
import 'package:planner_celebrity/main.dart';

part 'share_feedback_state.dart';

class ShareFeedbackCubit extends Cubit<ShareFeedbackState> {
  ShareFeedbackCubit() : super(ShareFeedbackInitialState());

  shareFeedback(String message) async {
    try {
      emit(ShareFeedbackLoadingState());

      final token = await pref.getString(sharedPrefAPITokenKey);

      final resp = await repository.postRequest(
        "${Constants.baseUrl}/api/feedback/celebrity",
        {
          "message": message,
        },
        
        header: {"Authorization": "Bearer $token"},
      );

      final Map<String, dynamic> result = jsonDecode(jsonEncode(resp.data));

      log("GET CELEBRITIES RESPONSE: $result");

      if (resp.statusCode == 200 || resp.statusCode==201) {
        if (result["status"] == true) {
          emit(ShareFeedbackLoadedState());
        } else {
          emit(ShareFeedbackErrorState(repository.errorMessage(result)));
        }
      } else {
        emit(ShareFeedbackErrorState(repository.errorMessage(result)));
      }
    } catch (e, stk) {
      log("GetCelebrities Catch Error: $e\n$stk");
      emit(ShareFeedbackErrorState("Something went wrong"));
      emit(ShareFeedbackInitialState());
    }
  }
}
