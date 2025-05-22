// To parse this JSON data, do
//
//     final panaByAnkModel = panaByAnkModelFromJson(jsonString);

import 'dart:convert';

PanaByAnkModel panaByAnkModelFromJson(String str) => PanaByAnkModel.fromJson(json.decode(str));

String panaByAnkModelToJson(PanaByAnkModel data) => json.encode(data.toJson());

class PanaByAnkModel {
  bool? status;
  String? msg;
  List<Datum>? data;

  PanaByAnkModel({
    this.status,
    this.msg,
    this.data,
  });

  factory PanaByAnkModel.fromJson(Map<String, dynamic> json) => PanaByAnkModel(
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
  dynamic digit;
  dynamic ank;
  dynamic mtype;

  Datum({
    this.digit,
    this.ank,
    this.mtype,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    digit: json["digit"],
    ank: json["ank"],
    mtype: json["mtype"],
  );

  Map<String, dynamic> toJson() => {
    "digit": digit,
    "ank": ank,
    "mtype": mtype,
  };
}