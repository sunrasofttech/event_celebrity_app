import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:planner_celebrity/error/api_failures.dart';
import 'package:planner_celebrity/error/failure_handler.dart';
import 'package:planner_celebrity/main.dart';
import 'package:planner_celebrity/model/bankDetailsModel.dart';
import 'package:planner_celebrity/model/withdraw_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utility/const.dart';
import '../model/withdrawalTiming.dart';

class PaymentRepository {
  PaymentRepository();

  Future<Either<ApiFailure, bool>> addPayment({required String amount}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString("key");
      var data = {"userid": userId, "amount": amount};
      print(data);
      //?userid=44&digit=123&points=10&market=1&mtype=sd&type=close
      final response = await repository.postRequest(addMoneyToWalletApi, data);
      print(response);

      return Right(true);
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }

  Future<Either<ApiFailure, String>> getUpi() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString("key");
      var data = {"userid": userId};
      print(data);
      //?userid=44&digit=123&points=10&market=1&mtype=sd&type=close
      final response = await repository.postRequest(getAdminUpi, data);
      final result = jsonDecode(response.body);
      //print(response["result"][0]["name"]);
      return Right(result["result"][0]["name"]);
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }

  Future<Either<ApiFailure, WithdrawDetails>> getWithdrawDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString("key");
      var data = {"userid": userId};
      print(data);
      //?userid=44&digit=123&points=10&market=1&mtype=sd&type=close
      final response = await repository.postRequest(getwithdrawDetailsUpi, data);
      final result = jsonDecode(response.body);
      print(result["result"]);

      return Right(WithdrawDetails.fromJson(result["result"]));
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }

  Future<Either<ApiFailure, WithdrwalTiming>> getWithdrawalTimeForMoney() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString("key");
      var data = {"userid": userId};
      print(data);
      //?userid=44&digit=123&points=10&market=1&mtype=sd&type=close
      final response = await repository.postRequest(withdrawAmountApiForTime, data);
      final result = jsonDecode(response.body);
      print(result["result"][0]["name"]);

      return Right(WithdrwalTiming.fromJson(result["result"]));
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }

  Future<Either<ApiFailure, bool>> checkLimitation({required String amount}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString("key");
      var data = {"userid": userId, "amount": amount};
      print(data);
      //?userid=44&digit=123&points=10&market=1&mtype=sd&type=close
      final response = await repository.postRequest(addMoneyLimitCheckAPi, data);
      print(response);

      return Right(true);
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }

  Future<Either<ApiFailure, BankDetailsModel>> getBankDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString("key");
      var data = {"userid": userId};
      var headers = {'Authorization': pref.getString(sharedPrefAPITokenKey) ?? ""};
      print(data);
      //?userid=44&digit=123&points=10&market=1&mtype=sd&type=close
      final response = await repository.postRequest("${getBankDetailsApi}/$userId", {}, header: headers);
      final result = jsonDecode(response.body);
      print("Get Bank Details Response ---> $result");
      if (result["status"] == true) {
        var res = BankDetailsModel.fromJson(result["data"]);
        return Right(res);
      } else {
        return Left(FailureHandler.handleFailure(result["error"]));
      }
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }

  Future<Either<ApiFailure, bool>> addAccount({
    required String bankAccount,
    required String ifsc,
    required String upiPay,
    required String phonePe,
    required String paytm,
    required String placeholder,
    required String bankName,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString("key");
      var headers = {'Content-Type': 'application/json', 'Authorization': pref.getString(sharedPrefAPITokenKey) ?? ""};
      var data =
          upiPay.isNotEmpty
              ? jsonEncode({"userId": int.parse(userId ?? "0"), "UPI": upiPay})
              : jsonEncode({
                "userId": int.parse(userId ?? "0"),
                "accountHolderName": placeholder,
                "Name": bankName,
                "accountNo": bankAccount,
                "IFSC": ifsc,
              });
      // ?userid=44&name=cdf&ac_no=12345&ifsc=k255&upi=gh&paytm=456&phonepe=5758
      print("Data=> ${data}");
      //?userid=44&digit=123&points=10&market=1&mtype=sd&type=close
      final response = await repository.postRequest(addAcountApi, data, header: headers);
      var result = jsonDecode(response.body);
      print("Add Bank Account Response => ${response.body}");
      if (response.statusCode == 200) {
        return Right(true);
      } else {
        return Left(FailureHandler.handleFailure(result["msg"]));
      }
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }

  Future<Either<ApiFailure, bool>> withdrawPayment({required String amount, required String account}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var headers = {'Content-Type': 'application/json', 'Authorization': pref.getString(sharedPrefAPITokenKey) ?? ""};
      var userId = prefs.getString("key");
      var data = jsonEncode({"userId": userId, "amount": amount, "toAccount": account});
      print("Withdraw Request Data => " + data);
      //?userid=44&digit=123&points=10&market=1&mtype=sd&type=close
      final response = await repository.postRequest(withdrawAmountApi, data, header: headers);
      print("Withdraw Request Response => " + response.body + " Status Code :- " + response.statusCode.toString());
      final result = jsonDecode(response.body);
      return response.statusCode == 200 || response.statusCode == 201
          ? Right(true)
          : Left(FailureHandler.handleFailure(result["error"]));
    } catch (e) {
      return Left(FailureHandler.handleFailure(e));
    }
  }
}
