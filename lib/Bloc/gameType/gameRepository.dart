import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:mobi_user/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utility/const.dart';
import '../../error/api_failures.dart';
import '../../error/failure_handler.dart';
import '../../model/banners.dart';
import '../../model/gameType.dart';

class GameRepository {
  GameRepository();

  Future<Either<ApiFailure, List<GameType>>> getAllAvailableGame() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = await prefs.getString("key");
      var headers = {
        // 'Content-Type': "application/json",
        'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
      };
      final response = await repository.postRequest(
        gameTypesApi,
        {
          "userId": userId,
        },
        header: headers,
      );
      final result = jsonDecode(response.body);
      print("Game List:- $result");
      List<GameType> bannerList =
          List.generate(result["data"].length, (index) => GameType.fromJson(result["data"][index]));

      return Right(bannerList);
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }

  Future<Either<ApiFailure, List<BannersModel>>> getBanners() async {
    try {
      // var data = {"phone": phone, "password": password, "name": name};
      final response = await repository.getRequest(bannersApi);
      print(jsonEncode(response.body));
      final result = jsonDecode(response.body);
      List<BannersModel> bannerList =
          List.generate(result["result"].length, (index) => BannersModel.fromJson(result["result"][index]));
      return Right(bannerList);
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }
}
