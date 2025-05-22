// To parse this JSON data, do
//
//     final bidHistoryModel = bidHistoryModelFromJson(jsonString);

import 'dart:convert';

BidHistoryModel bidHistoryModelFromJson(String str) => BidHistoryModel.fromJson(json.decode(str));

String bidHistoryModelToJson(BidHistoryModel data) => json.encode(data.toJson());

class BidHistoryModel {
  bool? status;
  String? msg;
  int? totalPages;
  List<Datum>? data;

  BidHistoryModel({
    this.status,
    this.msg,
    this.totalPages,
    this.data,
  });

  factory BidHistoryModel.fromJson(Map<String, dynamic> json) => BidHistoryModel(
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
  int? id;
  int? userId;
  String? name;
  String? phone;
  String? market;
  String? game;
  String? session;
  String? digit;
  String? pana;
  dynamic points;
  String? win;
  String? date;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic winAmount;
  String? winTime;
  String? userPayment;
  String? winReversed;
  String? winResult;

  Datum({
    this.id,
    this.userId,
    this.name,
    this.phone,
    this.market,
    this.game,
    this.session,
    this.digit,
    this.pana,
    this.points,
    this.win,
    this.date,
    this.createdAt,
    this.updatedAt,
    this.winAmount,
    this.winTime,
    this.userPayment,
    this.winReversed,
    this.winResult,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["userId"],
        name: json["name"],
        phone: json["phone"],
        market: json["market"],
        game: json["game"],
        session: json["session"],
        digit: json["digit"],
        pana: json["pana"],
        points: json["points"],
        win: json["win"],
        date: json["date"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        winAmount: json["winAmount"],
        winTime: json["winTime"],
        userPayment: json["userPayment"],
        winReversed: json["winReversed"],
        winResult: json["winResult"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "name": name,
        "phone": phone,
        "market": market,
        "game": game,
        "session": session,
        "digit": digit,
        "pana": pana,
        "points": points,
        "win": win,
        "date": date,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "winAmount": winAmount,
        "winTime": winTime,
        "userPayment": userPayment,
        "winReversed": winReversed,
        "winResult": winResult,
      };
}
