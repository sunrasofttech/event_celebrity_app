// To parse this JSON data, do
//
//     final panaByAnkModel = panaByAnkModelFromJson(jsonString);

import 'dart:convert';

OddEvenModel oddEvenModelFromJson(String str) => OddEvenModel.fromJson(json.decode(str));

String oddEvenModelToJson(OddEvenModel data) => json.encode(data.toJson());

class OddEvenModel {
  bool? status;
  String? msg;
  List<Datum>? data;

  OddEvenModel({
    this.status,
    this.msg,
    this.data,
  });

  factory OddEvenModel.fromJson(Map<String, dynamic> json) => OddEvenModel(
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
  dynamic number;
  dynamic ank;
  dynamic mtype;

  Datum({
    this.number,
    this.ank,
    this.mtype,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    number: json["number"],
    ank: json["ank"],
    mtype: json["mtype"],
  );

  Map<String, dynamic> toJson() => {
    "number": number,
    "ank": ank,
    "mtype": mtype,
  };
}