// To parse this JSON data, do
//
//     final getProfileModel = getProfileModelFromJson(jsonString);

import 'dart:convert';

GetProfileModel getProfileModelFromJson(String str) => GetProfileModel.fromJson(json.decode(str));

String getProfileModelToJson(GetProfileModel data) => json.encode(data.toJson());

class GetProfileModel {
    bool? status;
    Data? data;

    GetProfileModel({
        this.status,
        this.data,
    });

    factory GetProfileModel.fromJson(Map<String, dynamic> json) => GetProfileModel(
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
    String? email;
    String? mobile;
    bool? isVerified;
    bool? isActive;
    String? fullName;
    String? publicHandle;
    String? profilePictureUrl;
    String? shortBio;
    SocialMediaLinks? socialMediaLinks;
    dynamic location;
    dynamic latitude;
    dynamic longitude;
    int? profileViews;
    bool? enableAll;
    bool? orderEmail;
    bool? orderPush;
    bool? orderSms;
    bool? orderWhatsapp;
    bool? prmotionEmail;
    bool? prmotionPush;
    bool? prmotionSms;
    bool? prmotionWhatsapp;
    DateTime? createdAt;
    DateTime? updatedAt;
    List<GalleryImage>? galleryImages;
    List<Category>? categories;
    List<RateCard>? rateCard;

    Data({
        this.id,
        this.email,
        this.mobile,
        this.isVerified,
        this.isActive,
        this.fullName,
        this.publicHandle,
        this.profilePictureUrl,
        this.shortBio,
        this.socialMediaLinks,
        this.location,
        this.latitude,
        this.longitude,
        this.profileViews,
        this.enableAll,
        this.orderEmail,
        this.orderPush,
        this.orderSms,
        this.orderWhatsapp,
        this.prmotionEmail,
        this.prmotionPush,
        this.prmotionSms,
        this.prmotionWhatsapp,
        this.createdAt,
        this.updatedAt,
        this.galleryImages,
        this.categories,
        this.rateCard,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        email: json["email"],
        mobile: json["mobile"],
        isVerified: json["isVerified"],
        isActive: json["isActive"],
        fullName: json["fullName"],
        publicHandle: json["publicHandle"],
        profilePictureUrl: json["profilePictureUrl"],
        shortBio: json["shortBio"],
        socialMediaLinks: json["socialMediaLinks"] == null ? null : SocialMediaLinks.fromJson(json["socialMediaLinks"]),
        location: json["location"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        profileViews: json["profileViews"],
        enableAll: json["enable_all"],
        orderEmail: json["order_email"],
        orderPush: json["order_push"],
        orderSms: json["order_sms"],
        orderWhatsapp: json["order_whatsapp"],
        prmotionEmail: json["prmotion_email"],
        prmotionPush: json["prmotion_push"],
        prmotionSms: json["prmotion_sms"],
        prmotionWhatsapp: json["prmotion_whatsapp"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        galleryImages: json["galleryImages"] == null ? [] : List<GalleryImage>.from(json["galleryImages"]!.map((x) => GalleryImage.fromJson(x))),
        categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
        rateCard: json["rateCard"] == null ? [] : List<RateCard>.from(json["rateCard"]!.map((x) => RateCard.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "mobile": mobile,
        "isVerified": isVerified,
        "isActive": isActive,
        "fullName": fullName,
        "publicHandle": publicHandle,
        "profilePictureUrl": profilePictureUrl,
        "shortBio": shortBio,
        "socialMediaLinks": socialMediaLinks?.toJson(),
        "location": location,
        "latitude": latitude,
        "longitude": longitude,
        "profileViews": profileViews,
        "enable_all": enableAll,
        "order_email": orderEmail,
        "order_push": orderPush,
        "order_sms": orderSms,
        "order_whatsapp": orderWhatsapp,
        "prmotion_email": prmotionEmail,
        "prmotion_push": prmotionPush,
        "prmotion_sms": prmotionSms,
        "prmotion_whatsapp": prmotionWhatsapp,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "galleryImages": galleryImages == null ? [] : List<dynamic>.from(galleryImages!.map((x) => x.toJson())),
        "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "rateCard": rateCard == null ? [] : List<dynamic>.from(rateCard!.map((x) => x.toJson())),
    };
}

class Category {
    String? id;
    String? title;

    Category({
        this.id,
        this.title,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
    };
}

class GalleryImage {
    String? id;
    String? imageUrl;

    GalleryImage({
        this.id,
        this.imageUrl,
    });

    factory GalleryImage.fromJson(Map<String, dynamic> json) => GalleryImage(
        id: json["id"],
        imageUrl: json["imageUrl"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "imageUrl": imageUrl,
    };
}

class RateCard {
    String? id;
    String? celebrityId;
    String? serviceName;
    String? price;
    dynamic description;
    bool? isActive;

    RateCard({
        this.id,
        this.celebrityId,
        this.serviceName,
        this.price,
        this.description,
        this.isActive,
    });

    factory RateCard.fromJson(Map<String, dynamic> json) => RateCard(
        id: json["id"],
        celebrityId: json["celebrityId"],
        serviceName: json["serviceName"],
        price: json["price"],
        description: json["description"],
        isActive: json["isActive"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "celebrityId": celebrityId,
        "serviceName": serviceName,
        "price": price,
        "description": description,
        "isActive": isActive,
    };
}

class SocialMediaLinks {
    String? twitter;
    String? instagram;

    SocialMediaLinks({
        this.twitter,
        this.instagram,
    });

    factory SocialMediaLinks.fromJson(Map<String, dynamic> json) => SocialMediaLinks(
        twitter: json["twitter"],
        instagram: json["instagram"],
    );

    Map<String, dynamic> toJson() => {
        "twitter": twitter,
        "instagram": instagram,
    };
}
