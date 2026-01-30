// To parse this JSON data, do
//
//     final getAllEaringModel = getAllEaringModelFromJson(jsonString);

import 'dart:convert';

GetAllEaringModel getAllEaringModelFromJson(String str) => GetAllEaringModel.fromJson(json.decode(str));

String getAllEaringModelToJson(GetAllEaringModel data) => json.encode(data.toJson());

class GetAllEaringModel {
    bool? status;
    List<Datum>? data;
    Pagination? pagination;

    GetAllEaringModel({
        this.status,
        this.data,
        this.pagination,
    });

    factory GetAllEaringModel.fromJson(Map<String, dynamic> json) => GetAllEaringModel(
        status: json["status"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
    };
}

class Datum {
    String? id;
    String? userId;
    String? celebrityId;
    String? organizerId;
    List<DateTime>? requestedDates;
    Notes? notes;
    Status? status;
    dynamic agreedPrice;
    PaymentStatus? paymentStatus;
    DateTime? createdAt;
    DateTime? updatedAt;
    User? user;
    Celebrity? celebrity;
    Organizer? organizer;

    Datum({
        this.id,
        this.userId,
        this.celebrityId,
        this.organizerId,
        this.requestedDates,
        this.notes,
        this.status,
        this.agreedPrice,
        this.paymentStatus,
        this.createdAt,
        this.updatedAt,
        this.user,
        this.celebrity,
        this.organizer,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["userId"],
        celebrityId: json["celebrityId"],
        organizerId: json["organizerId"],
        requestedDates: json["requestedDates"] == null ? [] : List<DateTime>.from(json["requestedDates"]!.map((x) => DateTime.parse(x))),
        notes: notesValues.map[json["notes"]]!,
        status: statusValues.map[json["status"]]!,
        agreedPrice: json["agreedPrice"],
        paymentStatus: paymentStatusValues.map[json["paymentStatus"]]!,
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        celebrity: json["celebrity"] == null ? null : Celebrity.fromJson(json["celebrity"]),
        organizer: json["organizer"] == null ? null : Organizer.fromJson(json["organizer"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "celebrityId": celebrityId,
        "organizerId": organizerId,
        "requestedDates": requestedDates == null ? [] : List<dynamic>.from(requestedDates!.map((x) => "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
        "notes": notesValues.reverse[notes],
        "status": statusValues.reverse[status],
        "agreedPrice": agreedPrice,
        "paymentStatus": paymentStatusValues.reverse[paymentStatus],
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
        "celebrity": celebrity?.toJson(),
        "organizer": organizer?.toJson(),
    };
}

class Celebrity {
    String? fullName;

    Celebrity({
        this.fullName,
    });

    factory Celebrity.fromJson(Map<String, dynamic> json) => Celebrity(
        fullName: json["fullName"],
    );

    Map<String, dynamic> toJson() => {
        "fullName": fullName,
    };
}

enum Notes {
    BOOKED,
    DDR,
    VH
}

final notesValues = EnumValues({
    "booked ": Notes.BOOKED,
    "ddr": Notes.DDR,
    "vh": Notes.VH
});

class Organizer {
    String? name;

    Organizer({
        this.name,
    });

    factory Organizer.fromJson(Map<String, dynamic> json) => Organizer(
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
    };
}

enum PaymentStatus {
    NOT_APPLICABLE
}

final paymentStatusValues = EnumValues({
    "not_applicable": PaymentStatus.NOT_APPLICABLE
});

enum Status {
    PENDING
}

final statusValues = EnumValues({
    "pending": Status.PENDING
});

class User {
    FullName? fullName;
    String? mobile;

    User({
        this.fullName,
        this.mobile,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        fullName: fullNameValues.map[json["fullName"]]!,
        mobile: json["mobile"],
    );

    Map<String, dynamic> toJson() => {
        "fullName": fullNameValues.reverse[fullName],
        "mobile": mobile,
    };
}

enum FullName {
    RAHUL_SHARMA
}

final fullNameValues = EnumValues({
    "Rahul Sharma": FullName.RAHUL_SHARMA
});

class Pagination {
    int? totalItems;
    int? totalPages;
    int? currentPage;

    Pagination({
        this.totalItems,
        this.totalPages,
        this.currentPage,
    });

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalItems: json["totalItems"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
    );

    Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "totalPages": totalPages,
        "currentPage": currentPage,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
