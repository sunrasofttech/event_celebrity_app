import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/MarketBloc/MarketModel.dart';
import 'package:mobi_user/Bloc/MarketBloc/MarketState.dart';
import 'package:mobi_user/Utility/const.dart';
import 'package:mobi_user/main.dart';

class MarketCubit extends Cubit<MarketState> {
  MarketCubit() : super(MarketInitState());

  emitLoading() {
    emit(MarketLoadingState());
  }

  getMarkets(String uid, {String? marketType}) async {
    try {
      var urlLink = marketApi;
      var data = jsonEncode({"userid": uid});
      if (marketType != null) {
        urlLink += marketType;
      } else {
        urlLink += "matka";
      }
      var headers = {'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "", 'Content-Type': "application/json"};
      final resp = await repository.postRequest(urlLink, data, header: headers);
      print("Response Body=> url=> $urlLink, ${resp.body}");
      final result = jsonDecode(resp.body);
      if (resp.statusCode == 605) {
        emit(MarketUnAuthorizedState(marketModelFromJson(resp.body)));
      } else if (resp.statusCode == 200) {
        if (result["status"]) {
          print("Market Response: ${jsonDecode(resp.body)['data']}");
          emit(MarketLoadedState(marketModelFromJson(resp.body)));
        } else {
          emit(MarketErrorState(result["error"]));
        }
      } else {
        emit(MarketErrorState(result["error"].toString()));
        repository.failureMessage(
          url: resp.request!.url.toString(),
          data: resp.body,
          statusCode: resp.statusCode.toString(),
        );
      }
    } catch (e, stk) {
      log("Catch Error in market cubit : $e, $stk");
      emit(MarketInitState());
    }
  }
}
