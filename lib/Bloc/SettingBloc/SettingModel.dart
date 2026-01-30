// To parse this JSON data, do
//
//     final settingModel = settingModelFromJson(jsonString);

import 'dart:convert';

SettingModel settingModelFromJson(String str) => SettingModel.fromJson(json.decode(str));

String settingModelToJson(SettingModel data) => json.encode(data.toJson());

class SettingModel {
    bool? status;
    Data? data;

    SettingModel({
        this.status,
        this.data,
    });

    factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    String? id;
    String? logoUrl;
    String? appName;
    String? appVersion;
    String? email;
    String? contact;
    String? developedBy;
    String? privacyPolicy;
    String? termsAndConditions;
    String? celebrityAppPrivacy;
    String? celebrityAppAbout;
    DateTime? createdAt;
    DateTime? updatedAt;

    Data({
        this.id,
        this.logoUrl,
        this.appName,
        this.appVersion,
        this.email,
        this.contact,
        this.developedBy,
        this.privacyPolicy,
        this.termsAndConditions,
        this.celebrityAppPrivacy,
        this.celebrityAppAbout,
        this.createdAt,
        this.updatedAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        logoUrl: json["logoUrl"],
        appName: json["appName"],
        appVersion: json["appVersion"],
        email: json["email"],
        contact: json["contact"],
        developedBy: json["developedBy"],
        privacyPolicy: json["privacyPolicy"],
        termsAndConditions: json["termsAndConditions"],
        celebrityAppPrivacy: json["celebrity_app_privacy"],
        celebrityAppAbout: json["celebrity_app_about"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "logoUrl": logoUrl,
        "appName": appName,
        "appVersion": appVersion,
        "email": email,
        "contact": contact,
        "developedBy": developedBy,
        "privacyPolicy": privacyPolicy,
        "termsAndConditions": termsAndConditions,
        "celebrity_app_privacy": celebrityAppPrivacy,
        "celebrity_app_about": celebrityAppAbout,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
