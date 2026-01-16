// To parse this JSON data, do
//
//     final panaModel = panaModelFromJson(jsonString);

import 'dart:convert';

PanaModel panaModelFromJson(String str) => PanaModel.fromJson(json.decode(str));

String panaModelToJson(PanaModel data) => json.encode(data.toJson());

class PanaModel {
  bool? status;
  String? msg;
  List<Datum>? data;

  PanaModel({
    this.status,
    this.msg,
    this.data,
  });

  factory PanaModel.fromJson(Map<String, dynamic> json) =>
      PanaModel(
        status: json["status"],
        msg: json["msg"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {
        "status": status,
        "msg": msg,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  dynamic digit;
  dynamic mType;
  dynamic ank;

  Datum({
    this.digit,
    this.ank,
    this.mType,
  });

  factory Datum.fromJson(Map<String, dynamic> json) =>
      Datum(
        digit: json["digit"],
        ank: json["ank"],
        mType: json["mType"],
      );

  Map<String, dynamic> toJson() =>
      {
        "digit": digit,
        "ank": ank,
        "mType": mType,
      };
}
