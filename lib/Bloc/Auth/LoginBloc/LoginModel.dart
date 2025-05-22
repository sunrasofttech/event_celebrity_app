// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  bool? status;
  String? msg;
  Data? data;

  LoginModel({
    this.status,
    this.msg,
    this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["status"],
        msg: json["msg"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  String? mobile;
  String? password;
  String? apiToken;

  Data({
    this.id,
    this.mobile,
    this.password,
    this.apiToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        mobile: json["mobile"],
        password: json["password"],
        apiToken: json["apiToken"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mobile": mobile,
        "password": password,
        "apiToken": apiToken,
      };
}
