// To parse this JSON data, do
//
//     final transactionHistoryModel = transactionHistoryModelFromJson(jsonString);

import 'dart:convert';

TransactionHistoryModel transactionHistoryModelFromJson(String str) =>
    TransactionHistoryModel.fromJson(json.decode(str));

String transactionHistoryModelToJson(TransactionHistoryModel data) => json.encode(data.toJson());

class TransactionHistoryModel {
  final bool? status;
  final String? msg;
  final int? totalPages;
  final List<Datum>? data;

  TransactionHistoryModel({
    this.status,
    this.msg,
    this.totalPages,
    this.data,
  });

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) => TransactionHistoryModel(
        status: json["status"],
        msg: json["msg"],
        totalPages: json["totalPages"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "totalPages": totalPages,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  final dynamic userBalance;
  final dynamic points;
  final String? transactionType;
  final String? message;
  final DateTime? date;
  final String? type;
  final String? status;

  Datum({
    this.userBalance,
    this.points,
    this.transactionType,
    this.message,
    this.date,
    this.type,
    this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        userBalance: json["userBalance"],
        points: json["points"],
        transactionType: json["transactionType"],
        message: json["message"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        type: json["type"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "userBalance": userBalance,
        "points": points,
        "transactionType": transactionType,
        "message": message,
        "date": date?.toIso8601String(),
        "type": type,
        "status": status,
      };
}
