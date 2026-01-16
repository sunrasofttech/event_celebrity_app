// To parse this JSON data, do
//
//     final depositModel = depositModelFromJson(jsonString);

import 'dart:convert';

DepositModel depositModelFromJson(String str) => DepositModel.fromJson(json.decode(str));

String depositModelToJson(DepositModel data) => json.encode(data.toJson());

class DepositModel {
    final bool? status;
    final String? msg;
    final List<Datum>? data;

    DepositModel({
        this.status,
        this.msg,
        this.data,
    });

    factory DepositModel.fromJson(Map<String, dynamic> json) => DepositModel(
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
    final int? id;
    final int? price;

    Datum({
        this.id,
        this.price,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
    };
}
