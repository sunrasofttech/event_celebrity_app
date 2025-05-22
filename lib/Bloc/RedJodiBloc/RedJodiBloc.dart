import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utility/const.dart';
import 'RedJodiEvent.dart';
import 'RedJodiModel.dart';
import 'RedJodiState.dart';

class RedJodiBloc extends Bloc<RedJodiEvent, RedJodiState> {
  RedJodiBloc() : super(RedJodiInitialState()) {
    on<RedJodiListEvent>((event, emit) async {
      try {
        emit(RedJodiLoadingState());
        SharedPreferences pref = await SharedPreferences.getInstance();
        String uid = pref.getString("key").toString();
        log("this is RedJodi list event");
        var headers = {
          'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
        };
        final resp = await repository.postRequest(
          redJodiApi,
          {},
          header: headers,
        );
        // {"type": event.shortCode },
        final result = jsonDecode(resp.body);
        log("this is RedJodi list event response:- $result");
        if (resp.statusCode == 200) {
          if (result["status"]) {
            emit(RedJodiLoadedState(redJodiModelFromJson(resp.body)));
          } else {
            emit(RedJodiErrorState(result["message"]));
          }
        } else {
          log("Error in api ${resp.body}");
          emit(RedJodiErrorState(result["message"]));
        }
      } catch (e, stk) {
        log("Error in RedJodi api:- $e, $stk");
        emit(RedJodiInitialState());
      }
    });
  }
}
