// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  bool? status;
  String? msg;
  List<Datum>? data;

  NotificationModel({
    this.status,
    this.msg,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
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
  String? title;
  String? message;
  String? date;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? userId;
  String? marketName;
  String? gameName;
  String? digit;
  int? winAmount;
  String? session;
  int? points;

  Datum({
    this.id,
    this.title,
    this.message,
    this.date,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.marketName,
    this.gameName,
    this.digit,
    this.winAmount,
    this.session,
    this.points,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        message: json["message"],
        date: json["date"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        userId: json["userId"],
        marketName: json["marketName"],
        gameName: json["gameName"],
        digit: json["digit"],
        winAmount: json["winAmount"],
        session: json["session"],
        points: json["points"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "message": message,
        "date": date,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "userId": userId,
        "marketName": marketName,
        "gameName": gameName,
        "digit": digit,
        "winAmount": winAmount,
        "session": session,
        "points": points,
      };
}
