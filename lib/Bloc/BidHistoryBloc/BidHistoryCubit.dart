import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/BidHistoryBloc/BidHistoryModel.dart';
import 'package:mobi_user/Bloc/BidHistoryBloc/BidHistoryState.dart';
import 'package:mobi_user/Utility/const.dart';
import 'package:mobi_user/main.dart';

class BidHistoryCubit extends Cubit<BidHistoryState> {
  BidHistoryCubit() : super(BidHistoryInitState());

  getBidHistory(String sDate, String eDate, int page) async {
    String uid = await pref.getString("key").toString();

    try {
      emit(BidHistoryLoadingState());
      var headers = {
        'Content-Type': "application/json",
        'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
      };
      final resp = await repository.postRequest(
        bidHistoryApi,
        json.encode({"userId": uid, "fromDate": sDate, "toDate": eDate, "page": page}),
        header: headers,
      );
      final result = jsonDecode(resp.body);
      if (resp.statusCode == 200) {
        if (result["status"]) {
          emit(BidHistoryLoadedState(bidHistoryModelFromJson(resp.body)));
        } else {
          emit(BidHistoryErrorState(result["error"]));
        }
      } else {
        emit(BidHistoryErrorState(result["error"]));
        repository.failureMessage(
          url: resp.request!.url.toString(),
          data: resp.body,
          statusCode: resp.statusCode.toString(),
        );
      }
    } catch (e, stk) {
      log("Catch Error on Bid History $e, $stk");
      emit(BidHistoryInitState());
    }
  }
}
