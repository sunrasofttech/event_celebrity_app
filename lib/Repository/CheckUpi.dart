/*
import 'dart:convert';
import 'package:mobi_user/Utility/const.dart';
import 'package:mobi_user/main.dart';
import 'package:flutter/material.dart';

class CheckUpi with ChangeNotifier {
  String _upi = "";
  String get upi => _upi;
  setUpi(String upiId) {
    this._upi = upiId;
    notifyListeners();
  }

  void getUpi() async {
    try {
      final resp = await repository.getRequest(settingApi);
      final result = jsonDecode(resp.body);
      if (resp.statusCode == 200) {
        if (result["status"]) {
          setUpi(result["data"][0]["upiName"]);
        }
      } else {
        repository.failureMessage(
            url: resp.request!.url.toString(), data: resp.body, statusCode: resp.statusCode.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
*/
