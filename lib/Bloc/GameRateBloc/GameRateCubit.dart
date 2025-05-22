import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/GameRateBloc/GameRateState.dart';
import 'package:mobi_user/main.dart';

import '../../Utility/const.dart';
import 'GameRateModel.dart';

class GameRateCubit extends Cubit<GameRateState> {
  GameRateCubit() : super(InitialState());

  getGameRate() async {
    String uid = await pref.getString("key").toString();
    try {
      emit(LoadingState());
      var headers = {
        'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
      };
      final resp = await repository.postRequest(
        gameRateApi,
        {
          "userId": uid,
        },
        header: headers,
      );
      final result = jsonDecode(resp.body);
      if (resp.statusCode == 200) {
        if (result["status"]) {
          emit(LoadedState(gameRateModelFromJson(resp.body)));
        } else {
          emit(ErrorState(result["message"]));
        }
      } else {
        repository.failureMessage(
          url: resp.request!.url.toString(),
          data: resp.body,
          statusCode: resp.statusCode.toString(),
        );
      }
    } catch (e) {
      emit(InitialState());
      throw Exception(e);
    }
  }
}
