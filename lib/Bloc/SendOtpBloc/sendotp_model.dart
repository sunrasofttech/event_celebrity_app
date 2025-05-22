// To parse this JSON data, do
//
//     final sendOtpModel = sendOtpModelFromJson(jsonString);

import 'dart:convert';

SendOtpModel sendOtpModelFromJson(String str) => SendOtpModel.fromJson(json.decode(str));

String sendOtpModelToJson(SendOtpModel data) => json.encode(data.toJson());

class SendOtpModel {
  bool? success;
  String? message;
  String? otp;
  Response? response;

  SendOtpModel({
    this.success,
    this.message,
    this.otp,
    this.response,
  });

  factory SendOtpModel.fromJson(Map<String, dynamic> json) => SendOtpModel(
        success: json["success"],
        message: json["message"],
        otp: json["otp"],
        response: json["response"] == null ? null : Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "otp": otp,
        "response": response?.toJson(),
      };
}

class Response {
  int? status;
  String? msg;

  Response({
    this.status,
    this.msg,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        status: json["status"],
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
      };
}
