import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/HomeTextBloc/HomeTextEvent.dart';
import 'package:mobi_user/Bloc/HomeTextBloc/HomeTextState.dart';
import 'package:mobi_user/Repository/Repository.dart';
import 'package:mobi_user/Utility/const.dart';

import '../../main.dart';
import 'HomeTextModel.dart';

class HomeTextBloc extends Bloc<HomeTextEvent, HomeTextState> {
  HomeTextBloc() : super(HomeTextInitState()) {
    on<FetchHomeTextEvent>((event, emit) async {
      try {
        emit(HomeTextLoadingState());
        var headers = {'Authorization': pref.getString(sharedPrefAPITokenKey) ?? ""};
        final resp = await Repository().postRequest(homeTextApi, {}, header: headers);
        final result = jsonDecode(resp.body);
        print("FETCH HOME TEXT: $result");
        if (resp.statusCode == 200) {
          if (result["status"]) {
            emit(HomeTextLoadedState(homeTextModelFromJson(resp.body)));
          } else {
            emit(HomeTextErrorState(result["msg"]));
          }
        } else {
          log("Error in api ${resp.body}");
        }
      } catch (e) {
        emit(HomeTextInitState());
        throw Exception(e);
      }
    });
  }
}
