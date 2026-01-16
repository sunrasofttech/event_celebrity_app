// To parse this JSON data, do
//
//     final editProfileModel = editProfileModelFromJson(jsonString);

import 'dart:convert';

EditProfileModel editProfileModelFromJson(String str) => EditProfileModel.fromJson(json.decode(str));

String editProfileModelToJson(EditProfileModel data) => json.encode(data.toJson());

class EditProfileModel {
  bool? status;
  String? msg;
  Data? data;

  EditProfileModel({
    this.status,
    this.msg,
    this.data,
  });

  factory EditProfileModel.fromJson(Map<String, dynamic> json) => EditProfileModel(
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
  String? apitoken;
  String? name;
  String? password;
  String? mobile;
  int? balance;
  String? status;
  String? registrationDate;
  String? autoDepositStatus;
  String? imagePath;
  String? referalCode;
  String? referalTo;
  int? isActive;
  String? deviceToken;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
    this.id,
    this.apitoken,
    this.name,
    this.password,
    this.mobile,
    this.balance,
    this.status,
    this.registrationDate,
    this.autoDepositStatus,
    this.imagePath,
    this.referalCode,
    this.referalTo,
    this.isActive,
    this.deviceToken,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        apitoken: json["apitoken"],
        name: json["name"],
        password: json["password"],
        mobile: json["mobile"],
        balance: json["balance"],
        status: json["status"],
        registrationDate: json["registrationDate"],
        autoDepositStatus: json["autoDepositStatus"],
        imagePath: json["image_path"],
        referalCode: json["referalCode"],
        referalTo: json["referalTo"],
        isActive: json["is_active"],
        deviceToken: json["deviceToken"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "apitoken": apitoken,
        "name": name,
        "password": password,
        "mobile": mobile,
        "balance": balance,
        "status": status,
        "registrationDate": registrationDate,
        "autoDepositStatus": autoDepositStatus,
        "image_path": imagePath,
        "referalCode": referalCode,
        "referalTo": referalTo,
        "is_active": isActive,
        "deviceToken": deviceToken,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
