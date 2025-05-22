// To parse this JSON data, do
//
//     final referModel = referModelFromJson(jsonString);

import 'dart:convert';

ReferModel referModelFromJson(String str) => ReferModel.fromJson(json.decode(str));

String referModelToJson(ReferModel data) => json.encode(data.toJson());

class ReferModel {
  final bool status;
  final int error;
  final int success;
  final String message;
  final String referralAmount;
  final ReferralCode referralCode;

  ReferModel({
    required this.status,
    required this.error,
    required this.success,
    required this.message,
    required this.referralAmount,
    required this.referralCode,
  });

  factory ReferModel.fromJson(Map<String, dynamic> json) => ReferModel(
    status: json["status"],
    error: json["error"],
    success: json["success"],
    message: json["message"],
    referralAmount: json["referral_amount"],
    referralCode: ReferralCode.fromJson(json["referral_code"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "success": success,
    "message": message,
    "referral_amount": referralAmount,
    "referral_code": referralCode.toJson(),
  };
}

class ReferralCode {
  final String referral;

  ReferralCode({
    required this.referral,
  });

  factory ReferralCode.fromJson(Map<String, dynamic> json) => ReferralCode(
    referral: json["referral"],
  );

  Map<String, dynamic> toJson() => {
    "referral": referral,
  };
}
