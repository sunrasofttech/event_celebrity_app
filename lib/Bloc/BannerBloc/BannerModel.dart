// To parse this JSON data, do
//
//     final bannerModel = bannerModelFromJson(jsonString);

import 'dart:convert';

BannerModel bannerModelFromJson(String str) => BannerModel.fromJson(json.decode(str));

String bannerModelToJson(BannerModel data) => json.encode(data.toJson());

class BannerModel {
  bool? status;
  String? msg;
  List<Datum>? data;

  BannerModel({
    this.status,
    this.msg,
    this.data,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
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
  String? imagepath;
  String? date;
  String? status;
  String? text;
  String? link;

  Datum({
    this.id,
    this.imagepath,
    this.date,
    this.status,
    this.text,
    this.link,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        imagepath: json["imagepath"],
        date: json["date"],
        status: json["status"],
        text: json["text"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "imagepath": imagepath,
        "date": date,
        "status": status,
        "text": text,
        "link": link,
      };
}
