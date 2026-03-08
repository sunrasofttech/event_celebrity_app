// To parse this JSON data, do
//
//     final eventDetailsModel = eventDetailsModelFromJson(jsonString);

import 'dart:convert';

EventDetailsModel eventDetailsModelFromJson(String str) =>
    EventDetailsModel.fromJson(json.decode(str));

String eventDetailsModelToJson(EventDetailsModel data) =>
    json.encode(data.toJson());

class EventDetailsModel {
  bool? status;
  String? message;
  EventData? data;

  EventDetailsModel({this.status, this.message, this.data});

  factory EventDetailsModel.fromJson(Map<String, dynamic> json) =>
      EventDetailsModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : EventData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class EventData {
  int? totalEventCapacity;
  int? totalAvailableSeats;
  int? totalTicketsSold;
  String? id;
  String? coverImageUrl;
  String? eventName;
  List<String>? eventDate;
  String? entryTime;
  String? showStartTime;
  String? disclamer;
  String? languages;
  String? ageLimit;
  String? showEndTime;
  String? organizerId;
  String? shortBio;
  String? termsAndConditions;
  String? thingsToKnow;
  dynamic eventPlace;
  dynamic eventAddress;
  String? eventLatitude;
  String? eventLongitude;
  bool? isActive;
  String? bookingStatus;
  bool? isSpotlight;
  bool? isFeatured;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? tickets;
  List<dynamic>? ticketOrders;
  Organizer? organizer;
  List<Category>? categories;
  List<Celebrity>? celebrities;
  List<DataGalleryImage>? galleryImages;

  EventData({
    this.totalEventCapacity,
    this.totalAvailableSeats,
    this.totalTicketsSold,
    this.id,
    this.coverImageUrl,
    this.eventName,
    this.eventDate,
    this.entryTime,
    this.showStartTime,
    this.showEndTime,
    this.organizerId,
    this.shortBio,
    this.termsAndConditions,
    this.thingsToKnow,
    this.eventPlace,
    this.eventAddress,
    this.disclamer,
    this.languages,
    this.ageLimit,
    this.eventLatitude,
    this.eventLongitude,
    this.isActive,
    this.bookingStatus,
    this.isSpotlight,
    this.isFeatured,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.tickets,
    this.ticketOrders,
    this.organizer,
    this.categories,
    this.celebrities,
    this.galleryImages,
  });

  factory EventData.fromJson(Map<String, dynamic> json) => EventData(
    totalEventCapacity: json["totalEventCapacity"],
    totalAvailableSeats: json["totalAvailableSeats"],
    totalTicketsSold: json["totalTicketsSold"],
    id: json["id"],
    coverImageUrl: json["coverImageUrl"],
    eventName: json["eventName"],
    eventDate:
        json["eventDate"] == null ? [] : List<String>.from(json["eventDate"]),
    entryTime: json["entryTime"],
    showStartTime: json["showStartTime"],
    showEndTime: json["showEndTime"],
    organizerId: json["organizerId"],
    shortBio: json["shortBio"],
    termsAndConditions: json["termsAndConditions"],
    thingsToKnow: json["thingsToKnow"],
    eventPlace: json["eventPlace"],
    eventAddress: json["eventAddress"],
    eventLatitude: json["eventLatitude"],
    eventLongitude: json["eventLongitude"],
    isActive: json["isActive"],
    bookingStatus: json["bookingStatus"],
    disclamer: json["disclamer"],
    languages: json["languages"],
    ageLimit: json["age_limit"],
    isSpotlight: json["isSpotlight"],
    isFeatured: json["isFeatured"],
    isDeleted: json["isDeleted"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    tickets:
        json["tickets"] == null
            ? []
            : List<dynamic>.from(json["tickets"]!.map((x) => x)),
    ticketOrders:
        json["ticketOrders"] == null
            ? []
            : List<dynamic>.from(json["ticketOrders"]!.map((x) => x)),
    organizer:
        json["organizer"] == null
            ? null
            : Organizer.fromJson(json["organizer"]),
    categories:
        json["categories"] == null
            ? []
            : List<Category>.from(
              json["categories"]!.map((x) => Category.fromJson(x)),
            ),
    celebrities:
        json["celebrities"] == null
            ? []
            : List<Celebrity>.from(
              json["celebrities"]!.map((x) => Celebrity.fromJson(x)),
            ),
    galleryImages:
        json["galleryImages"] == null
            ? []
            : List<DataGalleryImage>.from(
              json["galleryImages"]!.map((x) => DataGalleryImage.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "totalEventCapacity": totalEventCapacity,
    "totalAvailableSeats": totalAvailableSeats,
    "totalTicketsSold": totalTicketsSold,
    "id": id,
    "coverImageUrl": coverImageUrl,
    "eventName": eventName,
    "eventDate": eventDate,
    "entryTime": entryTime,
    "showStartTime": showStartTime,
    "showEndTime": showEndTime,
    "organizerId": organizerId,
    "shortBio": shortBio,
    "termsAndConditions": termsAndConditions,
    "thingsToKnow": thingsToKnow,
    "eventPlace": eventPlace,
    "eventAddress": eventAddress,
    "eventLatitude": eventLatitude,
    "eventLongitude": eventLongitude,
    "isActive": isActive,
    "bookingStatus": bookingStatus,
    "disclamer": disclamer,
    "languages": languages,
    "age_limit": ageLimit,
    "isSpotlight": isSpotlight,
    "isFeatured": isFeatured,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "tickets":
        tickets == null ? [] : List<dynamic>.from(tickets!.map((x) => x)),
    "ticketOrders":
        ticketOrders == null
            ? []
            : List<dynamic>.from(ticketOrders!.map((x) => x)),
    "organizer": organizer?.toJson(),
    "categories":
        categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
    "celebrities":
        celebrities == null
            ? []
            : List<dynamic>.from(celebrities!.map((x) => x.toJson())),
    "galleryImages":
        galleryImages == null
            ? []
            : List<dynamic>.from(galleryImages!.map((x) => x.toJson())),
  };
}

class Category {
  String? id;
  String? title;

  Category({this.id, this.title});

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(id: json["id"], title: json["title"]);

  Map<String, dynamic> toJson() => {"id": id, "title": title};
}

class Celebrity {
  String? id;
  String? fullName;
  String? profilePictureUrl;

  Celebrity({this.id, this.fullName, this.profilePictureUrl});

  factory Celebrity.fromJson(Map<String, dynamic> json) => Celebrity(
    id: json["id"],
    fullName: json["fullName"],
    profilePictureUrl: json["profilePictureUrl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "profilePictureUrl": profilePictureUrl,
  };
}

class DataGalleryImage {
  String? id;
  String? eventId;
  String? imageUrl;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  DataGalleryImage({
    this.id,
    this.eventId,
    this.imageUrl,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory DataGalleryImage.fromJson(
    Map<String, dynamic> json,
  ) => DataGalleryImage(
    id: json["id"],
    eventId: json["eventId"],
    imageUrl: json["imageUrl"],
    isDeleted: json["isDeleted"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "eventId": eventId,
    "imageUrl": imageUrl,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class Organizer {
  String? id;
  String? name;
  String? logoUrl;
  String? about;
  String? mobile;
  String? email;
  String? address;
  bool? isActive;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<OrganizerGalleryImage>? galleryImages;

  Organizer({
    this.id,
    this.name,
    this.logoUrl,
    this.about,
    this.mobile,
    this.email,
    this.address,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.galleryImages,
  });

  factory Organizer.fromJson(Map<String, dynamic> json) => Organizer(
    id: json["id"],
    name: json["name"],
    logoUrl: json["logoUrl"],
    about: json["about"],
    mobile: json["mobile"],
    email: json["email"],
    address: json["address"],
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    galleryImages:
        json["galleryImages"] == null
            ? []
            : List<OrganizerGalleryImage>.from(
              json["galleryImages"]!.map(
                (x) => OrganizerGalleryImage.fromJson(x),
              ),
            ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "logoUrl": logoUrl,
    "about": about,
    "mobile": mobile,
    "email": email,
    "address": address,
    "isActive": isActive,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "galleryImages":
        galleryImages == null
            ? []
            : List<dynamic>.from(galleryImages!.map((x) => x.toJson())),
  };
}

class OrganizerGalleryImage {
  String? id;
  String? imageUrl;
  String? organizerId;
  DateTime? createdAt;
  DateTime? updatedAt;

  OrganizerGalleryImage({
    this.id,
    this.imageUrl,
    this.organizerId,
    this.createdAt,
    this.updatedAt,
  });

  factory OrganizerGalleryImage.fromJson(
    Map<String, dynamic> json,
  ) => OrganizerGalleryImage(
    id: json["id"],
    imageUrl: json["imageUrl"],
    organizerId: json["organizerId"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "imageUrl": imageUrl,
    "organizerId": organizerId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
