// To parse this JSON data, do
//
//     final getDashboardModel = getDashboardModelFromJson(jsonString);

import 'dart:convert';

GetDashboardModel getDashboardModelFromJson(String str) => GetDashboardModel.fromJson(json.decode(str));

String getDashboardModelToJson(GetDashboardModel data) => json.encode(data.toJson());

class GetDashboardModel {
    bool? status;
    String? message;
    Data? data;

    GetDashboardModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetDashboardModel.fromJson(Map<String, dynamic> json) => GetDashboardModel(
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
    String? welcomeMessage;
    List<UpcomingEvent>? upcomingEvents;
    List<UpcomingBookingRequest>? upcomingBookingRequests;
    Analytics? analytics;

    Data({
        this.welcomeMessage,
        this.upcomingEvents,
        this.upcomingBookingRequests,
        this.analytics,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        welcomeMessage: json["welcomeMessage"],
        upcomingEvents: json["upcomingEvents"] == null ? [] : List<UpcomingEvent>.from(json["upcomingEvents"]!.map((x) => UpcomingEvent.fromJson(x))),
        upcomingBookingRequests: json["upcomingBookingRequests"] == null ? [] : List<UpcomingBookingRequest>.from(json["upcomingBookingRequests"]!.map((x) => UpcomingBookingRequest.fromJson(x))),
        analytics: json["analytics"] == null ? null : Analytics.fromJson(json["analytics"]),
    );

    Map<String, dynamic> toJson() => {
        "welcomeMessage": welcomeMessage,
        "upcomingEvents": upcomingEvents == null ? [] : List<dynamic>.from(upcomingEvents!.map((x) => x.toJson())),
        "upcomingBookingRequests": upcomingBookingRequests == null ? [] : List<dynamic>.from(upcomingBookingRequests!.map((x) => x.toJson())),
        "analytics": analytics?.toJson(),
    };
}

class Analytics {
    int? profileViews;
    int? upcomingEventsCount;
    int? pendingRequestsCount;

    Analytics({
        this.profileViews,
        this.upcomingEventsCount,
        this.pendingRequestsCount,
    });

    factory Analytics.fromJson(Map<String, dynamic> json) => Analytics(
        profileViews: json["profileViews"],
        upcomingEventsCount: json["upcomingEventsCount"],
        pendingRequestsCount: json["pendingRequestsCount"],
    );

    Map<String, dynamic> toJson() => {
        "profileViews": profileViews,
        "upcomingEventsCount": upcomingEventsCount,
        "pendingRequestsCount": pendingRequestsCount,
    };
}

class UpcomingBookingRequest {
    String? id;
    List<DateTime>? requestedDates;
    String? status;
    String? notes;
    dynamic agreedPrice;
    String? paymentStatus;
    DateTime? createdAt;

    UpcomingBookingRequest({
        this.id,
        this.requestedDates,
        this.status,
        this.notes,
        this.agreedPrice,
        this.paymentStatus,
        this.createdAt,
    });

    factory UpcomingBookingRequest.fromJson(Map<String, dynamic> json) => UpcomingBookingRequest(
        id: json["id"],
        requestedDates: json["requestedDates"] == null ? [] : List<DateTime>.from(json["requestedDates"]!.map((x) => DateTime.parse(x))),
        status: json["status"],
        notes: json["notes"],
        agreedPrice: json["agreedPrice"],
        paymentStatus: json["paymentStatus"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "requestedDates": requestedDates == null ? [] : List<dynamic>.from(requestedDates!.map((x) => "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
        "status": status,
        "notes": notes,
        "agreedPrice": agreedPrice,
        "paymentStatus": paymentStatus,
        "createdAt": createdAt?.toIso8601String(),
    };
}

class UpcomingEvent {
    String? id;
    String? eventName;
    List<String>? eventDate;
    String? coverImageUrl;
    dynamic eventPlace;
    dynamic eventAddress;
    String? entryTime;
    String? showStartTime;
    String? bookingStatus;

    UpcomingEvent({
        this.id,
        this.eventName,
        this.eventDate,
        this.coverImageUrl,
        this.eventPlace,
        this.eventAddress,
        this.entryTime,
        this.showStartTime,
        this.bookingStatus,
    });

    factory UpcomingEvent.fromJson(Map<String, dynamic> json) => UpcomingEvent(
        id: json["id"],
        eventName: json["eventName"],
        eventDate: json["eventDate"] == null ? [] : List<String>.from(json["eventDate"]),
        coverImageUrl: json["coverImageUrl"],
        eventPlace: json["eventPlace"],
        eventAddress: json["eventAddress"],
        entryTime: json["entryTime"],
        showStartTime: json["showStartTime"],
        bookingStatus: json["bookingStatus"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "eventName": eventName,
        "eventDate": eventDate,
        "coverImageUrl": coverImageUrl,
        "eventPlace": eventPlace,
        "eventAddress": eventAddress,
        "entryTime": entryTime,
        "showStartTime": showStartTime,
        "bookingStatus": bookingStatus,
    };
}
