// To parse this JSON data, do
//
//     final pattiModel = pattiModelFromJson(jsonString);

import 'dart:convert';

PattiModel pattiModelFromJson(String str) => PattiModel.fromJson(json.decode(str));

String pattiModelToJson(PattiModel data) => json.encode(data.toJson());

class PattiModel {
  bool status;
  String message;
  List<Result> result;

  PattiModel({
    required this.status,
    required this.message,
    required this.result,
  });

  factory PattiModel.fromJson(Map<String, dynamic> json) => PattiModel(
        status: json["status"],
        message: json["message"],
        result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class Result {
  int id;
  dynamic digit;
  dynamic numbers;
  dynamic deleted;

  Result({
    required this.id,
    required this.digit,
    required this.numbers,
    required this.deleted,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        digit: json["digit"],
        numbers: json["number"],
        deleted: json["deleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "digit": digit,
        "number": numbers,
        "deleted": deleted,
      };
}
