import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/BannerBloc/BannerModel.dart';
import 'package:mobi_user/Bloc/BannerBloc/BannerState.dart';
import 'package:mobi_user/Utility/const.dart';
import 'package:mobi_user/main.dart';

class BannerCubit extends Cubit<BannerState> {
  BannerCubit() : super(BannerInitState());

  fetchBanner() async {
    try {
      emit(BannerLoadingState());
      var headers = {
        'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
      };
      final resp = await repository.postRequest("${bannersApi}", {}, header: headers);
      final result = jsonDecode(resp.body);
      if (resp.statusCode == 200) {
        if (result["status"]) {
          emit(BannerLoadedState(bannerModelFromJson(resp.body)));
        } else {
          emit(BannerErrorState(result["message"]));
        }
      } else {
        repository.failureMessage(
          url: resp.request!.url.toString(),
          data: resp.body,
          statusCode: resp.statusCode.toString(),
        );
      }
    } catch (e) {
      emit(BannerInitState());
      throw Exception(e);
    }
  }
}
