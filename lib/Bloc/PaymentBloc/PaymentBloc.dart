import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/PaymentBloc/PaymentEvent.dart';
import 'package:mobi_user/Bloc/PaymentBloc/PaymentModel.dart';
import 'package:mobi_user/Bloc/PaymentBloc/PaymentState.dart';
import 'package:mobi_user/Repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utility/const.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(InitialState()) {
    on<GeneratePayment>((event, emit) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      try {
        emit(LoadingState());
        String uid = await pref.getString("key").toString();
        var headers = {
          'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
        };
        print("UserId ${uid}");
        final resp = await Repository().postRequest(
          generateUpiPayment,
          {
            "userId": uid,
            "amount": event.amount,
          },
          header: headers,
        );
        final result = jsonDecode(resp.body);
        if (resp.statusCode == 201) {
          if (result["status"] == true) {
            emit(LoadedState(model: paymentModelFromJson(resp.body)));
          } else {
            emit(ErrorState(result["msg"]));
          }
        } else {
          log("Error in a api ${resp.body}");
          emit(InitialState());
        }
      } catch (e) {
        emit(InitialState());
        throw Exception(e);
      }
    });
  }
}
