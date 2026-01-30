// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    bool? status;
    String? message;
    Data? data;

    LoginModel({
        this.status,
        this.message,
        this.data,
    });

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
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
    String? token;
    Celebrity? celebrity;

    Data({
        this.token,
        this.celebrity,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        celebrity: json["celebrity"] == null ? null : Celebrity.fromJson(json["celebrity"]),
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "celebrity": celebrity?.toJson(),
    };
}

class Celebrity {
    String? id;
    String? email;
    String? mobile;
    String? fullName;
    String? publicHandle;
    String? profilePictureUrl;
    bool? isVerified;

    Celebrity({
        this.id,
        this.email,
        this.mobile,
        this.fullName,
        this.publicHandle,
        this.profilePictureUrl,
        this.isVerified,
    });

    factory Celebrity.fromJson(Map<String, dynamic> json) => Celebrity(
        id: json["id"],
        email: json["email"],
        mobile: json["mobile"],
        fullName: json["fullName"],
        publicHandle: json["publicHandle"],
        profilePictureUrl: json["profilePictureUrl"],
        isVerified: json["isVerified"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "mobile": mobile,
        "fullName": fullName,
        "publicHandle": publicHandle,
        "profilePictureUrl": profilePictureUrl,
        "isVerified": isVerified,
    };
}
