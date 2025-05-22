// To parse this JSON data, do
//
//     final panaByAnkModel = panaByAnkModelFromJson(jsonString);

import 'dart:convert';

RedJodiModel redJodiModelFromJson(String str) => RedJodiModel.fromJson(json.decode(str));

String redJodiModelToJson(RedJodiModel data) => json.encode(data.toJson());

class RedJodiModel {
  bool? status;
  String? msg;
  List<Datum>? data;

  RedJodiModel({
    this.status,
    this.msg,
    this.data,
  });

  factory RedJodiModel.fromJson(Map<String, dynamic> json) => RedJodiModel(
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
  dynamic type;
  dynamic ank;

  Datum({
    this.digit,
    this.ank,
    this.type,
  });

  factory Datum.fromJson(Map<String, dynamic> json) =>
      Datum(
        digit: json["digits"],
        ank: json["ank"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() =>
      {
        "digits": digit,
        "ank": ank,
        "type": type,
      };
}