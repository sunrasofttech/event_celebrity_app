// To parse this JSON data, do
//
//     final gameRateModel = gameRateModelFromJson(jsonString);

import 'dart:convert';

GameRateModel gameRateModelFromJson(String str) => GameRateModel.fromJson(json.decode(str));

String gameRateModelToJson(GameRateModel data) => json.encode(data.toJson());

class GameRateModel {
  bool? status;
  String? msg;
  List<Datum>? data;

  GameRateModel({
    this.status,
    this.msg,
    this.data,
  });

  factory GameRateModel.fromJson(Map<String, dynamic> json) => GameRateModel(
        status: json["status"],
        msg: json["msg"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? id;
  String? shortCode;
  String? name;
  String? rate;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.shortCode,
    this.name,
    this.rate,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        shortCode: json["shortCode"],
        name: json["name"],
        rate: json["rate"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shortCode": shortCode,
        "name": name,
        "rate": rate,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
