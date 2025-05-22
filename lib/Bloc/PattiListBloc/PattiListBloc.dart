import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/PattiListBloc/PattiListEvent.dart';
import 'package:mobi_user/Bloc/PattiListBloc/PattiListState.dart';
import 'package:mobi_user/Bloc/PattiListBloc/PattiModel.dart';
import 'package:mobi_user/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utility/const.dart';

class PattiListBloc extends Bloc<PattiListEvent, PattiListState> {
  PattiListBloc() : super(InitialPattiState()) {
    on<FetchPattiEvent>((event, emit) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userId = prefs.getString("key");
        var headers = {
          'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
        };
        emit(LoadingPattiState());
        final resp = await repository.postRequest(
          getsuggestionApi,
          {
            "userid": userId,
            "type": event.type,
            "q": event.q,
          },
          header: headers,
        );
        final result = jsonDecode(resp.body);
        print("suggest panas: ${resp.body}");
        if (resp.statusCode == 200) {
          if (result["status"]) {
            emit(LoadedPattiState(pattiModelFromJson(resp.body)));
          } else {
            emit(ErrorPattiState(result["message"]));
          }
        } else {
          log("Error in api ${resp.body}");
          emit(ErrorPattiState(result["message"]));
        }
      } catch (e, stk) {
        log("Catch error on suggest panas Z: $stk");
        emit(InitialPattiState());
        throw Exception(e);
      }
    });
  }
}
