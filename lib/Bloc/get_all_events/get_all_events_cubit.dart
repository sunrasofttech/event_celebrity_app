import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:planner_celebrity/Bloc/get_all_events/get_all_events_model.dart';
import 'package:planner_celebrity/Utility/const.dart';
import 'package:planner_celebrity/main.dart';

part 'get_all_events_state.dart';

class GetAllEventsCubit extends Cubit<GetAllEventsState> {
  GetAllEventsCubit() : super(GetAllEventsInitial());

  getAllEvent() async {
    try {
      emit(GetAllEventsLoadingState());

      final resp = await repository.getRequest(
        "${Constants.baseUrl}/api/celebrity/getCelebrityBookingEvents",
        header: {
          'Content-Type': 'application/json',
          'Authorization':
              "Bearer ${pref.getString(sharedPrefAPITokenKey) ?? ""}",
        },
      );
      final Map<String, dynamic> result = jsonDecode(jsonEncode(resp.data));
      log("--- $result");
      if (resp.statusCode == 200) {
        if (result["status"]) {
          emit(
            GetAllEventsLoadedState(
              GetAllUpComingEventModel.fromJson(resp.data),
            ),
          );
        } else {
          emit(GetAllEventsErrorState(result["message"]));
        }
      } else {
        if (result["message"] == "Login limit exceeded contact admin") {
          emit(GetAllEventsErrorState(result["error"]));
        } else {
          emit(GetAllEventsErrorState(result["message"]));
        }
      }
    } catch (e, stk) {}
  }
}
