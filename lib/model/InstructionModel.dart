// To parse this JSON data, do
//
//     final instructionModel = instructionModelFromJson(jsonString);

import 'dart:convert';

InstructionModel instructionModelFromJson(String str) => InstructionModel.fromJson(json.decode(str));

String instructionModelToJson(InstructionModel data) => json.encode(data.toJson());

class InstructionModel {
    final bool? status;
    final String? msg;
    final List<Datum>? data;

    InstructionModel({
        this.status,
        this.msg,
        this.data,
    });

    factory InstructionModel.fromJson(Map<String, dynamic> json) => InstructionModel(
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
    final String? message;
    final String? type;
    final DateTime? date;

    Datum({
        this.id,
        this.message,
        this.type,
        this.date,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        message: json["message"],
        type: json["type"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "type": type,
        "date": date?.toIso8601String(),
    };
}
