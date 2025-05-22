import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:mobi_user/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utility/const.dart';
import '../../error/api_failures.dart';
import '../../error/failure_handler.dart';

class AuthenticationRepository {
  AuthenticationRepository();

  /* Future<Either<ApiFailure, bool>> registerUser(
      {required String phone,
      required String password,
      required String name,
      String? code}) async {
    try {
      var data = {
        "phone": phone,
        "password": password,
        "name": name,
        "referralby": code
      };
      final response =
          await Service().postRequest(url: registerApi, data: data);
      print(response["user_id"]["id"]);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userId", response["user_id"]["id"]);
      return Right(true);
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }*/

  /* Future<Either<ApiFailure, bool>> forgotPassword(
      {required String phone, required String password}) async {
    try {
      var data = {
        "phone": phone,
        "password": password,
      };
      print(data);
      final response =
          await Service().postRequest(url: forgetPassApi, data: data);
      print(response);
      return Right(true);
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }*/

  /* Future<Either<ApiFailure, bool>> loginUser({
    required String phone,
    required String password,
  }) async {
    try {
      var data = {
        "phone": phone,
        "password": password,
      };
      print(loginApi);

      final response = await Service().postRequest(url: loginApi, data: data);
      print(response["result"]["id"]);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userId", response["result"]["id"]);
      return Right(true);
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }*/

  /* Future<Either<ApiFailure, bool>> loginUsermock({
    required String phone,
    required String password,
  }) async {
    try {
      var data = {
        "phone": phone,
        "password": password,
      };
      final response = await Service().postRequest(url: loginApi, data: data);
      print(response["result"]["id"]);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userId", response["result"]["id"]);
      return Right(true);
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }*/

  Future<Either<ApiFailure, bool>> changePassword({
    required String newPassword,
    required String oldPassword,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString("key");

      var data = {
        "userId": userId,
        "newPassword": newPassword,
        "oldPassword": oldPassword,
        "confirmPassword": newPassword,
      };
      var headers = {
        // 'Content-Type': "application/json",
        'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "",
      };
      final resp = await repository.postRequest(changePassApi, data, header: headers);
      final result = jsonDecode(resp.body);
      return result["status"] == true ? Right(true) : Left(result["msg"]);
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }
}
