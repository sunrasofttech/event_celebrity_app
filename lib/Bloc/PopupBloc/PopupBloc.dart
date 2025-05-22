import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/PopupBloc/PopupEvent.dart';
import 'package:mobi_user/Bloc/PopupBloc/PopupState.dart';
import 'package:mobi_user/Utility/const.dart';
import 'package:mobi_user/main.dart';

class PopupBloc extends Bloc<PopupEvent, PopupState> {
  PopupBloc() : super(PopUpInitialState()) {
    on<FetchPopupEvent>((event, emit) async {
      try {
        emit(PopUpLoadingState());
        final String uid = pref.getString("key").toString();
        final resp = await repository.postRequest(popBannerApi, {"userid": uid});
        final result = jsonDecode(resp.body);
        if (resp.statusCode == 200) {
          if (result["status"]) {
            print("Load Pop Banner ${result["result"]["pop_banner"]}");
            emit(PopUpLoadedState(result["result"]["pop_banner"]));
          } else {
            emit(PopUpErrorState(result["message"]));
          }
        } else {
          log("Error in api ${resp.body}");
        }
      } catch (e) {
        PopUpInitialState();
        throw Exception(e);
      }
    });
  }
}
