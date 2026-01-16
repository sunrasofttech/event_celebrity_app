import 'dart:convert';
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:planner_celebrity/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utility/const.dart';
import '../../error/api_failures.dart';
import '../../error/failure_handler.dart';
import '../../model/userProfileModel.dart';

class UserProfileRepository {
  UserProfileRepository();

  Future<Either<ApiFailure, UserProfile>> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("key");
    var headers = {'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "", 'Content-Type': "application/json"};
    final resp = await repository.postRequest(userProfileApi, jsonEncode({"userId": userId}), header: headers);

    final result = jsonDecode(resp.body);
    log("--------- profile:---- $result");
    var data = UserProfile.fromJson(result);
    return Right(data);
  }

  Future<Either<ApiFailure, String>> shareLink() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString("key");
      // var data = {"phone": phone, "password": password, "name": name};
      log("Userid $userId");
      final response = await repository.getRequest("${getRefferalCodeApi}?userid=$userId");
      //print(jsonEncode(response["result"]));
      final result = jsonDecode(response.body);

      return Right(result["referral_code"]["referral"]);
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }

  /*getNUmber() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //var userId = prefs.getString("userId");
      // var data = {"phone": phone, "password": password, "name": name};
      final response = await repository.getRequest("$getNumberApi");
      print(jsonEncode(response.body));
      final result = jsonDecode(response.body);
      var data = result["result"]["phone"];
      return data;
    } catch (e) {
      // return Left(FailureHandler.handleFailure(e));
      print(e);
    }
  }*/

  /* getNUmbers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString("userId");
      // var data = {"phone": phone, "password": password, "name": name};
      final response = await repository.getRequest("$getNumberApi");
      print(jsonEncode(response.body));
      final result = jsonDecode(response.body);

      var data = result["result"]["phone"];
      return data;
    } catch (e) {
      // return Left(FailureHandler.handleFailure(e));
      print("$e");
    }
  }*/

  Future<bool> getVersion() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString("key");
      var headers = {'Authorization': pref.getString(sharedPrefAPITokenKey) ?? ""};
      // var data = {"phone": phone, "password": password, "name": name};
      final response = await repository.postRequest(getVersionNumberApi, {"userId": uid}, header: headers);
      print("get Settings to save version code\n" + jsonEncode(response.body));
      // return true;
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final result = jsonDecode(response.body);
      String data = result["data"][0]["version"];
      String code = packageInfo.version;
      print("App Version Check=> $code & Data=>$data");
      if (code == "null") {
        prefs.setString("versionCode", data);
        return false;
      }
      if (code == data) {
        return false;
      }
      prefs.setString("versionCode", code.toString());
      print("Changed ${code}");
      return true;
    } catch (e) {
      // return Left(FailureHandler.handleFailure(e));
      print(e);
      return false;
    }
  }
}
