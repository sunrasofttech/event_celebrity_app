// To parse this JSON data, do
//
//     final getAvailabilityModel = getAvailabilityModelFromJson(jsonString);

import 'dart:convert';

GetAvailabilityModel getAvailabilityModelFromJson(String str) => GetAvailabilityModel.fromJson(json.decode(str));

String getAvailabilityModelToJson(GetAvailabilityModel data) => json.encode(data.toJson());

class GetAvailabilityModel {
    bool? status;
    String? message;
    Data? data;

    GetAvailabilityModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetAvailabilityModel.fromJson(Map<String, dynamic> json) => GetAvailabilityModel(
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
    List<dynamic>? bookedDates;
    List<dynamic>? unavailableDates;
    List<dynamic>? availableDates;

    Data({
        this.bookedDates,
        this.unavailableDates,
        this.availableDates,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        bookedDates: json["booked_dates"] == null ? [] : List<dynamic>.from(json["booked_dates"]!.map((x) => x)),
        unavailableDates: json["unavailable_dates"] == null ? [] : List<dynamic>.from(json["unavailable_dates"]),
        availableDates: json["available_dates"] == null ? [] : List<dynamic>.from(json["available_dates"]),
    );

    Map<String, dynamic> toJson() => {
        "booked_dates": bookedDates == null ? [] : List<dynamic>.from(bookedDates!.map((x) => x)),
        "unavailable_dates": unavailableDates == null ? [] : List<dynamic>.from(unavailableDates!.map((x) => "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
        "available_dates": availableDates == null ? [] : List<dynamic>.from(availableDates!.map((x) => "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
    };
}
