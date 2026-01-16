// To parse this JSON data, do
//
//     final bidModel = bidModelFromJson(jsonString);

import 'dart:convert';

BidModel bidModelFromJson(String str) => BidModel.fromJson(json.decode(str));

String bidModelToJson(BidModel data) => json.encode(data.toJson());

class BidModel {
  String? userId;
  String? market;
  String? game;
  List<Datum>? data;

  BidModel({
    this.userId,
    this.market,
    this.game,
    this.data,
  });

  factory BidModel.fromJson(Map<String, dynamic> json) => BidModel(
        userId: json["userId"],
        market: json["market"],
        game: json["game"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "market": market,
        "game": game,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? session;
  String? digit;
  String? points;
  String? pana;
  String? game;
  String? marketId;

  Datum({
    this.session,
    this.digit,
    this.points,
    this.marketId,
    this.game,
    this.pana,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        marketId: json["market"],
        game: json["game"],
        session: json["session"],
        digit: json["digit"],
        points: json["points"],
        pana: json["pana"],
      );

  Map<String, dynamic> toJson() => {
        "market": marketId,
        "game": game,
        "session": session,
        "digit": digit,
        "points": points,
        "pana": pana,
      };
}
