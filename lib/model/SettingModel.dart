// To parse this JSON data, do
//
//     final settingModel = settingModelFromJson(jsonString);

import 'dart:convert';

SettingModel settingModelFromJson(String str) => SettingModel.fromJson(json.decode(str));

String settingModelToJson(SettingModel data) => json.encode(data.toJson());

class SettingModel {
    final bool status;
    final int error;
    final int success;
    final Result result;

    SettingModel({
        required this.status,
        required this.error,
        required this.success,
        required this.result,
    });

    factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
        status: json["status"],
        error: json["error"],
        success: json["success"],
        result: Result.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
        "success": success,
        "result": result.toJson(),
    };
}

class Result {
    final String id;
    final String userid;
    final String email;
    final String phone;
    final String whatsApp;
    final String onesignalAppId;
    final String onesignalApiKey;
    final String rozarpayAppId;
    final String rozarpayApiKey;
    final String title;
    final String logoImgpath;
    final String favicon;
    final String playStoreLink;
    final String deleted;
    final String addedBy;
    final DateTime dt;
    final String autoActivate;
    final String howToPlay;
    final String telegramLink;
    final String fcmKey;
    final String popBanner;
    final String value;
    final String type;
    final String privacy;
    final dynamic privacyUrl;
    final String depositLimit;
    final String withdrawLimit;

    Result({
        required this.id,
        required this.userid,
        required this.email,
        required this.phone,
        required this.whatsApp,
        required this.onesignalAppId,
        required this.onesignalApiKey,
        required this.rozarpayAppId,
        required this.rozarpayApiKey,
        required this.title,
        required this.logoImgpath,
        required this.favicon,
        required this.playStoreLink,
        required this.deleted,
        required this.addedBy,
        required this.dt,
        required this.autoActivate,
        required this.howToPlay,
        required this.telegramLink,
        required this.fcmKey,
        required this.popBanner,
        required this.value,
        required this.type,
        required this.privacy,
        required this.privacyUrl,
        required this.depositLimit,
        required this.withdrawLimit,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        userid: json["userid"],
        email: json["email"],
        phone: json["phone"],
        whatsApp: json["whats_app"],
        onesignalAppId: json["onesignal_app_id"],
        onesignalApiKey: json["onesignal_api_key"],
        rozarpayAppId: json["rozarpay_app_id"],
        rozarpayApiKey: json["rozarpay_api_key"],
        title: json["title"],
        logoImgpath: json["logo_imgpath"],
        favicon: json["favicon"],
        playStoreLink: json["play_store_link"],
        deleted: json["deleted"],
        addedBy: json["added_by"],
        dt: DateTime.parse(json["dt"]),
        autoActivate: json["auto_activate"],
        howToPlay: json["how_to_play"],
        telegramLink: json["telegram_link"],
        fcmKey: json["fcm_key"],
        popBanner: json["pop_banner"],
        value: json["value"],
        type: json["type"],
        privacy: json["privacy"],
        privacyUrl: json["privacy_url"],
        depositLimit: json["deposit_limit"],
        withdrawLimit: json["withdraw_limit"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userid": userid,
        "email": email,
        "phone": phone,
        "whats_app": whatsApp,
        "onesignal_app_id": onesignalAppId,
        "onesignal_api_key": onesignalApiKey,
        "rozarpay_app_id": rozarpayAppId,
        "rozarpay_api_key": rozarpayApiKey,
        "title": title,
        "logo_imgpath": logoImgpath,
        "favicon": favicon,
        "play_store_link": playStoreLink,
        "deleted": deleted,
        "added_by": addedBy,
        "dt": dt.toIso8601String(),
        "auto_activate": autoActivate,
        "how_to_play": howToPlay,
        "telegram_link": telegramLink,
        "fcm_key": fcmKey,
        "pop_banner": popBanner,
        "value": value,
        "type": type,
        "privacy": privacy,
        "privacy_url": privacyUrl,
        "deposit_limit": depositLimit,
        "withdraw_limit": withdrawLimit,
    };
}
