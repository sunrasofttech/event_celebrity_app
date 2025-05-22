// To parse this JSON data, do
//
//     final homeTextModel = homeTextModelFromJson(jsonString);

import 'dart:convert';

HomeTextModel homeTextModelFromJson(String str) => HomeTextModel.fromJson(json.decode(str));

String homeTextModelToJson(HomeTextModel data) => json.encode(data.toJson());

class HomeTextModel {
  bool? status;
  String? msg;
  String? homeText;
  String? type;

  HomeTextModel({this.status, this.msg, this.homeText, this.type});

  HomeTextModel copyWith({bool? status, String? msg, String? homeText, String? type}) =>
      HomeTextModel(status: status ?? this.status, msg: msg ?? this.msg, homeText: homeText ?? this.homeText, type: type ?? this.type);

  factory HomeTextModel.fromJson(Map<String, dynamic> json) =>
      HomeTextModel(status: json["status"], msg: json["msg"], homeText: json["homeText"], type: json["type"]);

  Map<String, dynamic> toJson() => {"status": status, "msg": msg, "homeText": homeText, "type": type};
}
