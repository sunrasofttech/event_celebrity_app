// To parse this JSON data, do
//
//     final checkBankModel = checkBankModelFromJson(jsonString);

import 'dart:convert';

CheckBankModel checkBankModelFromJson(String str) => CheckBankModel.fromJson(json.decode(str));

String checkBankModelToJson(CheckBankModel data) => json.encode(data.toJson());

class CheckBankModel {
  final bool status;
  final int error;
  final int success;
  final String message;

  CheckBankModel({
    required this.status,
    required this.error,
    required this.success,
    required this.message,
  });

  factory CheckBankModel.fromJson(Map<String, dynamic> json) => CheckBankModel(
    status: json["status"],
    error: json["error"],
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "success": success,
    "message": message,
  };
}
