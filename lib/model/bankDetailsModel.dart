// To parse this JSON data, do
//
//     final bankDetailsModel = bankDetailsModelFromJson(jsonString);

import 'dart:convert';

BankDetailsModel bankDetailsModelFromJson(String str) => BankDetailsModel.fromJson(json.decode(str));

String bankDetailsModelToJson(BankDetailsModel data) => json.encode(data.toJson());

class BankDetailsModel {
  int? id;
  String? name;
  String? accountNo;
  String? ifsc;
  int? userId;
  String? googlePay;
  String? paytm;
  String? phonepe;
  String? upi;
  String? placeholder;

  BankDetailsModel({
    this.id,
    this.name,
    this.accountNo,
    this.ifsc,
    this.userId,
    this.googlePay,
    this.paytm,
    this.phonepe,
    this.upi,
    this.placeholder
  });

  factory BankDetailsModel.fromJson(Map<String, dynamic> json) => BankDetailsModel(
        id: json["id"] ?? 0,
        name: json["Name"] ?? "",
        accountNo: json["accountNo"] ?? "",
        ifsc: json["IFSC"] ?? "",
        userId: json["userId"] ?? 0,
        googlePay: json["GooglePay"] ?? "",
        paytm: json["Paytm"] ?? "",
        phonepe: json["Phonepe"] ?? "",
        upi: json["UPI"] ?? "",
        placeholder: json["accountHolderName"]
      );

  BankDetailsModel.empty() {
    id = 0;
    userId = 0;
    name = "";
    accountNo = "";
    ifsc = "";
    phonepe = "";
    googlePay = "";
    upi = "";
    paytm = "";
    placeholder="";
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "Name": name,
        "accountNo": accountNo,
        "IFSC": ifsc,
        "userId": userId,
        "GooglePay": googlePay,
        "Paytm": paytm,
        "Phonepe": phonepe,
        "UPI": upi,
        "accountHolderName":placeholder,
      };
}
