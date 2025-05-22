import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/DepositListBloc/DepositListEvent.dart';
import 'package:mobi_user/Bloc/DepositListBloc/DepositListState.dart';
import 'package:mobi_user/Repository/repository.dart';
import 'package:mobi_user/Utility/const.dart';
import 'package:mobi_user/model/DepositModel.dart';

import '../../main.dart';

class DepositListBloc extends Bloc<DepositListEvent, DepositListState> {
  DepositListBloc() : super(DepositInitState()) {
    on<DepositListDataEvent>((event, emit) async {
      try {
        emit(DepositLoadingState());
        var headers = {
          'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
        };
        log("Url=>${depositListApi}");
        final resp = await Repository().postRequest(depositListApi, {}, header: headers);
        final result = jsonDecode(resp.body);
        log("Deposit List=> ${resp.body}");
        if (resp.statusCode == 200) {
          if (result["status"]) {
            emit(DepositLoadedState(depositModelFromJson(resp.body)));
          } else {
            emit(DepositErrorState(result["msg"]));
          }
        } else {
          print("Error in api ${resp.body}");
        }
      } catch (e) {
        emit(DepositInitState());
        throw Exception(e);
      }
    });
  }
}
