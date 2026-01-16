// To parse this JSON data, do
//
//     final registerModel = registerModelFromJson(jsonString);

import 'dart:convert';

RegisterModel registerModelFromJson(String str) => RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  bool? status;
  String? msg;
  Data? data;

  RegisterModel({
    this.status,
    this.msg,
    this.data,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
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
  String? userName;
  String? mobile;
  String? email;
  String? apiToken;

  Data({
    this.id,
    this.userName,
    this.mobile,
    this.email,
    this.apiToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userName: json["userName"],
        mobile: json["mobile"],
        email: json["email"],
        apiToken: json["apiToken"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userName": userName,
        "mobile": mobile,
        "email": email,
        "apiToken": apiToken,
      };
}
