// To parse this JSON data, do
//
//     final paymentModel = paymentModelFromJson(jsonString);

import 'dart:convert';

PaymentModel paymentModelFromJson(String str) => PaymentModel.fromJson(json.decode(str));

String paymentModelToJson(PaymentModel data) => json.encode(data.toJson());

class PaymentModel {
  final bool? status;
  final String? msg;
  final Data? data;

  PaymentModel({this.status, this.msg, this.data});

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      PaymentModel(status: json["status"], msg: json["msg"], data: json["data"] == null ? null : Data.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"status": status, "msg": msg, "data": data?.toJson()};
}

class Data {
  final int? userId;
  final int? amount;
  final DateTime? date;
  final String? merchantTransactionId;
  final String? clientId;
  final String? paymentUrl;
  final String? spURL;
  final String? encData;
  final String? clientCode;

  Data({this.userId, this.amount, this.date, this.merchantTransactionId, this.clientId, this.paymentUrl, this.spURL, this.encData, this.clientCode});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["userId"],
    amount: json["amount"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    merchantTransactionId: json["merchantTransactionId"],
    clientId: json["clientId"],
    paymentUrl: json["paymentUrl"],
    spURL: json["spURL"],
    encData: json["encData"],
    clientCode: json["clientCode"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "amount": amount,
    "date": date?.toIso8601String(),
    "merchantTransactionId": merchantTransactionId,
    "clientId": clientId,
    "paymentUrl": paymentUrl,
    "spURL": spURL,
    "encData": encData,
    "clientCode": clientCode,
  };
}
