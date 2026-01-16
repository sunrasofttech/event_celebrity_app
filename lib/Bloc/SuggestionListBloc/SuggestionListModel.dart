// To parse this JSON data, do
//
//     final suggestionListModel = suggestionListModelFromJson(jsonString);

import 'dart:convert';

SuggestionListModel suggestionListModelFromJson(String str) => SuggestionListModel.fromJson(json.decode(str));

String suggestionListModelToJson(SuggestionListModel data) => json.encode(data.toJson());

class SuggestionListModel {
  bool? status;
  String? msg;
  List<Datum>? data;

  SuggestionListModel({
    this.status,
    this.msg,
    this.data,
  });

  factory SuggestionListModel.fromJson(Map<String, dynamic> json) => SuggestionListModel(
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
  String? digit;
  String? ank;

  Datum({
    this.digit,
    this.ank,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        digit: json["digit"],
        ank: json["ank"],
      );

  Map<String, dynamic> toJson() => {
        "digit": digit,
        "ank": ank,
      };
}
