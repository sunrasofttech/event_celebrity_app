// To parse this JSON data, do
//
//     final winHistoryModel = winHistoryModelFromJson(jsonString);

import 'dart:convert';

WinHistoryModel winHistoryModelFromJson(String str) => WinHistoryModel.fromJson(json.decode(str));

String winHistoryModelToJson(WinHistoryModel data) => json.encode(data.toJson());

class WinHistoryModel {
  final bool? status;
  final String? msg;
  final int? totalPages;
  final List<Datum>? data;

  WinHistoryModel({
    this.status,
    this.msg,
    this.totalPages,
    this.data,
  });

  factory WinHistoryModel.fromJson(Map<String, dynamic> json) => WinHistoryModel(
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
  final String? marketName;
  final String? gameDetails;
  final String? session;
  final dynamic points;
  final dynamic winAmount;
  final String? winTime;

  Datum({
    this.marketName,
    this.gameDetails,
    this.session,
    this.points,
    this.winAmount,
    this.winTime,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        marketName: json["marketName"],
        gameDetails: json["game_details"],
        session: json["session"],
        points: json["points"],
        winAmount: json["winAmount"],
        winTime: json["winTime"],
      );

  Map<String, dynamic> toJson() => {
        "marketName": marketName,
        "game_details": gameDetails,
        "session": session,
        "points": points,
        "winAmount": winAmount,
        "winTime": winTime,
      };
}
