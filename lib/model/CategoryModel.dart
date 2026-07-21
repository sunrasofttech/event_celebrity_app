import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));
String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  bool? status;
  List<CategoryDatum>? data;

  CategoryModel({this.status, this.data});

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<CategoryDatum>.from(
                json["data"]!.map((x) => CategoryDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CategoryDatum {
  String? id;
  String? title;
  String? iconImageUrl;
  String? backgroundColor;
  bool? isDeleted;

  CategoryDatum({
    this.id,
    this.title,
    this.iconImageUrl,
    this.backgroundColor,
    this.isDeleted,
  });

  factory CategoryDatum.fromJson(Map<String, dynamic> json) => CategoryDatum(
        id: json["id"],
        title: json["title"],
        iconImageUrl: json["iconImageUrl"],
        backgroundColor: json["background_color"],
        isDeleted: json["isDeleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "iconImageUrl": iconImageUrl,
        "background_color": backgroundColor,
        "isDeleted": isDeleted,
      };
}
