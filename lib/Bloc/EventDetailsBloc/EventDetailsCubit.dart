import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner_celebrity/Utility/const.dart';

import '../../../main.dart';
import 'EventDetailsModel.dart';
import 'EventDetailsState.dart';

class EventDetailsCubit extends Cubit<EventDetailsState> {
  EventDetailsCubit() : super(EventDetailsInitialState());

  getEventDetails(String eventId) async {
    try {
      emit(EventDetailsLoadingState());

      final token = await pref.getString(sharedPrefAPITokenKey);

      final resp = await repository.getRequest(
        "${Constants.baseUrl}/api/celebrity/getEventById/$eventId",
        header: {"Authorization": "Bearer $token"},
      );

      final Map<String, dynamic> result = jsonDecode(jsonEncode(resp.data));
      log(
        "EVENT DETAILS RESPONSE :- $result. $token. $getEventByIdApi/$eventId",
      );

      if (resp.statusCode == 200) {
        if (result["status"] == true) {
          emit(EventDetailsLoadedState(EventDetailsModel.fromJson(result)));
        } else {
          emit(EventDetailsErrorState(repository.errorMessage(result)));
        }
      } else {
        emit(EventDetailsErrorState(repository.errorMessage(result)));
      }
    } catch (e, stk) {
      print("Catch Error in Event Details: $e\n$stk");
      emit(EventDetailsErrorState("Something went wrong"));
      emit(EventDetailsInitialState());
    }
  }
}
