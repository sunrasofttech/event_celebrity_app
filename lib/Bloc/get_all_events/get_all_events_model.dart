// To parse this JSON data, do
//
//     final getAllUpComingEventModel = getAllUpComingEventModelFromJson(jsonString);

import 'dart:convert';

GetAllUpComingEventModel getAllUpComingEventModelFromJson(String str) => GetAllUpComingEventModel.fromJson(json.decode(str));

String getAllUpComingEventModelToJson(GetAllUpComingEventModel data) => json.encode(data.toJson());

class GetAllUpComingEventModel {
    bool? status;
    String? message;
    Data? data;

    GetAllUpComingEventModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetAllUpComingEventModel.fromJson(Map<String, dynamic> json) => GetAllUpComingEventModel(
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
    List<UpcomingEvent>? upcomingEvents;
    List<UpcomingEvent>? todayEvents;
    List<UpcomingEvent>? completedEvents;
    Counts? counts;

    Data({
        this.upcomingEvents,
        this.todayEvents,
        this.completedEvents,
        this.counts,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        upcomingEvents: json["upcomingEvents"] == null ? [] : List<UpcomingEvent>.from(json["upcomingEvents"]!.map((x) => UpcomingEvent.fromJson(x))),
        todayEvents: json["todayEvents"] == null ? [] : List<UpcomingEvent>.from(json["todayEvents"]!.map((x) => UpcomingEvent.fromJson(x))),
        completedEvents: json["completedEvents"] == null ? [] : List<UpcomingEvent>.from(json["completedEvents"]!.map((x) => UpcomingEvent.fromJson(x))),
        counts: json["counts"] == null ? null : Counts.fromJson(json["counts"]),
    );

    Map<String, dynamic> toJson() => {
        "upcomingEvents": upcomingEvents == null ? [] : List<dynamic>.from(upcomingEvents!.map((x) => x.toJson())),
        "todayEvents": todayEvents == null ? [] : List<dynamic>.from(todayEvents!.map((x) => x.toJson())),
        "completedEvents": completedEvents == null ? [] : List<dynamic>.from(completedEvents!.map((x) => x.toJson())),
        "counts": counts?.toJson(),
    };
}

class Counts {
    int? upcoming;
    int? today;
    int? completed;

    Counts({
        this.upcoming,
        this.today,
        this.completed,
    });

    factory Counts.fromJson(Map<String, dynamic> json) => Counts(
        upcoming: json["upcoming"],
        today: json["today"],
        completed: json["completed"],
    );

    Map<String, dynamic> toJson() => {
        "upcoming": upcoming,
        "today": today,
        "completed": completed,
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
    String? showEndTime;
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
        this.showEndTime,
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
        showEndTime: json["showEndTime"],
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
        "showEndTime": showEndTime,
        "bookingStatus": bookingStatus,
    };
}
