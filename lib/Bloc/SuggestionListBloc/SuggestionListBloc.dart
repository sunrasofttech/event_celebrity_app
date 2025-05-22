import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/SuggestionListBloc/SuggestionListEvent.dart';
import 'package:mobi_user/Bloc/SuggestionListBloc/SuggestionListModel.dart';
import 'package:mobi_user/Bloc/SuggestionListBloc/SuggestionListState.dart';
import 'package:mobi_user/Utility/const.dart';
import 'package:mobi_user/main.dart';

class SuggestionListBloc extends Bloc<SuggestionListEvent, SuggestionListState> {
  SuggestionListBloc() : super(InitialState()) {
    on<SuggestionListInitEvent>((event, emit) => emit(InitialState()));
    on<SuggestionListLoadEvent>((event, emit) async {
      try {
        emit(LoadingState());
        var headers = {
          'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
        };
        final resp = await repository.postRequest(
          suggestionListApi,
          {
            // "userid": pref.getString("key"),
            "tableName": event.type,
            "digit": event.digit,
          },
          header: headers,
        );
        final result = jsonDecode(resp.body);
        if (resp.statusCode == 200) {
          if (result["status"]) {
            emit(LoadedState(suggestionListModelFromJson(resp.body)));
          } else {
            emit(ErrorState(result["error"]));
          }
        } else {
          emit(ErrorState(result["error"]));
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
    });
    on<SuggestionListHSDEvent>((event, emit) async {
      try {
        emit(LoadingState());
        final resp = await repository.postRequest(
          suggestionListApi,
          {
            // "userid": pref.getString("key"),
            "tableName": event.type,
          },
        );
        final result = jsonDecode(resp.body);
        if (resp.statusCode == 200) {
          if (result["status"]) {
            emit(LoadedState(suggestionListModelFromJson(resp.body)));
          } else {
            emit(ErrorState(result["msg"]));
          }
        } else {
          emit(ErrorState(result["msg"]));
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
    });
  }
}
