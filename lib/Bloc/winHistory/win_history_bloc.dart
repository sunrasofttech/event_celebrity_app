import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/winHistory/win_history_event.dart';
import 'package:mobi_user/Bloc/winHistory/win_history_state.dart';
import 'package:mobi_user/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utility/const.dart';
import '../../model/win_history_model.dart';

class WinHistoryBloc extends Bloc<WinHistoryEvent, WinHistoryState> {
  WinHistoryBloc() : super(WinHistoryInitial()) {
    on<FetchWinHistoryDataEvent>((event, emit) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String uid = await pref.getString("key").toString();
      try {
        emit(WinHistoryLoading());
        var data = jsonEncode(
          {
            "userId": uid,
            "page": int.parse(event.page),
            "fromDate": event.sDate,
            "toDate": event.eDate,
          },
        );
        var headers = {
          'Content-Type': "application/json",
          'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
        };
        final resp = await repository.postRequest(
          "${winHistoryApi}",
          data,
          header: headers,
        );
        final result = jsonDecode(resp.body);
        print("Response => ${result}");
        if (resp.statusCode == 200) {
          if (result["status"]) {
            emit(WinHistoryFetchedState(winHistoryModelFromJson(resp.body)));
          } else {
            print("Error");
            emit(WinHistoryInitial());
          }
        } else {
          log("message Error in api ${resp.request!.url}");
        }
      } catch (e, stk) {
        log("Catch Error message api $e, $stk");
        emit(WinHistoryInitial());
      }
      /*  // TODO: implement event handler
      emit(WinHistoryLoading());
      print("Win History Data");
      var data = await WinRepository().getWinHistory(pagination: event.page, sdate: event.sDate, edate: event.eDate,market: event.marketName);
      // await checkloadMorePossible();
      data.fold(
          (left) {
            emit(
              WinHistoryFetchedState(
                apiFailureOrSuccessOption: optionOf(data),
                list: [],
              ),
            );
          },
          (right) {
        emit(
          WinHistoryFetchedState(
              apiFailureOrSuccessOption: none(), list: right),
        );
      });*/
    });
  }
}
