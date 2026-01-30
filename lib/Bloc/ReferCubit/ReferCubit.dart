import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Utility/const.dart';
import '../../main.dart';
import 'ReferModel.dart';
import 'ReferState.dart';

class ReferCubit extends Cubit<ReferState> {
  ReferCubit() : super(InitialState());

  // referCode(String uid) async {
  //   try {
  //     final resp = await repository.getClient().get(Uri.parse("${referCodeApi}?userid=$uid"));
  //     final result = jsonDecode(resp.body);
  //     if (resp.statusCode == 200) {
  //       if (result["status"]) {
  //         emit(LoadedState(referModelFromJson(resp.body)));
  //       } else {
  //         emit(ErrorState(result["message"]));
  //         emit(InitialState());
  //       }
  //     } else {
  //       log("Error in Api ${resp.request!.url}");
  //     }
  //   } catch (e) {
  //     emit(InitialState());
  //     throw Exception(e);
  //   }
  // }
}
