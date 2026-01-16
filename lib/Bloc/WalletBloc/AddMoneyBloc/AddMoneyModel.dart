// To parse this JSON data, do
//
//     final addMoneyModel = addMoneyModelFromJson(jsonString);

import 'dart:convert';

AddMoneyModel addMoneyModelFromJson(String str) => AddMoneyModel.fromJson(json.decode(str));

String addMoneyModelToJson(AddMoneyModel data) => json.encode(data.toJson());

class AddMoneyModel {
  bool? status;
  String? msg;
  Data? data;

  AddMoneyModel({
    this.status,
    this.msg,
    this.data,
  });

  factory AddMoneyModel.fromJson(Map<String, dynamic> json) => AddMoneyModel(
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
  int? userId;
  int? amount;
  String? paymentStatus;
  String? date;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
    this.id,
    this.userId,
    this.amount,
    this.paymentStatus,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["userId"],
        amount: json["amount"],
        paymentStatus: json["paymentStatus"],
        date: json["date"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "amount": amount,
        "paymentStatus": paymentStatus,
        "date": date,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
