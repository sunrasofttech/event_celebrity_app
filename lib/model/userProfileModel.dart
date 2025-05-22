// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

UserProfile userProfileFromJson(String str) => UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
  bool? status;
  String? masg;
  Data? data;

  UserProfile({this.status, this.masg, this.data});

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      UserProfile(status: json["status"], masg: json["masg"], data: json["data"] == null ? null : Data.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"status": status, "masg": masg, "data": data?.toJson()};
}

class Data {
  int? id;
  String? apitoken;
  String? name;
  String? password;
  String? mobile;
  dynamic balance;
  String? status;
  String? registrationDate;
  String? autoDepositStatus;
  dynamic imagePath;
  String? referalCode;
  dynamic referalTo;
  dynamic starlineStatus;
  int? isActive;
  String? deviceToken;
  String? sub_name;
  dynamic lowBalanceAmount;
  dynamic isImage;
  dynamic lowBalanceAmountBonus;
  dynamic lowBalanceAmountText;
  String? latestVersion;
  String? apkUrl;
  DateTime? createdAt;
  DateTime? subscription_expires_at;
  DateTime? updatedAt;

  Data({
    this.id,
    this.apitoken,
    this.name,
    this.password,
    this.mobile,
    this.isImage,
    this.balance,
    this.status,
    this.registrationDate,
    this.autoDepositStatus,
    this.imagePath,
    this.referalCode,
    this.sub_name,
    this.starlineStatus,
    this.referalTo,
    this.isActive,
    this.deviceToken,
    this.createdAt,
    this.latestVersion,
    this.apkUrl,
    this.lowBalanceAmount,
    this.lowBalanceAmountText,
    this.lowBalanceAmountBonus,
    this.subscription_expires_at,
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
    isImage: json["isImage"],
    registrationDate: json["registrationDate"],
    autoDepositStatus: json["autoDepositStatus"],
    imagePath: json["image_path"],
    sub_name: json["sub_name"],
    referalCode: json["referalCode"],
    referalTo: json["referalTo"],
    isActive: json["is_active"],
    latestVersion: json["latest_version"],
    apkUrl: json["apk_url"],
    starlineStatus: json["starline_status"],
    lowBalanceAmount: json["lowBalanceAmount"],
    lowBalanceAmountText: json["lowBalanceAmountText"],
    lowBalanceAmountBonus: json["lowBalanceAmountBonus"],
    deviceToken: json["deviceToken"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    subscription_expires_at: json["subscription_expires_at"] == null ? null : DateTime.parse(json["subscription_expires_at"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "apitoken": apitoken,
    "name": name,
    "password": password,
    "mobile": mobile,
    "balance": balance,
    "isImage": isImage,
    "status": status,
    "sub_name": sub_name,
    "registrationDate": registrationDate,
    "autoDepositStatus": autoDepositStatus,
    "lowBalanceAmountBonus": lowBalanceAmountBonus,
    "lowBalanceAmountText": lowBalanceAmountText,
    "lowBalanceAmount": lowBalanceAmount,
    "image_path": imagePath,
    "starline_status": starlineStatus,
    "referalCode": referalCode,
    "latest_version": latestVersion,
    "apk_url": apkUrl,
    "referalTo": referalTo,
    "is_active": isActive,
    "deviceToken": deviceToken,
    "createdAt": createdAt?.toIso8601String(),
    "subscription_expires_at": subscription_expires_at?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
