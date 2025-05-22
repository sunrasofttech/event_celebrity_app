import 'dart:convert';
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:mobi_user/error/api_failures.dart';
import 'package:mobi_user/error/failure_handler.dart';
import 'package:mobi_user/main.dart';
import 'package:mobi_user/model/BidModel.dart' as bid_model;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utility/const.dart';
import '../../model/bidHistory.dart';

class BidRepository {
  BidRepository();

  Future<Either<ApiFailure, bool>> placeBid({
    required String marketId,
    required String game,
    required List<bid_model.Datum> datum,
    required String points,
    required String session,
    required String digit,
    required String pana1,
  }) async {
    try {
      /*print("Pana Data ${pana1}");*/
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString("key");
      // var data = json.encode({
      //   "userId": userId,
      //   "market": marketId,
      //   "game": game,
      //   "session": session,
      //   "digit": digit,
      //   "points": int.parse(points),
      //   "pana": pana1,
      // });

      var data = json.encode({
        "userId": userId,
        "data": datum,
      });
      print("Place Bid Value =>$data");
      var headers = {
        'Content-Type': "application/json",
        'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
      };
      final response = await repository.postRequest(
        "${placeBidNewApi}",
        data,
        header: headers,
      );
      print("${response.request!.url}");
      //print("Bid Response Simple => sd,jd,sp,dp,tp,hsd,fsd => " + response.request!.url.toString());
      final result = jsonDecode(response.body);
      print("Response Body =>${response.body}");
      return result["status"] == true ? Right(true) : Left(FailureHandler.handleFailure(result["msg"]));
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }

  Future<Either<ApiFailure, bool>> placeBidForSPDPTP({
    required String marketId,
    required String mType,
    required String game,
    required List<bid_model.Datum> datum,
    required String points,
    required String session,
    required String digit,
    required String pana1,
  }) async {
    try {
      /*print("Pana Data ${pana1}");*/
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString("key");
      // var data = json.encode({
      //   "userId": userId,
      //   "market": marketId,
      //   "game": game,
      //   "session": session,
      //   "digit": digit,
      //   "points": int.parse(points),
      //   "pana": pana1,
      // });

      var data = json.encode({
        "userId": userId,
        "mtype": mType,
        "data": datum,
      });
      print("Place Bid Value =>$data");
      var headers = {
        'Content-Type': "application/json",
        'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
      };
      final response = await repository.postRequest(
        "${placeSPDPTPBidNewApi}",
        data,
        header: headers,
      );
      print("${response.request!.url}");
      //print("Bid Response Simple => sd,jd,sp,dp,tp,hsd,fsd => " + response.request!.url.toString());
      final result = jsonDecode(response.body);
      print("Response Body SPDPTP =>${response.body}");
      return result["status"] == true ? Right(true) : Left(FailureHandler.handleFailure(result["msg"]));
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }

  Future<Either<ApiFailure, bool>> placeBidForPatti({
    required String points,
    required String type,
    required String marketId,
    required String mType,
    required String pana1,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString("key");
      var data = {
        "userid": userId,
        "points": points,
        "market": marketId,
        "type": type,
        "mtype": mType,
        "pana": pana1,
      };
      print("Pana placeBidForPatti data: $data");
      // https: //sultangamings.com/alpha/api/bidonPana?userid=2&pana=111,116,166,666&points=10&market=1&
      // mtype=fp&type=open
      final response = await repository.postRequest(placeBidForPattiApi, data);
      print(response);
      final result = jsonDecode(response.body);
      return result["status"] == true ? Right(true) : Left(FailureHandler.handleFailure("Can't Place Bid"));
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }

  Future<Either<ApiFailure, List<BidHistoryModel>>> getBidHistory({required int page}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString("key");
      var data = {"userid": userId, "page": page};
      print("Data=>$data");
      print("bidHistoryApi?userid=$userId&page=$page");
      // https: //mtadmin.online/junglerajyog_king/api/bidHistory?userid=44&page=0
      final response = await repository.getRequest("bidHistoryApi?userid=$userId&page=$page");
      print(response);
      final result = jsonDecode(response.body);
      List<BidHistoryModel> bidHistory =
          List.generate(result["result"].length, (index) => BidHistoryModel.fromJson(result["result"][index]));
      return Right(bidHistory);
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }

  Future<Either<ApiFailure, String>> getPitties({
    required String type,
    required String pana,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString("key");
      log("${getpattiesApi}?userid=$userId&type=$type&pana=$pana");
//https://sultangamings.com/alpha/api/getpatties?userid=2&type=dpa&pana=1
      final response = await repository.getRequest("${getpattiesApi}?userid=$userId&type=$type&pana=$pana");
      log(response.toString());
      final result = jsonDecode(response.body);
      return Right(result["result"]["all_bp"]);
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }

  /* Future<Either<ApiFailure, bool>> placeStarLineBid({
    required String points,
    required String starLineId,
    */ /*This is starline id*/ /*
    required String digit,
    required String mType,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId =prefs.getString("key");
      var data = {
        "userid": userId,
        "points": points,
        "starline": starLineId,
        "mtype": mType,
        "digit": digit,
      };
      print(data);
      //?userid=44&digit=123&points=10&market=1&mtype=sd&type=close
      final response = await Service().postRequest(url: starLinePlaceBidApi, data: data);
      print(response);
      final result = jsonDecode(response.body);
      return result["status"] == true ? Right(true) : Left(FailureHandler.handleFailure("Cant' Place Bid"));
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }*/

  Future<Either<ApiFailure, List<String>>> suggestPatties({
    required String type,
    required String q,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString("key");
      var headers = {
        'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
      };
      final response = await repository.postRequest(
        getsuggestionApi,
        {
          "userid": userId,
          "type": type,
          "q": q,
        },
        header: headers,
      );
      final result = jsonDecode(response.body);
      return Right(
        // List<String>.generate(result["result"].length, (index) => result["result"][index]["bet_patties"].toString()),
        List<String>.generate(result["result"].length, (index) => result["result"][index]["numbers"].toString()),
      );
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }
}
