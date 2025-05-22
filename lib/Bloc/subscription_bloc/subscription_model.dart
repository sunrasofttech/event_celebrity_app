// To parse this JSON data, do
//
//     final subscriptionModel = subscriptionModelFromJson(jsonString);

import 'dart:convert';

SubscriptionModel subscriptionModelFromJson(String str) => SubscriptionModel.fromJson(json.decode(str));

String subscriptionModelToJson(SubscriptionModel data) => json.encode(data.toJson());

class SubscriptionModel {
  bool? status;
  List<Datum>? data;

  SubscriptionModel({this.status, this.data});

  SubscriptionModel copyWith({bool? status, List<Datum>? data}) =>
      SubscriptionModel(status: status ?? this.status, data: data ?? this.data);

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) => SubscriptionModel(
    status: json["status"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? name;
  int? validity;
  int? amount;
  int? bonus;
  DateTime? createdAt;

  Datum({this.id, this.name, this.validity, this.amount, this.bonus, this.createdAt});

  Datum copyWith({int? id, String? name, dynamic validity, dynamic amount, dynamic bonus, DateTime? createdAt}) =>
      Datum(
        id: id ?? this.id,
        name: name ?? this.name,
        validity: validity ?? this.validity,
        amount: amount ?? this.amount,
        bonus: bonus ?? this.bonus,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    validity: json["validity"],
    amount: json["amount"],
    bonus: json["bonus"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "validity": validity,
    "amount": amount,
    "bonus": bonus,
    "createdAt": createdAt?.toIso8601String(),
  };
}
