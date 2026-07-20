// To parse this JSON data, do
//
//     final getAllRevenueModel = getAllRevenueModelFromJson(jsonString);

import 'dart:convert';

GetAllRevenueModel getAllRevenueModelFromJson(String str) => GetAllRevenueModel.fromJson(json.decode(str));

String getAllRevenueModelToJson(GetAllRevenueModel data) => json.encode(data.toJson());

class GetAllRevenueModel {
    bool? status;
    String? message;
    Data? data;

    GetAllRevenueModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetAllRevenueModel.fromJson(Map<String, dynamic> json) => GetAllRevenueModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    Summary? summary;
    List<RevenueList>? revenueList;

    Data({
        this.summary,
        this.revenueList,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
        revenueList: json["revenueList"] == null ? [] : List<RevenueList>.from(json["revenueList"]!.map((x) => RevenueList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "summary": summary?.toJson(),
        "revenueList": revenueList == null ? [] : List<dynamic>.from(revenueList!.map((x) => x.toJson())),
    };
}

class RevenueList {
    String? id;
    String? agreedPrice;
    String? status;
    String? paymentStatus;
    List<DateTime>? requestedDates;
    String? userId;
    String? userName;
    dynamic profileImg;
    dynamic organizerId;
    dynamic organizerName;
    String? eventId;
    String? eventName;
    String? coverImageUrl;
    List<DateTime>? eventDate;
    dynamic eventPlace;
    String? eventAddress;
    String? entryTime;
    String? showStartTime;
    String? showEndTime;

    RevenueList({
        this.id,
        this.agreedPrice,
        this.status,
        this.paymentStatus,
        this.requestedDates,
        this.userId,
        this.userName,
        this.profileImg,
        this.organizerId,
        this.organizerName,
        this.eventId,
        this.eventName,
        this.coverImageUrl,
        this.eventDate,
        this.eventPlace,
        this.eventAddress,
        this.entryTime,
        this.showStartTime,
        this.showEndTime,
    });

    factory RevenueList.fromJson(Map<String, dynamic> json) => RevenueList(
        id: json["id"],
        agreedPrice: json["agreedPrice"],
        status: json["status"],
        paymentStatus: json["paymentStatus"],
        requestedDates: json["requestedDates"] == null ? [] : List<DateTime>.from(json["requestedDates"]!.map((x) => DateTime.parse(x))),
        userId: json["userId"],
        userName: json["userName"],
        profileImg: json["profile_img"],
        organizerId: json["organizerId"],
        organizerName: json["organizerName"],
        eventId: json["eventId"],
        eventName: json["eventName"],
        coverImageUrl: json["coverImageUrl"],
        eventDate: json["eventDate"] == null ? [] : List<DateTime>.from(json["eventDate"]!.map((x) => DateTime.parse(x))),
        eventPlace: json["eventPlace"],
        eventAddress: json["eventAddress"],
        entryTime: json["entryTime"],
        showStartTime: json["showStartTime"],
        showEndTime: json["showEndTime"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "agreedPrice": agreedPrice,
        "status": status,
        "paymentStatus": paymentStatus,
        "requestedDates": requestedDates == null ? [] : List<dynamic>.from(requestedDates!.map((x) => "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
        "userId": userId,
        "userName": userName,
        "profile_img": profileImg,
        "organizerId": organizerId,
        "organizerName": organizerName,
        "eventId": eventId,
        "eventName": eventName,
        "coverImageUrl": coverImageUrl,
        "eventDate": eventDate == null ? [] : List<dynamic>.from(eventDate!.map((x) => "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
        "eventPlace": eventPlace,
        "eventAddress": eventAddress,
        "entryTime": entryTime,
        "showStartTime": showStartTime,
        "showEndTime": showEndTime,
    };
}

class Summary {
    String? totalRevenue;
    int? totalTransactions;

    Summary({
        this.totalRevenue,
        this.totalTransactions,
    });

    factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        totalRevenue: json["totalRevenue"],
        totalTransactions: json["totalTransactions"],
    );

    Map<String, dynamic> toJson() => {
        "totalRevenue": totalRevenue,
        "totalTransactions": totalTransactions,
    };
}
