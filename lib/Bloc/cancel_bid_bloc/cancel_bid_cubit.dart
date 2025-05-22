import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Utility/const.dart';

import '../../main.dart';
import 'cancel_bid_state.dart';

class CancelBidCubit extends Cubit<CancelBidState> {
  CancelBidCubit() : super(CancelBidInitialState());

  cancelBidApiCall({
    required String bidId,
  }) async {
    try {
      var headers = {'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "", 'Content-Type': "application/json"};
      emit(CancelBidLoadingState());
      // var data = json.encode({"id": bidId});
      final _resp = await repository.postRequest(
        "${cancelBidApiUrl}/$bidId",
        {},
        header: headers,
      );
      final resp = jsonDecode(_resp.body);
      log("Cancel Bid Response: ${resp.data}");

      final result = jsonDecode(jsonEncode(resp.data));
      if (resp.statusCode == 200) {
        emit(CancelBidLoadedState(result["msg"]));
      } else {
        emit(CancelBidErrorState(result["msg"]));
        log("Error Message=> Url ${resp.realUri} Status Code=>${resp.statusCode}");
      }
    } catch (e, stk) {
      log("catch error on [Cancel Bid api]: $e $stk");
      emit(CancelBidErrorState("$e"));
    }
  }
}
