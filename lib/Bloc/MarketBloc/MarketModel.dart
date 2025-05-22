// To parse this JSON data, do
//
//     final marketModel = marketModelFromJson(jsonString);

import 'dart:convert';

MarketModel marketModelFromJson(String str) => MarketModel.fromJson(json.decode(str));

String marketModelToJson(MarketModel data) => json.encode(data.toJson());

class MarketModel {
  bool? status;
  String? msg;
  List<Datum>? data;

  MarketModel({this.status, this.msg, this.data});

  factory MarketModel.fromJson(Map<String, dynamic> json) => MarketModel(
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
  String? marketName;
  String? openOpenTime;
  String? openCloseTime;
  String? closeCloseTime;
  String? date;
  String? type;
  String? status;
  String? monday;
  String? tuesday;
  String? wednesday;
  String? thursday;
  String? friday;
  String? saturday;
  String? sunday;
  dynamic url;
  String? color;
  String? marketStatus;
  String? marketStatusToday;
  String? result;
  String? openTime;
  String? opencloseTime;
  String? closeTime;
  String? marketSessionType;
  String? marketOpenTime;

  Datum({
    this.id,
    this.marketName,
    this.openOpenTime,
    this.openCloseTime,
    this.closeCloseTime,
    this.date,
    this.type,
    this.status,
    this.color,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
    this.url,
    this.marketStatus,
    this.marketStatusToday,
    this.result,
    this.openTime,
    this.opencloseTime,
    this.closeTime,
    this.marketSessionType,
    this.marketOpenTime,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    marketName: json["marketName"],
    openOpenTime: json["OpenOpenTime"],
    openCloseTime: json["OpenCloseTime"],
    closeCloseTime: json["CloseCloseTime"],
    date: json["date"],
    color: json["color"],
    type: json["type"],
    status: json["status"],
    monday: json["Monday"],
    tuesday: json["Tuesday"],
    wednesday: json["Wednesday"],
    thursday: json["Thursday"],
    friday: json["Friday"],
    saturday: json["Saturday"],
    sunday: json["Sunday"],
    url: json["url"],
    marketStatus: json["marketStatus"],
    marketStatusToday: json["marketStatusToday"],
    result: json["result"],
    openTime: json["openTime"],
    opencloseTime: json["opencloseTime"],
    closeTime: json["closeTime"],
    marketSessionType: json["marketSessionType"],
    marketOpenTime: json["marketOpenTime"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "marketName": marketName,
    "OpenOpenTime": openOpenTime,
    "OpenCloseTime": openCloseTime,
    "CloseCloseTime": closeCloseTime,
    "date": date,
    "type": type,
    "status": status,
    "color": color,
    "Monday": monday,
    "Tuesday": tuesday,
    "Wednesday": wednesday,
    "Thursday": thursday,
    "Friday": friday,
    "Saturday": saturday,
    "Sunday": sunday,
    "url": url,
    "marketStatus": marketStatus,
    "marketStatusToday": marketStatusToday,
    "result": result,
    "openTime": openTime,
    "opencloseTime": opencloseTime,
    "closeTime": closeTime,
    "marketSessionType": marketSessionType,
    "marketOpenTime": marketOpenTime,
  };
}
