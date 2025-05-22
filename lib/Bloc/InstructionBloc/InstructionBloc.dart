import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/InstructionBloc/InstructionEvent.dart';
import 'package:mobi_user/Bloc/InstructionBloc/InstructionState.dart';
import 'package:mobi_user/model/InstructionModel.dart';

import '../../Utility/const.dart';
import '../../main.dart';

class InstructionBloc extends Bloc<InstructionEvent, InstructionState> {
  InstructionBloc() : super(InstructionInitState()) {
    on<FetchInstructionEvent>((event, emit) async {
      try {
        emit(InstructionLoadingState());
        var headers = {
          'Content-Type': "application/json",
          'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
        };
        final resp = await repository.postRequest(
          instructionApi,
          json.encode({"type": event.type}),
          header: headers,
        );
        final result = jsonDecode(resp.body);

        if (resp.statusCode == 200) {
          if (result["status"]) {
            print("Market Response: ${jsonDecode(resp.body)['data']}");
            if (event.type == "deposit") {
              emit(InstructionLoadedState(instructionModelFromJson(resp.body)));
            } else {
              emit(InstructionLoadedDataState(instructionModelFromJson(resp.body)));
            }
          } else {
            emit(InstructionErrorState(result["error"]));
          }
        } else {
          emit(InstructionErrorState(result["error"]));
          repository.failureMessage(
            url: resp.request!.url.toString(),
            data: resp.body,
            statusCode: resp.statusCode.toString(),
          );
        }
      } catch (e) {
        emit(InstructionInitState());
        throw Exception(e);
      }
    });
  }
}
