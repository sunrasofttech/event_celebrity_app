// To parse this JSON data, do
//
//     final settingModel = settingModelFromJson(jsonString);

import 'dart:convert';

SettingModel settingModelFromJson(String str) => SettingModel.fromJson(json.decode(str));

String settingModelToJson(SettingModel data) => json.encode(data.toJson());

class SettingModel {
  final bool? status;
  final List<Datum>? data;

  SettingModel({this.status, this.data});

  factory SettingModel.fromJson(Map<String, dynamic> json) =>
      SettingModel(status: json["status"], data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))));

  Map<String, dynamic> toJson() => {"status": status, "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson()))};
}

class Datum {
  final int? id;
  final String? phone;
  final String? upiName;
  final int? withdrawMinimumLimitAmount;
  final int? withdrawQueryNo;
  final String? withdrawText;
  final String? websiteLogo;
  final String? fabiconLogo;
  final String? firebaseKey;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? whatsappNo;
  final String? telegramLink;
  final int? referedByMoney;
  final int? referedToMoney;
  final String? websiteTitle;
  final String? email;
  final String? oneSignalAppId;
  final String? razorPayAppId;
  final String? razorPayAppKey;
  final String? googlePlayLink;
  final String? howToPlay;
  final String? version;
  final int? minimumDeposit;
  final String? step1;
  final String? step2;
  final String? qrImage;
  final String? videolink;
  final int? minimumBidAmount;
  final String? startTime;
  final String? endTime;
  final String? withdrawRequestText;
  final String? monday;
  final String? tuesday;
  final String? wednesday;
  final String? thursday;
  final String? friday;
  final String? saturday;
  final String? sunday;
  final String? harmFullAppTitle;
  final int? minimumSdBidAmount;
  final int? minimumJdBidAmount;
  final String? minimumSpDpTpBidAmount;
  final int? minimumFsdBidAmount;
  final int? minimumHsdBidAmount;
  final int? minimumWithdrawDailyLimit;
  final String? weekDayStatus;
  final String? shareUrl;
  final dynamic withdrawEnabled;
  final dynamic paymentMode;

  Datum({
    this.id,
    this.phone,
    this.upiName,
    this.withdrawMinimumLimitAmount,
    this.withdrawQueryNo,
    this.withdrawText,
    this.websiteLogo,
    this.fabiconLogo,
    this.firebaseKey,
    this.createdAt,
    this.updatedAt,
    this.whatsappNo,
    this.referedByMoney,
    this.referedToMoney,
    this.websiteTitle,
    this.email,
    this.oneSignalAppId,
    this.razorPayAppId,
    this.razorPayAppKey,
    this.googlePlayLink,
    this.howToPlay,
    this.version,
    this.minimumDeposit,
    this.step1,
    this.step2,
    this.qrImage,
    this.videolink,
    this.minimumBidAmount,
    this.startTime,
    this.endTime,
    this.withdrawRequestText,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
    this.harmFullAppTitle,
    this.minimumSdBidAmount,
    this.minimumJdBidAmount,
    this.minimumSpDpTpBidAmount,
    this.minimumFsdBidAmount,
    this.minimumHsdBidAmount,
    this.minimumWithdrawDailyLimit,
    this.weekDayStatus,
    this.shareUrl,
    this.withdrawEnabled,
    this.paymentMode,
    this.telegramLink,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    phone: json["phone"],
    upiName: json["upiName"],
    withdrawMinimumLimitAmount: json["withdrawMinimumLimitAmount"],
    withdrawQueryNo: json["withdrawQueryNo"],
    withdrawText: json["withdrawText"],
    websiteLogo: json["websiteLogo"],
    fabiconLogo: json["fabiconLogo"],
    firebaseKey: json["firebaseKey"],
    shareUrl: json["share_url"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    whatsappNo: json["whatsappNo"],
    referedByMoney: json["referedByMoney"],
    referedToMoney: json["referedToMoney"],
    websiteTitle: json["websiteTitle"],
    email: json["email"],
    oneSignalAppId: json["oneSignalAppId"],
    razorPayAppId: json["razorPayAppId"],
    razorPayAppKey: json["razorPayAppKey"],
    googlePlayLink: json["googlePlayLink"],
    howToPlay: json["howToPlay"],
    version: json["version"],
    minimumDeposit: json["minimumDeposit"],
    step1: json["step1"],
    step2: json["step2"],
    qrImage: json["QrImage"],
    videolink: json["videolink"],
    minimumBidAmount: json["minimumBidAmount"],
    startTime: json["startTime"],
    endTime: json["endTime"],
    withdrawRequestText: json["withdrawRequestText"],
    monday: json["Monday"],
    tuesday: json["Tuesday"],
    wednesday: json["Wednesday"],
    thursday: json["Thursday"],
    friday: json["Friday"],
    saturday: json["Saturday"],
    sunday: json["Sunday"],
    harmFullAppTitle: json["harmful_app_text"],
    minimumSdBidAmount: json["minimum_sd_bid_amount"],
    minimumJdBidAmount: json["minimum_jd_bid_amount"],
    minimumSpDpTpBidAmount: json["minimum_sp_dp_tp_bid_amount"],
    minimumFsdBidAmount: json["minimum_fsd_bid_amount"],
    minimumHsdBidAmount: json["minimum_hsd_bid_amount"],
    minimumWithdrawDailyLimit: json["minimum_withdraw_daily_limit"],
    weekDayStatus: json["WeekDayStatus"],
    withdrawEnabled: json["withdraw"],
    paymentMode: json["payment_mode"],
    telegramLink: json["telegram_link"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "phone": phone,
    "upiName": upiName,
    "withdrawMinimumLimitAmount": withdrawMinimumLimitAmount,
    "withdrawQueryNo": withdrawQueryNo,
    "withdrawText": withdrawText,
    "websiteLogo": websiteLogo,
    "fabiconLogo": fabiconLogo,
    "firebaseKey": firebaseKey,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "whatsappNo": whatsappNo,
    "referedByMoney": referedByMoney,
    "referedToMoney": referedToMoney,
    "websiteTitle": websiteTitle,
    "email": email,
    "share_url": shareUrl,
    "harmful_app_text": harmFullAppTitle,
    "oneSignalAppId": oneSignalAppId,
    "razorPayAppId": razorPayAppId,
    "razorPayAppKey": razorPayAppKey,
    "googlePlayLink": googlePlayLink,
    "howToPlay": howToPlay,
    "version": version,
    "minimumDeposit": minimumDeposit,
    "step1": step1,
    "step2": step2,
    "QrImage": qrImage,
    "videolink": videolink,
    "minimumBidAmount": minimumBidAmount,
    "startTime": startTime,
    "endTime": endTime,
    "withdrawRequestText": withdrawRequestText,
    "Monday": monday,
    "Tuesday": tuesday,
    "Wednesday": wednesday,
    "Thursday": thursday,
    "Friday": friday,
    "Saturday": saturday,
    "Sunday": sunday,
    "minimum_sd_bid_amount": minimumSdBidAmount,
    "minimum_jd_bid_amount": minimumJdBidAmount,
    "minimum_sp_dp_tp_bid_amount": minimumSpDpTpBidAmount,
    "minimum_fsd_bid_amount": minimumFsdBidAmount,
    "minimum_hsd_bid_amount": minimumHsdBidAmount,
    "minimum_withdraw_daily_limit": minimumWithdrawDailyLimit,
    "WeekDayStatus": weekDayStatus,
    "withdraw": withdrawEnabled,
    "payment_mode": paymentMode,
    "telegram_link": telegramLink,
  };
}
