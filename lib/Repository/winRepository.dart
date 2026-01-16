import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:planner_celebrity/error/api_failures.dart';
import 'package:planner_celebrity/error/failure_handler.dart';
import 'package:planner_celebrity/main.dart';
import 'package:planner_celebrity/model/win_history_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utility/const.dart';

class WinRepository {
  WinRepository();

  Future<Either<ApiFailure, List<Datum>>> getWinHistory({
    required int pagination,
    required String sdate,
    required String edate,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString("key");
      var data = jsonEncode({"userId": userId, "page": pagination, "fromDate": sdate, "toDate": edate});
      var headers = {'Content-Type': "application/json", 'Authorization': pref.getString(sharedPrefAPITokenKey) ?? ""};
      print(data);
      // https://mtadmin.online/junglerajyog_king/api/winningHistory?userid=45&sdate=2023-03-03&edate=2023-03-05
      final response = await repository.postRequest("${winHistoryApi}", data, header: headers);
      print(response);
      final result = jsonDecode(response.body);
      List<Datum> list = List.generate(result["data"].length, (index) => Datum.fromJson(result["data"][index]));

      return Right(list);
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }

  /* Future<Either<ApiFailure, List<WinRatesModel>>> getWinRates() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString("userId");
      var data = {
        "userid": userId //, "page": pagination
      };
      print(data);
      final response =
          await repository.postRequest(winningRatesApi, data);
      print(response);
      List<WinRatesModel> list = List.generate(response["result"].length,
          (index) => WinRatesModel.fromJson(response["result"][index]));
      return Right(list);
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }

  Future<Either<ApiFailure, List<VideoModel>>> getVideos() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString("userId");
      var data = {
        "userid": userId,
      };

      final response =
          await repository.postRequest(url: getVideosApi, data: data);
      print(response);
      List<VideoModel> list = List.generate(response["result"].length,
          (index) => VideoModel.fromJson(response["result"][index]));
      return Right(list);
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }*/
}
