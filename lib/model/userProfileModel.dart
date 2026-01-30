// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

UserProfile userProfileFromJson(String str) => UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
    bool? status;
    Data? data;

    UserProfile({
        this.status,
        this.data,
    });

    factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
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
    DateTime? createdAt;
    DateTime? updatedAt;
    List<dynamic>? galleryImages;
    List<Category>? categories;

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
        this.createdAt,
        this.updatedAt,
        this.galleryImages,
        this.categories,
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
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        galleryImages: json["galleryImages"] == null ? [] : List<dynamic>.from(json["galleryImages"]!.map((x) => x)),
        categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
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
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "galleryImages": galleryImages == null ? [] : List<dynamic>.from(galleryImages!.map((x) => x)),
        "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
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
